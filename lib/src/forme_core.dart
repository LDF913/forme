import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'forme_utils.dart';
import 'forme_field.dart';
import 'forme_state_model.dart';
import 'forme_controller.dart';

/// triggered when form field's value changed
typedef FormeValueChanged = void Function(
    FormeValueFieldController field, dynamic newValue);

// listen focus change
typedef FocusListener<T extends FormeFieldController> = void Function(
    T field, bool hasFocus);

/// listen field errorText change
typedef ValidateErrorListener<T extends FormeValueFieldController> = void
    Function(T field, FormeValidateError? error);

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
    return currentState;
  }

  @override
  Map<String, dynamic> get data => _currentController.data;

  @override
  bool get readOnly => _currentController.readOnly;

  @override
  Map<FormeValueFieldController, String> get errors =>
      _currentController.errors;

  @override
  T field<T extends FormeFieldController>(String name) =>
      _currentController.field<T>(name);

  @override
  bool hasField(String name) => _currentController.hasField(name);

  @override
  Map<FormeValueFieldController, String> performValidate(
          {bool quietly = false}) =>
      _currentController.performValidate(quietly: quietly);

  @override
  void reset() => _currentController.reset();

  @override
  void save() => _currentController.save();

  @override
  T valueField<T extends FormeValueFieldController>(String name) =>
      _currentController.valueField<T>(name);

  @override
  set data(Map<String, dynamic> data) => _currentController.data = data;

  @override
  set readOnly(bool readOnly) => _currentController.readOnly = readOnly;

  @override
  FormeFieldListenable<T> fieldListenable<T>(String name) =>
      _currentController.fieldListenable<T>(name);

  static FormeController of(BuildContext context) {
    return _FormScope.of(context).formeController;
  }

  @override
  bool get quietlyValidate => _currentController.quietlyValidate;

  @override
  set quietlyValidate(bool quietlyValidate) =>
      _currentController.quietlyValidate = quietlyValidate;
}

/// build your form !
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
  /// **this property can be overwritten by field's initialValue**
  final Map<String, dynamic> initialValue;

  /// used to listen field's validate error changed
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

class _FormeState extends State<Forme> implements FormeController {
  final List<FormeFieldController> controllers = [];
  final List<_FormeFieldListenable> listenables = [];

  bool? _readOnly;
  bool? _quietlyValidate;

  @protected
  int gen = 0;

  @override
  bool get readOnly => _readOnly ?? widget.readOnly;

