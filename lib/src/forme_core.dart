import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'forme_utils.dart';
import 'forme_field.dart';
import 'forme_state_model.dart';
import 'forme_controller.dart';
import 'widget/forme_field_decorator.dart';

/// triggered when form field's value changed
typedef FormeValueChanged = void Function(
    FormeValueFieldController field, dynamic oldValue, dynamic newValue);

// listen focus change
typedef FocusListener<T extends FormeFieldController> = void Function(
    T field, bool hasFocus);

/// listen field errorText change
typedef ValidateErrorListener<T extends FormeValueFieldController> = void
    Function(T field, String? errorText);

/// form key is a global key
class FormeKey extends LabeledGlobalKey<_FormeState>
    implements FormeController {
  FormeKey({String? debugLabel}) : super(debugLabel);

  /// whether formKey is initialized
  bool get initialized {
    _FormeState? state = currentState;
    if (state == null) return false;
    return true;
  }

  /// get form controller , throw an error if there's no form controller
  FormeController get _currentController {
    _FormeState? currentState = super.currentState;
    if (currentState == null) {
      throw 'current state is null,did you put this key on Forme?';
    }
    return currentState.formeController;
  }

  @override
  Map<String, dynamic> get data => _currentController.data;

  @override
  bool get readOnly => _currentController.readOnly;

  @override
  List<FormeFieldControllerWithError> get errors => _currentController.errors;

  @override
  T field<T extends FormeFieldController>(String name) =>
      _currentController.field<T>(name);

  @override
  bool hasField(String name) => _currentController.hasField(name);

  @override
  bool get isValid => _currentController.isValid;

  @override
  List<FormeFieldControllerWithError> validate() =>
      _currentController.validate();

  @override
  void reset() => _currentController.reset();

  @override
  void save() => _currentController.save();

  @override
  void setData(Map<String, dynamic> data, {bool trigger = true}) =>
      _currentController.setData(data, trigger: trigger);

  @override
  T valueField<T extends FormeValueFieldController>(String name) =>
      _currentController.valueField<T>(name);

  @override
  set data(Map<String, dynamic> data) => _currentController.data = data;

  @override
  set readOnly(bool readOnly) => _currentController.readOnly = readOnly;

  @override
  FormeFieldNotifier<T> fieldNotifier<T>(String name) =>
      _currentController.fieldNotifier<T>(name);

  static FormeController of(BuildContext context) {
    return _FormScope.of(context).formeController;
  }

  @override
  bool get quietlyValidate => _currentController.quietlyValidate;

  @override
  set quietlyValidate(bool quietlyValidate) =>
      _currentController.quietlyValidate = quietlyValidate;
}

/// build your form
class Forme extends StatefulWidget {
  /// whether form should be readOnly;
  ///
  /// default false
  final bool readOnly;

  /// listen form value changed
  ///
  /// this listener will be always triggered when field'value changed
  final FormeValueChanged? onChanged;

  /// form content
  final Widget child;

  /// map initial value
  ///
  /// **this property will override field's initialValue**
  final Map<String, dynamic> initialValue;

  /// used to listen field's validate error changed
  ///
  /// triggerer when:
  ///
  /// 1. if your field's autovalidatemode is not disabled, **in this case, will triggered after current frame completed**
  /// 2. after called [validate] method
  /// 3. after called [quietlyValidate] method
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final ValidateErrorListener? validateErrorListener;

  final WillPopCallback? onWillPop;

  /// if this flag is true , will not display default error when perform a valiate
  ///
  /// [FormeValueFieldController.errorText] will return null
  final bool quietlyValidate;

  Forme({
    FormeKey? key,
    this.readOnly = false,
    this.onChanged,
    required this.child,
    this.initialValue = const {},
    this.validateErrorListener,
    this.onWillPop,
    this.quietlyValidate = false,
  }) : super(key: key);

  @override
  _FormeState createState() => _FormeState();
}

class _FormeState extends State<Forme> {
  late final _FormeController formeController;
  final ValueNotifier<List<FormeFieldController>> controllerAliveNotifier =
      ValueNotifier([]);

  bool? _readOnly;
  bool? _quietlyValidate;

  @override
  void initState() {
    super.initState();
    formeController = _FormeController(this);
  }

  @protected
  int gen = 0;

