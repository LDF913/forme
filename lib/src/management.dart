import 'package:flutter/widgets.dart';

import '../form_builder.dart';
import 'focus_node.dart';
import 'form_state_model.dart';
import 'text_selection.dart';

/// base form management
///
/// you can access a form management by [FormKey]
///
/// **if you are use layout form builder, you can cast this to [LayoutFormManagement] ,
/// which can use [FormLayoutManagement] and hide|show form**
abstract class FormManagement {
  /// whether form has a name field
  bool hasField(String name);

  /// whether form is readonly
  bool get readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly);

  /// create a new formfieldManagement by name
  ///
  /// when your field is a BaseField and your form is LayoutForm,
  /// you can cast FormFieldManagement as [BaseLayoutFormFieldManagement] , which
  /// can used to check visible of field or get field's position
  ///
  /// you can override [AbstractFieldState.createFormFieldManagement] to wrap you custom
  /// FormFieldManagement, and this method will return your wrapped.
  /// **when you override this method,
  /// you should handle value that returned  by parent carefully to avoid lose some abilities provided by  parent**
  T newFormFieldManagement<T extends FormFieldManagement>(String name);

  /// get form data
  ///
  /// if a value field doesn't has a name ,it's value will be ignored
  Map<String, dynamic> get data;

  /// get error msg after validate form,if you don't want to display error text,
  /// look at [quietlyValidate]
  ///
  /// you can get errorText
  /// via [FormFieldManagementWithError.errorText]
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
  void save();
}

/// used to control form field
abstract class FormFieldManagement<T extends AbstractFieldStateModel> {
  ///get field's name
  String? get name;

  /// whether field is readOnly;
  bool get readOnly;

  /// set readOnly on field,it's equals to update1('readOnly',readOnly)
  /// set readOnly(bool readOnly);
  set readOnly(bool readOnly);

  /// whether field is focusable
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

  /// set state model on field
  ///
  /// [model] is provided by your custom [AbstractFieldState],
  /// if you no need a model,you can use [EmptyStateModel]
  ///
  /// model is a property variable of [AbstractFieldState],used to provide
  /// data that determine how to render a field , you can
  /// rebuild field easily via call this method and
  /// avoid build whole form
  ///
  /// **model's all properties should be nullable**
  ///
  /// **model's runtimetype must be  a child or same as  your custom [AbstractFieldState]'s generic model type**
  set model(T model);

  /// get current state model;
  T get model;

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
  /// if you don't want to trigger it,you can use setValue method
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
