import 'package:flutter/widgets.dart';
import 'forme_field.dart';

import '../forme.dart';
import 'forme_state_model.dart';
import 'widget/forme_field_decorator.dart';

/// base form controller
///
/// you can access a form controller by [FormeKey]
abstract class FormeController {
  /// whether form has a name field
  bool hasField(String name);

  /// whether form is readonly
  bool get readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly);

  /// create a new [FormeFieldController] by name
  ///
  /// you can override [AbstractFieldState.createFormeFieldController] to wrap you custom
  /// FormeFieldController, and this method will return your wrapped.
  /// **when you override this method,
  /// you should handle value that returned  by parent carefully to avoid lose some abilities provided by  parent**
  T field<T extends FormeFieldController>(String name);

  /// create a new [FormeValueFieldController] by name
  ///
  /// you can override [AbstractFieldState.createFormeFieldController] to wrap you custom
  /// FormeFieldController, and this method will return your wrapped.
  /// **when you override this method,
  /// you should handle value that returned  by parent carefully to avoid lose some abilities provided by  parent**
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

  /// get error msg after validate form,if you don't want to display error text,
  /// look at [quietlyValidate]
  ///
  /// you can get errorText
  /// via [FormeFieldControllerWithError.errorText]
  /// or request a focus via [FormeFieldController.focus]
  /// or ensure field visible via [FormeFieldController.ensureVisible]
  List<FormeFieldControllerWithError> get errors;

  /// perform a validate
  ///
  /// if [Forme.quietlyValidate] is true, this method will not display default error
  ///
  /// **if [quietly] is true , this method will not update and display error though [Forme.quietlyValidate] is false**
  ///
  ///
  /// you can get errorText
  /// via [FormeFieldControllerWithError.errorText]
  /// or request a focus via [FormeFieldController.focus]
  /// or ensure field visible via [FormeFieldController.ensureVisible]
  List<FormeFieldControllerWithError> validate({bool quietly = false});

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
  FormeController get controller;

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

  /// whether field is value field
  bool get isValueField;

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
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenableController] instead**
  FormeValueListenable<bool> get focusListenable;

  static T of<T extends FormeFieldController>(BuildContext context) {
    return InheritedFormeFieldController.of(context) as T;
  }

  static T? maybeOf<T extends FormeFieldController>(BuildContext context) {
    return InheritedFormeFieldController.of(context) as T;
  }
}

abstract class FormeValueFieldController<T, E extends FormeModel>
    extends FormeFieldController<E> {
  /// get current value of valuefield
  T? get value;

  /// set newValue on valuefield,this method will trigger onChanged listener
  /// if you don't want to trigger it,you can use setValue method
  set value(T? value) => setValue(value, trigger: true);

  /// set newValue on valuefield,if trigger is false,won't trigger onChanged listener
  setValue(T? value, {bool trigger: true});

  /// validate field , return errorText
  ///
  /// if [quietly] is true,will not rebuild field and update and display error Text
  String? validate({bool quietly = false});

  /// reset valuefield,will set value to initialValue
  /// also clear error msg
  void reset();

  /// get error message
  ///
  /// if [Forme.quietlyValidate] is true, this method will always return null
  String? get errorText;

  /// save field
  ///
  /// trigger save listener
  void save();

  /// get forme decorator controller
  ///
  /// maybe null if field not wrapped by a [FormeDecorator]
  FormeDecoratorController<T>?
      getFormeDecoratorController<T extends FormeModel>();

  /// get error listenable
  ///
  /// it's useful when you want to display error by your custom way!
  ///
  /// this notifier is used for [ValueListenableBuilder]
  ///
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenableController] instead**
  FormeValueListenable<Optional<String>?> get errorTextListenable;

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
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenableController] instead**
  FormeValueListenable<T?> get valueListenable;
}

abstract class FormeFieldControllerDelegate<E extends FormeModel>
    implements FormeFieldController<E> {
  FormeFieldController<E> get delegate;

  @override
  FormeController get controller => delegate.controller;
  @override
  E get model => delegate.model;
  @override
  set model(E model) => delegate.model = model;
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
        alignmentPolicy: alignmentPolicy,
        alignment: alignment,
      );
  @override
  set focus(bool focus) => delegate.focus = focus;
  @override
  bool get focusable => delegate.focusable;
  @override
  bool get hasFocus => delegate.hasFocus;
  @override
  bool get isValueField => true;
  @override
  String? get name => delegate.name;
  @override
  void updateModel(E model) => delegate.updateModel(model);
  @override
  FormeValueListenable<bool> get focusListenable => delegate.focusListenable;
}

abstract class FormeValueFieldControllerDelegate<T, E extends FormeModel>
    extends FormeFieldControllerDelegate<E>
    implements FormeValueFieldController<T, E> {
  FormeValueFieldController<T, E> get delegate;

  @override
  T? get value => delegate.value;
  @override
  set value(T? value) => setValue(value, trigger: true);
  @override
  setValue(T? value, {bool trigger: true}) =>
      delegate.setValue(value, trigger: true);
  @override
  String? validate({bool quietly = false}) =>
      delegate.validate(quietly: quietly);
  @override
  void reset() => delegate.reset();
  @override
  String? get errorText => delegate.errorText;
  @override
  void save() => delegate.save();
  @override
  FormeDecoratorController<T>?
      getFormeDecoratorController<T extends FormeModel>() =>
          delegate.getFormeDecoratorController<T>();
  @override
  FormeValueListenable<Optional<String>?> get errorTextListenable =>
      delegate.errorTextListenable;
  @override
  FormeValueListenable<T?> get valueListenable => delegate.valueListenable;
}
