import 'package:flutter/material.dart';
import 'forme_controller.dart';

import 'forme_core.dart';
import 'forme_state_model.dart';

/// form field value changed listener
typedef FormeFieldValueChanged<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E>, T? oldValue, T? newValue);

typedef NonnullFormeFieldValueChanged<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E>, T oldValue, T newValue);
typedef NonnullFieldValidator<T> = String? Function(T value);
typedef NonnullFormFieldSetter<T> = void Function(T newValue);

typedef FieldContentBuilder<T extends AbstractFieldState> = Widget Function(
    T state);
mixin StatefulField<T extends AbstractFieldState<StatefulWidget, E>,
    E extends FormeModel> on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String? get name;

  @override
  T createState();

  E get model;

  bool get readOnly;

  FocusListener<FormeFieldController<E>>? get focusListener;
}

/// if you want to create a stateful form field, but don't want to return a value,you can override this field
class CommonField<E extends FormeModel> extends StatefulWidget
    with StatefulField<CommonFieldState<E>, E> {
  final String? name;
  final FieldContentBuilder<CommonFieldState<E>> builder;
  final E model;
  final bool readOnly;
  final FocusListener<FormeFieldController<E>>? focusListener;
  const CommonField({
    Key? key,
    this.name,
    required this.builder,
    required this.model,
    this.readOnly = false,
    this.focusListener,
  }) : super(key: key);

  @override
  CommonFieldState<E> createState() => CommonFieldState();
}

class CommonFieldState<E extends FormeModel> extends State<CommonField<E>>
    with AbstractFieldState<CommonField<E>, E> {
  @override
  Widget build(BuildContext context) {
    return InheritedFormeFieldController(controller, widget.builder(this));
  }
}

/// base field used to return a value
///
/// if your return value is nonnull,use [NonnullValueField]
class ValueField<T, E extends FormeModel> extends FormField<T>
    with StatefulField<ValueFieldState<T, E>, E> {
  final String? name;
  final FormeFieldValueChanged<T, E>? onChanged;
  final E model;
  final bool readOnly;

  /// used to listen focus changed
  final FocusListener<FormeFieldController<E>>? focusListener;

  /// used to listen field's validate errorText changed
  ///
  /// triggerer when:
  ///
  /// 1. if autovalidatemode is not disabled, **in this case, will triggered after current frame completed**
  /// 2. after called [validate] method
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final ValidateErrorListener<FormeValueFieldController<T, E>>?
      validateErrorListener;

  ValueField({
    Key? key,
    this.onChanged,
    this.name,
    required FieldContentBuilder<ValueFieldState<T, E>> builder,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    bool enabled = true,
    FormFieldSetter<T>? onSaved,
    required this.model,
    this.readOnly = false,
    this.validateErrorListener,
    FocusListener<FormeValueFieldController<T, E>>? focusListener,
  })  : this.focusListener = _convertFocusListener(focusListener),
        super(
            key: key,
            enabled: enabled,
            onSaved: onSaved,
            builder: (field) {
              ValueFieldState<T, E> state = field as ValueFieldState<T, E>;
              return builder(state);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);
  @override
  ValueFieldState<T, E> createState() => ValueFieldState();

  static FocusListener<FormeFieldController<E>>?
      _convertFocusListener<T, E extends FormeModel>(
          FocusListener<FormeValueFieldController<T, E>>? listener) {
    if (listener == null) return null;
    return (v, focus) => listener(v as FormeValueFieldController<T, E>, focus);
  }
}

/// base field used to return a nonnull value
class NonnullValueField<T, E extends FormeModel> extends ValueField<T, E> {
  @override
  T get initialValue => super.initialValue!;

  NonnullValueField({
    required FieldContentBuilder<NonnullValueFieldState<T, E>> builder,
    NonnullFormeFieldValueChanged<T, E>? onChanged,
    NonnullFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    required T initialValue,
    NonnullFormFieldSetter<T>? onSaved,
    bool enabled = true,
    String? name,
    required E model,
    bool readOnly = false,
    Key? key,
    ValidateErrorListener<FormeValueFieldController<T, E>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<T, E>>? focusListener,
  }) : super(
            focusListener: focusListener,
            validateErrorListener: validateErrorListener,
            key: key,
            model: model,
            readOnly: readOnly,
            enabled: enabled,
            onSaved: onSaved == null ? null : (value) => onSaved(value!),
            onChanged: onChanged == null
                ? null
                : (controller, oldValue, newValue) =>
                    onChanged(controller, oldValue!, newValue!),
            builder: (field) {
              NonnullValueFieldState<T, E> state =
                  field as NonnullValueFieldState<T, E>;
              return builder(state);
            },
            validator: validator == null ? null : (value) => validator(value!),
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            name: name);
  @override
  NonnullValueFieldState<T, E> createState() => NonnullValueFieldState();
}

/// share FormFieldController in sub tree
class InheritedFormeFieldController extends InheritedWidget {
  final FormeFieldController controller;
  const InheritedFormeFieldController(this.controller, Widget child)
      : super(child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static FormeFieldController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFormeFieldController>()!
        .controller;
  }

  static FormeFieldController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFormeFieldController>()
        ?.controller;
  }
}
