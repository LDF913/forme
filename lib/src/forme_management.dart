import 'package:flutter/widgets.dart';
import 'forme_field.dart';

import '../forme.dart';
import 'forme_state_model.dart';

/// base form management
///
/// you can access a form management by [FormeKey]
abstract class FormeManagement {
  /// whether form has a name field
  bool hasField(String name);

  /// whether form is readonly
  bool get readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly);

  /// create a new [FormeFieldManagement] by name
  ///
  /// you can override [AbstractFieldState.createFormeFieldManagement] to wrap you custom
  /// FormeFieldManagement, and this method will return your wrapped.
  /// **when you override this method,
  /// you should handle value that returned  by parent carefully to avoid lose some abilities provided by  parent**
  T field<T extends FormeFieldManagement>(String name);

  /// create a new [FormeValueFieldManagement] by name
  ///
  /// you can override [AbstractFieldState.createFormeFieldManagement] to wrap you custom
  /// FormeFieldManagement, and this method will return your wrapped.
  /// **when you override this method,
  /// you should handle value that returned  by parent carefully to avoid lose some abilities provided by  parent**
  T valueField<T extends FormeValueFieldManagement>(String name);

  /// get form data
  ///
  /// if a value field doesn't has a name ,it's value will be ignored
  Map<String, dynamic> get data;

  /// get error msg after validate form,if you don't want to display error text,
  /// look at [quietlyValidate]
  ///
  /// you can get errorText
  /// via [FormeFieldManagementWithError.errorText]
  /// or request a focus via [FormeFieldManagement.focus]
  /// or ensure field visible via [FormeFieldManagement.ensureVisible]
  List<FormeFieldManagementWithError> get errors;

  /// perform a quietly validate, used to get error text and without display it
  ///
  /// this method will not set errorText on field and rebuild field , so after this method called
  /// [FormeValueFieldManagement.isValid] still return true even though an error text returned by
  /// field's validator ,  also [FormeValueFieldManagement.errorText] will   return null too,
  /// so value field will not display error
  ///
  /// you can get errorText
  /// via [FormeFieldManagementWithError.errorText]
  /// or request a focus via [FormeFieldManagement.focus]
  /// or ensure field visible via [FormeFieldManagement.ensureVisible]
  List<FormeFieldManagementWithError> quietlyValidate();

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
abstract class FormeFieldManagement<E extends FormeModel> {
  /// get forme management
  FormeManagement get management;

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
  /// FormeFieldManagement<FormeTextFieldModel> m;
  /// // update field's labelText to '123'
  /// m.update(FormeTextFieldModel(inputDecoration:InputDecoration(labelText:'123')));
  /// // update field's labelText size to 20, you won't lose labelText!
  /// m.update(FormeTextFieldModel(inputDecoration:InputDecoration(labelStyle:TextStyle(fontSize:20))));
  /// ```
  ///
  /// **update a null value will not work! if you update some attributes to null,use [set model] instead**
  void update(E model);

  /// make current field visible in viewport
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment});

  static T of<T extends FormeFieldManagement>(BuildContext context) {
    return InheritedFormeFieldManagement.of(context) as T;
  }

  static T? maybeOf<T extends FormeFieldManagement>(BuildContext context) {
    return InheritedFormeFieldManagement.of(context) as T;
  }
}

abstract class FormeValueFieldManagement<T, E extends FormeModel>
    extends FormeFieldManagement<E> {
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

  /// save field
  ///
  /// trigger save listener
  void save();

  /// set decorator model
  ///
  /// see [FormeInputDecorator]
  set decoratorModel(FormeModel model);

  /// get current decorator model;
  ///
  /// if you field not wrapped by any FormeDecorator ,this method will return null
  /// see [FormeInputDecorator]
  FormeModel? get currentDecoratorModel;

  /// update a decorator model
  ///
  /// no need to call `model.copyWith(oldModel)` manually
  ///
  /// see [FormeInputDecorator]
  void updateDecoratorModel(FormeModel model);
}

abstract class FormeFieldManagementDelegate<E extends FormeModel>
    implements FormeFieldManagement<E> {
  FormeFieldManagement<E> get delegate;

  @override
  FormeManagement get management => delegate.management;
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
  void update(E model) => delegate.update(model);
}