  @override
  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      setState(() {
        gen++;
        _readOnly = readOnly;
      });
    }
  }

  @override
  bool get quietlyValidate => _quietlyValidate ?? widget.quietlyValidate;

  @override
  set quietlyValidate(bool quietlyValidate) {
    if (_quietlyValidate != quietlyValidate) {
      setState(() {
        gen++;
        _quietlyValidate = quietlyValidate;
      });
    }
  }

  @override
  void dispose() {
    listenables.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _InheritedFormScope(
        gen: gen,
        formScope: _FormScope(this),
        child: widget.child,
      ),
      onWillPop: widget.onWillPop,
    );
  }

  @override
  Map<String, dynamic> get data {
    Map<String, dynamic> map = {};
    valueFieldControllers.forEach((element) {
      String? name = element.name;
      dynamic value = element.value;
      map[name] = value;
    });
    return map;
  }

  @override
  Map<FormeValueFieldController<dynamic, FormeModel>, String> get errors =>
      readErrors((e) => e.error?.text);

  @override
  T field<T extends FormeFieldController<FormeModel>>(String name) {
    T? controller = getFormeFieldController(name);
    if (controller == null) throw 'no field can be found by name :$name';
    return controller;
  }

  @override
  FormeFieldListenable<T> fieldListenable<T>(String name) {
    _FormeFieldListenable<T> listenable = createFieldListenable<T>(name);
    return FormeFieldListenable._(listenable.focusNotifier,
        listenable.errorTextNotifier, listenable.valueNotifier);
  }

  @override
  bool hasField(String name) {
    return getFormeFieldController(name) != null;
  }

  @override
  void reset() {
    valueFieldControllers.forEach((element) {
      element.reset();
    });
  }

  @override
  void save() {
    valueFieldControllers.forEach((element) {
      element.save();
    });
  }

  @override
  Map<FormeValueFieldController<dynamic, FormeModel>, String> performValidate(
          {bool quietly = false}) =>
      readErrors((e) => e.performValidate(quietly: quietly));

  @override
  T valueField<T extends FormeValueFieldController>(String name) =>
      field<T>(name);

  @override
  set data(Map<String, dynamic> data) {
    if (data.isEmpty) return;
    data.map((key, value) => MapEntry(key, value)).forEach((key, value) {
      FormeValueFieldController? controller = getFormeFieldController(key);
      if (controller == null) return;
      controller.value = value;
    });
  }

  void registerController(FormeFieldController controller) {
    controllers.add(controller);
    listenables
        .where((element) => element.name == controller.name)
        .forEach((element) {
      element.whenAlive(controller);
    });
    if (controller is FormeValueFieldController) {
      controller.valueListenable.addListener(() {
        FormeValueChanged? valueChanged = widget.onChanged;
        if (valueChanged != null)
          valueChanged(controller, controller.valueListenable.value);
      });
      controller.errorTextListenable.addListener(() {
        ValidateErrorListener? validateErrorListener =
            widget.validateErrorListener;
        if (validateErrorListener != null)
          validateErrorListener(
              controller, controller.errorTextListenable.value);
      });
    }
  }

  void unregisterController(FormeFieldController<FormeModel> controller) {
    controllers.remove(controller);
    listenables
        .where((element) => element.name == controller.name)
        .forEach((element) {
      element.whenDead(controller);
    });
  }

  _FormeFieldListenable<T> createFieldListenable<T>(String name) {
    for (_FormeFieldListenable listenable in listenables) {
      if (listenable.name == name)
        return listenable as _FormeFieldListenable<T>;
    }
    _FormeFieldListenable<T> newListenable =
        _FormeFieldListenable<T>(name, getFormeFieldController(name));
    listenables.add(newListenable);
    return newListenable;
  }

  Map<FormeValueFieldController, String> readErrors(
      String? f(FormeValueFieldController e)) {
    Map<FormeValueFieldController, String> errorMap = {};
    for (FormeValueFieldController controller in valueFieldControllers) {
      String? errorText = f(controller);
      if (errorText == null) continue;
      errorMap[controller] = errorText;
    }
    return errorMap;
  }

  T? getFormeFieldController<T extends FormeFieldController>(String name) {
    for (FormeFieldController controller in controllers)
      if (controller.name == name) return controller as T;
  }

  Iterable<FormeValueFieldController> get valueFieldControllers {
    return controllers
        .where((element) => element is FormeValueFieldController)
        .map((e) => e as FormeValueFieldController);
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
  final _FormeState state;

  _FormScope(this.state);

  FormeController get formeController => state;
  bool get readOnly => state.readOnly;
  bool get quietlyValidate => state.quietlyValidate;
  dynamic getInitialValue(String name) => state.widget.initialValue[name];

  void registerController(FormeFieldController controller) {
    state.registerController(controller);
  }

  void unregisterController(FormeFieldController controller) {
    state.unregisterController(controller);
  }

  static _FormScope of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedFormScope>()!
      .formScope;
}

