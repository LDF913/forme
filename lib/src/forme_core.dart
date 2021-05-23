import 'package:flutter/material.dart';

import 'forme_focus_node.dart';
import 'forme_utils.dart';
import 'forme_field.dart';
import 'forme_state_model.dart';
import 'forme_management.dart';

typedef FormeValueChanged = void Function(
    String name, dynamic oldValue, dynamic newValue);

/// form key is a global key
///
/// used to get form management
class FormeKey extends LabeledGlobalKey<_FormeState> {
  FormeKey({String? debugLabel}) : super(debugLabel);

  //get form management , return null if there's no form management
  FormeManagement? get quietlyManagement {
    _FormeState? state = currentState;
    if (state == null) return null;
    return state.formeManagement;
  }

  /// get form management , throw an error if there's no form management
  FormeManagement get currentManagement {
    _FormeState? currentState = super.currentState;
    if (currentState == null) {
      throw 'current state is null,did you put this key on Forme?';
    }
    return currentState.formeManagement;
  }
}

class Forme extends StatefulWidget {
  /// whether form should be readOnly;
  ///
  /// default false
  final bool readOnly;

  /// listen form value changed
  ///
  /// this listener will be always triggered when field'value changed
  ///
  /// **only listen fields which has a name**
  final FormeValueChanged? onChanged;

  final Widget child;

  Forme({
    FormeKey? key,
    this.readOnly = false,
    this.onChanged,
    required this.child,
  }) : super(key: key);

  @override
  _FormeState createState() => _FormeState();
}

class _FormeState extends State<Forme> {
  late final FormeManagement formeManagement;

