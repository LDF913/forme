import 'package:flutter/material.dart';

import '../builder.dart';
import '../form_field.dart';
import '../management.dart';
import '../form_state_model.dart';

/// used to wrap BaseField
///
///
/// wrap result should not be changed at runtime
typedef WidgetWrapper = Widget Function(Widget child);

class LayoutParam {
  final bool? visible;
  final int? flex;
  final EdgeInsets? padding;
  final WidgetWrapper? wrapper;

  const LayoutParam({
    this.visible,
    this.flex,
    this.padding,
    this.wrapper,
  });
}

mixin BaseStatefulField<T extends AbstractFieldState,
    E extends AbstractFieldStateModel> on StatefulField<T, E> {
  LayoutParam? get layoutParam;
}

/// this state is used for BaseFormField
///
/// **do not used this state unless your custom field is [BaseStatefulField]**
mixin BaseFieldState<T extends StatefulWidget,
    E extends AbstractFieldStateModel> on AbstractFieldState<T, E> {
  bool? _readOnly;

  LayoutParam? _layoutParam;

  @override
  bool get isFieldReadOnly => _readOnly ?? _field.readOnly;

  @override
  set readOnly(bool readOnly) {
    if (readOnly != _readOnly)
      setState(() {
        _readOnly = readOnly;
      });
  }

  LayoutParam? get layoutParam => _layoutParam ?? _field.layoutParam;

  set layoutParam(LayoutParam? layoutParam) {
    setState(() {
      LayoutParam? old = this.layoutParam;
      _layoutParam = LayoutParam(
        visible: layoutParam?.visible ?? old?.visible,
        flex: layoutParam?.flex ?? old?.flex,
        padding: layoutParam?.padding ?? old?.padding,
        wrapper: layoutParam?.wrapper ?? old?.wrapper,
      );
    });
  }

  /// used to build default field widget
  Widget get field;

  /// used to wrap default field  to flexible
  ///
  /// override this if you do not need flexible
  @override
  Widget build(BuildContext context) {
    if (!isLayoutForm) return field;
    Widget child = Visibility(
      maintainState: true,
      child: Padding(
        padding: layoutParam?.padding ??
            const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child:
            layoutParam?.wrapper == null ? field : layoutParam?.wrapper!(field),
      ),
      visible: layoutParam?.visible ?? true,
    );
    return Flexible(
      fit: layoutParam?.visible ?? true ? FlexFit.tight : FlexFit.loose,
      child: child,
      flex: layoutParam?.flex ?? 1,
    );
  }

  /// return [BaseLayoutFormFieldManagement]
  @override
  FormFieldManagement createFormFieldManagement() {
    if (isLayoutForm)
      return _BaseFormFieldManagement(super.createFormFieldManagement(), this);
    return super.createFormFieldManagement();
  }

  BaseStatefulField get _field => widget as BaseStatefulField;
}

class BaseCommonField<E extends AbstractFieldStateModel>
    extends CommonField<BaseCommonFieldState<E>, E> with BaseStatefulField {
  final E model;
  final bool readOnly;

  /// **only worked when use layout form builder**
  final LayoutParam? layoutParam;

  BaseCommonField({
    String? name,
    this.readOnly = false,
    this.layoutParam,
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
  final LayoutParam? layoutParam;
  BaseValueField(
      {ValueChanged<T?>? onChanged,
      this.layoutParam,
      required this.model,
      required FieldContentBuilder<BaseValueFieldState<T, E>> builder,
      FormFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      T? initialValue,
      bool enabled = true,
      FormFieldSetter<T>? onSaved,
      this.readOnly = false,
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
  final LayoutParam? layoutParam;
  BaseNonnullValueField({
    required this.model,
    required FieldContentBuilder<BaseNonnullValueFieldState<T, E>> builder,
    ValueChanged<T>? onChanged,
    NonnullFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    required T initialValue,
    NonnullFormFieldSetter<T>? onSaved,
    bool enabled = true,
    String? name,
    this.readOnly = true,
    this.layoutParam,
  }) : super(
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
    extends ValueFieldState<T, E> with BaseFieldState {
  @override
  Widget get field => super.doBuild();
}

class BaseNonnullValueFieldState<T, E extends AbstractFieldStateModel>
    extends NonnullValueFieldState<T, E> with BaseFieldState {
  @override
  Widget get field => super.doBuild();
}

abstract class BaseLayoutFormFieldManagement
    extends FormFieldManagementDelegate {
  final FormFieldManagement delegate;

  BaseLayoutFormFieldManagement(this.delegate);

  /// get layout param
  ///
  /// only worked on LayoutFormBuilder
  LayoutParam? get layoutParam;

  /// set layout param
  ///
  /// only workded on LayoutFormBuilder
  set layoutParam(LayoutParam? layoutParam);

  /// get field's position
  ///
  /// if field does not has a name ,you can use [Position.of] instead
  Position get position;

  /// whether field is visible
  bool get visible;
}

class _BaseFormFieldManagement extends BaseLayoutFormFieldManagement {
  final BaseFieldState state;
  _BaseFormFieldManagement(FormFieldManagement delegate, this.state)
      : super(delegate);

  @override
  LayoutParam? get layoutParam => state.layoutParam;

  @override
  set layoutParam(LayoutParam? layoutParam) => state.layoutParam = layoutParam;

  @override
  Position get position => Position.of(state.context);

  @override
  bool get visible => layoutParam?.visible ?? true;
}