/// state for all stateful form field
///
/// if you want Forme control your custom stateful field,you can do as follows
///
/// 1. make your custom field extends StatefulWidget and with [StatefulField]
/// 2. make your custom state extends State and with [AbstractFieldState]
///
mixin AbstractFieldState<T extends StatefulWidget, E extends FormeModel>
    on State<T> implements FormeFieldController<E> {
  bool _init = false;
  FocusNode? _focusNode;
  late _FormScope _formScope;
  E? _model;
  bool? _readOnly;

  final ValueNotifier<bool> _focusNotifier = ValueNotifier(false);
  late final ValueListenable<bool> focusListenable;

  /// whether current focusnode is not null and  can request focus
  bool get focusable => _focusNode != null && _focusNode!.canRequestFocus;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formScope = _FormScope.of(context);
    if (_init) return;
    _init = true;
    beforeInitiation();
    _formScope.registerController(this);
    afterInitiation();
  }

  @override
  void dispose() {
    _focusNotifier.dispose();
    _focusNode?.dispose();
    _formScope.unregisterController(this);
    super.dispose();
  }

  /// called after  FormeFieldController registed
  ///
  /// this method is called in didChangeDependencies and will only called once in state's lifecycle
  ///
  /// **init your resource in this method**
  @protected
  @mustCallSuper
  void afterInitiation() {}

  /// called before  FormeFieldController registed
  ///
  /// this method is called in didChangeDependencies and will only called once in state's lifecycle
  @protected
  @mustCallSuper
  void beforeInitiation() {
    focusListenable = _ValueListenable(_focusNotifier);
  }

  /// used to do some logic before update model
  ///
  /// this method will triggered when update model
  @protected
  E beforeUpdateModel(E old, E current) => current;

  @protected
  E beforeSetModel(E old, E current) => current;

  /// set model but do no request a new frame
  ///
  /// **make sure call setState after this model**
  @protected
  setModel(E model) {
    this._model = model;
  }

  @override
  String get name => _field.name;
  @override
  updateModel(E _model) {
    if (_model != model) {
      E copy = beforeUpdateModel(model, _model);
      if (copy != model) {
        setState(() {
          this._model = copy.copyWith(model) as E;
        });
      }
    }
  }

  @override
  set model(E _model) {
    if (_model != model) {
      E copy = beforeSetModel(model, _model);
      if (copy != model) {
        setState(() {
          this._model = copy;
        });
      }
    }
  }

  @override
  FormeController get formeController => _formScope.formeController;
  @override
  bool get readOnly => _formScope.readOnly || (_readOnly ?? _field.readOnly);
  @override
  set readOnly(bool readOnly) {
    if (readOnly != _readOnly)
      setState(() {
        _readOnly = readOnly;
      });
  }

  @override
  void requestFocus() {
    if (!focusable) return;
    _focusNode!.requestFocus();
  }

  @override
  void unfocus({
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) {
    if (!focusable) return;
    _focusNode!.unfocus(disposition: disposition);
  }

  @override
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment}) {
    return Scrollable.ensureVisible(context,
        duration: duration ?? Duration.zero,
        curve: curve ?? Curves.ease,
        alignmentPolicy:
            alignmentPolicy ?? ScrollPositionAlignmentPolicy.explicit,
        alignment: alignment ?? 0);
  }

  @override
  bool get hasFocus => _focusNode != null && _focusNode!.hasFocus;
  @override
  E get model => _model ?? _field.model;

  void _onFocusChange() {
    _focusNotifier.value = focusNode.hasFocus;
    if (_field.focusListener != null)
      _field.focusListener!(this, focusNode.hasFocus);
  }

  StatefulField<AbstractFieldState<T, E>, E> get _field =>
      widget as StatefulField<AbstractFieldState<T, E>, E>;
}