class FormeValueFieldManagementDelegate<T, E extends FormeModel>
    extends FormeFieldManagementDelegate<E>
    implements FormeValueFieldManagement<T, E> {
  final FormeValueFieldManagement<T, E> delegate;

  FormeValueFieldManagementDelegate(this.delegate);

  @override
  T? get value => delegate.value;
  @override
  set value(T? value) => setValue(value, trigger: true);
  @override
  setValue(T? value, {bool trigger: true}) =>
      delegate.setValue(value, trigger: true);
  @override
  bool get isValid => delegate.isValid;
  @override
  bool validate() => delegate.validate();
  @override
  void reset() => delegate.reset();
  @override
  String? get errorText => delegate.errorText;
  @override
  String? quietlyValidate() => delegate.quietlyValidate();
  @override
  void save() => delegate.save();
  @override
  FormeModel? get currentDecoratorModel => delegate.currentDecoratorModel;
  @override
  void updateDecoratorModel(FormeModel decoratorModel) =>
      delegate.updateDecoratorModel(decoratorModel);
  @override
  set decoratorModel(FormeModel decoratorModel) =>
      delegate.decoratorModel = decoratorModel;
}

abstract class FormeProxyFieldManagment<
    E extends FormeModel,
    N extends FormeModel,
    K extends FormeFieldManagement<N>> implements FormeFieldManagement<E> {
  set proxyManagement(K proxyManagement);
}

/// proxy value field management
/// [FormeRadioGroup]
abstract class FormeProxyValueFieldManagement<T, E extends FormeModel, M,
        N extends FormeModel, K extends FormeValueFieldManagement<M, N>>
    implements
        FormeValueFieldManagement<T, E>,
        FormeProxyFieldManagment<E, N, K> {}

/// an proxy management
abstract class FormeProxyFieldManagmentDelegate<E extends FormeModel,
        N extends FormeModel, K extends FormeFieldManagement<N>>
    implements FormeProxyFieldManagment<E, N, K> {
  final FormeFieldManagement<E> delegate;
  FormeProxyFieldManagmentDelegate(this.delegate);
  late K _proxyManagement;
  @override
  set proxyManagement(K proxyManagement) {
    _proxyManagement = proxyManagement;
  }

  @protected
  K get proxyManagement => _proxyManagement;

  @override
  String? get name => delegate.name;
  @override
  set model(E model) => _proxyManagement.model = deconvertModel(model);
  @override
  update(E model) => _proxyManagement.update(deconvertModel(model));
  @override
  E get model => convertModel(_proxyManagement.model);
  @override
  FormeManagement get management => delegate.management;
  @override
  bool get isValueField => false;
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
  @override
  set focus(bool focus) => _proxyManagement.focus = focus;
  @override
  bool get focusable => _proxyManagement.focusable;
  @override
  bool get hasFocus => _proxyManagement.hasFocus;

  N deconvertModel(E model);

  E convertModel(N model);
}

abstract class FormeProxyValueFieldManagementDelegate<T, E extends FormeModel,
        M, N extends FormeModel, K extends FormeValueFieldManagement<M, N>>
    extends FormeProxyFieldManagmentDelegate<E, N, K>
    implements FormeProxyValueFieldManagement<T, E, M, N, K> {
  FormeProxyValueFieldManagementDelegate(
      FormeValueFieldManagement<T, E> delegate)
      : super(delegate);
  @override
  FormeValueFieldManagement<T, E> get delegate =>
      super.delegate as FormeValueFieldManagement<T, E>;

  @override
  T? get value => convertValue(_proxyManagement.value);
  @override
  set value(T? value) => _proxyManagement.value = deconvertValue(value);
  @override
  setValue(T? value, {bool trigger: true}) =>
      _proxyManagement.setValue(deconvertValue(value), trigger: trigger);
  @override
  String? get errorText => _proxyManagement.errorText;
  @override
  bool get isValid => _proxyManagement.isValid;
  @override
  String? quietlyValidate() => _proxyManagement.quietlyValidate();
  @override
  void reset() => _proxyManagement.reset();
  @override
  bool validate() => _proxyManagement.validate();
  @override
  bool get isValueField => true;
  @override
  void save() => _proxyManagement.save();
  @override
  FormeModel? get currentDecoratorModel => delegate.currentDecoratorModel;
  @override
  void updateDecoratorModel(FormeModel decoratorModel) =>
      delegate.updateDecoratorModel(decoratorModel);
  @override
  set decoratorModel(FormeModel decoratorModel) =>
      delegate.decoratorModel = decoratorModel;

  T? convertValue(M? value);

  M? deconvertValue(T? value);
}
