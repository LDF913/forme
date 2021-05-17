import 'package:flutter/widgets.dart';

import '../form_builder.dart';
import 'focus_node.dart';
import 'form_layout.dart';
import 'text_selection.dart';

/// used to control form field
abstract class FormFieldManagement {
  ///get field's name
  String? get name;

  /// get field's position
  Position get position;

  /// get  field's readOnly state,equals to getState<bool>('readOnly')!
  // bool get readOnly;

  /// set readOnly on field,it's equals to update1('readOnly',readOnly)
  //set readOnly(bool readOnly);

  // whether field support focus
  bool get focusable;

  // whether field is focused
  bool get hasFocus;

  /// focus|unfocus field
  ///
  /// if field is not focusable ,an error will be throw
  set focus(bool focus);

  /// set focus listener on field
  ///
  /// if field does not has a focusnode ,an error will be throw
  set focusListener(FocusListener? listener);

  /// if current value is valuefield return a [ValueFormFieldManagement] otherwise throw a exception
  ValueFieldManagement get valueFieldManagement;

  /// whether field is value field
  bool get isValueField;

  /// whether field support textselection
  bool get supportTextSelection;

  /// if field support textselection return management,
  /// otherwise throw an exception
  TextSelectionManagement get textSelectionManagement;

  /// set state model for field
  set model(AbstractFieldStateModel model);

  /// get current state model;
  AbstractFieldStateModel get model;

  /// is readOnly of **this field**
  bool get readOnly;

  /// set readOnly on this field
  set readOnly(bool readOnly);

  /// make current field visible in viewport
  ///
  /// if current field|form is invisible , nothing happened
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment});
}

abstract class ValueFieldManagement<T> {
  /// get current value of valuefield
  T? get value;

  /// set newValue on valuefield,this method will trigger onChanged listener
  /// if you do not trigger it,you can use setValue method
  set value(T? value) => setValue(value, trigger: true);

  /// set newValue on valuefield,if trigger is false,won't trigger onChanged listener
  setValue(T? value, {bool trigger: true});

  /// whether value field is valid,this method won't display error msg
  /// if you want to show error msg,use validate instead
  bool get isValid;

  /// validate value field ,return whether field is valid or not
  /// this message will show error msg,you can use isValid instead if you don't want show error msg
  bool validate();

  /// reset valuefield,will set value to initialValue
  /// also clear error msg
  void reset();

  /// get error message
  String? get errorText;

  /// validate quietly,return an error message if has
  ///
  /// this method won't display error message
  String? quietlyValidate();
}

abstract class FormFieldManagementDelegate extends FormFieldManagement {
  @protected
  FormFieldManagement get delegate;

  @override
  String? get name => delegate.name;

  @override
  Position get position => delegate.position;

  @override
  bool get focusable => delegate.focusable;

  @override
  bool get hasFocus => delegate.hasFocus;

  @override
  set focus(bool focus) => delegate.focus = focus;

  @override
  set focusListener(FocusListener? listener) =>
      delegate.focusListener = listener;

  @override
  ValueFieldManagement get valueFieldManagement =>
      delegate.valueFieldManagement;

  @override
  bool get isValueField => delegate.isValueField;

  @override
  bool get supportTextSelection => delegate.supportTextSelection;

  @override
  TextSelectionManagement get textSelectionManagement =>
      delegate.textSelectionManagement;

  @override
  set model(AbstractFieldStateModel model) => delegate.model = model;

  @override
  AbstractFieldStateModel get model => delegate.model;

  @override
  bool get readOnly => delegate.readOnly;

  @override
  set readOnly(bool readOnly) => delegate.readOnly = readOnly;

  @override
  Future<void> ensureVisible(
          {Duration? duration,
          Curve? curve,
          ScrollPositionAlignmentPolicy? alignmentPolicy,
          double? alignment}) =>
      delegate.ensureVisible(
          duration: duration,
          curve: curve,
          alignment: alignment,
          alignmentPolicy: alignmentPolicy);
}

/// base form field management
abstract class BaseFormFieldManagement extends FormFieldManagementDelegate {
  final FormFieldManagement delegate;

  BaseFormFieldManagement(this.delegate);

  /// whether field is visible
  bool get visible;

  /// hide|show field
  set visible(bool visible);

  /// get flex of field
  int? get flex;

  /// set flex of field
  set flex(int? flex);

  /// get padding of field
  EdgeInsets? get padding;

  /// set padding of field
  set padding(EdgeInsets? padding);
}

abstract class BaseFormValueFieldManagement extends BaseFormFieldManagement {
  BaseFormValueFieldManagement(BaseFormFieldManagement delegate)
      : super(delegate);

  /// whether field is visible
  bool get visible => delegate.visible;

  /// hide|show field
  set visible(bool visible) => delegate.visible = visible;

  /// get flex of field
  int? get flex => delegate.flex;

  /// set flex of field
  set flex(int? flex) => delegate.flex = flex;

  /// get padding of field
  EdgeInsets? get padding => delegate.padding;

  /// set padding of field
  set padding(EdgeInsets? padding) => delegate.padding = padding;

  /// shake field
  ///
  /// typically used to warn user this field has an error
  void shake({Shaker? shaker});

  @override
  BaseFormFieldManagement get delegate =>
      super.delegate as BaseFormFieldManagement;
}

abstract class CastableFormFieldManagement extends FormFieldManagementDelegate {
  /// whether this formfieldmanagement can cast to target
  bool canCast<T extends FormFieldManagement>() => delegate is T;

  /// cast FormFieldManagement to what you want
  ///
  /// if field is BaseValueField , can cast to [BaseFormValueFieldManagement]
  ///
  /// if field is BaseCommonField , can cast to [BaseFormFieldManagement]
  T cast<T extends FormFieldManagement>() {
    if (delegate is! T)
      throw 'current FormFieldManagement is ${delegate.runtimeType}, can not cast to $T';
    return delegate as T;
  }
}