/// this State is only used for [ValueField]
class ValueFieldState<T, E extends FormeModel> extends FormFieldState<T>
    with AbstractFieldState<FormField<T>, E>
    implements FormeValueFieldController<T, E> {
  final ValueNotifier<FormeValidateError?> _errorNotifier = ValueNotifier(null);
  final ValueNotifier<FormeModel?> _decoratorNotifier = ValueNotifier(null);
  late final ValueNotifier<T?> _valueNotifier;
  late final FormeDecoratorController decoratorController;
  late final ValueListenable<T?> valueListenable;
  late final ValueListenable<FormeValidateError?> errorTextListenable;

  @override
  ValueField<T, E> get widget => super.widget as ValueField<T, E>;

  @override
  String? get errorText => _formScope.quietlyValidate ? null : super.errorText;

  /// copy super._hasInteractedByUser here to detect whether performed validate in builder
  bool _hasInteractedByUser = false;

  @override
  T? get value => replaceNullValue(super.value);

  /// get initialValue
  @protected
  T? get initialValue =>
      widget.initialValue ?? _formScope.getInitialValue(widget.name);

  /// **when you want to init something that relies on initialValue,
  /// you should do that in [afterInitiation] rather than in this method**
  @override
  void initState() {
    super.initState();
  }

  @override
  void beforeInitiation() {
    super.beforeInitiation();
    _valueNotifier = ValueNotifier(initialValue);
    decoratorController = _FormeDecoratorController(_decoratorNotifier);
    valueListenable =
        _ValueFieldValueListenable(_valueNotifier, widget.nullValueReplacement);
    errorTextListenable = _ValueListenable(_errorNotifier);

    _valueNotifier.addListener(() {
      if (widget.onChanged != null)
        widget.onChanged!(this, replaceNullValue(_valueNotifier.value));
    });

    _errorNotifier.addListener(() {
      if (widget.validateErrorListener != null)
        widget.validateErrorListener!(this, _errorNotifier.value);
    });
  }

  @override
  void didChange(T? newValue) {
    _hasInteractedByUser = true;
    T? oldValue = super.value;
    if (!compare(oldValue, newValue)) {
      super.didChange(newValue);
      _valueNotifier.value = newValue;
    }
  }

  @override
  void reset() {
    T? oldValue = super.value;
    super.reset();
    _hasInteractedByUser = false;
    if (!compare(oldValue, initialValue)) {
      setValue(initialValue);
      _valueNotifier.value = initialValue;
    }
    _errorNotifier.value = null;
  }

  @override
  void dispose() {
    _decoratorNotifier.dispose();
    _errorNotifier.dispose();
    _valueNotifier.dispose();
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

  @override
  bool validate() => performValidate(quietly: false) == null;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    bool needValidate = widget.validator != null &&
        widget.enabled &&
        ((widget.autovalidateMode == AutovalidateMode.always) ||
            (widget.autovalidateMode == AutovalidateMode.onUserInteraction &&
                _hasInteractedByUser));
    if (needValidate) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _errorNotifier.value = FormeValidateError(super.errorText);
      });
    }
    Widget child = super.build(context);

    if (widget.decoratorBuilder != null) {
      child = widget.decoratorBuilder!.build(
        focusListenable,
        errorTextListenable,
        valueListenable,
        child,
        decoratorController.currentModel,
      );
    }

    return InheritedFormeFieldController(this, child);
  }

  @override
  FormeController get formeController => _formScope.formeController;

  @override
  FormeValidateError? get error => errorTextListenable.value;

  T? replaceNullValue(T? value) {
    if (value == null && widget.nullValueReplacement != null)
      return widget.nullValueReplacement;
    return value;
  }

  @override
  String? performValidate({bool quietly = false}) {
    if (widget.validator == null) return null;
    if (_formScope.quietlyValidate || quietly) {
      String? errorText = widget.validator!(super.value);
      _errorNotifier.value = FormeValidateError(errorText);
      return errorText;
    }
    super.validate();
    _errorNotifier.value = FormeValidateError(super.errorText);
    return super.errorText;
  }

  @override
  set value(T? value) => didChange(value);
}

class _ValueFieldValueListenable<T> extends _ValueListenable<T> {
  final T nullValueReplacement;

