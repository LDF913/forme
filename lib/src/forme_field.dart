import 'package:flutter/material.dart';
import 'forme_management.dart';

import 'forme_core.dart';
import 'forme_state_model.dart';
import 'widget/forme_decoration_widget.dart';

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

  FocusListener<FormeFieldManagement<E>>? get focusListener;
}

/// if you want to create a stateful form field, but don't want to return a value,you can override this field
class CommonField<E extends FormeModel> extends StatefulWidget
    with StatefulField<CommonFieldState<E>, E> {
  final String? name;
  final FieldContentBuilder<CommonFieldState<E>> builder;
  final E model;
  final bool readOnly;
  final FocusListener<FormeFieldManagement<E>>? focusListener;
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
    return widget.builder(this);
  }
}

/// base field used to return a value
///
/// if your return value is nonnull,use [NonnullValueField]
class ValueField<T, E extends FormeModel> extends FormField<T>
    with StatefulField<ValueFieldState<T, E>, E> {
  final String? name;
  final ValueChanged<T?>? onChanged;
  final E model;
  final bool readOnly;

  /// used to listen focus changed
  final FocusListener<FormeFieldManagement<E>>? focusListener;

  /// used to listen field's validate errorText changed
  ///
  /// triggerer when:
  ///
  /// 1. if autovalidatemode is not disabled, **in this case, will triggered after current frame completed**
  /// 2. after called [validate] method
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final ValidateErrorListener<FormeValueFieldManagement<T, E>>?
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
    this.focusListener,
  }) : super(
            key: key,
            enabled: enabled,
            onSaved: onSaved,
            builder: (field) {
              ValueFieldState<T, E> state = field as ValueFieldState<T, E>;
              return InheritedFormeFieldManagement._(
                  state.management, builder(state));
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);
  @override
  ValueFieldState<T, E> createState() => ValueFieldState();
}

/// base field used to return a nonnull value
class NonnullValueField<T, E extends FormeModel> extends ValueField<T, E> {
  @override
  T get initialValue => super.initialValue!;

  NonnullValueField({
    required FieldContentBuilder<NonnullValueFieldState<T, E>> builder,
    ValueChanged<T>? onChanged,
    NonnullFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    required T initialValue,
    NonnullFormFieldSetter<T>? onSaved,
    bool enabled = true,
    String? name,
    required E model,
    bool readOnly = false,
    Key? key,
    ValidateErrorListener<FormeValueFieldManagement<T, E>>?
        validateErrorListener,
    FocusListener<FormeFieldManagement<E>>? focusListener,
  }) : super(
            focusListener: focusListener,
            validateErrorListener: validateErrorListener,
            key: key,
            model: model,
            readOnly: readOnly,
            enabled: enabled,
            onSaved: onSaved == null ? null : (value) => onSaved(value!),
            onChanged: onChanged == null ? null : (value) => onChanged(value!),
            builder: (field) {
              NonnullValueFieldState<T, E> state =
                  field as NonnullValueFieldState<T, E>;
              return InheritedFormeFieldManagement._(
                  state.management, builder(state));
            },
            validator: validator == null ? null : (value) => validator(value!),
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            name: name);
  @override
  NonnullValueFieldState<T, E> createState() => NonnullValueFieldState();
}

/// share FormFieldManagement in sub tree
class InheritedFormeFieldManagement extends InheritedWidget {
  final FormeFieldManagement management;
  const InheritedFormeFieldManagement._(this.management, Widget child)
      : super(child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static FormeFieldManagement of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFormeFieldManagement>()!
        .management;
  }

  static FormeFieldManagement? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFormeFieldManagement>()
        ?.management;
  }
}

/// when you want to create your custom `FormeDecorator`
///
/// 1. make your field's state extends this
/// 2. create your `FormeDecorator` widget
/// 3. your `FormeDecorator` widget must provide a [FormeDecoration]
///
/// see
///    1. [FormeInputDecorator]
///    2. [FormeDecoration]
mixin FormeDecoratorState<T, E extends FormeModel,
    K extends FormeDecoratorManagement<T, E>> on ValueFieldState<T, E> {
  FormeDecoration? _decoration;

  @override
  FormeDecoratorManagement<T, E> get management =>
      super.management as FormeDecoratorManagement<T, E>;

  @override
  FormeDecoratorManagement<T, E> createFormeFieldManagement() =>
      _FormeDecoratorManagement(super.createFormeFieldManagement(), this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _decoration = FormeDecoration.of(context);
    focusNode.removeListener(_focusChange);
    if (_decoration != null) focusNode.addListener(_focusChange);
  }

  @override
  void onErrorTextChange(String? oldErrorText, String? currentErrorText) {
    if (_decoration != null) _decoration!.onErrorChanged(currentErrorText);
  }

  void _focusChange() {
    if (_decoration != null) _decoration!.onFocusChanged(focusNode.hasFocus);
  }

  @override
  void dispose() {
    if (_decoration != null) {
      focusNode.removeListener(_focusChange);
    }
    super.dispose();
  }
}

class _FormeDecoratorManagement<T, E extends FormeModel>
    extends FormeDecoratorManagement<T, E> {
  final FormeDecoratorState _state;

  _FormeDecoratorManagement(
      FormeValueFieldManagement<T, E> delegate, this._state)
      : super(delegate);
  @override
  set decoratorModel(FormeDecoratorModel? model) {
    if (_state._decoration != null) {
      _state._decoration!.onModelChanged(model);
    }
  }

  @override
  FormeDecoratorModel? get decoratorModel => _state._decoration?.decoratorModel;
}
