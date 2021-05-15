import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'focus_node.dart';
import 'form_builder_utils.dart';
import 'form_field.dart';
import 'form_layout.dart';
import 'management.dart';
import 'state_model.dart';
import 'text_selection.dart';

/// used to build a field
typedef FieldBuilder = Widget Function(BuilderInfo info, BuildContext context);
typedef FormValueChanged = void Function(
    String name, dynamic oldValue, dynamic newValue);

class FormBuilder extends StatefulWidget {
  final FormManagement formManagement;
  final Map<String, StateValue> _initStateMap;

  /// listen form value changed
  ///
  /// this listener will be always triggered when field'value changed
  ///
  /// **only listen fields which has a name**
  final FormValueChanged? onChanged;

  /// whether enableLayoutManagement
  ///
  /// if enabled , global key will be used for every builder field (root of form field)
  ///
  /// **enable it when you really need modify form layout at runtime,otherwise disable it for performance improve,
  /// when try to update this flag at runtime,an error will be throw**
  ///
  ///
  /// **@experimental**
  final bool enableLayoutManagement;

  FormBuilder(
      {bool readOnly = false,
      bool visible = true,
      required this.formManagement,
      MainAxisAlignment? mainAxisAlignment,
      MainAxisSize? mainAxisSize,
      CrossAxisAlignment? crossAxisAlignment,
      TextDirection? textDirection,
      VerticalDirection? verticalDirection,
      TextBaseline? textBaseline,
      this.enableLayoutManagement = false,
      this.onChanged})
      : this._initStateMap = {
          'formLayout': StateValue<FormLayout>(FormLayout(
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: crossAxisAlignment,
              textBaseline: textBaseline,
              textDirection: textDirection,
              verticalDirection: verticalDirection)),
          'visible': StateValue<bool>(visible),
          'readOnly': StateValue<bool>(readOnly),
        };

  FormLayout get _formLayout => _initStateMap['formLayout']!.value;

  /// require a new Row
  ///
  /// if last row is empty won't create a new row
  FormBuilder newRow() {
    _formLayout.lastEmptyRow();
    return this;
  }

