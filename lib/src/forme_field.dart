import 'package:flutter/material.dart';
import 'forme_management.dart';

import 'forme_core.dart';
import 'forme_state_model.dart';

typedef NonnullFieldValidator<T> = String? Function(T value);
typedef NonnullFormFieldSetter<T> = void Function(T newValue);
typedef FieldContentBuilder<T extends AbstractFieldState> = Widget Function(
    T state);
mixin StatefulField<T extends AbstractFieldState, E extends FormeModel>
    on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String? get name;

  @override
  T createState();

  E get model;

  bool get readOnly;
}

/// if you want to create a stateful form field, but don't want to return a value,you can override this field
class CommonField<E extends FormeModel> extends StatefulWidget
    with StatefulField<CommonFieldState, E> {
  final String? name;
  final FieldContentBuilder<CommonFieldState<E>> builder;
  final E model;
  final bool readOnly;
  const CommonField({
    Key? key,
    this.name,
    required this.builder,
    required this.model,
    this.readOnly = false,
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
  }) : super(
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
}