  final List<AbstractFieldState> fieldStates = [];

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
    Iterable<AbstractFieldState> iterable =
        fieldStates.where((element) => element.name == name);
    if (iterable.isNotEmpty)
      return iterable.first.createFormeFieldManagement() as T;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedFormScope(
      gen: gen,
      formScope: _FormScope(
        readOnly: readOnly,
        fieldStates: fieldStates,
        valueChanged: widget.onChanged,
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
  final bool readOnly;
  final List<AbstractFieldState> fieldStates;
  final FormeValueChanged? valueChanged;

  void onValueChanged(String name, oldValue, newValue) {
    if (valueChanged != null) valueChanged!(name, oldValue, newValue);
  }

  _FormScope({
    required this.readOnly,
    required this.fieldStates,
    this.valueChanged,
  });

  void registerField(AbstractFieldState fieldState) {
    this.fieldStates.add(fieldState);
  }

  void unregisterField(AbstractFieldState fieldState) {
    this.fieldStates.remove(fieldState);
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
mixin AbstractFieldState<T extends StatefulWidget, E extends AbstractFormeModel>
    on State<T> {
  bool _init = false;
  FocusNodes? _focusNode;
  String? get name => _field.name;

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
  ///
  /// call this method in builder or in [initFormeManagement]
  FocusNodes get focusNode {
    return _focusNode ??= FocusNodes();
  }

  void requestFocus() {
    if (_focusNode == null || !_focusNode!.canRequestFocus) return;
    _focusNode!.requestFocus();
  }

  /// you can override this method to wrap your custom FormeFieldManagement
  ///
  /// **you should always wrap formfieldmanagement
  /// returned by parent**
  ///
  /// use [FormeManagement.newFormeFieldManagement] to get FormeFieldManagement that you wrapped,
  ///
  /// you can use [FormeFieldManagementDelegate] to fast wrap
  FormeFieldManagement createFormeFieldManagement() {
    return _FormeFieldManagement(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formScope = _FormScope.of(context);
    if (_init) return;
    _init = true;
    _formScope.registerField(this);
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _formScope.unregisterField(this);
    super.dispose();
  }

  /// used to do some logic before model merge
  @protected
  void beforeMerge(E old, E current) {}

  StatefulField<AbstractFieldState, E> get _field =>
      widget as StatefulField<AbstractFieldState, E>;

  _updateModel(E _model) {
    if (_model != model) {
      setState(() {
        beforeMerge(model, _model);
        this._model = _model.merge(model) as E;
      });
    }
  }

  E get model => _model ?? _field.model;
}

class ValueFieldState<T, E extends AbstractFormeModel> extends FormFieldState<T>
    with AbstractFieldState<FormField<T>, E> {
  ValueChanged<T?>? get onChanged =>
      (super.widget as ValueField<T, E>).onChanged;

  FormeFieldManagement createFormeFieldManagement() {
    return _FormeValueFieldManagement(this);
  }

  @override
  void didChange(T? value) {
    doChangeValue(value);
  }

  @protected
  void setValue(T? newValue) {
    if (!compare(value, newValue)) {
      super.setValue(newValue);
      _didChange(value, newValue, true);
    }
  }

  void doChangeValue(T? newValue, {bool trigger = true}) {
    T? oldValue = value;
    if (!compare(oldValue, newValue)) {
      super.didChange(newValue);
      _didChange(oldValue, newValue, trigger);
    }
  }

  @override
  void reset() {
    try {
      if (!compare(value, widget.initialValue)) {
        _didChange(value, widget.initialValue, true);
      }
    } finally {
      super.reset();
    }
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

  _didChange(T? old, T? current, bool trigger) {
    if (trigger) {
      ValueChanged<T?>? onChanged =
          (super.widget as ValueField<T, E>).onChanged;
      if (onChanged != null) onChanged(current);
    }
    if (name != null) {
      _formScope.onValueChanged(name!, old, current);
    }
  }

  String? _quietlyValidate() {
    if (widget.validator != null) return widget.validator!(value);
  }
}

class _FormeFieldManagement extends FormeFieldManagement {
  final AbstractFieldState state;

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
  set focusListener(FocusListener? listener) {
    if (state._focusNode == null) throw 'current field do not has a focusnode';
    state._focusNode!.focusListener = listener;
  }

  @override
  bool get isValueField => state is ValueFieldState;

  AbstractFormeModel get model => state.model;

  @override
  String? get name => state.name;

  @override
  bool get readOnly => state.readOnly;

  @override
  set readOnly(bool readOnly) => state.readOnly = readOnly;

  @override
  set model(AbstractFormeModel model) {
    state._updateModel(model);
  }
}

class _FormeValueFieldManagement extends FormeValueFieldManagement {
  final ValueFieldState state;
  final FormeFieldManagement formeFieldManagement;
  _FormeValueFieldManagement(this.state)
      : this.formeFieldManagement = _FormeFieldManagement(state);

  @override
  dynamic get value => state.value;

  @override
  void setValue(dynamic value, {bool trigger = true}) =>
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
  AbstractFormeModel get model => formeFieldManagement.model;

  @override
  set model(AbstractFormeModel model) => formeFieldManagement.model = model;

  @override
  bool get readOnly => formeFieldManagement.readOnly;

  @override
  set readOnly(bool readOnly) => formeFieldManagement.readOnly = readOnly;

  @override
  Future<void> ensureVisible(
          {Duration? duration,
          Curve? curve,
          ScrollPositionAlignmentPolicy? alignmentPolicy,
          double? alignment}) =>
      formeFieldManagement.ensureVisible(
        duration: duration,
        curve: curve,
        alignmentPolicy: alignmentPolicy,
        alignment: alignment,
      );

  @override
  set focus(bool focus) => formeFieldManagement.focus = focus;

  @override
  set focusListener(listener) => formeFieldManagement.focusListener = listener;

  @override
  bool get focusable => formeFieldManagement.focusable;

  @override
  bool get hasFocus => formeFieldManagement.hasFocus;

  @override
  bool get isValueField => true;

  @override
  String? get name => formeFieldManagement.name;
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
  T newFormeFieldManagement<T extends FormeFieldManagement>(String name) {
    T? management = _state.getFormeFieldManagement<T>(name);
    if (management == null) throw 'no field can be found by name :$name';
    return management;
  }

  @override
  Map<String, dynamic> get data {
    Map<String, dynamic> map = {};
    _valueFieldStates.forEach((element) {
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
    return _readErrors((state) => state._quietlyValidate());
  }

  List<FormeFieldManagementWithError> _readErrors(
      String? f(ValueFieldState e)) {
    List<FormeFieldManagementWithError> errors = [];
    for (ValueFieldState state in _valueFieldStates) {
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
    _valueFieldStates.forEach((element) {
      element.reset();
    });
  }

  @override
  bool validate() {
    bool hasError = false;
    for (final ValueFieldState field in _valueFieldStates)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  @override
  bool get isValid {
    bool hasError = false;
    for (final ValueFieldState field in _valueFieldStates)
      hasError = !field.isValid || hasError;
    return !hasError;
  }

  @override
  void save() {
    _valueFieldStates.forEach((element) {
      element.save();
    });
  }

  Iterable<ValueFieldState> get _valueFieldStates => _state.fieldStates
      .where((element) => element is ValueFieldState)
      .map((e) => e as ValueFieldState);
}