  /// customize last row
  FormBuilder customize({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    _formLayout.customize(
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
  FormBuilder append(Widget field) {
    _formLayout.lastRow().append(field);
    return this;
  }

  /// append a fieldBuilder to last  row
  FormBuilder appendBuilder(FieldBuilder builder) {
    return append(_builderField(builder));
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
  FormBuilder oneRowField(Widget field) {
    _formLayout.lastEmptyRow().append(field);
    _formLayout.append();
    return this;
  }

  FormBuilder oneRowBuilder(FieldBuilder builder) {
    return oneRowField(_builderField(builder));
  }

  Widget _builderField(FieldBuilder builder) {
    return Builder(
      builder: (context) {
        BuilderInfo info = BuilderInfo.of(context);
        return builder(info, context);
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _FormBuilderState();
}

class _FormData extends InheritedWidget {
  final _ResourceManagement data;
  final int gen;

  _FormData(this.data, this.gen, {required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant _FormData oldWidget) {
    return gen != oldWidget.gen;
  }

  static _FormData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormData>()!;
  }
}

class _FormModel extends BaseStateModel {
  final bool enableLayoutManagement;
  final FormValueChanged? onChanged;
  FormLayout? originalFormLayout;
  _FormModel(Map<String, StateValue> value, this.enableLayoutManagement,
      this.onChanged)
      : super(value);

  FormLayout get formLayout => getState('formLayout');
  set formLayout(FormLayout formLayout) => update1('formLayout', formLayout);

  bool get visible => getState('visible');
  set visible(bool visible) => update1('visible', visible);

  bool get readOnly => getState('readOnly');
  set readOnly(bool readOnly) => update1('readOnly', readOnly);

  @override
  void afterStateValueChanged(String key, dynamic old, dynamic current) {
    if (key == 'formLayout' && old == null) {
      originalFormLayout = getInitState(key);
    }
  }
}

class _FormBuilderState extends State<FormBuilder> {
  late final _ResourceManagement resourceManagement;
  late _FormModel model;

  @override
  void initState() {
    super.initState();
    resourceManagement = widget.formManagement._resourceManagement;
    model = _FormModel(
        widget._initStateMap, widget.enableLayoutManagement, widget.onChanged);
    model.addListener(() {
      setState(() {});
    });
    resourceManagement.registerFormModel(model);
  }

  @override
  void didUpdateWidget(FormBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    model.didUpdateModel(oldWidget._initStateMap, widget._initStateMap);
    if (oldWidget.enableLayoutManagement != widget.enableLayoutManagement)
      throw 'enableLayoutManagement should not be changed at runtime !';
    migrateLayout();
  }

  @override
  void dispose() {
    resourceManagement.unregisterFormModel(model);
    resourceManagement.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FormLayout formLayout = model.formLayout;
    bool visible = model.visible;

    formLayout.removeEmptyRow();
    List<Row> rows = [];
    int row = 0;
    List<int> indexs = [];
    for (FormRow formRow in formLayout.rows) {
      List<_FormBuilderField> children = [];
      int column = 0;
      for (IndexWidget iw in formRow.columns) {
        Position position = Position(row: row, column: column);
        Key? key = widget.enableLayoutManagement
            ? resourceManagement.registerGlobalKey(iw.index)
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
    //removed unused keys
    resourceManagement.unregisterGlobalKeys(indexs);
    return Visibility(
        visible: visible,
        maintainState: true,
        child: _FormData(
          resourceManagement,
          model.gen,
          child: Column(
            mainAxisAlignment: formLayout.mainAxisAlignment,
            mainAxisSize: formLayout.mainAxisSize,
            crossAxisAlignment: formLayout.crossAxisAlignment,
            textDirection: formLayout.textDirection,
            textBaseline: formLayout.textBaseline,
            verticalDirection: formLayout.verticalDirection,
            children: rows,
          ),
        ));
  }

  void migrateLayout() {
    if (model.originalFormLayout == null) return;
    //form layout has been changed by formlayoutmanagement
    FormLayout currentLayout = widget._formLayout;
    FormLayout originalLayout = model.originalFormLayout!;
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
    FormLayout stateLayout = model.formLayout;
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
    _FormModel model = _ResourceManagement.of(context).formModel;
    return _InheritedFieldInfo(
        FieldInfo._(widget.position, model.readOnly), widget.child);
  }
}

/// used to register|unregister|lookup resources
class _ResourceManagement {
  final GlobalKey key = GlobalKey(); //form key !
  _FormModel? _formModel;
  final Map<int, Key> keys = {};
  final List<_FixedFormFieldManagement> formFieldManagements = [];

  Key registerGlobalKey(int index) {
    return keys.putIfAbsent(index, () => GlobalKey());
  }

  void unregisterGlobalKeys(List<int> used) {
    keys.removeWhere((key, value) => !used.contains(key));
  }

  void registerFormModel(_FormModel formModel) {
    this._formModel = formModel;
  }

  void unregisterFormModel(_FormModel formModel) {
    if (this._formModel == formModel) {
      this._formModel!.dispose();
      this._formModel = null;
    } else
      formModel.dispose();
  }

  void registerFormFieldManagement(
          _FixedFormFieldManagement formFieldManagement) =>
      formFieldManagements.add(formFieldManagement);

  void unregisterFormFieldManagement(
          _FixedFormFieldManagement formFieldManagement) =>
      formFieldManagements.remove(formFieldManagement);

  static _ResourceManagement of(BuildContext context) {
    return _FormData.of(context).data;
  }

  FormFieldManagement? getFormFieldManagement(_FieldKey key) {
    if (key.name != null) {
      Iterable<FormFieldManagement> it =
          formFieldManagements.where((element) => element.name == key.name!);
      return it.isEmpty ? null : it.first;
    }
    if (key.row != null && key.index != null) {
      Iterable<FormFieldManagement> it =
          getFormFieldManagements(key.row!, column: key.column);
      if (it.isEmpty || key.index! > it.length - 1) return null;
      return it.elementAt(key.index!);
    }
  }

  Iterable<FormFieldManagement> getFormFieldManagements(int row,
      {int? column}) {
    return formFieldManagements.where((element) {
      if (element.position.row == row)
        return column == null ? true : element.position.column == column;
      return false;
    });
  }

  Iterable<ValueFieldState> get valueFieldStates => formFieldManagements
      .where((element) => element.isValueField)
      .map((e) => e._valueFieldManagement!.state);

  Iterable<_FixedFormFieldManagement> get valueFieldManagements =>
      formFieldManagements.where((element) => element.isValueField);

  bool hasName(String name) =>
      getFormFieldManagement(_FieldKey(name: name)) != null;

  _FormModel get formModel {
    if (_formModel == null) throw 'no form model can be found';
    return _formModel!;
  }

  void dispose() {
    keys.clear();
  }
}

/// a management used to control a form
///
/// ```
/// FormBuilder(formManagement:your form management)
/// ```
///
/// **when you create a _FormBuilderFieldModel,it's also created a new  GlobalKey used by FormBuilder,so if your _FormBuilderFieldModel instance changed for every builder
/// (eg FormBuilder(formMangement:_FormBuilderFieldModel())),your form will rebuild always**
class FormManagement {
  final _ResourceManagement _resourceManagement;
  FormLayoutManagement? _formLayoutManagement;

  FormManagement() : this._resourceManagement = _ResourceManagement();

  FormManagement._(this._resourceManagement);

  /// whether form has a name field
  bool hasField(String name) => _resourceManagement.hasName(name);

  /// whether form is visible
  bool get visible => _formModel.visible;

  /// show|hide form
  set visible(bool visible) => _formModel.visible = visible;

  /// whether form is readonly
  bool get readOnly => _formModel.readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly) => _formModel.readOnly = readOnly;

  /// get rows of form
  int get rows => _formModel.formLayout.rowCount;

  /// get column of a row
  int getColumn(int row) {
    if (row < 0 || row > rows - 1) throw 'row out of range ,range is 0~$rows';
    return _formModel.formLayout.rows[row].columnCount;
  }

  /// get a new formfieldManagement by name
  ///
  /// you can create field management via this method as State variable,
  /// sometimes, two fields may swap their names, this management will auto find last field by name
  /// ```
  /// late FormFieldManagement usernameManagement;
  ///
  /// void initState(){
  ///   initState();
  ///   usernameManagment = formManagement.newFormFieldManagement('username') ;//ok to create
  ///   bool readOnly = usernameManagement.readOnly;//will cause an error here, do this in a button or  Builder
  /// }
  /// ```
  FormFieldManagement newFormFieldManagement(String name) =>
      _RealTimeFormFieldManagement(_FieldKey(name: name), _resourceManagement);

  /// create a form position management used to control visible|readOnly state of all
  /// fields at this position
  FormPositionManagement newFormPositionManagement(int row, {int? column}) =>
      FormPositionManagement._(_resourceManagement, row, column: column);

  /// create a form layout management used to modify layout of form
  ///
  /// **@experimental**
  FormLayoutManagement newFormLayoutManagement() =>
      _formLayoutManagement ??= FormLayoutManagement._(_resourceManagement);

  /// get form data
  ///
  /// if a value field doesn't has a name state,it's value will be ignored
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

  /// get error msg after validate form,if you don't want to display error text,
  /// look at [quietlyValidate]
  ///
  /// key is field'name
  /// value is [FormFieldManagement] you can get errorText
  /// via [FormFieldManagement.valueFieldManagement.errorText]
  /// or request a focus via [FormFieldManagement.focus]
  /// or ensure field visible via [FormFieldManagement.ensureVisible]
  ///
  /// **the result has been sorted by position**
  Map<String, FormFieldManagement> get errors {
    return (_valueFieldManagements
            .where((element) =>
                element.name != null &&
                element.valueFieldManagement.errorText != null)
            .toList()
              ..sort((a, b) {
                Position pa = a.position;
                Position pb = b.position;
                int compare = pa.row.compareTo(pb.row);
                if (compare == 0) return pa.column.compareTo(pb.column);
                return compare;
              }))
        .asMap()
        .map((key, value) => MapEntry(value.name!, value));
  }

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
  ///
  /// **the result has been sorted by position**
  List<FormFieldManagementWithError> quietlyValidate() {
    List<FormFieldManagementWithError> errors = [];
    for (_FixedFormFieldManagement management in _valueFieldManagements) {
      if (management.name == null) continue;
      String? errorText =
          management._valueFieldManagement!.state._quietlyValidate();
      if (errorText == null) continue;
      errors.add(FormFieldManagementWithError._(management, errorText));
    }
    errors.sort((a, b) {
      Position p1 = a.formFieldManagement.position;
      Position p2 = b.formFieldManagement.position;
      int compare = p1.row.compareTo(p2.row);
      if (compare == 0) return p1.column.compareTo(p2.column);
      return compare;
    });
    return errors;
  }

  /// equals to setData(data,trigger:true)
  set data(Map<String, dynamic> data) => setData(data);

  /// set form data
  ///
  /// [trigger] whether trigger onChanged
  void setData(Map<String, dynamic> data, {bool trigger = true}) {
    if (data.isEmpty) return;
    data.map((key, value) => MapEntry(key, value)).forEach((key, value) {
      FormFieldManagement? management =
          _resourceManagement.getFormFieldManagement(_FieldKey(name: key));
      if (management == null || !management.isValueField) return;
      management.valueFieldManagement.setValue(value, trigger: trigger);
    });
  }

  /// reset form
  ///
  /// **only reset all value fields**
  void reset() {
    _valueFieldStates.forEach((element) {
      element.reset();
    });
  }

  /// validate form and return is valid or not
  ///
  /// **will display error if invalid ,
  /// if you only want to know the form is valid or not ,
  /// use [isValid] instead**
  bool validate() {
    bool hasError = false;
    for (final ValueFieldState field in _valueFieldStates)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  /// whether form is valid
  ///
  /// **only check is valid or not , won't show error**
  bool get isValid {
    bool hasError = false;
    for (final ValueFieldState field in _valueFieldStates)
      hasError = !field.isValid || hasError;
    return !hasError;
  }

  /// save all form fields
  ///
  /// form field's onSaved will be  called
  void onSaved() {
    _valueFieldStates.forEach((element) {
      element.save();
    });
  }

  /// get current formManagement from context
  ///
  /// **context must be child context of FormBuilder**
  ///
  /// ```
  /// appendBuilder(Builder(builder:(context){
  ///   //ok to call FormManagement.of(context)
  /// }))
  /// ```
  static FormManagement of(BuildContext context) =>
      FormManagement._(_ResourceManagement.of(context));

  _FormModel get _formModel => _resourceManagement.formModel;

  Iterable<_FixedFormFieldManagement> get _valueFieldManagements =>
      _resourceManagement.valueFieldManagements;

  Iterable<ValueFieldState> get _valueFieldStates =>
      _resourceManagement.valueFieldStates;
}

class _FixedFormFieldManagement extends FormFieldManagement {
  final AbstractFieldStateModel model;
  final BuildContext context;
  final _ResourceManagement resourceManagement;
  final TextSelectionManagement? _textSelectionManagement;
  String? name;
  FocusNodes? focusNode;
  _FixedValueFieldManagement? _valueFieldManagement;

  _FixedFormFieldManagement(this.name, this.model, this.context,
      this.resourceManagement, this._textSelectionManagement);

  @override
  bool get readOnly => model.readOnly;
  @override
  set readOnly(bool readOnly) => model.readOnly = readOnly;
  @override
  bool get visible => this.model.visible;
  @override
  set visible(bool visible) => model.visible = visible;

  @override
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment}) {
    if (!model.visible || !resourceManagement.formModel.visible)
      return Future<void>.value();
    return Scrollable.ensureVisible(context,
        duration: duration ?? Duration.zero,
        curve: curve ?? Curves.ease,
        alignmentPolicy:
            alignmentPolicy ?? ScrollPositionAlignmentPolicy.explicit,
        alignment: alignment ?? 0);
  }

  @override
  bool get focusable => focusNode != null && focusNode!.canRequestFocus;
  @override
  bool get hasFocus {
    if (focusNode == null) throw 'current field do not has a focusnode';
    return focusNode!.hasFocus;
  }

  @override
  set focus(bool focus) {
    if (!focusable)
      throw 'current field do not has a focusnode or focusnode can not request a focus';
    if (focus)
      focusNode!.requestFocus();
    else
      focusNode!.unfocus();
  }

  @override
  set focusListener(FocusListener? listener) {
    if (focusNode == null) throw 'current field do not has a focusnode';
    focusNode!.focusListener = listener;
  }

  @override
  Position get position => FieldInfo.of(context).position;

  @override
  bool get supportTextSelection => _textSelectionManagement != null;

  @override
  TextSelectionManagement get textSelectionManagement {
    if (!supportTextSelection) throw 'field not support textselection';
    return _textSelectionManagement!;
  }

  @override
  void update(Map<String, dynamic> state) => model.update(state);

  @override
  _FixedValueFieldManagement get valueFieldManagement {
    if (_valueFieldManagement == null)
      throw 'current field is not a value field';
    return _valueFieldManagement!;
  }

  @override
  bool get isValueField => _valueFieldManagement != null;

  @override
  bool supportState(String key) => model.support(key);
}

class _FixedValueFieldManagement<T> extends ValueFieldManagement<T> {
  final ValueFieldState<T> state;

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
}

/// a field management used to control field
class _RealTimeFormFieldManagement extends FormFieldManagement {
  final _FieldKey key;
  final _ResourceManagement resourceManagement;

  _RealTimeFormFieldManagement(this.key, this.resourceManagement);
  @override
  String? get name => _management.name;
  @override
  Position get position => _management.position;
  @override
  bool get visible => _management.visible;
  @override
  set visible(bool visible) => _management.visible = visible;
  @override
  bool get readOnly => _management.readOnly;
  @override
  set readOnly(bool readOnly) => _management.readOnly = readOnly;
  @override
  bool get focusable => _management.focusable;
  @override
  bool get hasFocus => _management.hasFocus;

  @override
  set focus(bool focus) => _management.focus = focus;

  @override
  set focusListener(FocusListener? listener) =>
      _management.focusListener = listener;

  @override
  ValueFieldManagement get valueFieldManagement =>
      _RealTimeValueFieldManagement(key, resourceManagement);

  @override
  bool get isValueField => _management.isValueField;
  @override
  bool get supportTextSelection => _management.supportTextSelection;
  @override
  TextSelectionManagement get textSelectionManagement =>
      _management.textSelectionManagement;

  @override
  void update(Map<String, dynamic> state) => _management.update(state);
  @override
  void update1(String key, dynamic value) => _management.update({key: value});

  FormFieldManagement get _management {
    FormFieldManagement? management =
        resourceManagement.getFormFieldManagement(key);
    if (management == null) throw 'field can not be found';
    return management;
  }

  @override
  Future<void> ensureVisible(
          {Duration? duration,
          Curve? curve,
          ScrollPositionAlignmentPolicy? alignmentPolicy,
          double? alignment}) =>
      _management.ensureVisible(
          duration: duration,
          curve: curve,
          alignmentPolicy: alignmentPolicy,
          alignment: alignment);

  @override
  bool supportState(String key) => _management.supportState(key);
}

class _RealTimeValueFieldManagement<T> extends ValueFieldManagement<T> {
  final _FieldKey key;
  final _ResourceManagement resourceManagement;

  _RealTimeValueFieldManagement(this.key, this.resourceManagement);

  @override
  T? get value => _management.value;

  @override
  void setValue(T? value, {bool trigger = true}) =>
      _management.setValue(value, trigger: trigger);

  @override
  String? get errorText => _management.errorText;

  @override
  bool get isValid => _management.isValid;

  @override
  void reset() => _management.reset();

  @override
  bool validate() => _management.validate();

  FormFieldManagement get _fieldManagement {
    FormFieldManagement? fieldManagement =
        resourceManagement.getFormFieldManagement(key);
    if (fieldManagement == null) throw 'field can not be found';
    return fieldManagement;
  }

  ValueFieldManagement get _management => _fieldManagement.valueFieldManagement;

  @override
  set value(T? value) => _management.value = value;
}

class FormPositionManagement {
  final int row;
  final int? column;
  final _ResourceManagement resourceManagement;
  FormPositionManagement._(this.resourceManagement, this.row, {this.column});

  bool get readOnly => _managements.every((element) => element.readOnly);

  bool get visible => _managements.any((element) => element.visible);

  set readOnly(bool readOnly) => _managements.forEach((element) {
        element.readOnly = readOnly;
      });

  set visible(bool visible) => _managements.forEach((element) {
        element.visible = visible;
      });

  Iterable<FormFieldManagement> get _managements {
    Iterable<FormFieldManagement> managements =
        resourceManagement.getFormFieldManagements(row, column: column);
    if (managements.isEmpty)
      throw 'no fields can be found at position row:$row column: $column';
    return managements;
  }
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
    _ensureEnabled();
    if (_formLayout != null)
      throw 'call apply or cancel first before you call startEdit again';
    _formLayout = _formModel.formLayout.copy();
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
    _formModel.formLayout = _formLayout!;
    _formLayout = null;
  }

  void _ensureStarted() {
    if (_formLayout == null) throw 'did you called startEdit?';
  }

  void _ensureEnabled() {
    if (!_formModel.enableLayoutManagement)
      throw 'layoutManagement is disabled!';
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

  _FormModel get _formModel => _resourceManagement.formModel;
}

/// state for all stateful form field
///
/// if you want FormBuilder control your custom stateful field,you can do as follows
///
/// 1. make your custom field extends StatefulWidget and with StatefulField
/// 2. make your custom state extends State and with AbstractFieldState
///
mixin AbstractFieldState<T extends StatefulWidget> on State<T> {
  bool _init = false;
  late final _ResourceManagement _resourceManagement;
  late final _FixedFormFieldManagement _fixedFormFieldManagement;

  late AbstractFieldStateModel model;
  late FieldInfo fieldInfo;

  FocusNodes? _focusNode;

  String? get name => (widget as StatefulField).name;

  /// get row of field
  int get row => position.row;

  /// get column of field
  int get column => position.column;

  bool get readOnly => _resourceManagement.formModel.readOnly || model.readOnly;

  Position get position => fieldInfo.position;

  bool get init => _init;

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  ///
  /// call this method in builder or in [initFormManagement]
  FocusNodes get focusNode {
    FocusNodes focusNodes = _focusNode ??= FocusNodes();
    _fixedFormFieldManagement.focusNode = focusNodes;
    return focusNodes;
  }

  void requestFocus() {
    if (_focusNode == null || !_focusNode!.canRequestFocus) return;
    _focusNode!.requestFocus();
  }

  @protected
  void didChangeDependencies() {
    super.didChangeDependencies();
    fieldInfo = FieldInfo.of(context);
    if (_init) return;
    _init = true;
    _resourceManagement = _ResourceManagement.of(context);
    model = createModel();
    initFormManagement();
  }

  @protected
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fixedFormFieldManagement.name = (widget as StatefulField).name;
  }

  /// this method will be called immediately after initState
  /// and will only be called once during state lifecycle
  ///
  /// **you should call getState in this method , not in initState!**
  @protected
  @mustCallSuper
  void initFormManagement() {
    TextSelectionManagement? textSelectionManagement;
    if (this is TextSelectionManagement)
      textSelectionManagement =
          _TextSelectionManagementDelegate(this as TextSelectionManagement);
    _fixedFormFieldManagement = _FixedFormFieldManagement(
        name, model, context, _resourceManagement, textSelectionManagement);
    _resourceManagement.registerFormFieldManagement(_fixedFormFieldManagement);
  }

  @protected
  void dispose() {
    _resourceManagement
        .unregisterFormFieldManagement(_fixedFormFieldManagement);
    _focusNode?.dispose();
    super.dispose();
  }

  AbstractFieldStateModel createModel();
}

abstract class ValueFieldState<T> extends FormFieldState<T>
    with AbstractFieldState<FormField<T>> {
  ValueChanged<T?>? get onChanged =>
      (super.widget as ValueField<T, ValueFieldState>).onChanged;

  @override
  void initFormManagement() {
    super.initFormManagement();
    this._fixedFormFieldManagement._valueFieldManagement =
        _FixedValueFieldManagement<T>(this);
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
          (super.widget as ValueField<T, ValueFieldState>).onChanged;
      if (onChanged != null) onChanged(current);
    }
    if (name != null) {
      FormValueChanged? formValueChanged =
          _resourceManagement.formModel.onChanged;
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
}

class FieldInfo {
  final Position position;
  final bool readOnly;

  FieldInfo._(this.position, this.readOnly);

  static FieldInfo of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedFieldInfo>()!
        .fieldInfo;
  }
}

class _InheritedFieldInfo extends InheritedWidget {
  final FieldInfo fieldInfo;

  _InheritedFieldInfo(this.fieldInfo, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(covariant _InheritedFieldInfo oldWidget) {
    return true;
  }
}

/// when you use [Builder] to build a widget
///
/// you can use [BuilderInfo.of(context)] to help you
class BuilderInfo {
  final Position position;

  /// whether form is readOnly
  final bool readOnly;
  final ThemeData themeData;

  static BuilderInfo of(BuildContext context) {
    FieldInfo fieldInfo = FieldInfo.of(context);
    return BuilderInfo._(Theme.of(context), fieldInfo);
  }

  BuilderInfo._(this.themeData, FieldInfo fieldInfo)
      : this.position = fieldInfo.position,
        this.readOnly = fieldInfo.readOnly;
}

class _FieldKey {
  final String? name;
  final int? row;
  final int? column;
  final int? index;

  const _FieldKey({this.name, this.row, this.column, this.index});
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
  final FormFieldManagement formFieldManagement;
  final String errorText;
  const FormFieldManagementWithError._(
      this.formFieldManagement, this.errorText);
}