  bool get readOnly => _readOnly ?? widget.readOnly;
  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      setState(() {
        gen++;
        _readOnly = readOnly;
      });
    }
  }

  bool get quietlyValidate => _quietlyValidate ?? widget.quietlyValidate;
  set quietlyValidate(bool quietlyValidate) {
    if (_quietlyValidate != quietlyValidate) {
      setState(() {
        gen++;
        _quietlyValidate = quietlyValidate;
      });
    }
  }

  T? getFormeFieldController<T extends FormeFieldController>(String name) {
    Iterable<FormeFieldController> iterable =
        controllerAliveNotifier.value.where((element) => element.name == name);
    if (iterable.isNotEmpty) return iterable.first as T;
  }

  @override
  void dispose() {
    formeController._dispose();
    controllerAliveNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _InheritedFormScope(
        gen: gen,
        formScope: _FormScope(
          formeController: formeController,
          readOnly: readOnly,
          controllerAliveNotifier: controllerAliveNotifier,
          valueChanged: widget.onChanged,
          formInitialValue: widget.initialValue,
          validateErrorListener: widget.validateErrorListener,
          quietlyValidate: quietlyValidate,
        ),
        child: widget.child,
      ),
      onWillPop: widget.onWillPop,
    );
  }
}

class _InheritedFormScope extends InheritedWidget {
  final int gen;
  final _FormScope formScope;

  _InheritedFormScope({
    required this.gen,
    required this.formScope,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant _InheritedFormScope oldWidget) {
    return gen != oldWidget.gen;
  }
}

class _FormScope {
  final FormeController formeController;
  final bool readOnly;
  final bool quietlyValidate;
  final FormeValueChanged? valueChanged;
  final Map<String, dynamic> formInitialValue;
  final ValidateErrorListener? validateErrorListener;
  final Map<String, String> errorMap = {};
  final ValueNotifier<List<FormeFieldController>> controllerAliveNotifier;

  void onValueChanged(
      FormeValueFieldController controller, oldValue, newValue) {
    if (valueChanged != null) valueChanged!(controller, oldValue, newValue);
  }

  void onValidateError(FormeValueFieldController field, String? errorText) {
    if (validateErrorListener != null) validateErrorListener!(field, errorText);
  }

  _FormScope({
    required this.readOnly,
    this.valueChanged,
    required this.formInitialValue,
    this.validateErrorListener,
    required this.formeController,
    required this.controllerAliveNotifier,
    required this.quietlyValidate,
  });

  void registerField(FormeFieldController controller) {
    controllerAliveNotifier.value = List.of(controllerAliveNotifier.value)
      ..add(controller);
  }

  void unregisterField(FormeFieldController controller) {
    controllerAliveNotifier.value = List.of(controllerAliveNotifier.value)
      ..remove(controller);
  }

  static _FormScope of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedFormScope>()!
      .formScope;

  bool hasInitialValue(String? name) =>
      name != null && formInitialValue.containsKey(name);

