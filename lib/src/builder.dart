import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'field/button.dart';
import 'field/filter_chip.dart';
import 'focus_node.dart';
import 'form_builder_utils.dart';
import 'form_field.dart';
import 'field/selector.dart';
import 'field/switch_group.dart';
import 'field/checkbox_group.dart';
import 'form_layout.dart';
import 'field/text_field.dart';
import 'field/radio_group.dart';
import 'field/slider.dart';
import 'state_model.dart';
import 'text_selection.dart';

typedef FormValueChanged = void Function(String name, dynamic newValue);
typedef FieldBuilder = Widget Function(BuilderInfo info, BuildContext context);

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
  /// if enabled , global key will be used for every field (root of form field)
  ///
  /// **enable it when you really need modify form layout at runtime,otherwise disable it for performance improve,
  /// this flag should not be changed at runtime**
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

  FormRow get _lastRow => _formLayout.lastRow();

  /// create a new Row
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
    _lastRow.customize(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection);
    return this;
  }

  /// append a number field to current row
  FormBuilder numberField(
      {String? name,
      int flex = 1,
      String? hintText,
      String? labelText,
      EdgeInsets? padding,
      VoidCallback? onTap,
      Widget? prefixIcon,
      ValueChanged<num?>? onChanged,
      FormFieldValidator<num>? validator,
      AutovalidateMode? autovalidateMode,
      double? max,
      bool clearable = true,
      bool readOnly = false,
      bool visible = true,
      int decimal = 0,
      TextStyle? style,
      num? initialValue,
      List<Widget>? suffixIcons,
      VoidCallback? onEditingComplete,
      TextInputAction? textInputAction,
      InputDecorationTheme? inputDecorationTheme,
      bool autofocus = false,
      bool allowNegative = false,
      FormFieldSetter<num>? onSaved}) {
    assert(flex != 0, 'numberfield flex can not be zero!');
    _lastRow.append(NumberFormField(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        autofocus: autofocus,
        onChanged: onChanged,
        decimal: decimal,
        max: max,
        hintText: hintText,
        labelText: labelText,
        validator: validator,
        autovalidateMode: autovalidateMode,
        clearable: clearable,
        prefixIcon: prefixIcon,
        style: style,
        initialValue: initialValue,
        suffixIcons: suffixIcons,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        inputDecorationTheme: inputDecorationTheme,
        allowNegative: allowNegative,
        onSaved: onSaved));
    return this;
  }

  /// add a textfield to current row
  FormBuilder textField({
    String? name,
    String? hintText,
    String? labelText,
    VoidCallback? onTap,
    bool obscureText = false,
    int flex = 1,
    int? maxLines = 1,
    Widget? prefixIcon,
    TextInputType? keyboardType,
    int? maxLength,
    ValueChanged<String>? onChanged,
    NonnullFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    bool clearable = true,
    bool passwordVisible = false,
    bool readOnly = false,
    bool visible = true,
    List<TextInputFormatter>? inputFormatters,
    EdgeInsets? padding,
    TextStyle? style,
    String? initialValue,
    ToolbarOptions? toolbarOptions,
    bool? selectAllOnFocus,
    List<Widget>? suffixIcons,
    VoidCallback? onEditingComplete,
    TextInputAction? textInputAction,
    InputDecorationTheme? inputDecorationTheme,
    bool autofocus = false,
    NonnullFormFieldSetter<String>? onSaved,
  }) {
    assert(flex != 0, 'textfield flex can not be zero!');
    _lastRow.append(ClearableTextFormField(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        autofocus: autofocus,
        hintText: hintText,
        labelText: labelText,
        maxLength: maxLength,
        maxLines: maxLines,
        obscureText: obscureText,
        onTap: onTap,
        keyboardType: keyboardType,
        validator: validator,
        autovalidateMode: autovalidateMode,
        clearable: clearable,
        prefixIcon: prefixIcon,
        passwordVisible: passwordVisible,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: style,
        initialValue: initialValue,
        toolbarOptions: toolbarOptions,
        selectAllOnFocus: selectAllOnFocus ?? false,
        suffixIcons: suffixIcons,
        textInputAction: textInputAction,
        inputDecorationTheme: inputDecorationTheme,
        onSaved: onSaved));
    return this;
  }

  /// add a radio group
  ///
  /// if inline is false,it will be added to current row
  /// otherwise it will be placed in a new row
  FormBuilder radioGroup<T>({
    required List<RadioGroupItem<T>> items,
    String? name,
    String? labelText,
    ValueChanged<T?>? onChanged,
    bool readOnly = false,
    bool visible = true,
    FormFieldValidator? validator,
    AutovalidateMode? autovalidateMode,
    int split = 2,
    EdgeInsets? padding,
    dynamic? initialValue,
    bool inline = false,
    int flex = 1,
    FormFieldSetter<T>? onSaved,
  }) {
    assert(flex != 0, 'radio group flex can not be zero!');
    _lastRow.append(
      RadioGroupFormField<T>(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        labelText: labelText,
        items: List.of(items),
        validator: validator,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        split: split,
        initialValue: initialValue,
        onSaved: onSaved,
      ),
    );
    return this;
  }

  FormBuilder checkboxGroup({
    required List<CheckboxGroupItem> items,
    String? name,
    String? labelText,
    ValueChanged<List<int>>? onChanged,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    bool readOnly = false,
    bool visible = true,
    int split = 2,
    int flex = 1,
    EdgeInsets? padding,
    List<int>? initialValue,
    bool inline = false,
    NonnullFormFieldSetter<List<int>>? onSaved,
  }) {
    assert(flex != 0, 'checkbox group flex can not be zero!');
    _lastRow.append(
      CheckboxGroupFormField(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        items: List.of(items),
        labelText: labelText,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        split: split,
        initialValue: initialValue,
        onSaved: onSaved,
      ),
    );
    return this;
  }

  FormBuilder button(
      {String? name,
      required WidgetBuilder childBuilder,
      int flex = 0,
      required VoidCallback onPressed,
      VoidCallback? onLongPress,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets? padding,
      Icon? icon,
      ButtonType type = ButtonType.Text}) {
    _lastRow.append(Button(
        childBuilder: childBuilder,
        onPressed: onPressed,
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        icon: icon,
        type: type));
    return this;
  }

  FormBuilder datetimeField({
    String? name,
    String? labelText,
    String? hintText,
    bool readOnly = false,
    bool visible = true,
    int flex = 1,
    DateTimeFormatter? formatter,
    FormFieldValidator<DateTime>? validator,
    bool useTime = true,
    EdgeInsets? padding,
    TextStyle? style,
    int? maxLines,
    ValueChanged<DateTime?>? onChanged,
    DateTime? initialValue,
    InputDecorationTheme? inputDecorationTheme,
    FormFieldSetter<DateTime>? onSaved,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    assert(flex != 0, 'datetimefield flex can not be zero!');
    _lastRow.append(
      DateTimeFormField(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        hintText: hintText,
        labelText: labelText,
        formatter: formatter,
        validator: validator,
        useTime: useTime,
        style: style,
        maxLines: maxLines,
        initialValue: initialValue,
        inputDecorationTheme: inputDecorationTheme,
        onChanged: onChanged,
        onSaved: onSaved,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
    return this;
  }

  FormBuilder selector<T>({
    String? name,
    String? labelText,
    String? hintText,
    bool readOnly = false,
    bool visible = true,
    bool clearable = true,
    NonnullFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    EdgeInsets? padding,
    bool multi = false,
    ValueChanged<List<T>>? onChanged,
    List<T>? initialValue,
    SelectItemRender<T>? selectItemRender,
    SelectedItemRender<T>? selectedItemRender,
    SelectedSorter<T>? selectedSorter,
    SelectItemProvider<T>? selectItemProvider,
    SelectedItemLayoutType selectedItemLayoutType = SelectedItemLayoutType.wrap,
    QueryFormBuilder? queryFormBuilder,
    OnSelectDialogShow? onSelectDialogShow,
    VoidCallback? onTap,
    InputDecorationTheme? inputDecorationTheme,
    bool inline = false,
    int flex = 1,
    NonnullFormFieldSetter<List<T>>? onSaved,
  }) {
    assert(flex != 0, 'selector flex can not be zero!');
    _lastRow.append(
      SelectorFormField<T>(
        selectItemProvider,
        onChanged: onChanged,
        labelText: labelText,
        hintText: hintText,
        clearable: clearable,
        validator: validator,
        autovalidateMode: autovalidateMode,
        multi: multi,
        initialValue: initialValue,
        selectItemRender: selectItemRender,
        selectedItemRender: selectedItemRender,
        selectedSorter: selectedSorter,
        onTap: onTap,
        selectedItemLayoutType: selectedItemLayoutType,
        queryFormBuilder: queryFormBuilder,
        onSelectDialogShow: onSelectDialogShow,
        inputDecorationTheme: inputDecorationTheme,
        onSaved: onSaved,
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
      ),
    );
    return this;
  }

  FormBuilder switchGroup({
    String? name,
    String? labelText,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    required List<SwitchGroupItem> items,
    bool hasSelectAllSwitch = true,
    ValueChanged<List<int>>? onChanged,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    List<int>? initialValue,
    EdgeInsets? selectAllPadding,
    bool inline = false,
    int flex = 1,
    NonnullFormFieldSetter<List<int>>? onSaved,
  }) {
    _lastRow.append(
      SwitchGroupFormField(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        labelText: labelText,
        items: items,
        hasSelectAllSwitch: hasSelectAllSwitch,
        validator: validator,
        autovalidateMode: autovalidateMode,
        initialValue: initialValue,
        onChanged: onChanged,
        onSaved: onSaved,
      ),
    );
    return this;
  }

  FormBuilder switchInline({
    String? name,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    int flex = 0,
    ValueChanged<bool>? onChanged,
    NonnullFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    NonnullFormFieldSetter<bool>? onSaved,
  }) {
    _lastRow.append(
      SwitchInlineFormField(
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          validator: validator,
          autovalidateMode: autovalidateMode,
          onChanged: onChanged,
          initialValue: initialValue,
          onSaved: onSaved),
    );
    return this;
  }

  FormBuilder slider({
    String? name,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    ValueChanged<num>? onChanged,
    NonnullFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    required double min,
    required double max,
    int? divisions,
    String? labelText,
    SubLabelRender? subLabelRender,
    int flex = 1,
    NonnullFormFieldSetter<num>? onSaved,
    EdgeInsets? labelPadding,
  }) {
    assert(flex != 0, 'textfield flex can not be zero!');
    _lastRow.append(
      SliderFormField(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        validator: validator,
        min: min,
        max: max,
        labelText: labelText,
        divisions: divisions,
        initialValue: initialValue ?? min,
        subLabelRender: subLabelRender,
        onSaved: onSaved,
      ),
    );
    return this;
  }

  FormBuilder rangeSlider({
    String? name,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    ValueChanged<RangeValues>? onChanged,
    NonnullFieldValidator<RangeValues>? validator,
    AutovalidateMode? autovalidateMode,
    RangeValues? initialValue,
    required double min,
    required double max,
    int? divisions,
    RangeSubLabelRender? rangeSubLabelRender,
    NonnullFormFieldSetter<RangeValues>? onSaved,
    int flex = 1,
    String? labelText,
  }) {
    assert(flex != 0, 'rangeSlider flex can not be zero!');
    _lastRow.append(
      RangeSliderFormField(
        visible: visible,
        readOnly: readOnly,
        flex: flex,
        padding: padding,
        name: name,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        validator: validator,
        min: min,
        max: max,
        labelText: labelText,
        divisions: divisions,
        initialValue: initialValue ?? RangeValues(min, max),
        rangeSubLabelRender: rangeSubLabelRender,
        onSaved: onSaved,
      ),
    );
    return this;
  }

  FormBuilder filterChip<T>({
    required List<FilterChipItem<T>> items,
    List<T>? initialValue,
    AutovalidateMode? autovalidateMode,
    NonnullFieldValidator<List<T>>? validator,
    ValueChanged<List<T>>? onChanged,
    double? pressElevation,
    String? name,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    NonnullFormFieldSetter<List<T>>? onSaved,
    int flex = 1,
    int? count,
    VoidCallback? exceedCallback,
    ChipLayoutType layoutType = ChipLayoutType.wrap,
    String? labelText,
  }) {
    _lastRow.append(FilterChipFormField(
      count: count,
      exceedCallback: exceedCallback,
      labelText: labelText,
      visible: visible,
      readOnly: readOnly,
      flex: flex,
      padding: padding,
      name: name,
      items: items,
      initialValue: initialValue,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onChanged: onChanged,
      pressElevation: pressElevation,
      onSaved: onSaved,
      layoutType: layoutType,
    ));
    return this;
  }

  FormBuilder field({
    required Widget field,
  }) {
    _lastRow.append(field);
    return this;
  }

  FormBuilder builder(FieldBuilder builder) {
    _lastRow.append(Builder(
      builder: (context) {
        BuilderInfo info = BuilderInfo.of(context);
        return builder(info, context);
      },
    ));
    return this;
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
  _FormModel(Map<String, StateValue> value, this.enableLayoutManagement,
      this.onChanged)
      : super(value);

  FormLayout get formLayout => getState('formLayout');
  set formLayout(FormLayout formLayout) => update1('formLayout', formLayout);

  bool get visible => getState('visible');
  set visible(bool visible) => update1('visible', visible);

  bool get readOnly => getState('readOnly');
  set readOnly(bool readOnly) => update1('readOnly', readOnly);
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
    _FormModel model = _ResourceManagement.of(context).formModel!;
    return _InheritedFieldInfo(
        FieldInfo._(widget.position, model.readOnly), widget.child);
  }
}

/// used to register|unregister|lookup resources
class _ResourceManagement {
  final GlobalKey key = GlobalKey(); //form key !
  final List<ValueFieldState> valueFieldStateList = [];
  final List<AbstractFieldStateModel> fieldModelList = [];
  _FormModel? formModel;
  final List<TextSelectionManagement> textSelectionManagementList = [];
  final List<FocusNodes> focusNodesList = [];
  final Map<int, Key> keys = {};

  Key registerGlobalKey(int index) {
    return keys.putIfAbsent(index, () => GlobalKey());
  }

  void unregisterGlobalKeys(List<int> used) {
    keys.removeWhere((key, value) => !used.contains(key));
  }

  void registerValueFieldState(ValueFieldState state) {
    valueFieldStateList.add(state);
  }

  void unregisterValueFieldState(ValueFieldState state) {
    valueFieldStateList.remove(state);
  }

  void registerFormModel(_FormModel formModel) {
    this.formModel = formModel;
  }

  void unregisterFormModel(_FormModel formModel) {
    if (this.formModel == formModel) {
      this.formModel!.dispose();
      this.formModel = null;
    } else
      formModel.dispose();
  }

  void registerFieldModel(AbstractFieldStateModel model) {
    fieldModelList.add(model);
  }

  void unregisterFieldModel(AbstractFieldStateModel model) {
    fieldModelList.remove(model);
  }

  void registerTextSelectionManagement(TextSelectionManagement management) {
    textSelectionManagementList.add(management);
  }

  void unregisterTextSelectionManagement(TextSelectionManagement management) {
    textSelectionManagementList.remove(management);
  }

  void registerFocusNode(FocusNodes focusNodes) {
    focusNodesList.add(focusNodes);
  }

  void unregisterFocusNode(FocusNodes focusNodes) {
    focusNodesList.remove(focusNodes);
    focusNodes.dispose();
  }

  static _ResourceManagement of(BuildContext context) {
    return _FormData.of(context).data;
  }

  AbstractFieldStateModel? getFieldModel(String name) {
    Iterable<AbstractFieldStateModel> models =
        fieldModelList.where((element) => element.name == name);
    return models.isEmpty ? null : models.first;
  }

  ValueFieldState? getValueFieldState(String name) {
    Iterable<ValueFieldState> states =
        valueFieldStateList.where((element) => element.name == name);
    if (states.isEmpty) return null;
    return states.first;
  }

  TextSelectionManagement? getTextSelectionManagement(String name) {
    Iterable<TextSelectionManagement> managements =
        textSelectionManagementList.where((element) => element.name == name);
    if (managements.isEmpty) return null;
    return managements.first;
  }

  FocusNodes? getFocusNodes(String name) {
    Iterable<FocusNodes> nodes =
        focusNodesList.where((element) => element.name == name);
    if (nodes.isEmpty) return null;
    return nodes.first;
  }

  Iterable<AbstractFieldStateModel> getFieldModels(int row, int? column) {
    return fieldModelList.where((element) {
      if (element.position.row == row) {
        if (column != null) return column == element.position.column;
        return true;
      }
      return false;
    });
  }

  bool hasName(String name) =>
      fieldModelList.where((element) => element.name == name).isNotEmpty;

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
  FormFieldManagement newFormFieldManagement(String name) =>
      FormFieldManagement._(name, _resourceManagement);

  /// create a form position management used to control visible|readOnly state of all
  /// fields at this position
  FormPositionManagement newFormPositionManagement(int row, {int? column}) =>
      FormPositionManagement._(_resourceManagement, row, column: column);

  /// create a form layout management used to modify layout of form
  ///
  /// **@experimental**
  FormLayoutManagement newFormLayoutManagement() =>
      FormLayoutManagement._(_resourceManagement);

  /// get form data
  ///
  /// if a value field doesn't has a name state,it's value will be ignored
  Map<String, dynamic> get data {
    Map<String, dynamic> map = {};
    _valueFieldStateList.forEach((element) {
      String? name = element.name;
      if (name == null) return;
      dynamic value = element.value;
      map[name] = value;
    });
    return map;
  }

  /// equals to setData(data,trigger:true)
  set data(Map<String, dynamic> data) => setData(data);

  /// set form data
  ///
  /// [trigger] whether trigger onChanged
  void setData(Map<String, dynamic> data, {bool trigger = true}) {
    if (data.isEmpty) return;
    data.map((key, value) => MapEntry(key, value)).forEach((key, value) {
      _valueFieldStateList
          .firstWhere((element) => element.name == key)
          .doChangeValue(value, trigger: trigger);
    });
  }

  /// reset form
  ///
  /// **only reset all value fields**
  void reset() {
    _valueFieldStateList.forEach((element) {
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
    for (final FormFieldState<dynamic> field in _valueFieldStateList)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  /// whether form is valid
  ///
  /// **only check is valid or not , won't show error**
  bool get isValid {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in _valueFieldStateList)
      hasError = !field.isValid || hasError;
    return !hasError;
  }

  /// save all form fields
  ///
  /// form field's onSaved will be  called
  void onSaved() {
    for (final FormFieldState<dynamic> field in _valueFieldStateList)
      field.save();
  }

  /// get  invalidate error msgs
  ///
  /// key is name ,value is error message
  ///
  /// if a value field doesn't has a name state,it's error will be ignored
  Map<String, String> get error {
    Map<String, String> errorMap = {};
    _valueFieldStateList.forEach((element) {
      String? error = element.errorText;
      String? name = element.name;
      if (error != null && name != null) errorMap[element.name!] = error;
    });
    return errorMap;
  }

  /// get current formManagement from context
  ///
  /// **context must be child context of FormBuilder**
  ///
  /// ```
  /// field(child:Builder(builder:(context){
  ///   //ok to call FormManagement.of(context)
  /// }))
  /// ```
  static FormManagement of(BuildContext context) =>
      FormManagement._(_ResourceManagement.of(context));

  _FormModel get _formModel => _resourceManagement.formModel!;
  List<ValueFieldState> get _valueFieldStateList =>
      _resourceManagement.valueFieldStateList;
}

/// a field management used to control field
class FormFieldManagement {
  final String name;
  final _ResourceManagement _resourceManagement;

  FormFieldManagement._(this.name, this._resourceManagement);

  /// get field's position
  Position get position => _fieldModel.position;

  /// get  field's visible state
  bool get visible => _fieldModel.visible;

  /// set visible of field,it's equals to update1('visible',visible)
  set visible(bool visible) => _fieldModel.visible = visible;

  /// get  field's readOnly state,equals to getState<bool>('readOnly')!
  bool get readOnly => _fieldModel.readOnly;

  /// set readOnly on field,it's equals to update1('readOnly',readOnly)
  set readOnly(bool readOnly) => _fieldModel.readOnly = readOnly;

  // whether field support focus
  bool get focusable => _focusNode != null && _focusNode!.canRequestFocus;

  // whether field is focused
  bool get hasFocus {
    if (_focusNode == null) throw 'field don\'t has a focusnode!';
    return _focusNode!.hasFocus;
  }

  /// focus|unfocus field
  ///
  /// if field is not focusable ,an error will be throw
  set focus(bool focus) {
    if (!focusable) {
      throw 'field is not focusable';
    }
    if (focus && !hasFocus) _focusNode!.requestFocus();
    if (!focus && hasFocus) _focusNode!.unfocus();
  }

  /// set focus listener on field
  ///
  /// if field does not has a focusnode ,an error will be throw
  set focusListener(FocusListener? listener) {
    if (_focusNode == null) throw 'field don\'t has a focusnode!';
    _focusNode!.focusListener = listener;
  }

  /// if current value is valuefield return a [ValueFormFieldManagement] otherwise throw a exception
  ValueFieldManagement get valueFieldManagement =>
      ValueFieldManagement._(name, _resourceManagement);

  /// whether field is value field
  bool get isValueField => _state != null;

  /// whether field support textselection
  bool get supportTextSelection => _textSelectionManagement != null;

  /// if field support textselection return management,
  /// otherwise throw an exception
  TextSelectionManagement get textSelectionManagement {
    if (!supportTextSelection)
      throw 'current field don\'t support TextSelectionManagement';
    return _textSelectionManagement!;
  }

  /// update state for a field
  void update(Map<String, dynamic> state) => _fieldModel.update(state);

  /// update one state for a field,equals to update({key:value})
  void update1(String key, dynamic value) => _fieldModel.update({key: value});

  AbstractFieldStateModel get _fieldModel {
    AbstractFieldStateModel? model = _resourceManagement.getFieldModel(name);
    if (model == null) throw 'no field can be found by name :$name';
    return model;
  }

  ValueFieldState? get _state => _resourceManagement.getValueFieldState(name);
  TextSelectionManagement? get _textSelectionManagement =>
      _resourceManagement.getTextSelectionManagement(name);
  FocusNodes? get _focusNode => _resourceManagement.getFocusNodes(name);
}

class FormPositionManagement {
  final int row;
  final int? column;
  final _ResourceManagement _resourceManagement;
  FormPositionManagement._(this._resourceManagement, this.row, {this.column});

  ///whether  all fields is readOnly
  bool get readOnly => _models.every((element) => element.readOnly);

  /// whether at least one field is visible
  bool get visible => _models.any((element) => element.visible);

  /// set readOnly on all fields at this position
  set readOnly(bool readOnly) => _models.forEach((element) {
        element.readOnly = readOnly;
      });

  /// set visible on all fields at this position
  set visible(bool visible) => _models.forEach((element) {
        element.visible = visible;
      });

  Iterable<AbstractFieldStateModel> get _models {
    Iterable<AbstractFieldStateModel> models =
        _resourceManagement.getFieldModels(row, column);
    if (models.isEmpty)
      throw 'no fields can be found at position row:$row column: $column';
    return models;
  }
}

class ValueFieldManagement {
  final String name;
  final _ResourceManagement _resourceManagement;

  ValueFieldManagement._(this.name, this._resourceManagement);

  /// get current value of valuefield
  dynamic get value => _valueFieldState.value;

  /// set newValue on valuefield,this method will trigger onChanged listener
  /// if you do not trigger it,you can use setValue method
  set value(dynamic value) =>
      _valueFieldState.doChangeValue(value, trigger: true);

  /// set newValue on valuefield,if trigger is false,won't trigger onChanged listener
  void setValue(dynamic value, {bool trigger: true}) =>
      _valueFieldState.doChangeValue(value, trigger: trigger);

  /// whether value field is valid,this method won't display error msg
  /// if you want to show error msg,use validate instead
  bool get isValid => _valueFieldState.isValid;

  /// validate value field ,return whether field is valid or not
  /// this message will show error msg,you can use isValid instead if you don't want show error msg
  bool validate() => _valueFieldState.validate();

  /// reset valuefield,will set value to initialValue
  /// also clear error msg
  void reset() => _valueFieldState.reset();

  /// get error message
  String? get error => _valueFieldState.errorText;

  ValueFieldState get _valueFieldState {
    ValueFieldState? state = _resourceManagement.getValueFieldState(name);
    if (state == null) throw 'current field is not value field!';
    return state;
  }
}

/// used to modify layout of form
///
/// **you should use it when you  really need modify form layout at runtime**
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

  _FormModel get _formModel => _resourceManagement.formModel!;
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

  late AbstractFieldStateModel model;
  late FieldInfo fieldInfo;

  FocusNodes? _focusNode;

  String? get name => (widget as StatefulField).name;

  /// get row of field
  int get row => position.row;

  /// get column of field
  int get column => position.column;

  /// whether field is readOnly
  bool get readOnly => _resourceManagement.formModel!.readOnly;

  Position get position => fieldInfo.position;

  bool get init => _init;

  ThemeData get themeData => Theme.of(context);

  TextSelectionManagement? _textSelectionManagement;

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  FocusNodes get focusNode {
    if (_focusNode == null) {
      _focusNode = FocusNodes(name);
      _resourceManagement.registerFocusNode(_focusNode!);
    }
    return _focusNode!;
  }

  @protected
  void didChangeDependencies() {
    super.didChangeDependencies();
    fieldInfo = FieldInfo.of(context);
    if (_init) return;
    _init = true;
    _resourceManagement = _ResourceManagement.of(context);
    if (this is TextSelectionManagement && name != null) {
      _textSelectionManagement = this as TextSelectionManagement;
      _resourceManagement
          .registerTextSelectionManagement(_textSelectionManagement!);
    }
    model = createModel();
    _resourceManagement.registerFieldModel(model);
    initFormManagement();
  }

  /// this method will be called immediately after initState
  /// and will only be called once during state lifecycle
  ///
  /// **you should call getState in this method , not in initState!**
  @protected
  @mustCallSuper
  void initFormManagement() {}

  @protected
  void dispose() {
    if (_textSelectionManagement != null) {
      _resourceManagement
          .registerTextSelectionManagement(_textSelectionManagement!);
    }
    _resourceManagement.unregisterFieldModel(model);
    if (_focusNode != null)
      _resourceManagement.unregisterFocusNode(_focusNode!);
    super.dispose();
  }

  AbstractFieldStateModel createModel();
}

abstract class ValueFieldState<T> extends FormFieldState<T>
    with AbstractFieldState<FormField<T>> {
  ValueChanged<T?>? get onChanged =>
      (super.widget as ValueField<T, ValueFieldState>).onChanged;

  @override
  void didChange(T? value) {
    doChangeValue(value);
  }

  void doChangeValue(T? newValue, {bool trigger = true}) {
    if (!compare(value, newValue)) {
      try {
        _didChange(newValue, trigger);
      } finally {
        super.didChange(newValue);
      }
    }
    _focusNode?.requestFocus();
  }

  @override
  void reset() {
    try {
      if (!compare(value, widget.initialValue)) {
        _didChange(widget.initialValue, true);
      }
    } finally {
      super.reset();
    }
  }

  @override
  void initFormManagement() {
    super.initFormManagement();
    _resourceManagement.registerValueFieldState(this);
  }

  @override
  void dispose() {
    _resourceManagement.unregisterValueFieldState(this);
    super.dispose();
  }

  @protected
  bool compare(T? a, T? b) {
    return FormBuilderUtils.compare(a, b);
  }

  _didChange(T? current, bool trigger) {
    if (trigger) {
      ValueChanged<T?>? onChanged =
          (super.widget as ValueField<T, ValueFieldState>).onChanged;
      if (onChanged != null) onChanged(current);
    }
    if (name != null) {
      FormValueChanged? formValueChanged =
          _resourceManagement.formModel!.onChanged;
      if (formValueChanged != null) {
        formValueChanged(name!, current);
      }
    }
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
