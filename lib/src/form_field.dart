import 'package:flutter/widgets.dart';

import 'builder.dart';
import 'form_state_model.dart';

typedef NonnullFieldValidator<T> = String? Function(T value);
typedef NonnullFormFieldSetter<T> = void Function(T newValue);
typedef FieldContentBuilder<T extends AbstractFieldState> = Widget Function(
    T state);

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

abstract class AbstractCommonField<T extends AbstractCommonFieldState,
        E extends AbstractFieldStateModel> extends StatefulWidget
    with StatefulField<T, E> {
  final String? name;
  final FieldContentBuilder<AbstractCommonFieldState> builder;
  const AbstractCommonField({
    this.name,
    required this.builder,
  });
}

abstract class CommonField<T extends AbstractCommonFieldState,
    E extends AbstractFieldStateModel> extends AbstractCommonField<T, E> {
  CommonField({
    String? name,
    required FieldContentBuilder<T> builder,
  }) : super(
            builder: (state) {
              return builder(state as T);
            },
            name: name);
  @override
  T createState();
}

abstract class ValueField<T, K extends ValueFieldState<T, E>,
        E extends AbstractFieldStateModel> extends FormField<T>
    with StatefulField<ValueFieldState<T, E>, E> {
  final String? name;
  final ValueChanged<T?>? onChanged;

  ValueField({
    this.onChanged,
    this.name,
    required FieldContentBuilder<K> builder,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    bool enabled = true,
    FormFieldSetter<T>? onSaved,
  }) : super(
            enabled: enabled,
            onSaved: onSaved,
            builder: (field) {
              K state = field as K;
              return builder(state);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);

  @override
  K createState();
}

abstract class NonnullValueField<T, K extends NonnullValueFieldState<T, E>,
    E extends AbstractFieldStateModel> extends ValueField<T, K, E> {
  @override
  T get initialValue => super.initialValue!;

  NonnullValueField({
    required FieldContentBuilder<K> builder,
    ValueChanged<T>? onChanged,
    NonnullFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    required T initialValue,
    NonnullFormFieldSetter<T>? onSaved,
    bool enabled = true,
    String? name,
  }) : super(
            enabled: enabled,
            onSaved: onSaved == null ? null : (value) => onSaved(value!),
            onChanged: onChanged == null ? null : (value) => onChanged(value!),
            builder: builder,
            validator: validator == null ? null : (value) => validator(value!),
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            name: name);

  @override
  K createState();
}

abstract class NonnullValueFieldState<T, E extends AbstractFieldStateModel>
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

abstract class AbstractCommonFieldState<E extends AbstractFieldStateModel>
    extends State<AbstractCommonField>
    with AbstractFieldState<AbstractCommonField, E> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}
