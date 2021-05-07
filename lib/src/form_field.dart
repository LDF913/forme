import 'package:flutter/material.dart';

import 'builder.dart';
import 'form_key.dart';
import 'form_theme.dart';
import 'state_model.dart';

typedef NonnullFieldValidator<T> = String? Function(T value);
typedef NonnullFormFieldSetter<T> = void Function(T newValue);
typedef FieldContentBuilder<T extends AbstractFormFieldState> = Widget Function(
    T state);

/// when you use [Builder] to build a widget
///
/// you can use [BuilderInfo.of(context)] to help you
class BuilderInfo {
  final FieldKey fieldKey;
  final bool readOnly;
  final int flex;
  final bool inline;
  final FormThemeData formThemeData;

  static BuilderInfo of(BuildContext context) {
    FieldInfo fieldInfo = FieldInfo.of(context);
    FormManagement formManagement = FormManagement.of(context);
    bool readOnly = formManagement.readOnly || fieldInfo.readOnly;
    FormThemeData formThemeData = formManagement.formThemeData;
    return BuilderInfo._(readOnly, formThemeData, fieldInfo);
  }

  BuilderInfo._(this.readOnly, this.formThemeData, FieldInfo fieldInfo)
      : this.inline = fieldInfo.inline,
        this.flex = fieldInfo.flex,
        this.fieldKey = fieldInfo.fieldKey;
}

mixin _InitStateField {
  Map<String, StateValue> get _initStateMap;
}

abstract class AbstractCommonField<CommonFieldState> extends StatefulWidget {
  final FieldContentBuilder<AbstractCommonFieldState> builder;
  const AbstractCommonField({required this.builder});
  @override
  AbstractCommonFieldState createState();
}

abstract class CommonField<K extends AbstractCommonFieldState>
    extends AbstractCommonField {
  CommonField({required FieldContentBuilder<K> builder})
      : super(builder: (state) {
          return builder(state as K);
        });
  @override
  K createState();
}

class BaseCommonField extends CommonField<BaseCommonFieldState>
    with _InitStateField {
  final Map<String, StateValue> _initStateMap;
  BaseCommonField(this._initStateMap,
      {required FieldContentBuilder<BaseCommonFieldState> builder})
      : super(builder: builder);

  @override
  BaseCommonFieldState createState() => BaseCommonFieldState();
}

abstract class ValueField<T, K extends ValueFieldState<T>>
    extends FormField<T> {
  final ValueChanged<T?>? onChanged;

  ValueField(
      {this.onChanged,
      required FieldContentBuilder<K> builder,
      FormFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      T? initialValue,
      bool enabled = true,
      FormFieldSetter<T>? onSaved})
      : super(
            enabled: enabled,
            onSaved: onSaved,
            builder: (field) {
              return builder(field as K);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);

  @override
  K createState();
}

class BaseValueField<T> extends ValueField<T, BaseValueFieldState<T>>
    with _InitStateField {
  final Map<String, StateValue> _initStateMap;
  BaseValueField(this._initStateMap,
      {ValueChanged<T?>? onChanged,
      required FieldContentBuilder<BaseValueFieldState<T>> builder,
      FormFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      T? initialValue,
      bool enabled = true,
      FormFieldSetter<T>? onSaved})
      : super(
            builder: builder,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            enabled: enabled,
            onSaved: onSaved);
  @override
  BaseValueFieldState<T> createState() => BaseValueFieldState();
}

class BaseNonnullValueField<T>
    extends NonnullValueField<T, BaseNonnullValueFieldState<T>>
    with _InitStateField {
  final Map<String, StateValue> _initStateMap;
  BaseNonnullValueField(
    this._initStateMap, {
    required FieldContentBuilder<BaseNonnullValueFieldState<T>> builder,
    ValueChanged<T>? onChanged,
    NonnullFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    required T initialValue,
    NonnullFormFieldSetter<T>? onSaved,
    bool enabled = true,
  }) : super(
            builder: builder,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            enabled: enabled,
            onSaved: onSaved);
  @override
  BaseNonnullValueFieldState<T> createState() => BaseNonnullValueFieldState();
}

abstract class NonnullValueField<T, K extends NonnullValueFieldState<T>>
    extends ValueField<T, K> {
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
  }) : super(
            enabled: enabled,
            onSaved: onSaved == null ? null : (value) => onSaved(value!),
            onChanged: onChanged == null ? null : (value) => onChanged(value!),
            builder: builder,
            validator: validator == null ? null : (value) => validator(value!),
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);

  @override
  K createState();
}

abstract class NonnullValueFieldState<T> extends ValueFieldState<T> {
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

abstract class AbstractCommonFieldState extends State<AbstractCommonField>
    with AbstractFormFieldState<AbstractCommonField> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}

mixin BaseFormFieldState<T extends StatefulWidget>
    on AbstractFormFieldState<T> {
  @protected
  dynamic getState(String stateKey) {
    return (model as BaseFieldStateModel).getState(stateKey);
  }

  @override
  void initFormManagement() {
    super.initFormManagement();
    (model as BaseFieldStateModel).addListener(() {
      setState(() {});
    });
  }

  @override
  BaseFieldStateModel createModel() {
    _InitStateField initStateField = (widget as _InitStateField);
    return BaseFieldStateModel(initStateField._initStateMap,
        fieldKey: fieldKey);
  }

  Map<String, dynamic> get currentMap =>
      (model as BaseFieldStateModel).currentMap;
}

class BaseCommonFieldState extends AbstractCommonFieldState
    with BaseFormFieldState {}

class BaseValueFieldState<T> extends ValueFieldState<T>
    with BaseFormFieldState {}

class BaseNonnullValueFieldState<T> extends NonnullValueFieldState<T>
    with BaseFormFieldState {}
