import 'package:flutter/material.dart';

import 'focus_node.dart';
import 'form_builder_utils.dart';
import 'form_field.dart';
import 'form_layout.dart';
import 'management.dart';
import 'state_model.dart';
import 'text_selection.dart';

typedef FormValueChanged = void Function(
    String name, dynamic oldValue, dynamic newValue);

/// form key is a global key
///
/// used to get form management
class FormKey extends LabeledGlobalKey<State> {
  FormKey({String? debugLabel}) : super(debugLabel);

  //get form management , return null if there's no form management
  FormManagement? get quietlyManagement {
    State? state = currentState;
    if (state == null || state is! _AbstractFormState) return null;
    return state.formManagement;
  }

  /// get form management , throw an error if there's no form management
  FormManagement get currentManagement {
    if (currentState == null) {
      throw 'current state is null,did you put this key on FormBuilder?';
    }
    if (currentState is! _AbstractFormState) {
      throw 'current state is not a FormState , you should put this key on FormBuilder rather than other widget';
    }
    return (currentState as _AbstractFormState).formManagement;
  }
}

class FormBuilder {
  FormValueChanged? _onChanged;
  bool _readOnly = false;
  FormLayoutBuilder? _layoutBuilder;
  FormKey? _key;

  FormBuilder key(FormKey key) {
    this._key = key;
    return this;
  }

  /// whether form should be readonly
  FormBuilder readOnly(bool readOnly) {
    this._readOnly = readOnly;
    return this;
  }

  /// set formvalue changed listener
  FormBuilder onChanged(FormValueChanged changed) {
    this._onChanged = changed;
    return this;
  }

  /// create a layout form builder
  FormLayoutBuilder layoutBuilder({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    return _layoutBuilder ??
        FormLayoutBuilder._(this,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textBaseline: textBaseline,
            textDirection: textDirection,
            verticalDirection: verticalDirection);
  }

  Widget build({
    required Widget child,
  }) {
    return _SimpleForm(
      key: _key,
      child: child,
      readOnly: _readOnly,
    );
  }
}

class FormLayoutBuilder {
  final FormBuilder _builder;
  final FormLayout _formLayout;
  bool? _visible;
  bool? _enableLayoutManagement;

