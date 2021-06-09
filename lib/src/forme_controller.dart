import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'forme_field.dart';

import 'package:forme/forme.dart';
import 'forme_state_model.dart';

/// base form controller
///
/// you can access a form controller by [FormeKey] or [FormeKey.of]
abstract class FormeController {
  /// whether form has a name field
  bool hasField(String name);

  /// whether form is readonly
  bool get readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly);

  /// find [FormeFieldController] by name
  T field<T extends FormeFieldController>(String name);

  /// find [FormeValueFieldController] by name
  T valueField<T extends FormeValueFieldController>(String name);

  /// notifiers of form field's focus|errorText|value
  ///
  ///
  /// **unlike [FormeFieldController]'s notifier , this controller's notifier will auto find last alived [FormeFieldController] by name,
  /// in another words , this controller's lifestyle is same as form,but [FormeFieldController]'s lifecycle is same as field,
  /// so it's safe to use this controller out of form field**
  ///
  /// **do not use this notifier out of forme**
  ///
  /// see [FormeInputDecorator]
  FormeFieldListenable<T> fieldListenable<T>(String name);

  /// get form data
  ///
  /// if a value field doesn't has a name ,it's value will be ignored
  Map<String, dynamic> get data;

  /// get error msg after [performValidate]
  ///
  /// key is [FormeValueFieldController]
  Map<FormeValueFieldController, String> get errors;

  /// perform a validate
  ///
  /// if [Forme.quietlyValidate] is true, this method will not display default error
  ///
  /// **if [quietly] is true , this method will not update and display error though [Forme.quietlyValidate] is false**
  ///
  /// key is [FormeValueFieldController]
  /// value is errorMsg
  Map<FormeValueFieldController, String> performValidate(
      {bool quietly = false});

  /// set forme data
  set data(Map<String, dynamic> data);

  /// reset form
  ///
  /// **only reset all value fields**
  void reset();

  /// save all form fields
  ///
  /// form field's onSaved will be  called
  void save();

  /// whether validate is quietly
  bool get quietlyValidate;

  /// set validate quietly
  ///
  /// **call this method (if Forme's quietlyValidate is false) if you want to display error by a custom way**
  set quietlyValidate(bool quietlyValidate);
}

/// used to control form field
abstract class FormeFieldController<E extends FormeModel> {
  /// get forme controller
  FormeController get formeController;

  ///get field's name
  String get name;

  /// whether field is readOnly;
  bool get readOnly;

  /// set readOnly on field,it's equals to update1('readOnly',readOnly)
  /// set readOnly(bool readOnly);
  set readOnly(bool readOnly);

  // whether field is focused
  bool get hasFocus;

  /// request focus
  ///
  /// if current field don't have a focusNode or focusNode is unfocusable,this method will no effect
  void requestFocus();

  /// unfocus
  ///
  /// if current field don't have a focusNode or focusNode is unfocusable,this method will no effect
  void unfocus({
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  });

  /// set state model on field
  ///
  /// directly set model will lose old model
  /// if you want to inherit old model, you can use  update model
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
  /// **the model's runtimetype must be  a child or same as  your custom [AbstractFieldState]'s generic model type**
  set model(E model);

  /// get current state model;
  E get model;

  /// update a model
  ///
  /// you needn't to call `model.copyWith(oldModel)` manually ,
  /// when you want to update something,just create a new model with the attributes
  /// you want to update,Forme will auto copy old model's attributes to new model
  ///
  /// ```
  /// FormeFieldController<FormeTextFieldModel> m;
  /// // update field's labelText to '123'
  /// m.update(FormeTextFieldModel(inputDecoration:InputDecoration(labelText:'123')));
  /// // update field's labelText size to 20, you won't lose labelText!
  /// m.update(FormeTextFieldModel(inputDecoration:InputDecoration(labelStyle:TextStyle(fontSize:20))));
  /// ```
  ///
  /// **update a null value will not work! if you update some attributes to null,use [set model] instead**
  void updateModel(E model);

  /// make current field visible in viewport
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment});

  /// focus listenable
  ///
  /// it's lifecycle is same as field
  ///
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenable] instead**
  ValueListenable<bool> get focusListenable;

  static T of<T extends FormeFieldController>(BuildContext context) {
    return InheritedFormeFieldController.of(context) as T;
  }
}

abstract class FormeValueFieldController<T, E extends FormeModel>
    extends FormeFieldController<E> {
  /// get current value of valuefield
  T? get value;

  /// set field value
  set value(T? value);

  /// validate field , return errorText
  ///
  /// if [quietly] is true,will not rebuild field and update and display error Text
  String? performValidate({bool quietly = false});

  /// reset valuefield,will set value to initialValue
  /// also clear error msg
  void reset();

  /// get error
  ///
  /// error is null means this field has not validated yet
  ///
  /// if error is not null and [FormeValidateError.text] is null ,means field is valid
  ///
  /// if error is not null and [FormeValidateError.text] is not null ,means is invalid
  ///
  /// if [Forme.quietlyValidate] is true, this method will always return null
  FormeValidateError? get error;

  /// save field
  ///
  /// trigger save listener
  void save();

  /// get forme decorator controller
  FormeDecoratorController get decoratorController;

  /// get error listenable
  ///
  /// it's useful when you want to display error by your custom way!
  ///
  /// this notifier is used for [ValueListenableBuilder]
  ///
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenable] instead**
  ValueListenable<FormeValidateError?> get errorTextListenable;

  /// get value listenable
  ///
  /// same as widget's onChanged , but it is more useful
  /// when you want to build a widget relies on field's value change
  ///
  /// eg: if you want to build a clear icon on textfield , but don't want to display it
  /// when textfield's value is empty ,you can do like this :
  ///
  /// ``` dart
  ///  return ValueListenableBuilder<String?>(
  ///         valueListenable:formeKey.valueField(name).valueListenable,
  ///         builder: (context, a, b) {
  ///           return a == null || a.length == 0
  ///               ? SizedBox()
  ///               : IconButton(icon:Icon(Icons.clear),onPressed:(){
  ///                 formeKey.valueField(name).value = '';
  ///               });
  ///         });
  /// ```
  ///
  /// this notifier is used for [ValueListenableBuilder]
  ///
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenable] instead**
  ValueListenable<T?> get valueListenable;

  static T of<T extends FormeValueFieldController>(BuildContext context) {
    return InheritedFormeFieldController.of(context) as T;
  }
}

/// used to control decorator's model
/// see  [ValueField.decoratorBuilder]
abstract class FormeDecoratorController {
  /// get current decorator model
  ///
  /// always return null if you don't update or set a decorator model yet
  FormeModel? get currentModel;

  /// update decorator model
  ///
  /// the model type is determined by type of FormeDecorator
  ///
  /// eg: [FormeInputDecorator]'s model type is [FormeInputDecoratorModel]
  update(FormeModel model);

  /// set decorator model
  ///
  /// the model type is determined by type of FormeDecorator
  ///
  /// eg: [FormeInputDecorator]'s model type is [FormeInputDecoratorModel]
  set model(FormeModel model);
}