  dynamic getInitialValue(String? name) => formInitialValue[name];
}

/// state for all stateful form field
///
/// if you want Forme control your custom stateful field,you can do as follows
///
/// 1. make your custom field extends StatefulWidget and with [StatefulField]
/// 2. make your custom state extends State and with [AbstractFieldState]
///
mixin AbstractFieldState<T extends StatefulWidget, E extends FormeModel>
    on State<T> {
  bool _init = false;
  FocusNode? _focusNode;
  String? get name => _field.name;
  late final FormeFieldController<E> controller;

  bool get init => _init;

  late _FormScope _formScope;

  E? _model;

  /// whether field should be readOnly
  bool get readOnly => _formScope.readOnly || (_readOnly ?? _field.readOnly);

  /// whether field is readOnly
  bool? _readOnly;

  /// set readOnly on this field
  set readOnly(bool readOnly) {
    if (readOnly != _readOnly)
      setState(() {
        _readOnly = readOnly;
      });
  }

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  FocusNode get focusNode {
    if (_focusNode == null) {
      _focusNode = FocusNode();
      _focusNode!.addListener(_onFocusChange);
    }
    return _focusNode ??= FocusNode();
  }

  void _onFocusChange() {
    controller.focusListenable._value = focusNode.hasFocus;
    if (_field.focusListener != null)
      _field.focusListener!(controller, focusNode.hasFocus);
  }

  /// focus current field is focusable
  void requestFocus() {
    if (_focusNode == null || !_focusNode!.canRequestFocus) return;
    _focusNode!.requestFocus();
  }

  /// you can override this method to wrap your custom FormeFieldController
  ///
  /// use [FormeController.newFormeFieldController] to get FormeFieldController that you wrapped,
  ///
  /// you can use [FormeFieldControllerDelegate] to fast wrap
  @protected
  FormeFieldController<E> createFormeFieldController() =>
      _FormeFieldController(this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formScope = _FormScope.of(context);
    if (_init) return;
    _init = true;
    controller = createFormeFieldController();
    _formScope.registerField(controller);
    afterInitiation();
  }

  /// called when  FormeFieldController created
  ///
  /// this method is called in didChangeDependencies and will only called once in state's lifecycle
  ///
  /// **init your resource in this method**
  @protected
  void afterInitiation() {}

  @override
  void dispose() {
    controller.focusListenable._notifier.dispose();
    _focusNode?.dispose();
    _formScope.unregisterField(controller);
    super.dispose();
  }

  /// used to do some logic before update model
  ///
  /// this method will triggered when update model
  @protected
  E beforeUpdateModel(E old, E current) => current;

  @protected
  E beforeSetModel(E old, E current) => current;

  StatefulField<AbstractFieldState<T, E>, E> get _field =>
      widget as StatefulField<AbstractFieldState<T, E>, E>;

  _updateModel(E _model) {
    if (_model != model) {
      E copy = beforeUpdateModel(model, _model);
      if (copy != model) {
        setState(() {
          this._model = copy.copyWith(model) as E;
        });
      }
    }
  }

  _setModel(E _model) {
    if (_model != model) {
      E copy = beforeSetModel(model, _model);
      if (copy != model) {
        setState(() {
          this._model = copy;
        });
      }
    }
  }

  /// set model but do no request a new frame
  ///
  /// **make sure call setState after this model**
  @protected
  setModel(E model) {
    this._model = model;
  }

  E get model => _model ?? _field.model;
}

/// this State is only used for [ValueField]
class ValueFieldState<T, E extends FormeModel> extends FormFieldState<T>
    with AbstractFieldState<FormField<T>, E> {
  @override
  ValueField<T, E> get widget => super.widget as ValueField<T, E>;

  @override
  String? get errorText => _formScope.quietlyValidate
      ? null
      : controller.errorTextListenable.value?._value;

  T? _value;
  String? _errorText;
  bool _hasInteractedByUser = false;

  @override
  bool get hasError => _errorText != null;

  @override
  bool get isValid => widget.validator?.call(_value) == null;

  @override
  T? get value => _value;

  void _validate() {
    if (widget.validator != null) _errorText = widget.validator!(_value);
  }

  @override
  FormeValueFieldController<T, E> get controller =>
      super.controller as FormeValueFieldController<T, E>;

  @override
  FormeValueFieldController<T, E> createFormeFieldController() =>
      _FormeValueFieldController(this);

  @override
  _setModel(E _model) {
    if (_model != model) {
      setState(() {
        this._model = beforeSetModel(model, _model);
      });
    }
  }

  /// get initialValue
  @protected
  T? get initialValue =>
      widget.initialValue ?? _formScope.getInitialValue(name);

  /// **when you want to init something that relies on initialValue,
  /// you should do that in [afterInitiation] rather than in this method**
  @override
  void initState() {
    super.initState();
  }

  /// this method is called in didChangeDependencies, but only called once in state's lifecycle
  ///
  /// get [FormFieldController] or access initialValue is safe here
  @override
  @mustCallSuper
  void afterInitiation() {
    _value = initialValue;
  }

  @override
  void didChange(T? value) {
    doChangeValue(value);
  }

  @protected
  @override
  void setValue(T? newValue) {
    newValue = beforeSetValue(newValue);
    if (!compare(value, newValue)) {
      _value = newValue;
      _didChange(value, newValue, true);
    }
  }

  /// handle new value before update value
  @protected
  T? beforeSetValue(T? value) => value;

  @visibleForTesting
  void doChangeValue(T? newValue, {bool trigger = true}) {
    newValue = beforeSetValue(newValue);
    T? oldValue = value;
    if (!compare(oldValue, newValue)) {
      setState(() {
        _value = newValue;
        _hasInteractedByUser = true;
        afterValueChanged(oldValue, newValue);
        _didChange(oldValue, newValue, trigger);
      });
    }
  }

  @override
  void reset() {
    T? oldValue = value;
    setState(() {
      _value = initialValue;
      _hasInteractedByUser = false;
      _errorText = null;
      afterValueChanged(oldValue, _value);
      _didChange(oldValue, _value, true);
      _onErrorTextChange(null);
    });
  }

  @override
  void dispose() {
    controller.valueListenable._notifier.dispose();
    controller.errorTextListenable._notifier.dispose();
    super.dispose();
  }

  /// used to compare two values  determine whether changeValue
  ///
  /// default used [FormeUtils.compare]
  ///
  /// override this method if it can't meet your needs
  @protected
  bool compare(T? a, T? b) {
    return FormeUtils.compare(a, b);
  }

  /// called after value changed
  ///
  /// when you want render value in field  after value changed ,you can override this method
  ///
  /// **called in [didChange] and [reset] , won't called in [setValue]**
  @protected
  void afterValueChanged(T? oldValue, T? current) {}

  _didChange(T? old, T? current, bool trigger) {
    if (trigger) {
      FormeFieldValueChanged<T, E>? onChanged = widget.onChanged;
      if (onChanged != null) onChanged(controller, old, current);
    }
    _formScope.onValueChanged(this.controller, old, current);
    controller.valueListenable._value = current;
  }

  @override
  bool validate() {
    if (widget.validator == null) return true;
    if (_formScope.quietlyValidate) {
      String? errorText = widget.validator!(value);
      _onErrorTextChange(Optional.fromNullable(errorText));
      return errorText == null;
    } else {
      setState(() {
        _validate();
        _onErrorTextChange(Optional.fromNullable(_errorText));
      });
      return isValid;
    }
  }

  void _onErrorTextChange(Optional<String>? nowErrorText) {
    if (controller.errorTextListenable.value != nowErrorText) {
      String? oldErrorText = controller.errorTextListenable.value?._value;
      controller.errorTextListenable._value = nowErrorText;
      onErrorTextChange(oldErrorText, nowErrorText?._value);
      if (widget.validateErrorListener != null)
        widget.validateErrorListener!(controller, nowErrorText?._value);
      _formScope.onValidateError(controller, nowErrorText?._value);
    }
  }

  @protected
  void onErrorTextChange(String? oldErrorText, String? currentErrorText) {}

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    bool needValidate = widget.validator != null &&
        widget.enabled &&
        ((widget.autovalidateMode == AutovalidateMode.always) ||
            (widget.autovalidateMode == AutovalidateMode.onUserInteraction &&
                _hasInteractedByUser));
    if (needValidate) {
      _validate();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _onErrorTextChange(Optional.fromNullable(_errorText));
      });
    }
    return InheritedFormeFieldController(controller, widget.builder(this));
  }
}