  FormLayoutBuilder._(
    this._builder, {
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) : this._formLayout = FormLayout(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textBaseline: textBaseline,
            textDirection: textDirection,
            verticalDirection: verticalDirection);

  /// require a new Row
  ///
  /// if last row is empty won't create a new row
  FormLayoutBuilder newRow() {
    _formLayout.lastEmptyRow();
    return this;
  }

  /// whether form should be visible
  FormLayoutBuilder visible(bool visible) {
    _visible = visible;
    return this;
  }

  /// whether enableLayoutManagement
  ///
  /// if enabled , global key will be used for every builder field (root of form field)
  ///
  /// **enable it when you really need modify form layout at runtime,otherwise disable it for performance improve,
  /// when try to update this flag at runtime,an error will be throw**
  ///
  ///
  /// **@experimental**
  FormLayoutBuilder enableLayoutManagement(bool enableLayoutManagement) {
    _enableLayoutManagement = enableLayoutManagement;
    return this;
  }

  /// customize last row
  FormLayoutBuilder customize({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    _formLayout.lastRow().customize(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection);
    return this;
  }

  /// ```
  /// Row
  ///   fields ... field
  /// ```
  FormLayoutBuilder append(Widget field) {
    _formLayout.lastRow().append(field);
    return this;
  }

  /// append a field take up one row
  ///
  /// ```
  /// Row(lastEmptyRow)
  ///   field
  /// Row newRow
  /// ```
  ///
  /// no need to call newRow before or after
  /// this method,they will be automatic created
  FormLayoutBuilder oneRowField(Widget field) {
    _formLayout.lastEmptyRow().append(field);
    _formLayout.append();
    return this;
  }

  Widget build() {
    return _LayoutForm(
      key: _builder._key,
      formLayout: _formLayout,
      readOnly: _builder._readOnly,
      visible: _visible ?? true,
      enableLayoutManagement: _enableLayoutManagement ?? false,
      onChanged: _builder._onChanged,
    );
  }
}

abstract class _AbstractForm extends StatefulWidget {
  /// whether form should be readOnly;
  ///
  /// default false
  final bool readOnly;

  /// listen form value changed
  ///
  /// this listener will be always triggered when field'value changed
  ///
  /// **only listen fields which has a name**
  final FormValueChanged? onChanged;

  _AbstractForm({
    Key? key,
    this.readOnly = false,
    this.onChanged,
  }) : super(key: key);

  @override
  _AbstractFormState createState();
}

abstract class _AbstractFormState extends State<_AbstractForm> {
  late final _ResourceManagement resourceManagement;
  late final FormManagement formManagement;

  bool? _readOnly;
  bool? _visible;

  final Map<int, Key> keys = {};
  final List<CastableFormFieldManagement> formFieldManagements = [];
  List<ValueFieldState> valueFieldStates = [];

  FormValueChanged? get onChanged => widget.onChanged;

  FormManagement createFormManagement(_ResourceManagement resourceManagement);

  @override
  void initState() {
    super.initState();
    resourceManagement = _ResourceManagement(this);
    formManagement = createFormManagement(resourceManagement);
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

  Widget buildContent();

  @override
  Widget build(BuildContext context) {
    return _FormStatus._(
      gen: gen,
      readOnly: readOnly,
      child: buildContent(),
      resourceManagement: resourceManagement,
    );
  }
}

class _FormStatus extends InheritedWidget {
  final bool readOnly;
  final int gen;
  final _ResourceManagement resourceManagement;

  _FormStatus._(
      {required this.readOnly,
      required this.gen,
      required Widget child,
      required this.resourceManagement})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant _FormStatus oldWidget) {
    return gen != oldWidget.gen;
  }
}

/// used to register|unregister|lookup resources
class _ResourceManagement {
  final _AbstractFormState state;
  final List<CastableFormFieldManagement> formFieldManagements = [];
  List<ValueFieldState> valueFieldStates = [];

  _ResourceManagement(this.state);

  void registerFormFieldManagement(
          CastableFormFieldManagement formFieldManagement) =>
      formFieldManagements.add(formFieldManagement);

  void unregisterFormFieldManagement(
          CastableFormFieldManagement formFieldManagement) =>
      formFieldManagements.remove(formFieldManagement);

  void registerValueFieldState(ValueFieldState valueFieldState) =>
      valueFieldStates.add(valueFieldState);

  void unregisterValueFieldState(ValueFieldState valueFieldState) =>
      valueFieldStates.remove(valueFieldState);

  CastableFormFieldManagement? getFormFieldManagement(String name) {
    Iterable<CastableFormFieldManagement> it =
        formFieldManagements.where((element) => element.name == name);
    return it.isEmpty ? null : it.first;
  }

  ValueFieldState? getValueFieldState(String name) {
    Iterable<ValueFieldState> it =
        valueFieldStates.where((element) => element.name == name);
    return it.isEmpty ? null : it.first;
  }

  bool hasName(String name) => getFormFieldManagement(name) != null;

  static _ResourceManagement of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FormStatus>()!
        .resourceManagement;
  }
}

/// state for all stateful form field
///
/// if you want FormBuilder control your custom stateful field,you can do as follows
///
/// 1. make your custom field extends StatefulWidget and with [StatefulField]
/// 2. make your custom state extends State and with [AbstractFieldState]
///
mixin AbstractFieldState<T extends StatefulWidget,
    E extends AbstractFieldStateModel> on State<T> {
  bool _init = false;
  late final _ResourceManagement _resourceManagement;
  late final CastableFormFieldManagement _formFieldManagement;

  FocusNodes? _focusNode;

  String? get name => _field.name;

  bool get init => _init;

  E? _model;

  /// whether field should be readOnly
  bool get readOnly => _resourceManagement.state.readOnly || isFieldReadOnly;

  /// whether form is LayoutForm
  @protected
  bool get useLayout => _resourceManagement.state is _LayoutFormState;

  /// whether field is readOnly
  @protected
  bool get isFieldReadOnly;

  /// set readOnly on this field
  set readOnly(bool readOnly);

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  ///
  /// call this method in builder or in [initFormManagement]
  FocusNodes get focusNode {
    return _focusNode ??= FocusNodes();
  }

  void requestFocus() {
    if (_focusNode == null || !_focusNode!.canRequestFocus) return;
    _focusNode!.requestFocus();
  }

  @protected
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    _resourceManagement = _ResourceManagement.of(context);
    initFormManagement();
  }

  /// this method will be called immediately after initState
  /// and will only be called once during state lifecycle
  ///
  /// **you should call getState in this method , not in initState!**
  @protected
  @mustCallSuper
  void initFormManagement() {
    _formFieldManagement = _CastableFormFieldManagement(
        customFormFieldManagement(_FixedFormFieldManagement(this)));
    _resourceManagement.registerFormFieldManagement(_formFieldManagement);
  }

