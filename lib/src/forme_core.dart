import 'package:flutter/material.dart';

import 'forme_utils.dart';
import 'forme_field.dart';
import 'forme_state_model.dart';
import 'forme_management.dart';

/// triggered when form field's value changed
typedef FormeValueChanged = void Function(
    FormeValueFieldManagement field, dynamic oldValue, dynamic newValue);

// listen focus change
typedef FocusListener<T extends FormeFieldManagement> = void Function(
    T field, bool hasFocus);

/// listen field errorText change
typedef ValidateErrorListener<T extends FormeValueFieldManagement> = void
    Function(T field, String? errorText);

/// form key is a global key
class FormeKey extends LabeledGlobalKey<_FormeState>
    implements FormeManagement {
  FormeKey({String? debugLabel}) : super(debugLabel);

  /// whether formKey is initialized
  bool get initialized {
    _FormeState? state = currentState;
    if (state == null) return false;
    return true;
  }

  /// get form management , throw an error if there's no form management
  FormeManagement get _currentManagement {
    _FormeState? currentState = super.currentState;
    if (currentState == null) {
      throw 'current state is null,did you put this key on Forme?';
    }
    return currentState.formeManagement;
  }

  @override
  Map<String, dynamic> get data => _currentManagement.data;

  @override
  bool get readOnly => _currentManagement.readOnly;

  @override
  List<FormeFieldManagementWithError> get errors => _currentManagement.errors;

  @override
  T field<T extends FormeFieldManagement>(String name) =>
      _currentManagement.field<T>(name);

  @override
  bool hasField(String name) => _currentManagement.hasField(name);

  @override
  bool get isValid => _currentManagement.isValid;

  @override
  List<FormeFieldManagementWithError> quietlyValidate() =>
      _currentManagement.quietlyValidate();

  @override
  void reset() => _currentManagement.reset();

  @override
  void save() => _currentManagement.save();

  @override
  void setData(Map<String, dynamic> data, {bool trigger = true}) =>
      _currentManagement.setData(data, trigger: trigger);

  @override
  bool validate() => _currentManagement.validate();

  @override
  T valueField<T extends FormeValueFieldManagement>(String name) =>
      _currentManagement.valueField<T>(name);

  @override
  set data(Map<String, dynamic> data) => _currentManagement.data = data;

  @override
  set readOnly(bool readOnly) => _currentManagement.readOnly = readOnly;
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
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final ValidateErrorListener? validateErrorListener;

  Forme({
    FormeKey? key,
    this.readOnly = false,
    this.onChanged,
    required this.child,
    this.initialValue = const {},
    this.validateErrorListener,
  }) : super(key: key);

  @override
  _FormeState createState() => _FormeState();
}

class _FormeState extends State<Forme> {
  late final FormeManagement formeManagement;

  final List<FormeFieldManagement> fieldManagements = [];

  bool? _readOnly;

