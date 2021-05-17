import 'package:flutter/widgets.dart';

import 'builder.dart';
import 'management.dart';
import 'state_model.dart';
import 'widget/shake_widget.dart';

typedef NonnullFieldValidator<T> = String? Function(T value);
typedef NonnullFormFieldSetter<T> = void Function(T newValue);
typedef FieldContentBuilder<T extends AbstractFieldState> = Widget Function(
    T state);

/// used to wrap BaseField
///
///
/// wrap result should not be changed at runtime
typedef WidgetWrapper = Widget Function(Widget child);

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
  const AbstractCommonField({this.name, required this.builder});
}

abstract class CommonField<T extends AbstractCommonFieldState,
    E extends AbstractFieldStateModel> extends AbstractCommonField<T, E> {
  CommonField({String? name, required FieldContentBuilder<T> builder})
      : super(
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

mixin BaseStatefulField<T extends AbstractFieldState,
    E extends AbstractFieldStateModel> on StatefulField<T, E> {
  bool get visible;
  int? get flex;
  EdgeInsets? get padding;
  WidgetWrapper? get wrapper;
}

/// this state is used for BaseFormField
///
/// **do not used this state unless your custom field is [BaseStatefulField]**
mixin BaseFieldState<T extends StatefulWidget,
    E extends AbstractFieldStateModel> on AbstractFieldState<T, E> {
  bool? _readOnly;
  bool? _visible;
  EdgeInsets? _padding;
  int? _flex;

  @override
  bool get isFieldReadOnly => _readOnly ?? _field.readOnly;
  @override
  set readOnly(bool readOnly) {
    if (readOnly != _readOnly)
      setState(() {
        _readOnly = readOnly;
      });
  }

  bool get visible => _visible ?? _field.visible;
  set visible(bool visible) {
    if (visible != _visible)
      setState(() {
        _visible = visible;
      });
  }

  int? get flex => _flex ?? _field.flex;
  set flex(int? flex) {
    if (flex != _flex)
      setState(() {
        _flex = flex;
      });
  }

  EdgeInsets? get padding => _padding ?? _field.padding;
  set padding(EdgeInsets? padding) {
    if (padding != _padding)
      setState(() {
        _padding = padding;
      });
  }

  /// whether this field is readOnly

  /// used to build default field widget
  Widget get field;

  /// used to wrap default field  to flexible
  ///
  /// override this if you do not need flexible
  @override
  Widget build(BuildContext context) {
    Widget child = Visibility(
      maintainState: true,
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: _field.wrapper == null ? field : _field.wrapper!(field),
      ),
      visible: visible,
    );
    return Flexible(
      fit: visible ? FlexFit.tight : FlexFit.loose,
      child: child,
      flex: flex ?? 1,
    );
  }

  @override
  FormFieldManagement customFormFieldManagement(FormFieldManagement delegate) {
    return _BaseFormFieldManagement(delegate, this);
  }

  BaseStatefulField get _field => widget as BaseStatefulField;
}

mixin BaseValueState<T, E extends AbstractFieldStateModel>
    on BaseFieldState<FormField<T>, E> {
  Key? _shakeKey;
  Shaker? _shaker;

  _shake(Shaker shaker) {
    if (_shaker != null) return;
    setState(() {
      _shaker = shaker;
    });
  }

  @override
  Widget get field {
    Widget field = shakeField;
    if (_shaker != null) _shakeKey = UniqueKey();
    Duration? duration = _shaker == null ? Duration.zero : _shaker!.duration;
    _shaker = null;
    Widget shake = ShakeWidget(
        key: _shakeKey,
        duration: duration,
        deltaX: _shaker?.deltax,
        curve: _shaker?.curve,
        onEnd: _shaker?.onEnd,
        child: field);
    return shake;
  }

  @override
  FormFieldManagement customFormFieldManagement(FormFieldManagement delegate) {
    BaseFormFieldManagement baseFormFieldManagement =
        super.customFormFieldManagement(delegate) as BaseFormFieldManagement;
    return _BaseFormValueFieldManagement(baseFormFieldManagement, this);
  }

  Widget get shakeField;
}

class BaseCommonField<E extends AbstractFieldStateModel>
    extends CommonField<BaseCommonFieldState<E>, E> with BaseStatefulField {
  final E model;
  final bool readOnly;
  final int? flex;
  final EdgeInsets? padding;
  final bool visible;
  final WidgetWrapper? wrapper;
  BaseCommonField({
    String? name,
    this.flex,
    this.padding,
    this.visible = true,
    this.readOnly = false,
    this.wrapper,
    required this.model,
    required FieldContentBuilder<BaseCommonFieldState<E>> builder,
  }) : super(builder: builder, name: name);

  @override
  BaseCommonFieldState<E> createState() => BaseCommonFieldState();
}

class BaseValueField<T, E extends AbstractFieldStateModel>
    extends ValueField<T, BaseValueFieldState<T, E>, E> with BaseStatefulField {
  final E model;
  final bool readOnly;
  final int? flex;
  final EdgeInsets? padding;
  final bool visible;
  final WidgetWrapper? wrapper;
  BaseValueField(
      {ValueChanged<T?>? onChanged,
      required this.model,
      required FieldContentBuilder<BaseValueFieldState<T, E>> builder,
      FormFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      T? initialValue,
      bool enabled = true,
      FormFieldSetter<T>? onSaved,
      this.flex,
      this.padding,
      this.visible = true,
      this.readOnly = false,
      this.wrapper,
      String? name})
      : super(
            builder: builder,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            enabled: enabled,
            onSaved: onSaved,
            name: name);
  @override
  BaseValueFieldState<T, E> createState() => BaseValueFieldState();
}

class BaseNonnullValueField<T, E extends AbstractFieldStateModel>
    extends NonnullValueField<T, BaseNonnullValueFieldState<T, E>, E>
    with BaseStatefulField {
  final E model;
  final bool readOnly;
  final int? flex;
  final EdgeInsets? padding;
  final bool visible;
  final WidgetWrapper? wrapper;
  BaseNonnullValueField(
      {required this.model,
      required FieldContentBuilder<BaseNonnullValueFieldState<T, E>> builder,
      ValueChanged<T>? onChanged,
      NonnullFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      required T initialValue,
      NonnullFormFieldSetter<T>? onSaved,
      bool enabled = true,
      String? name,
      this.flex,
      this.padding,
      this.visible = true,
      this.readOnly = false,
      this.wrapper})
      : super(
            name: name,
            builder: builder,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            enabled: enabled,
            onSaved: onSaved);
  @override
  BaseNonnullValueFieldState<T, E> createState() =>
      BaseNonnullValueFieldState();
}

class BaseCommonFieldState<E extends AbstractFieldStateModel>
    extends AbstractCommonFieldState<E> with BaseFieldState {
  @override
  Widget get field {
    return widget.builder(this);
  }
}

class BaseValueFieldState<T, E extends AbstractFieldStateModel>
    extends ValueFieldState<T, E> with BaseFieldState, BaseValueState<T, E> {
  @override
  Widget get shakeField => super.doBuild();
}

class BaseNonnullValueFieldState<T, E extends AbstractFieldStateModel>
    extends NonnullValueFieldState<T, E>
    with BaseFieldState, BaseValueState<T, E> {
  @override
  Widget get shakeField => super.doBuild();
}

class Shaker {
  final Duration? duration;
  final double? deltax;
  final Curve? curve;
  final VoidCallback? onEnd;
  Shaker({this.duration, this.deltax, this.curve, this.onEnd});
}

class _BaseFormFieldManagement extends BaseFormFieldManagement {
  final BaseFieldState state;
  _BaseFormFieldManagement(FormFieldManagement delegate, this.state)
      : super(delegate);

  @override
  int? get flex => state.flex;

  @override
  set flex(int? flex) => state.flex = flex;

  @override
  EdgeInsets? get padding => state.padding;

  @override
  set padding(EdgeInsets? padding) => state.padding = padding;

  @override
  bool get visible => state.visible;

  @override
  set visible(bool visible) => state.visible = visible;
}

class _BaseFormValueFieldManagement extends BaseFormValueFieldManagement {
  final BaseValueState state;
  _BaseFormValueFieldManagement(BaseFormFieldManagement delegate, this.state)
      : super(delegate);

  @override
  void shake({Shaker? shaker}) {
    state._shake(shaker ?? Shaker());
  }
}