  /// let subclass override base FormFieldManagement
  @protected
  FormFieldManagement customFormFieldManagement(
      FormFieldManagement baseManagement) {
    return baseManagement;
  }

  @protected
  void dispose() {
    _resourceManagement.unregisterFormFieldManagement(_formFieldManagement);
    _focusNode?.dispose();
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

abstract class ValueFieldState<T, E extends AbstractFieldStateModel>
    extends FormFieldState<T> with AbstractFieldState<FormField<T>, E> {
  ValueChanged<T?>? get onChanged =>
      (super.widget as ValueField<T, ValueFieldState<T, E>, E>).onChanged;

  @override
  void initFormManagement() {
    super.initFormManagement();
    _resourceManagement.registerValueFieldState(this);
  }

  @override
  void didChange(T? value) {
    doChangeValue(value);
  }

  void setValue(T? newValue) {
    if (!compare(value, newValue)) {
      super.setValue(newValue);
      _didChange(value, newValue, true);
    }
  }

  void doChangeValue(T? newValue, {bool trigger = true}) {
    if (!compare(value, newValue)) {
      super.didChange(newValue);
      _didChange(value, newValue, trigger);
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
  /// default used [FormBuilderUtils.compare]
  ///
  /// override this method if it can't meet your needs
  @protected
  bool compare(T? a, T? b) {
    return FormBuilderUtils.compare(a, b);
  }

  _didChange(T? old, T? current, bool trigger) {
    if (trigger) {
      ValueChanged<T?>? onChanged =
          (super.widget as ValueField<T, ValueFieldState<T, E>, E>).onChanged;
      if (onChanged != null) onChanged(current);
    }
    if (name != null) {
      FormValueChanged? formValueChanged = _resourceManagement.state.onChanged;
      if (formValueChanged != null) {
        formValueChanged(name!, old, current);
      }
    }
  }

  String? _quietlyValidate() {
    if (widget.validator != null) return widget.validator!(value);
  }

  @protected
  Widget doBuild() {
    return super.build(context);
  }

  @override
  void dispose() {
    super.dispose();
    _resourceManagement.unregisterValueFieldState(this);
  }
}

class _FixedFormFieldManagement extends FormFieldManagement {
  final AbstractFieldState state;

  _FixedFormFieldManagement(this.state);

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
  bool get supportTextSelection => state is TextSelectionManagement;

  @override
  TextSelectionManagement get textSelectionManagement {
    if (!supportTextSelection) throw 'field not support textselection';
    return _TextSelectionManagementDelegate(state as TextSelectionManagement);
  }

  @override
  bool get isValueField => state is ValueFieldState;

  AbstractFieldStateModel get model => state.model;

  @override
  String? get name => state.name;

  @override
  bool get readOnly => state.readOnly;

  @override
  set readOnly(bool readOnly) => state.readOnly = readOnly;

  @override
  set model(AbstractFieldStateModel model) {
    state._updateModel(model);
  }

  @override
  ValueFieldManagement get valueFieldManagement {
    if (!isValueField) throw 'current field is not a value field';
    return _FixedValueFieldManagement(state as ValueFieldState);
  }
}

class _FixedValueFieldManagement<T> extends ValueFieldManagement<T> {
  final ValueFieldState state;
  _FixedValueFieldManagement(this.state);

  @override
  T? get value => state.value;

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
}

class _TextSelectionManagementDelegate extends TextSelectionManagement {
  final TextSelectionManagement textSelectionManagement;

  _TextSelectionManagementDelegate(this.textSelectionManagement);
  @override
  void selectAll() {
    textSelectionManagement.selectAll();
  }

  @override
  void setSelection(int start, int end) {
    textSelectionManagement.setSelection(start, end);
  }
}

class FormFieldManagementWithError {
  final CastableFormFieldManagement formFieldManagement;
  final String errorText;
  const FormFieldManagementWithError._(
      this.formFieldManagement, this.errorText);
}

class _CastableFormFieldManagement extends CastableFormFieldManagement {
  final FormFieldManagement delegate;
  _CastableFormFieldManagement(this.delegate);
}

class _LayoutForm extends _AbstractForm {
  final bool enableLayoutManagement;

  final bool visible;

  final FormLayout formLayout;

  _LayoutForm({
    Key? key,
    this.enableLayoutManagement = false,
    FormValueChanged? onChanged,
    bool readOnly = false,
    this.visible = true,
    required this.formLayout,
  }) : super(
          key: key,
          readOnly: readOnly,
          onChanged: onChanged,
        );

  @override
  _LayoutFormState createState() => _LayoutFormState();
}

class _LayoutFormState extends _AbstractFormState {
  FormLayout? _formLayout;
  FormLayout? originalFormLayout;

  Map<int, Key> keys = {};

  bool get visible => _visible ?? widget.visible;
  set visible(bool visible) {
    if (_visible != visible) {
      setState(() {
        gen++;
        _visible = visible;
      });
    }
  }

  @override
  _LayoutForm get widget => super.widget as _LayoutForm;

  set formLayout(FormLayout formLayout) {
    if (!widget.enableLayoutManagement)
      throw 'can not update form layout, enableLayoutManagement is false';
    if (_formLayout == null) {
      originalFormLayout = widget.formLayout;
    }
    setState(() {
      gen++;
      _formLayout = formLayout;
    });
  }

  FormLayout get formLayout => _formLayout ?? widget.formLayout;

  @override
  void didUpdateWidget(_LayoutForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    migrateLayout();
  }

  @override
  Widget buildContent() {
    formLayout.removeEmptyRow();
    List<Row> rows = [];
    int row = 0;
    List<int> indexs = [];
    for (FormRow formRow in formLayout.rows) {
      List<_FormBuilderField> children = [];
      int column = 0;
      for (IndexWidget iw in formRow.columns) {
        Position position = Position._(row: row, column: column);
        Key? key = widget.enableLayoutManagement
            ? keys.putIfAbsent(iw.index, () => GlobalKey())
            : null;
        children.add(_FormBuilderField(iw.widget, position, key: key));
        column++;
        indexs.add(iw.index);
      }
      rows.add(Row(
        crossAxisAlignment: formRow.crossAxisAlignment,
        mainAxisAlignment: formRow.mainAxisAlignment,
        mainAxisSize: formRow.mainAxisSize,
        textDirection: formRow.textDirection,
        verticalDirection: formRow.verticalDirection,
        textBaseline: formRow.textBaseline,
        children: children,
      ));
      row++;
    }
    keys.removeWhere((key, value) => !indexs.contains(key));
    return Visibility(
        visible: visible,
        maintainState: true,
        child: Column(
          mainAxisAlignment: formLayout.mainAxisAlignment,
          mainAxisSize: formLayout.mainAxisSize,
          crossAxisAlignment: formLayout.crossAxisAlignment,
          textDirection: formLayout.textDirection,
          textBaseline: formLayout.textBaseline,
          verticalDirection: formLayout.verticalDirection,
          children: rows,
        ));
  }

  void migrateLayout() {
    if (originalFormLayout == null) return;
    //form layout has been changed by formlayoutmanagement
    FormLayout currentLayout = widget.formLayout..removeEmptyRow();
    FormLayout originalLayout = originalFormLayout!;
    if (currentLayout.rowCount != originalLayout.rowCount)
      throwWhenLayoutChanged();
    for (int i = 0; i < originalLayout.rowCount; i++) {
      FormRow originalRow = originalLayout.rows[i];
      FormRow currentRow = currentLayout.rows[i];
      if (originalRow.index != currentRow.index) throwWhenLayoutChanged();
      if (originalRow.columnCount != currentRow.columnCount)
        throwWhenLayoutChanged();

      for (int j = 0; j < originalRow.columnCount; j++) {
        IndexWidget originalColumn = originalRow.columns[j];
        IndexWidget currentColumn = currentRow.columns[j];

        if (originalColumn.index != currentColumn.index ||
            originalColumn.widget.runtimeType !=
                currentColumn.widget.runtimeType) throwWhenLayoutChanged();
      }
    }
    FormLayout stateLayout = formLayout;
    //start migrate
    currentLayout.rows.forEach((element) {
      Iterable<FormRow> stateRowIt = stateLayout.rows
          .where((stateRowElement) => stateRowElement.index == element.index);
      if (stateRowIt.isEmpty) return;
      FormRow stateRow = stateRowIt.first;
      stateRow.customize(
          mainAxisAlignment: element.mainAxisAlignment,
          mainAxisSize: element.mainAxisSize,
          crossAxisAlignment: element.crossAxisAlignment,
          textBaseline: element.textBaseline,
          textDirection: element.textDirection,
          verticalDirection: element.verticalDirection);

      element.columns.forEach((element) {
        Iterable<IndexWidget> stateIndexWidgetIt = stateRow.columns.where(
            (stateColumnElement) => stateColumnElement.index == element.index);
        if (stateIndexWidgetIt.isEmpty) return;
        stateIndexWidgetIt.first.widget = element.widget;
      });
    });

    stateLayout.customize(
        mainAxisAlignment: currentLayout.mainAxisAlignment,
        mainAxisSize: currentLayout.mainAxisSize,
        crossAxisAlignment: currentLayout.crossAxisAlignment,
        textBaseline: currentLayout.textBaseline,
        textDirection: currentLayout.textDirection,
        verticalDirection: currentLayout.verticalDirection);
  }

  void throwWhenLayoutChanged() =>
      throw 'since form layout has been changed by FormLayoutManagement , you can\'t change form layout via ide or setState out of FormBuilder';

  @override
  FormManagement createFormManagement(_ResourceManagement resourceManagement) {
    return LayoutFormManagement._(resourceManagement);
  }
}

class _FormBuilderField extends StatefulWidget {
  final Widget child;
  final Position position;
  _FormBuilderField(this.child, this.position, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormBuilderFieldState();
}

class _FormBuilderFieldState extends State<_FormBuilderField> {
  @override
  Widget build(BuildContext context) {
    return _FieldInfo(widget.position, widget.child);
  }
}

/// field's position
///
/// one position may contain multi fields
class Position {
  /// row of field
  final int row;

  /// columns of field
  final int column;

  Position._({required this.row, required this.column});

  @override
  bool operator ==(other) {
    if (other is! Position) return false;
    if (row == other.row && column == other.column) return true;
    return false;
  }

  @override
  int get hashCode => hashValues(row, column);

  /// get current field's position
  ///
  /// **can only be used in LayoutForm**
  static Position of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FieldInfo>()!.position;
  }
}

class _FieldInfo extends InheritedWidget {
  final Position position;

  _FieldInfo(this.position, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class _SimpleForm extends _AbstractForm {
  final Widget child;
  _SimpleForm({
    Key? key,
    required this.child,
    FormValueChanged? onChanged,
    bool readOnly = false,
  }) : super(
          key: key,
          onChanged: onChanged,
          readOnly: readOnly,
        );
  @override
  _SimpleFormState createState() => _SimpleFormState();
}

class _SimpleFormState extends _AbstractFormState {
  @override
  Widget buildContent() {
    return (widget as _SimpleForm).child;
  }

  @override
  FormManagement createFormManagement(_ResourceManagement resourceManagement) {
    return SimpleFormManagement._(resourceManagement);
  }
}

class SimpleFormManagement extends FormManagement {
  final _ResourceManagement _resourceManagement;

  SimpleFormManagement._(this._resourceManagement);

  @override
  bool hasField(String name) => _resourceManagement.hasName(name);

  @override
  bool get readOnly => _resourceManagement.state.readOnly;

  @override
  set readOnly(bool readOnly) => _resourceManagement.state.readOnly = readOnly;

  @override
  CastableFormFieldManagement newFormFieldManagement(String name) {
    CastableFormFieldManagement? management =
        _resourceManagement.getFormFieldManagement(name);
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
  List<FormFieldManagementWithError> get errors {
    List<FormFieldManagementWithError> errors = [];
    for (ValueFieldState state in _valueFieldStates) {
      if (state.name == null) continue;
      String? errorText = state.errorText;
      if (errorText == null) continue;
      CastableFormFieldManagement management =
          _resourceManagement.getFormFieldManagement(state.name!)!;
      errors.add(FormFieldManagementWithError._(management, errorText));
    }
    return errors;
  }

  @override
  List<FormFieldManagementWithError> quietlyValidate() {
    List<FormFieldManagementWithError> errors = [];
    for (ValueFieldState state in _valueFieldStates) {
      if (state.name == null) continue;
      String? errorText = state._quietlyValidate();
      if (errorText == null) continue;
      CastableFormFieldManagement management =
          _resourceManagement.getFormFieldManagement(state.name!)!;
      errors.add(FormFieldManagementWithError._(management, errorText));
    }
    return errors;
  }

  @override
  set data(Map<String, dynamic> data) => setData(data);

  @override
  void setData(Map<String, dynamic> data, {bool trigger = true}) {
    if (data.isEmpty) return;
    data.map((key, value) => MapEntry(key, value)).forEach((key, value) {
      FormFieldManagement? management =
          _resourceManagement.getFormFieldManagement(key);
      if (management == null || !management.isValueField) return;
      management.valueFieldManagement.setValue(value, trigger: trigger);
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
  void onSaved() {
    _valueFieldStates.forEach((element) {
      element.save();
    });
  }

  Iterable<ValueFieldState> get _valueFieldStates =>
      _resourceManagement.valueFieldStates;
}

class LayoutFormManagement extends SimpleFormManagement
    implements FormManagement {
  final FormLayoutManagement formLayoutManagement;
  LayoutFormManagement._(_ResourceManagement resourceManagement)
      : this.formLayoutManagement = FormLayoutManagement._(resourceManagement),
        super._(resourceManagement);

  bool get visible => _state.visible;

  set visible(bool visible) => _state.visible = visible;

  _LayoutFormState get _state => _resourceManagement.state as _LayoutFormState;
}

/// used to modify layout of form
///
/// make sure [FormBuilder.enableLayoutManagement] is true before you start edit
///
/// **when you start edit layout,even though you did nothing before  apply is called,
/// form layout will be stored in FormModel,when you try to update layout by setState or ide an error will be throw**
///
/// **@experimental**
class FormLayoutManagement {
  final _ResourceManagement _resourceManagement;
  FormLayoutManagement._(this._resourceManagement);

  FormLayout? _formLayout;

  /// is editing
  bool get isEditing => _formLayout != null;

  /// get editing layout rows
  int get rows => _formLayout!.rowCount;

  void customizeColumn({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    _ensureStarted();
    _formLayout!.customize(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection);
  }

  void customizeRow({
    int? row,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    _ensureStarted();
    if (row != null) _rangeCheck(row);
    FormRow formRow =
        row == null ? _formLayout!.lastRow() : _formLayout!.rows[row];
    formRow.customize(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection);
  }

  /// get columns of a row
  int getColumns(int row) {
    _ensureStarted();
    _rangeCheck(row);
    return _formLayout!.rows[row].columnCount;
  }

  // remove field or a row at position
  void remove(int row, {int? column}) {
    _ensureStarted();
    _rangeCheck(row, column: column);
    if (column == null) {
      _formLayout!.rows.removeAt(row);
    } else {
      FormRow formRow = _formLayout!.rows[row];
      formRow.columns.removeAt(column);
    }
  }

  /// insert a field at position
  void insert(
      {int? column, int? row, required Widget field, bool newRow = false}) {
    _ensureStarted();
    if (row != null) _rangeCheck(row, column: column);
    FormRow formRow = row == null
        ? newRow
            ? _formLayout!.append()
            : _formLayout!.rows[_formLayout!.rows.length - 1]
        : newRow
            ? _formLayout!.insert(row)
            : _formLayout!.rows[row];
    if (column == null)
      formRow.append(field);
    else
      formRow.insert(field, column);
  }

  /// swap two row
  void swapRow(int oldRow, int newRow) {
    _ensureStarted();
    _rangeCheck(oldRow);
    _rangeCheck(newRow);
    if (oldRow == newRow) throw 'oldRow must not equals newRow';
    FormRow row = _formLayout!.rows.removeAt(oldRow);
    _formLayout!.rows.insert(newRow, row);
  }

  /// start edit
  ///
  /// when you want to modify layout,you should call this method first
  /// and do what you want (remove|insert|swap) ,finally you should call
  /// apply to commit and rebuild form
  ///
  /// **if layoutmanagement is disabled,an error will be throw**
  void startEdit() {
    if (_formLayout != null)
      throw 'call apply or cancel first before you call startEdit again';
    _formLayout =
        (_resourceManagement.state as _LayoutFormState).formLayout.copy();
  }

  /// cancel edit
  void cancel() {
    _ensureStarted();
    _formLayout = null;
  }

  /// apply edit
  void apply() {
    _ensureStarted();
    _formLayout!.removeEmptyRow();
    (_resourceManagement.state as _LayoutFormState).formLayout = _formLayout!;
    _formLayout = null;
  }

  void _ensureStarted() {
    if (_formLayout == null) throw 'did you called startEdit?';
  }

  void _rangeCheck(int row, {int? column}) {
    if (row < 0 || row >= _formLayout!.rows.length)
      throw 'row is out of range ,range is 0,${_formLayout!.rows.length - 1}';
    if (column != null) {
      FormRow formRow = _formLayout!.rows[row];
      int maxColumn = formRow.columns.length - 1;
      if (column < 0 || column > maxColumn)
        throw 'column is out of range ,range is 0,$maxColumn';
    }
  }
}