  @override
  void initState() {
    super.initState();
    formeManagement = _FormeManagement(this);
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

  T? getFormeFieldManagement<T extends FormeFieldManagement>(String name) {
    Iterable<FormeFieldManagement> iterable =
        fieldManagements.where((element) => element.name == name);
    if (iterable.isNotEmpty) return iterable.first as T;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedFormScope(
      gen: gen,
      formScope: _FormScope(
        formeManagement: formeManagement,
        readOnly: readOnly,
        fieldManagements: fieldManagements,
        valueChanged: widget.onChanged,
        formInitialValue: widget.initialValue,
        validateErrorListener: widget.validateErrorListener,
      ),
      child: widget.child,
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
  final FormeManagement formeManagement;
  final bool readOnly;
  final List<FormeFieldManagement> fieldManagements;
  final FormeValueChanged? valueChanged;
  final Map<String, dynamic> formInitialValue;
  final ValidateErrorListener? validateErrorListener;
  final Map<String, String> errorMap = {};

  void onValueChanged(
      FormeValueFieldManagement management, oldValue, newValue) {
    if (valueChanged != null) valueChanged!(management, oldValue, newValue);
  }

  void onValidateError(FormeValueFieldManagement field, String? errorText) {
    if (validateErrorListener != null) validateErrorListener!(field, errorText);
  }

  _FormScope({
    required this.readOnly,
    required this.fieldManagements,
    this.valueChanged,
    required this.formInitialValue,
    this.validateErrorListener,
    required this.formeManagement,
  });

  void registerField(FormeFieldManagement management) {
    this.fieldManagements.add(management);
  }

  void unregisterField(FormeFieldManagement management) {
    this.fieldManagements.remove(management);
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
  late final FormeFieldManagement<E> management;

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
    if (_field.focusListener != null)
      _field.focusListener!(management, focusNode.hasFocus);
  }

  /// focus current field is focusable
  void requestFocus() {
    if (_focusNode == null || !_focusNode!.canRequestFocus) return;
    _focusNode!.requestFocus();
  }

  /// you can override this method to wrap your custom FormeFieldManagement
  ///
  /// use [FormeManagement.newFormeFieldManagement] to get FormeFieldManagement that you wrapped,
  ///
  /// you can use [FormeFieldManagementDelegate] to fast wrap
  @protected
  FormeFieldManagement<E> createFormeFieldManagement() =>
      _FormeFieldManagement(this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formScope = _FormScope.of(context);
    FormeFieldManagement? formeFieldManagement =
        InheritedFormeFieldManagement.maybeOf(context);
    bool proxy = formeFieldManagement != null &&
        formeFieldManagement is FormeProxyFieldManagment;
    if (_init) return;
    _init = true;
    management = createFormeFieldManagement();
    if (!proxy) {
      _formScope.registerField(management);
    } else {
      formeFieldManagement.proxyManagement = management;
    }
    afterInitiation();
  }

  /// called when  FormeFieldManagement created
  ///
  /// this method is called in didChangeDependencies and will only called once in state's lifecycle
  ///
  /// **init your resource in this method**
  @protected
  void afterInitiation() {}

  @override
  void dispose() {
    _focusNode?.dispose();
    _formScope.unregisterField(management);
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
      setState(() {
        E copy = beforeUpdateModel(model, _model);
        this._model = copy.copyWith(model) as E;
      });
    }
  }

  _setModel(E _model) {
    if (_model != model) {
      setState(() {
        this._model = beforeSetModel(model, _model);
      });
    }
  }

  E get model => _model ?? _field.model;
}

/// this State is only used for [ValueField]
class ValueFieldState<T, E extends FormeModel> extends FormFieldState<T>
    with AbstractFieldState<FormField<T>, E> {
  @override
  ValueField<T, E> get widget => super.widget as ValueField<T, E>;

  FormeDecoration? _decoration;

  @override
  FormeValueFieldManagement<T, E> get management =>
      super.management as FormeValueFieldManagement<T, E>;

  @override
  FormeValueFieldManagement<T, E> createFormeFieldManagement() =>
      _FormeValueFieldManagement(this);

  bool get enabled => widget.enabled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _decoration = FormeDecoration.of(context);
    focusNode.removeListener(_focusChange);
    if (_decoration != null) focusNode.addListener(_focusChange);
  }

  void _focusChange() {
    if (_decoration != null) _decoration!.onFocusChanged(focusNode.hasFocus);
  }

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
  /// get [FormFieldManagement] or access initialValue is safe here
  @override
  @mustCallSuper
  void afterInitiation() {
    super.setValue(initialValue);
  }

  @override
  void didChange(T? value) {
    doChangeValue(value);
  }

  @protected
  @override
  void setValue(T? newValue) {
    if (!compare(value, newValue)) {
      super.setValue(newValue);
      _didChange(value, newValue, true);
    }
  }

  @visibleForTesting
  void doChangeValue(T? newValue, {bool trigger = true}) {
    T? oldValue = value;
    if (!compare(oldValue, newValue)) {
      super.didChange(newValue);
      afterValueChanged(oldValue, newValue);
      _didChange(oldValue, newValue, trigger);
    }
  }

  @override
  void reset() {
    String? currentErrorText = errorText;
    T? oldValue = value;
    super.reset();
    if (_formScope.hasInitialValue(name)) super.setValue(initialValue);
    if (!compare(oldValue, value)) {
      afterValueChanged(oldValue, value);
      _didChange(oldValue, value, true);
    }
    _onErrorTextChange(currentErrorText, errorText);
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
      if (onChanged != null) onChanged(management, old, current);
    }
    _formScope.onValueChanged(this.management, old, current);
  }

  String? _quietlyValidate() {
    if (widget.validator != null) return widget.validator!(value);
  }

  @override
  bool validate() {
    String? currentErrorText = super.errorText;
    bool isValid = super.validate();
    _onErrorTextChange(currentErrorText, errorText);
    return isValid;
  }

  void _onErrorTextChange(String? currentErrorText, String? errorText) {
    if (currentErrorText != errorText) {
      if (_decoration != null) _decoration!.onErrorChanged(currentErrorText);
      onErrorTextChange(currentErrorText, errorText);
      if (widget.validateErrorListener != null)
        widget.validateErrorListener!(management, errorText);
      _formScope.onValidateError(management, errorText);
    }
  }