  _ValueFieldValueListenable(ValueNotifier delegate, this.nullValueReplacement)
      : super(delegate);

  @override
  T get value => super.value == null ? nullValueReplacement : super.value;
}

class _FormeDecoratorController extends FormeDecoratorController {
  final ValueNotifier<FormeModel?> notifier;

  _FormeDecoratorController(this.notifier);

  @override
  FormeModel? get currentModel => notifier.value;

  @override
  update(FormeModel model) => notifier.value == null
      ? notifier.value = model
      : notifier.value = model.copyWith(notifier.value!);

  @override
  set model(FormeModel model) => notifier.value = model;
}

class FormeFieldListenable<T> {
  final ValueListenable<bool> focusListenable;
  final ValueListenable<FormeValidateError?> errorTextListenable;
  final ValueListenable<T?> valueListenable;
  FormeFieldListenable._(
    ValueNotifier<bool> focusNotifier,
    ValueNotifier<FormeValidateError?> errorTextNotifier,
    ValueNotifier<T?> valueNotifier,
  )   : this.focusListenable = _ValueListenable(focusNotifier),
        this.errorTextListenable = _ValueListenable(errorTextNotifier),
        this.valueListenable = _ValueListenable(valueNotifier);
}

class _FormeFieldListenable<T> {
  final String name;
  FormeFieldController? controller;

  final ValueNotifier<bool> focusNotifier = ValueNotifier(false);
  final ValueNotifier<FormeValidateError?> errorTextNotifier =
      ValueNotifier(null);
  final ValueNotifier<T?> valueNotifier = ValueNotifier(null);

  _FormeFieldListenable(this.name, FormeFieldController? controller) {
    if (controller != null) whenAlive(controller);
  }

  void whenAlive(FormeFieldController controller) {
    if (this.controller != null) {
      this.controller!.focusListenable.removeListener(listenFocus);
      if (this.controller is FormeValueFieldController) {
        (controller as FormeValueFieldController)
            .valueListenable
            .removeListener(listenValue);
        controller.errorTextListenable.removeListener(listenFormeValidateError);
      }
    }

    this.controller = controller;
    focusNotifier.value = controller.focusListenable.value;
    controller.focusListenable.addListener(listenFocus);

    if (controller is! FormeValueFieldController) {
      return;
    }

    FormeValueFieldController<T, FormeModel> cast =
        controller as FormeValueFieldController<T, FormeModel>;

    errorTextNotifier.value = cast.errorTextListenable.value;
    cast.errorTextListenable.addListener(listenFormeValidateError);

    valueNotifier.value = cast.valueListenable.value;
    cast.valueListenable.addListener(listenValue);
  }

  void whenDead(FormeFieldController controller) {
    if (this.controller == controller) {
      this.controller = null;
    }
  }

  void listenFocus() {
    if (controller != null)
      focusNotifier.value = controller!.focusListenable.value;
  }

  void listenValue() {
    if (controller != null && controller is FormeValueFieldController)
      valueNotifier.value =
          (controller as FormeValueFieldController).valueListenable.value;
  }

  void listenFormeValidateError() {
    if (controller != null && controller is FormeValueFieldController)
      errorTextNotifier.value =
          (controller as FormeValueFieldController).errorTextListenable.value;
  }

  void dispose() {
    errorTextNotifier.dispose();
    focusNotifier.dispose();
    valueNotifier.dispose();
  }
}

class FormeValidateError {
  final String? text;
  bool get hasError => text != null;
  const FormeValidateError(this.text);

  @override
  int get hashCode => text.hashCode;
  @override
  bool operator ==(Object o) => o is FormeValidateError && o.text == text;
}

class _ValueListenable<T> extends ValueListenable<T> {
  final ValueNotifier delegate;
  const _ValueListenable(this.delegate);
  @override
  void addListener(VoidCallback listener) => delegate.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      delegate.removeListener(listener);

  @override
  T get value => delegate.value;
}
