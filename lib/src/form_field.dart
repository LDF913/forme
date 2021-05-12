import 'package:flutter/material.dart';

import 'builder.dart';
import 'form_layout.dart';
import 'state_model.dart';

typedef FieldBuilder = Widget Function(BuilderInfo info, BuildContext context);
typedef NonnullFieldValidator<T> = String? Function(T value);
typedef NonnullFormFieldSetter<T> = void Function(T newValue);
typedef FieldContentBuilder<T extends AbstractFieldState> = Widget Function(
    T state);

/// when you use [Builder] to build a widget
///
/// you can use [BuilderInfo.of(context)] to help you
class BuilderInfo {
  final Position position;

  /// whether form is readOnly
  final bool readOnly;
  final ThemeData themeData;

  static BuilderInfo of(BuildContext context) {
    FieldInfo fieldInfo = FieldInfo.of(context);
    return BuilderInfo._(Theme.of(context), fieldInfo);
  }

  BuilderInfo._(this.themeData, FieldInfo fieldInfo)
      : this.position = fieldInfo.position,
        this.readOnly = fieldInfo.readOnly;
}

mixin StatefulField<T extends AbstractFieldState> on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String? get name;

  @override
  T createState();
}

mixin BaseStatefulField<T extends AbstractFieldState> on StatefulField<T> {
  Map<String, StateValue> get _initStateMap;
}

abstract class AbstractCommonField<CommonFieldState> extends StatefulWidget
    with StatefulField {
  final String? name;
  final FieldContentBuilder<AbstractCommonFieldState> builder;
  const AbstractCommonField({this.name, required this.builder});
  @override
  AbstractCommonFieldState createState();
}

abstract class CommonField<K extends AbstractCommonFieldState>
    extends AbstractCommonField {
  CommonField({String? name, required FieldContentBuilder<K> builder})
      : super(
            builder: (state) {
              return builder(state as K);
            },
            name: name);
  @override
  K createState();
}

abstract class ValueField<T, K extends ValueFieldState<T>> extends FormField<T>
    with StatefulField<ValueFieldState<T>> {
  final String? name;
  final ValueChanged<T?>? onChanged;

  ValueField(
      {this.onChanged,
      this.name,
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
              K state = field as K;
              return builder(state);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);

  @override
  K createState();
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
    with AbstractFieldState<AbstractCommonField> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}

/// this state is used for BaseFormField
///
/// **do not used this state unless your custom field is [BaseCommonField] [BaseValueField] [BaseNonnullValueField]**
mixin BaseFieldState<T extends StatefulWidget> on AbstractFieldState<T> {
  @override
  bool get readOnly => super.readOnly || _baseFieldStateModel.readOnly;

  @protected
  T? getState<T>(String stateKey) => _baseFieldStateModel.getState<T>(stateKey);

  @override
  void initFormManagement() {
    super.initFormManagement();
    _baseFieldStateModel.addListener(() {
      setState(() {});
    });
  }

  @override
  BaseFieldStateModel createModel() {
    return BaseFieldStateModel(
        _getInitStateField(widget)!._initStateMap, position, name);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _baseFieldStateModel.name = name;
    _baseFieldStateModel.position = position;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    Map<String, StateValue>? old = _getInitStateField(oldWidget)?._initStateMap;
    Map<String, StateValue>? current =
        _getInitStateField(widget)?._initStateMap;
    _baseFieldStateModel.didUpdateModel(old, current);
  }

  Map<String, dynamic> get currentMap => _baseFieldStateModel.currentMap;

  BaseStatefulField? _getInitStateField(T t) =>
      t is BaseStatefulField ? t as BaseStatefulField : null;

  BaseFieldStateModel get _baseFieldStateModel => model as BaseFieldStateModel;

  /// used to build default field widget
  Widget get _child;

  @override
  void dispose() {
    _baseFieldStateModel.dispose();
    super.dispose();
  }

  /// used to wrap default field  to flexible
  ///
  /// override this if you do not need flexible
  @override
  Widget build(BuildContext context) {
    bool visible = model.visible;
    EdgeInsets? padding = _baseFieldStateModel.padding;
    Widget child = Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Visibility(
        maintainState: true,
        child: _child,
        visible: visible,
      ),
    );
    return Flexible(
      fit: visible ? FlexFit.tight : FlexFit.loose,
      child: child,
      flex: _baseFieldStateModel.flex,
    );
  }
}

class BaseCommonField extends CommonField<BaseCommonFieldState>
    with BaseStatefulField {
  final Map<String, StateValue> _initStateMap;
  BaseCommonField(
    this._initStateMap, {
    String? name,
    required FieldContentBuilder<BaseCommonFieldState> builder,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
  }) : super(builder: builder, name: name) {
    _initStateMap.addAll({
      'flex': StateValue<int>(flex),
      'padding': StateValue<EdgeInsets?>(padding),
      'visible': StateValue<bool>(visible),
      'readOnly': StateValue<bool>(readOnly),
    });
  }

  @override
  BaseCommonFieldState createState() => BaseCommonFieldState();
}

class BaseValueField<T> extends ValueField<T, BaseValueFieldState<T>>
    with BaseStatefulField {
  final Map<String, StateValue> _initStateMap;
  BaseValueField(this._initStateMap,
      {ValueChanged<T?>? onChanged,
      required FieldContentBuilder<BaseValueFieldState<T>> builder,
      FormFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      T? initialValue,
      bool enabled = true,
      FormFieldSetter<T>? onSaved,
      int flex = 1,
      bool visible = true,
      bool readOnly = false,
      EdgeInsets? padding,
      String? name})
      : super(
            builder: builder,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            enabled: enabled,
            onSaved: onSaved,
            name: name) {
    _initStateMap.addAll({
      'flex': StateValue<int>(flex),
      'padding': StateValue<EdgeInsets?>(padding),
      'visible': StateValue<bool>(visible),
      'readOnly': StateValue<bool>(readOnly),
    });
  }
  @override
  BaseValueFieldState<T> createState() => BaseValueFieldState();
}

class BaseNonnullValueField<T>
    extends NonnullValueField<T, BaseNonnullValueFieldState<T>>
    with BaseStatefulField {
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
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
  }) : super(
            name: name,
            builder: builder,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            enabled: enabled,
            onSaved: onSaved) {
    _initStateMap.addAll({
      'flex': StateValue<int>(flex),
      'padding': StateValue<EdgeInsets?>(padding),
      'visible': StateValue<bool>(visible),
      'readOnly': StateValue<bool>(readOnly),
    });
  }
  @override
  BaseNonnullValueFieldState<T> createState() => BaseNonnullValueFieldState();
}

class BaseCommonFieldState extends AbstractCommonFieldState
    with BaseFieldState {
  @override
  Widget get _child {
    return widget.builder(this);
  }
}

class BaseValueFieldState<T> extends ValueFieldState<T> with BaseFieldState {
  @override
  Widget get _child {
    return widget.builder(this);
  }
}

class BaseNonnullValueFieldState<T> extends NonnullValueFieldState<T>
    with BaseFieldState {
  @override
  Widget get _child {
    return widget.builder(this);
  }
}