class NonnullValueFieldState<T, E extends FormeModel>
    extends ValueFieldState<T, E> {
  @protected
  T get initialValue =>
      super.initialValue ?? (widget as NonnullValueField).initialValue;

  @override
  T get value => super.value!;

  @override
  void doChangeValue(T? newValue, {bool trigger = true}) {
    super.doChangeValue(newValue == null ? initialValue : newValue,
        trigger: trigger);
  }

  @mustCallSuper
  @override
  void setValue(T? value) {
    super.setValue(value == null ? initialValue : value);
  }

  @override
  void afterValueChanged(T? oldValue, T? current) {
    afterNonnullValueChanged(oldValue!, current!);
  }

  @protected
  void afterNonnullValueChanged(T oldValue, T current) {}
}

class _FormeFieldController<E extends FormeModel>
    extends FormeFieldController<E> {
  final AbstractFieldState<StatefulWidget, E> state;
  final FormeValueListenable<bool> focusListenable =
      FormeValueListenable._(ValueNotifier(false));

  _FormeFieldController(this.state);

  @override
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment}) {
    return Scrollable.ensureVisible(state.context,
        duration: duration ?? Duration.zero,
        curve: curve ?? Curves.ease,
        alignmentPolicy:
            alignmentPolicy ?? ScrollPositionAlignmentPolicy.explicit,
        alignment: alignment ?? 0);
  }

  @override
  bool get focusable =>
      state._focusNode != null && state._focusNode!.canRequestFocus;
  @override
  bool get hasFocus {
    if (state._focusNode == null) throw 'current field do not has a focusnode';
    return state._focusNode!.hasFocus;
  }

  @override
  set focus(bool focus) {
    if (!focusable)
      throw 'current field do not has a focusnode or focusnode can not request a focus';
    if (focus)
      state._focusNode!.requestFocus();
    else
      state._focusNode!.unfocus();
  }

  @override
  bool get isValueField => state is ValueFieldState;

  E get model => state.model;

  @override
  String? get name => state.name;

  @override
  bool get readOnly => state.readOnly;

  @override
  set readOnly(bool readOnly) => state.readOnly = readOnly;

  @override
  set model(E model) {
    state._setModel(model);
  }

  @override
  void updateModel(E model) {
    state._updateModel(model);
  }

  @override
  FormeController get controller =>
      _FormScope.of(state.context).formeController;
}

