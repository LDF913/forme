import 'package:flutter/material.dart';

import 'builder.dart';
import 'form_state_model.dart';

mixin StatefulField<T extends AbstractFieldState,
    E extends AbstractFieldStateModel> on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String? get name;

  @override
  T createState();

  E get model;

  bool get readOnly;
}

class CommonField<E extends AbstractFieldStateModel> extends StatefulWidget
    with StatefulField<CommonFieldState, E> {
  final String? name;
  final FieldContentBuilder<CommonFieldState<E>> builder;
  final E model;
  final bool readOnly;
  const CommonField({
    this.name,
    required this.builder,
    required this.model,
    this.readOnly = false,
  });

  @override
  CommonFieldState<E> createState() => CommonFieldState();
}

class CommonFieldState<E extends AbstractFieldStateModel>
    extends State<CommonField<E>> with AbstractFieldState<CommonField<E>, E> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}

class ValueField<T, E extends AbstractFieldStateModel> extends FormField<T>
    with StatefulField<ValueFieldState<T, E>, E> {
  final String? name;
  final ValueChanged<T?>? onChanged;
  final E model;
  final bool readOnly;

  ValueField({
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
            enabled: enabled,
            onSaved: onSaved,
            builder: (field) {
              ValueFieldState<T, E> state = field as ValueFieldState<T, E>;
              return builder(state);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);

  ValueFieldState<T, E> createState() => ValueFieldState();
}

class NonnullValueField<T, E extends AbstractFieldStateModel>
    extends ValueField<T, E> {
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
  }) : super(
            model: model,
            readOnly: readOnly,
            enabled: enabled,
            onSaved: onSaved == null ? null : (value) => onSaved(value!),
            onChanged: onChanged == null ? null : (value) => onChanged(value!),
            builder: (field) {
              NonnullValueFieldState<T, E> state =
                  field as NonnullValueFieldState<T, E>;
              return builder(state);
            },
            validator: validator == null ? null : (value) => validator(value!),
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            name: name);

  NonnullValueFieldState<T, E> createState() => NonnullValueFieldState();
}

class NonnullValueFieldState<T, E extends AbstractFieldStateModel>
    extends ValueFieldState<T, E> {
  @override
  T get value => super.value!;

  @override
  void doChangeValue(T? newValue, {bool trigger = true}) {
    super.doChangeValue(newValue == null ? widget.initialValue : newValue,
        trigger: trigger);
  }

  @mustCallSuper
  @override
  void setValue(T? value) {
    super.setValue(value == null ? widget.initialValue : value);
  }
}
