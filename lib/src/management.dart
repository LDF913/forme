import 'package:flutter/widgets.dart';

import '../form_builder.dart';
import 'focus_node.dart';
import 'text_selection.dart';

abstract class FormManagement {
  /// whether form has a name field
  bool hasField(String name);

  /// whether form is readonly
  bool get readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly);

  /// get a new formfieldManagement by name
  CastableFormFieldManagement newFormFieldManagement(String name);

  /// get form data
  ///
  /// if a value field doesn't has a name state,it's value will be ignored
  Map<String, dynamic> get data;

  /// get error msg after validate form,if you don't want to display error text,
  /// look at [quietlyValidate]
  ///
  /// key is field'name
  /// value is [FormFieldManagement] you can get errorText
  /// via [FormFieldManagement.valueFieldManagement.errorText]
  /// or request a focus via [FormFieldManagement.focus]
  /// or ensure field visible via [FormFieldManagement.ensureVisible]
  List<FormFieldManagementWithError> get errors;

  /// perform a quietly validate, used to get error text and without display it
  ///
  /// this method will not set errorText on field and rebuild field , so after this method called
  /// [ValueFieldManagement.isValid] still return true even though an error text returned by
  /// field's validator ,  also [ValueFieldManagement.errorText] will   return null too,
  /// so value field will not display error
  ///
  /// you can get errorText
  /// via [FormFieldManagementWithError.errorText]
  /// or request a focus via [FormFieldManagement.focus]
  /// or ensure field visible via [FormFieldManagement.ensureVisible]
  List<FormFieldManagementWithError> quietlyValidate();

  /// equals to setData(data,trigger:true)
  set data(Map<String, dynamic> data) => setData(data);

  /// set form data
  ///
  /// [trigger] whether trigger onChanged
  void setData(Map<String, dynamic> data, {bool trigger = true});

  /// reset form
  ///
  /// **only reset all value fields**
  void reset();

  /// validate form and return is valid or not
  ///
  /// **will display error if invalid ,
  /// if you only want to know the form is valid or not ,
  /// use [isValid] instead**
  bool validate();

  /// whether form is valid
  ///
  /// **only check is valid or not , won't show error**
  bool get isValid;

  /// save all form fields
  ///
  /// form field's onSaved will be  called
  void onSaved();
}

/// used to control form field
abstract class FormFieldManagement {
  ///get field's name
  String? get name;
  // bool get readOnly;

  bool get readOnly;

  /// set readOnly on field,it's equals to update1('readOnly',readOnly)
  //set readOnly(bool readOnly);
  set readOnly(bool readOnly);

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

  /// make current field visible in viewport
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

abstract class CastableFormFieldManagement extends FormFieldManagementDelegate {
  /// whether this formfieldmanagement can cast to target
  bool canCast<T extends FormFieldManagement>() => delegate is T;

  /// cast FormFieldManagement to what you want
  ///
  /// if field is BaseCommonField , can cast to [BaseFormFieldManagement]
  T cast<T extends FormFieldManagement>() {
    if (delegate is! T)
      throw 'current FormFieldManagement is ${delegate.runtimeType}, can not cast to $T';
    return delegate as T;
  }
}