class _FormeValueFieldController<T, E extends FormeModel>
    extends FormeFieldControllerDelegate<E>
    implements FormeValueFieldController<T, E> {
  final ValueFieldState<T, E> state;
  final FormeFieldController<E> delegate;
  _FormeValueFieldController(this.state)
      : this.delegate = _FormeFieldController<E>(state);
  final FormeValueListenable<Optional<String>?> errorTextListenable =
      FormeValueListenable._(ValueNotifier(null));
  final FormeValueListenable<T?> valueListenable =
      FormeValueListenable._(ValueNotifier(null));

  @override
  T? get value => state.value;

  @override
  set value(T? value) => state.doChangeValue(value, trigger: true);

  @override
  void setValue(T? value, {bool trigger = true}) =>
      state.doChangeValue(value, trigger: trigger);

  @override
  String? get errorText => state.errorText;

  @override
  bool get isValid => state.isValid;

  @override
  void reset() => state.reset();

  @override
  bool validate() => state.validate();

  @override
  void save() => state.save();

  @override
  FormeDecoratorController<T>?
      getFormeDecoratorController<T extends FormeModel>() {
    return FormeDecoratorController.of<T>(state.context);
  }
}

class FormeFieldControllerWithError {
  final FormeValueFieldController formeFieldController;
  final String errorText;
  const FormeFieldControllerWithError._(
      this.formeFieldController, this.errorText);
}

class _FormeController extends FormeController {
  final _FormeState _state;

  List<FormeFieldNotifier> notifiers = [];
  _FormeController(this._state);

  @override
  bool hasField(String name) => _state.getFormeFieldController(name) != null;

  @override
  bool get readOnly => _state.readOnly;

  @override
  set readOnly(bool readOnly) => _state.readOnly = readOnly;

  @override
  T field<T extends FormeFieldController>(String name) {
    T? controller = _state.getFormeFieldController<T>(name);
    if (controller == null) throw 'no field can be found by name :$name';
    return controller;
  }

  @override
  T valueField<T extends FormeValueFieldController>(String name) {
    return field(name) as T;
  }

  @override
  Map<String, dynamic> get data {
    Map<String, dynamic> map = {};
    _valueFieldControllers.forEach((element) {
      String? name = element.name;
      if (name == null) return;
      dynamic value = element.value;
      map[name] = value;
    });
    return map;
  }

  @override
  List<FormeFieldControllerWithError> get errors {
    return _readErrors((state) => state.errorText);
  }

  @override
  List<FormeFieldControllerWithError> validate() {
    return _readErrors((state) {
      state.validate();
      return state.errorText;
    });
  }

  List<FormeFieldControllerWithError> _readErrors(
      String? f(FormeValueFieldController e)) {
    List<FormeFieldControllerWithError> errors = [];
    for (FormeValueFieldController controller in _valueFieldControllers) {
      if (controller.name == null) continue;
      String? errorText = f(controller);
      if (errorText == null) continue;
      errors.add(FormeFieldControllerWithError._(controller, errorText));
    }
    return errors;
  }

  @override
  set data(Map<String, dynamic> data) => setData(data);

  @override
  void setData(Map<String, dynamic> data, {bool trigger = true}) {
    if (data.isEmpty) return;
    data.map((key, value) => MapEntry(key, value)).forEach((key, value) {
      FormeValueFieldController? controller =
          _state.getFormeFieldController(key);
      if (controller == null || !controller.isValueField) return;
      controller.setValue(value, trigger: trigger);
    });
  }

  @override
  void reset() {
    _valueFieldControllers.forEach((element) {
      element.reset();
    });
  }

  @override
  bool get isValid {
    bool hasError = false;
    for (final FormeValueFieldController field in _valueFieldControllers)
      hasError = !field.isValid || hasError;
    return !hasError;
  }