  @protected
  void onErrorTextChange(String? oldErrorText, String? currentErrorText) {}

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    String? currentErrorText = super.errorText;
    Widget result = super.build(context);
    if (super.widget.enabled &&
        super.widget.autovalidateMode != AutovalidateMode.disabled) {
      if (currentErrorText != errorText) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _onErrorTextChange(currentErrorText, errorText);
        });
      }
    }
    return result;
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

class _FormeFieldManagement<E extends FormeModel>
    extends FormeFieldManagement<E> {
  final AbstractFieldState<StatefulWidget, E> state;

  _FormeFieldManagement(this.state);

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
  void update(E model) {
    state._updateModel(model);
  }

  @override
  FormeManagement get management =>
      _FormScope.of(state.context).formeManagement;
}

class _FormeValueFieldManagement<T, E extends FormeModel>
    extends FormeFieldManagementDelegate<E>
    implements FormeValueFieldManagement<T, E> {
  final ValueFieldState<T, E> state;
  final FormeFieldManagement<E> delegate;
  _FormeValueFieldManagement(this.state)
      : this.delegate = _FormeFieldManagement<E>(state);

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
  String? quietlyValidate() => state._quietlyValidate();

  @override
  void save() => state.save();

  @override
  FormeModel? get currentDecoratorModel =>
      state._decoration == null ? null : state._decoration!.management.model;

  @override
  void updateDecoratorModel(FormeModel model) {
    if (state._decoration == null) return;
    state._decoration!.management.updateModel(model);
  }

  @override
  set decoratorModel(FormeModel model) {
    if (state._decoration == null) return;
    state._decoration!.management.setModel(model);
  }
}

class FormeFieldManagementWithError {
  final FormeFieldManagement formeFieldManagement;
  final String errorText;
  const FormeFieldManagementWithError._(
      this.formeFieldManagement, this.errorText);
}

class _FormeManagement extends FormeManagement {
  final _FormeState _state;

  _FormeManagement(this._state);

  @override
  bool hasField(String name) => _state.getFormeFieldManagement(name) != null;

  @override
  bool get readOnly => _state.readOnly;

  @override
  set readOnly(bool readOnly) => _state.readOnly = readOnly;

  @override
  T field<T extends FormeFieldManagement>(String name) {
    T? management = _state.getFormeFieldManagement<T>(name);
    if (management == null) throw 'no field can be found by name :$name';
    return management;
  }

  @override
  T valueField<T extends FormeValueFieldManagement>(String name) {
    return field(name) as T;
  }

  @override
  Map<String, dynamic> get data {
    Map<String, dynamic> map = {};
    _valueFieldManagements.forEach((element) {
      String? name = element.name;
      if (name == null) return;
      dynamic value = element.value;
      map[name] = value;
    });
    return map;
  }

  @override
  List<FormeFieldManagementWithError> get errors {
    return _readErrors((state) => state.errorText);
  }

  @override
  List<FormeFieldManagementWithError> quietlyValidate() {
    return _readErrors((state) => state.quietlyValidate());
  }

  List<FormeFieldManagementWithError> _readErrors(
      String? f(FormeValueFieldManagement e)) {
    List<FormeFieldManagementWithError> errors = [];
    for (FormeValueFieldManagement state in _valueFieldManagements) {
      if (state.name == null) continue;
      String? errorText = f(state);
      if (errorText == null) continue;
      FormeFieldManagement management =
          _state.getFormeFieldManagement(state.name!)!;
      errors.add(FormeFieldManagementWithError._(management, errorText));
    }
    return errors;
  }

  @override
  set data(Map<String, dynamic> data) => setData(data);

  @override
  void setData(Map<String, dynamic> data, {bool trigger = true}) {
    if (data.isEmpty) return;
    data.map((key, value) => MapEntry(key, value)).forEach((key, value) {
      FormeValueFieldManagement? management =
          _state.getFormeFieldManagement(key);
      if (management == null || !management.isValueField) return;
      management.setValue(value, trigger: trigger);
    });
  }

  @override
  void reset() {
    _valueFieldManagements.forEach((element) {
      element.reset();
    });
  }

  @override
  bool validate() {
    bool hasError = false;
    for (final FormeValueFieldManagement field in _valueFieldManagements)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  @override
  bool get isValid {
    bool hasError = false;
    for (final FormeValueFieldManagement field in _valueFieldManagements)
      hasError = !field.isValid || hasError;
    return !hasError;
  }

  @override
  void save() {
    _valueFieldManagements.forEach((element) {
      element.save();
    });
  }

  Iterable<FormeValueFieldManagement> get _valueFieldManagements =>
      _state.fieldManagements
          .where((element) => element is FormeValueFieldManagement)
          .map((e) => e as FormeValueFieldManagement);
}
