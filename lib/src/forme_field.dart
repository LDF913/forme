import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'forme_controller.dart';

import 'forme_core.dart';
import 'forme_state_model.dart';

abstract class FormeDecoratorBuilder<T> {
  Widget build(
    ValueListenable<bool> focusListenable,
    ValueListenable<FormeValidateError?> errorTextListenable,
    ValueListenable<T?> valueListenable,
    Widget child,
    FormeModel? model,
  );
}

/// form field value changed listener
typedef FormeFieldValueChanged<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E>, T? newValue);

typedef FieldContentBuilder<T extends AbstractFieldState> = Widget Function(
    T state);
mixin StatefulField<T extends AbstractFieldState<StatefulWidget, E>,
    E extends FormeModel> on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String get name;

  @override
  T createState();

  E get model;

  bool get readOnly;

  FocusListener<FormeFieldController<E>>? get focusListener;
}

/// if you want to create a stateful form field, but don't want to return a value,you can override this field
class CommonField<E extends FormeModel> extends StatefulWidget
    with StatefulField<CommonFieldState<E>, E> {
  final String name;
  final FieldContentBuilder<CommonFieldState<E>> builder;
  final E model;
  final bool readOnly;
  final FocusListener<FormeFieldController<E>>? focusListener;
  const CommonField({
    Key? key,
    required this.name,
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
    return InheritedFormeFieldController(this, widget.builder(this));
  }
}

/// base field used to return a value
///
/// if your return value is nonnull,use [ValueField]
class ValueField<T, E extends FormeModel> extends FormField<T>
    with StatefulField<ValueFieldState<T, E>, E> {
  final String name;
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

  /// used to build a decorator
  ///
  /// **decorator is a part of field widget**
  final FormeDecoratorBuilder<T>? decoratorBuilder;

  /// used to replace null value
  ///
  /// will effect
  ///
  ///   1. [FormeValueFieldController.value]
  ///   2. [ValueField.validator]
  ///   3. [ValueField.onSaved]
  ///   4. [FormeValueFieldController.valueListenable]
  ///   5. [ValueField.onChanged]
  ///   6. [Forme.onChanged]
  ///
  /// **should not setted by user**
  final T? nullValueReplacement;

  ValueField({
    Key? key,
    this.onChanged,
    required this.name,
    required FieldContentBuilder<ValueFieldState<T, E>> builder,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    bool enabled = true,
    FormFieldSetter<T>? onSaved,
    required this.model,
    this.readOnly = false,
    this.validateErrorListener,
    this.decoratorBuilder,
    this.nullValueReplacement,
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
            validator: validator == null
                ? null
                : (v) {
                    if (v == null && nullValueReplacement != null) {
                      return validator(nullValueReplacement);
                    }
                    return validator(v);
                  },
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