  @override
  void save() {
    _valueFieldControllers.forEach((element) {
      element.save();
    });
  }

  @override
  FormeFieldNotifier<T> fieldNotifier<T>(String name) {
    for (FormeFieldNotifier notifier in notifiers) {
      if (notifier.name == name) return notifier as FormeFieldNotifier<T>;
    }
    FormeFieldNotifier<T> newNotifier = FormeFieldNotifier<T>._(name, _state);
    notifiers.add(newNotifier);
    return newNotifier;
  }

  void _dispose() {
    notifiers.removeWhere((element) {
      element._dispose();
      return true;
    });
  }

  Iterable<FormeValueFieldController> get _valueFieldControllers =>
      _state.controllerAliveNotifier.value
          .where((element) => element is FormeValueFieldController)
          .map((e) => e as FormeValueFieldController);

  @override
  bool get quietlyValidate => _state.quietlyValidate;

  @override
  set quietlyValidate(bool quietlyValidate) =>
      _state.quietlyValidate = quietlyValidate;
}

class FormeFieldNotifier<T> {
  final _FormeState _state;
  final String name;

  final FormeValueListenable<bool> focusListenable =
      FormeValueListenable._(ValueNotifier(false));
  final FormeValueListenable<Optional<String>?> errorTextListenable =
      FormeValueListenable._(ValueNotifier(null));
  final FormeValueListenable<T?> valueNotifier =
      FormeValueListenable._(ValueNotifier(null));

  FormeValueListenable<Optional<String>?>? _delegateErrorTextListenable;
  FormeValueListenable<bool>? _delegateFocusListenable;
  FormeValueListenable<T?>? _delegateValueListenable;

  FormeFieldNotifier._(this.name, this._state) {
    _state.controllerAliveNotifier.addListener(_updateAlive);
    _updateAlive();
  }

  _updateAlive() {
    bool alive = _state.controllerAliveNotifier.value
        .any((element) => element.name == name);
    if (alive) {
      FormeFieldController controller = _state.controllerAliveNotifier.value
          .where((element) => element.name == name)
          .first;

      if (_delegateFocusListenable == null) {
        _delegateFocusListenable = controller.focusListenable;
        _delegateFocusListenable!.addListener(_listenfocusListenable);
      }

      if (controller is! FormeValueFieldController) {
        return;
      }

      FormeValueFieldController<T, FormeModel> cast =
          controller as FormeValueFieldController<T, FormeModel>;

      if (_delegateErrorTextListenable == null) {
        _delegateErrorTextListenable = cast.errorTextListenable;
        _delegateErrorTextListenable!.addListener(_listenerrorTextListenable);
      }

      if (_delegateValueListenable == null) {
        _delegateValueListenable = cast.valueListenable;
        _delegateValueListenable!.addListener(_listenValueNotifier);
      }
    } else {
      //no need to removeListener here , delegate notifier has been disposed !
      _delegateFocusListenable = null;
      _delegateValueListenable = null;
      _delegateErrorTextListenable = null;
    }
  }

  _listenfocusListenable() {
    if (_delegateFocusListenable != null)
      focusListenable._value = _delegateFocusListenable!.value;
  }

  _listenValueNotifier() {
    if (_delegateValueListenable != null)
      valueNotifier._value = _delegateValueListenable!.value;
  }

  _listenerrorTextListenable() {
    if (_delegateErrorTextListenable != null)
      errorTextListenable._value = _delegateErrorTextListenable!.value;
  }

  void _dispose() {
    _state.controllerAliveNotifier.removeListener(_updateAlive);
    focusListenable._notifier.dispose();
    errorTextListenable._notifier.dispose();
    valueNotifier._notifier.dispose();
  }
}

class FormeValueListenable<T> implements ValueListenable<T> {
  final ValueNotifier<T> _notifier;
  FormeValueListenable._(this._notifier);

  @override
  void addListener(VoidCallback listener) => _notifier.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _notifier.removeListener(listener);

  @override
  T get value => _notifier.value;

  set _value(T newValue) => _notifier.value = newValue;
}

class Optional<T> {
  final T? _value;
  const Optional.absent() : _value = null;
  const Optional.fromNullable(T? value) : _value = value;

  T? get value => _value;

  @override
  int get hashCode => _value.hashCode;
  @override
  bool operator ==(Object o) => o is Optional<T> && o._value == _value;

  bool get isPresent => _value != null;
  bool get isNotPresent => _value == null;
}
