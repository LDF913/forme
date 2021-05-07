import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'field/filter_chip.dart';
import 'focus_node.dart';
import 'form_builder_utils.dart';
import 'form_field.dart';
import 'form_key.dart';
import 'field/selector.dart';
import 'field/switch_group.dart';
import 'field/checkbox_group.dart';
import 'form_layout.dart';
import 'form_theme.dart';
import 'field/text_field.dart';
import 'field/radio_group.dart';
import 'field/slider.dart';
import 'state_model.dart';
import 'text_selection.dart';

class FormBuilder extends StatefulWidget {
  final FormManagement formManagement;
  final bool readOnly;
  final bool visible;
  final FormThemeData formThemeData;
  final bool enableLayoutManagement;
  final FormLayout _formLayout;

  FormBuilder({
    this.readOnly = false,
    this.visible = true,
    FormThemeData? formThemeData,
    this.enableLayoutManagement = false,
    required this.formManagement,
  })   : this._formLayout = FormLayout(),
        this.formThemeData = formThemeData ?? FormThemeData.defaultTheme,
        super(key: formManagement._resourceManagement.key);

  FormBuilder nextLine() {
    _formLayout.lastEmptyRow();
    return this;
  }

  /// append a number field to current row
  FormBuilder numberField(
      {String? name,
      int? flex,
      String? hintText,
      String? labelText,
      EdgeInsets? padding,
      VoidCallback? onTap,
      Widget? prefixIcon,
      ValueChanged<num?>? onChanged,
      FormFieldValidator<num>? validator,
      AutovalidateMode? autovalidateMode,
      double? min,
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
      FormFieldSetter<num>? onSaved}) {
    _formLayout.lastStretchableRow().append(FormBuilderFieldBuilder(
        visible: visible,
        name: name,
        flex: flex,
        inline: true,
        readOnly: readOnly,
        padding: padding,
        child: NumberFormField(
            autofocus: autofocus,
            onChanged: onChanged,
            decimal: decimal,
            min: min,
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
            onSaved: onSaved)));
    return this;
  }

  /// add a textfield to current row
  FormBuilder textField({
    String? name,
    String? hintText,
    String? labelText,
    VoidCallback? onTap,
    bool obscureText = false,
    int? flex,
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
    _formLayout.lastStretchableRow().append(FormBuilderFieldBuilder(
        visible: visible,
        name: name,
        flex: flex,
        inline: true,
        readOnly: readOnly,
        padding: padding,
        child: ClearableTextFormField(
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
            onSaved: onSaved)));
    return this;
  }

  /// add a radio group
  ///
  /// if inline is false,it will be added to current row
  /// otherwise it will be placed in a new row
  FormBuilder radioGroup<T>({
    required List<RadioGroupItem<T>> items,
    String? name,
    String? label,
    ValueChanged<T?>? onChanged,
    bool readOnly = false,
    bool visible = true,
    FormFieldValidator? validator,
    AutovalidateMode? autovalidateMode,
    int split = 2,
    EdgeInsets? padding,
    dynamic? initialValue,
    bool inline = false,
    int? flex = 0,
    EdgeInsets? errorTextPadding,
    FormFieldSetter<T>? onSaved,
  }) {
    FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(FormBuilderFieldBuilder(
      visible: visible,
      name: name,
      flex: inline ? flex : 1,
      inline: inline,
      readOnly: readOnly,
      padding: padding,
      child: RadioGroupFormField<T>(
        label: label,
        items: List.of(items),
        validator: validator,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        split: split,
        initialValue: initialValue,
        errorTextPadding: errorTextPadding,
        onSaved: onSaved,
      ),
    ));
    return this;
  }

  FormBuilder checkboxGroup({
    required List<CheckboxGroupItem> items,
    String? name,
    String? label,
    ValueChanged<List<int>>? onChanged,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    bool readOnly = false,
    bool visible = true,
    int split = 2,
    int? flex = 0,
    EdgeInsets? padding,
    List<int>? initialValue,
    EdgeInsets? errorTextPadding,
    bool inline = false,
    NonnullFormFieldSetter<List<int>>? onSaved,
  }) {
    FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(FormBuilderFieldBuilder(
      visible: visible,
      name: name,
      inline: inline,
      readOnly: readOnly,
      flex: inline ? flex : 1,
      padding: padding,
      child: CheckboxGroupFormField(
        items: List.of(items),
        errorTextPadding: errorTextPadding,
        label: label,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        split: split,
        initialValue: initialValue,
        onSaved: onSaved,
      ),
    ));
    return this;
  }

  FormBuilder textButton({
    String? name,
    String? label,
    Widget? child,
    int? flex = 0,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
  }) {
    _formLayout.lastStretchableRow().append(
          FormBuilderFieldBuilder(
              visible: visible,
              name: name,
              flex: flex,
              inline: true,
              padding: padding,
              child: BaseCommonField(
                {
                  'label': StateValue<String?>(label),
                  'child': StateValue<Widget?>(child),
                },
                builder: (state) {
                  Map<String, dynamic> stateMap = state.currentMap;
                  Widget child = stateMap['child'] ?? Text(stateMap['label']);
                  return TextButton(
                      onPressed: readOnly ? null : onPressed,
                      onLongPress: readOnly ? null : onLongPress,
                      child: child);
                },
              )),
        );
    return this;
  }

  FormBuilder datetimeField({
    String? name,
    String? labelText,
    String? hintText,
    bool readOnly = false,
    bool visible = true,
    int? flex,
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
  }) {
    _formLayout.lastStretchableRow().append(
          FormBuilderFieldBuilder(
              visible: visible,
              inline: true,
              name: name,
              padding: padding,
              flex: flex,
              child: DateTimeFormField(
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
                  onSaved: onSaved)),
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
    int? flex,
    NonnullFormFieldSetter<List<T>>? onSaved,
  }) {
    FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(
      FormBuilderFieldBuilder(
          visible: visible,
          name: name,
          flex: inline ? flex : 1,
          inline: inline,
          readOnly: readOnly,
          padding: padding,
          child: SelectorFormField<T>(selectItemProvider,
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
              onSaved: onSaved)),
    );
    return this;
  }

  FormBuilder divider({
    String? name,
    double? height,
    bool visible = true,
    EdgeInsets? padding = const EdgeInsets.symmetric(horizontal: 5),
  }) {
    FormRow row = _formLayout.lastEmptyRow();
    row.append(FormBuilderFieldBuilder(
      visible: visible,
      name: name,
      flex: 1,
      inline: false,
      padding: padding,
      readOnly: true,
      child: BaseCommonField(
        {'height': StateValue<double>(height ?? 1.0)},
        builder: (state) {
          return Divider(
            height: state.currentMap['height'],
          );
        },
      ),
    ));
    return this;
  }

  FormBuilder switchGroup({
    String? name,
    String? label,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    required List<SwitchGroupItem> items,
    bool hasSelectAllSwitch = true,
    ValueChanged<List<int>>? onChanged,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    List<int>? initialValue,
    EdgeInsets? errorTextPadding,
    EdgeInsets? selectAllPadding,
    bool inline = false,
    int? flex,
    NonnullFormFieldSetter<List<int>>? onSaved,
  }) {
    FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(FormBuilderFieldBuilder(
      visible: visible,
      name: name,
      flex: inline ? flex : 1,
      padding: padding,
      inline: inline,
      readOnly: readOnly,
      child: SwitchGroupFormField(
        label: label,
        items: items,
        hasSelectAllSwitch: hasSelectAllSwitch,
        validator: validator,
        autovalidateMode: autovalidateMode,
        initialValue: initialValue,
        onChanged: onChanged,
        errorTextPadding: errorTextPadding,
        selectAllPadding: selectAllPadding,
        onSaved: onSaved,
      ),
    ));
    return this;
  }

  FormBuilder switchInline({
    String? name,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    int? flex = 0,
    ValueChanged<bool>? onChanged,
    NonnullFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    NonnullFormFieldSetter<bool>? onSaved,
  }) {
    _formLayout.lastStretchableRow().append(FormBuilderFieldBuilder(
          visible: visible,
          name: name,
          padding: padding,
          flex: flex,
          inline: true,
          readOnly: readOnly,
          child: SwitchInlineFormField(
              validator: validator,
              autovalidateMode: autovalidateMode,
              onChanged: onChanged,
              initialValue: initialValue,
              onSaved: onSaved),
        ));
    return this;
  }

  FormBuilder slider({
    String? name,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    ValueChanged<double>? onChanged,
    NonnullFieldValidator<double>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    required double min,
    required double max,
    int? divisions,
    String? label,
    SubLabelRender? subLabelRender,
    EdgeInsets? contentPadding,
    bool inline = false,
    int? flex,
    NonnullFormFieldSetter<double>? onSaved,
  }) {
    FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(FormBuilderFieldBuilder(
      visible: visible,
      name: name,
      flex: inline ? flex : 1,
      padding: padding,
      inline: inline,
      readOnly: readOnly,
      child: SliderFormField(
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        validator: validator,
        min: min,
        max: max,
        label: label,
        divisions: divisions,
        initialValue: initialValue ?? min,
        subLabelRender: subLabelRender,
        contentPadding: contentPadding,
        onSaved: onSaved,
      ),
    ));
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
    String? label,
    RangeSubLabelRender? rangeSubLabelRender,
    EdgeInsets? contentPadding,
    bool inline = false,
    NonnullFormFieldSetter<RangeValues>? onSaved,
  }) {
    FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(FormBuilderFieldBuilder(
      visible: visible,
      name: name,
      flex: 1,
      inline: inline,
      readOnly: readOnly,
      padding: padding,
      child: RangeSliderFormField(
          autovalidateMode: autovalidateMode,
          onChanged: onChanged,
          validator: validator,
          min: min,
          max: max,
          label: inline ? null : label,
          divisions: divisions,
          initialValue: initialValue ?? RangeValues(min, max),
          rangeSubLabelRender: rangeSubLabelRender,
          contentPadding: contentPadding,
          onSaved: onSaved),
    ));
    return this;
  }

  FormBuilder filterChip<T>({
    required List<FilterChipItem<T>> items,
    List<T>? initialValue,
    AutovalidateMode? autovalidateMode,
    NonnullFieldValidator<List<T>>? validator,
    ValueChanged<List<T>>? onChanged,
    double? pressElevation,
    String? label,
    EdgeInsets? errorTextPadding,
    String? name,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    NonnullFormFieldSetter<List<T>>? onSaved,
  }) {
    FormRow row = _formLayout.lastEmptyRow();
    row.append(FormBuilderFieldBuilder(
        visible: visible,
        name: name,
        flex: 1,
        inline: false,
        readOnly: readOnly,
        padding: padding,
        child: FilterChipFormField(
            items: items,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            validator: validator,
            onChanged: onChanged,
            pressElevation: pressElevation,
            label: label,
            errorTextPadding: errorTextPadding,
            onSaved: onSaved)));
    return this;
  }

  FormBuilder field({
    String? name,
    int flex = 1,
    bool visible = true,
    EdgeInsets? padding,
    bool inline = false,
    bool readOnly = false,
    required Widget field,
  }) {
    FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(
      FormBuilderFieldBuilder(
          visible: visible,
          name: name,
          flex: flex,
          inline: inline,
          padding: padding,
          readOnly: readOnly,
          child: field),
    );
    return this;
  }

  @override
  State<StatefulWidget> createState() => _FormBuilderState();
}

class _FormData extends InheritedWidget {
  final _ResourceManagement data;
  final bool readOnly;
  final FormThemeData formThemeData;

  _FormData(this.data, this.readOnly, this.formThemeData,
      {required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant _FormData oldWidget) {
    return readOnly != oldWidget.readOnly ||
        formThemeData != oldWidget.formThemeData;
  }
}

class _FormBuilderState extends State<FormBuilder> {
  late final _ResourceManagement resourceManagement;
  late FormModel model;

  @override
  void initState() {
    super.initState();
    resourceManagement = widget.formManagement._resourceManagement;
    model = FormModel(getInitStateMap(widget), widget.enableLayoutManagement);
    model.addListener(() {
      setState(() {});
    });
    resourceManagement.registerFormModel(model);
  }

  @override
  void didUpdateWidget(FormBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    model.updateInitStateMap(
        getInitStateMap(oldWidget), getInitStateMap(widget));
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
    FormThemeData formThemeData = model.formThemeData;
    bool visible = model.visible;

    formLayout.removeEmptyRow();
    Set<String> names = {};
    List<Row> rows = [];
    int row = 0;
    for (FormRow formRow in formLayout.rows) {
      List<_FormBuilderField> children = [];
      int column = 0;
      for (FormBuilderFieldBuilder builder in formRow.builders) {
        Key? key;
        String? name = builder.name;
        if (name == null) {
          if (model.rebuildLayout) {
            key = UniqueKey();
          }
        } else {
          key = resourceManagement.newFieldKey(name);
          if (names.contains(name)) throw 'name must unique in a form';
          names.add(name);
        }
        children.add(_FormBuilderField(builder, key, row, column));
        column++;
      }
      rows.add(Row(
        children: children,
      ));
      row++;
    }
    names.clear();
    model.rebuildLayout = false;
    return Theme(
        data: formThemeData.themeData,
        child: Visibility(
            visible: visible,
            maintainState: true,
            child: _FormData(
              resourceManagement,
              model.readOnly,
              model.formThemeData,
              child: Column(
                children: rows,
              ),
            )));
  }

  Map<String, StateValue> getInitStateMap(FormBuilder widget) {
    return {
      'formLayout': StateValue<FormLayout>(widget._formLayout),
      'formThemeData': StateValue<FormThemeData>(widget.formThemeData),
      'visible': StateValue<bool>(widget.visible),
      'readOnly': StateValue<bool>(widget.readOnly),
    };
  }
}

class FieldInfo {
  final FieldKey fieldKey;
  final bool inline;
  final int flex;
  final int gen;
  final bool readOnly;

  FieldInfo._(this.fieldKey, this.inline, FormBuilderFieldModel model)
      : this.flex = model.flex,
        this.gen = model.gen,
        this.readOnly = model.readOnly;

  bool operator ==(Object other) =>
      (other is FieldInfo) &&
      other.fieldKey.name == fieldKey.name &&
      other.fieldKey.row == fieldKey.row &&
      other.fieldKey.column == fieldKey.column &&
      other.inline == inline &&
      other.gen == gen;

  @override
  int get hashCode => hashValues(fieldKey, inline, gen);

  static FieldInfo of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFieldInfo>()!
        .fieldInfo;
  }
}

class InheritedFieldInfo extends InheritedWidget {
  final FieldInfo fieldInfo;

  InheritedFieldInfo(this.fieldInfo, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedFieldInfo oldWidget) {
    return fieldInfo != oldWidget.fieldInfo;
  }
}

class _FormBuilderField extends StatefulWidget {
  final Widget child;
  final FieldKey fieldKey;
  final bool inline;
  final FormBuilderFieldBuilder builder;
  final bool readOnly;
  final bool visible;
  final int flex;
  final EdgeInsets? padding;
  _FormBuilderField(this.builder, Key? key, int row, int column)
      : this.child = builder.child,
        this.inline = builder.inline,
        this.fieldKey = FieldKey(column: column, row: row, name: builder.name),
        this.readOnly = builder.readOnly,
        this.visible = builder.visible,
        this.flex = builder.flex,
        this.padding = builder.padding,
        super(key: key);
  @override
  State<StatefulWidget> createState() => _FormBuilderFieldState();
}

class _FormBuilderFieldState extends State<_FormBuilderField> {
  bool _init = false;

  late final _ResourceManagement resourceManagement;
  late FormBuilderFieldModel model;

  @override
  void didUpdateWidget(_FormBuilderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    model.updateInitStateMap(
        getInitStateMap(oldWidget), getInitStateMap(widget));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    resourceManagement = _ResourceManagement.of(context);
    model = FormBuilderFieldModel(widget.fieldKey, getInitStateMap(widget));
    model.addListener(() {
      setState(() {});
    });
    resourceManagement.registerFormBuilderFieldMode(model);
  }

  @override
  void dispose() {
    resourceManagement.unregisterFormBuilderFieldMode(model);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool visible = model.visible;
    EdgeInsets padding = model.padding ??
        resourceManagement.formModel.formThemeData.padding ??
        EdgeInsets.zero;
    int flex = model.flex;
    Widget child = Visibility(
        maintainState: true,
        visible: visible,
        child: Padding(
          padding: padding,
          child: widget.child,
        ));
    return InheritedFieldInfo(
      FieldInfo._(widget.fieldKey, widget.inline, model),
      Flexible(
        fit: visible ? FlexFit.tight : FlexFit.loose,
        child: child,
        flex: flex,
      ),
    );
  }

  Map<String, StateValue> getInitStateMap(_FormBuilderField widget) {
    return {
      'flex': StateValue<int>(widget.flex),
      'padding': StateValue<EdgeInsets?>(widget.padding),
      'visible': StateValue<bool>(widget.visible),
      'readOnly': StateValue<bool>(widget.readOnly),
    };
  }
}

class FormBuilderFieldBuilder {
  final String? name;
  final int flex;
  final bool visible;
  final Widget child;
  final EdgeInsets? padding;
  final bool inline;
  final bool readOnly;
  FormBuilderFieldBuilder(
      {bool? visible,
      this.name,
      int? flex,
      required this.child,
      EdgeInsets? padding,
      bool? inline,
      this.readOnly = false})
      : this.visible = visible ?? true,
        this.flex = flex ?? 1,
        this.padding = padding,
        this.inline = inline ?? false;
}

/// used to register|unregister|lookup resources
class _ResourceManagement {
  final GlobalKey key = GlobalKey(); //form key !
  final List<ValueFieldState> valueFieldStateList = [];
  final List<FormBuilderFieldModel> builderFieldModelList = [];
  final List<AbstractFieldStateModel> fieldModelList = [];
  final List<FormModel> formModels = [];
  final Map<String, Key> mappings = {};
  final List<TextSelectionManagement> textSelectionManagementList = [];
  final List<FocusNodes> focusNodesList = [];

  void registerValueFieldState(ValueFieldState state) {
    valueFieldStateList.add(state);
  }

  void unregisterValueFieldState(ValueFieldState state) {
    valueFieldStateList.remove(state);
  }

  void registerFormModel(FormModel formModel) {
    formModels.add(formModel);
  }

  void unregisterFormModel(FormModel formModel) {
    if (formModels.remove(formModel)) formModel.dispose();
  }

  void registerFormBuilderFieldMode(FormBuilderFieldModel model) {
    builderFieldModelList.add(model);
  }

  void unregisterFormBuilderFieldMode(FormBuilderFieldModel model) {
    if (builderFieldModelList.remove(model)) model.dispose();
  }

  void registerFieldModel(AbstractFieldStateModel model) {
    fieldModelList.add(model);
  }

  void unregisterFieldModel(AbstractFieldStateModel model) {
    if (fieldModelList.remove(model)) model.dispose();
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
    if (focusNodesList.remove(focusNodes)) focusNodes.dispose();
  }

  Key newFieldKey(String name) {
    bool useGlobalKey = formModel.enableLayoutManagement;
    return mappings.putIfAbsent(
        name, () => useGlobalKey ? GlobalKey() : UniqueKey());
  }

  void dispose() {
    mappings.clear();
    // we don't clear and dispose models|states here
    // let State do that
    if (kDebugMode) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        assert(builderFieldModelList.isEmpty,
            'FormBuilderFieldModel is not all disposed, may cause a memory leak');
        assert(fieldModelList.isEmpty,
            'FieldModel is not all disposed, may cause a memory leak');
        assert(valueFieldStateList.isEmpty,
            'ValueFieldState is not all disposed,may cause a memory leaks');
        assert(formModels.isEmpty,
            'FormModel is not all disposed, may cause a memory leak');
      });
    }
  }

  static _ResourceManagement of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormData>()!.data;
  }

  FormModel get formModel => formModels.first;

  Iterable<FormBuilderFieldModel> getFormBuilderFieldModelByRow(int row) =>
      builderFieldModelList.where((element) => element.fieldKey.row == row);

  FormBuilderFieldModel getFormBuilderFieldModel(FieldKey fieldKey) =>
      builderFieldModelList.firstWhere(
          (element) => element.fieldKey == fieldKey,
          orElse: () => throw 'no field can be founded ');

  AbstractFieldStateModel getFieldModel(FieldKey fieldKey) =>
      fieldModelList.firstWhere((element) => element.fieldKey == fieldKey,
          orElse: () => throw 'no field can be founded ');

  ValueFieldState? getValueFieldState(FieldKey fieldKey) =>
      FormBuilderUtils.firstWhereOrNull(valueFieldStateList,
          (element) => element.mounted && element.fieldKey == fieldKey);

  TextSelectionManagement? getTextSelectionManagement(FieldKey fieldKey) =>
      FormBuilderUtils.firstWhereOrNull(textSelectionManagementList,
          (element) => element.fieldKey == fieldKey);

  FocusNodes? getFocusNodes(FieldKey fieldKey) =>
      FormBuilderUtils.firstWhereOrNull(
          focusNodesList, (element) => element.fieldKey == fieldKey);

  bool hasField(String name) => mappings.containsKey(name);
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

  /// get current formthemeData
  FormThemeData get formThemeData => _formModel.formThemeData;

  /// whether form has a name field
  bool hasField(String name) => _resourceManagement.hasField(name);

  /// set formthemedata
  set formThemeData(FormThemeData formThemeData) =>
      _formModel.formThemeData = formThemeData;

  /// whether form is visible
  bool get visible => _formModel.visible;

  /// show|hide form
  set visible(bool visible) => _formModel.visible = visible;

  /// whether form is readonly
  bool get readOnly => _formModel.readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly) => _formModel.readOnly = readOnly;

  /// get rows of form
  int get rows => _formModel.formLayout.rows.length;

  /// whether enableLayoutManagement or not
  bool get enableLayoutManagement => _formModel.enableLayoutManagement;

  /// get a new formfieldManagement by name
  ///
  /// if you don't know name,you can use [newFormFieldManagementByPosition] instead
  FormFieldManagement newFormFieldManagement(String name) {
    return _newFormFieldManagementByFieldKey(FieldKey.of(name));
  }

  /// create a formfieldmanagement by field's position
  FormFieldManagement newFormFieldManagementByPosition(int row, int column) {
    return _newFormFieldManagementByFieldKey(FieldKey.atPosition(row, column));
  }

  /// get all invalid & focusable field
  Iterable<FocusableInvalidField> getFocusableInvalidFields() {
    return (_valueFieldStateList
          ..sort((a, b) {
            FieldKey aKey = a.fieldKey;
            FieldKey bKey = b.fieldKey;
            int compareRow = aKey.row.compareTo(bKey.row);
            if (compareRow == 0) return aKey.column.compareTo(bKey.column);
            return compareRow;
          }))
        .where((element) =>
            element.hasError &&
            element._focusNode != null &&
            element._focusNode!.canRequestFocus)
        .map((e) => FocusableInvalidField(e.errorText!, e.focusNode));
  }

  FormFieldManagement _newFormFieldManagementByFieldKey(FieldKey fieldKey) {
    return FormFieldManagement._(fieldKey, _resourceManagement);
  }

  /// get form data
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
    data
        .map((key, value) => MapEntry(FieldKey.of(key), value))
        .forEach((key, value) {
      _valueFieldStateList
          .firstWhere((element) => element.fieldKey == key)
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

  /// whether form is valid or not
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

  /// get all validate error msgs
  ///
  /// key is name ,value is error message
  Map<FieldKey, String> get error {
    Map<FieldKey, String> errorMap = {};
    _valueFieldStateList.forEach((element) {
      String? error = element.errorText;
      if (error != null) errorMap[element.fieldKey] = error;
    });
    return errorMap;
  }

  /// create a row management used to set visible|readOnly on a row
  FormRowManagement newFormRowManagement(int row) {
    return FormRowManagement._(row, _resourceManagement);
  }

  /// create a new layout management
  ///
  /// **enableLayoutManagement should be true when you call this method**
  FormLayoutManagement newFormLayoutManagement() {
    FormModel formModel = _formModel;
    if (!formModel.enableLayoutManagement)
      throw 'you should set enableLayoutManagement to true before you call this method';
    return FormLayoutManagement._(_resourceManagement);
  }

  static FormManagement of(BuildContext context) {
    return FormManagement._(_ResourceManagement.of(context));
  }

  FormModel get _formModel => _resourceManagement.formModel;
  List<ValueFieldState> get _valueFieldStateList =>
      _resourceManagement.valueFieldStateList;
}

class FormFieldManagement {
  final FieldKey fieldKey;
  final _ResourceManagement _resourceManagement;

  FormFieldManagement._(this.fieldKey, this._resourceManagement);

  // whether field support focus
  bool get focusable => _focusNode != null && _focusNode!.canRequestFocus;

  // whether field is focused
  //
  bool get hasFocus {
    if (_focusNode == null) throw 'field don\'t has a focusnode!';
    return _focusNode!.hasFocus;
  }

  set focus(bool focus) {
    if (!focusable) {
      throw 'field is not focusable';
    }
    if (focus && !hasFocus) _focusNode!.requestFocus();
    if (!focus && hasFocus) _focusNode!.unfocus();
  }

  set focusListener(FocusListener? listener) {
    if (_focusNode == null) throw 'field don\'t has a focusnode!';
    _focusNode!.focusListener = listener;
  }

  /// if current value is valuefield return a [ValueFormFieldManagement] otherwise throw a exception
  ValueFieldManagement get valueFieldManagement {
    return ValueFieldManagement._(fieldKey, _resourceManagement);
  }

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

  /// whether form field is readOnly
  /// only return field's readOnly state,if form is readOnly but field is not
  /// will return false
  bool get readOnly => _buildFieldModel.readOnly;

  /// set readOnly on a form field
  set readOnly(bool readOnly) => _buildFieldModel.readOnly = readOnly;

  /// whether form field is visible
  /// only return field's visible state,if form is visible but field is not
  /// will return false
  bool get visible => _buildFieldModel.visible;

  /// set visible on a form field
  set visible(bool visible) => _buildFieldModel.visible = visible;

  /// get formfield's padding,will return null if no padding is set
  /// FormThemeData also has a padding works on formfield,but this method won't return it
  EdgeInsets? get padding => _buildFieldModel.padding;

  /// update state for a field
  void update(Map<String, dynamic> state) => _fieldModel.update(state);

  /// update one state for a field
  void update1(String key, dynamic value) =>
      _buildFieldModel.update({key: value});

  FormBuilderFieldModel get _buildFieldModel =>
      _resourceManagement.getFormBuilderFieldModel(fieldKey);
  AbstractFieldStateModel get _fieldModel =>
      _resourceManagement.getFieldModel(fieldKey);
  ValueFieldState? get _state =>
      _resourceManagement.getValueFieldState(fieldKey);
  TextSelectionManagement? get _textSelectionManagement =>
      _resourceManagement.getTextSelectionManagement(fieldKey);
  FocusNodes? get _focusNode => _resourceManagement.getFocusNodes(fieldKey);
}

class ValueFieldManagement {
  final FieldKey fieldKey;
  final _ResourceManagement _resourceManagement;

  ValueFieldManagement._(this.fieldKey, this._resourceManagement);

  /// get current value of valuefield
  dynamic get value => _valueFieldState.value;

  /// set newValue on valuefield,this method will trigger onChanged listener
  /// if you do not trigger it,you can use setData method
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
    ValueFieldState? state = _resourceManagement.getValueFieldState(fieldKey);
    if (state == null) throw 'current field is not value field!';
    return state;
  }
}

class FormRowManagement {
  final int row;
  final _ResourceManagement _resourceManagement;

  FormRowManagement._(this.row, this._resourceManagement);

  /// get column count
  int get columns => _models.length;

  /// set visible on row
  set visible(bool visible) => _models.forEach((element) {
        element.visible = visible;
      });

  /// set readonly on row
  set readOnly(bool readOnly) => _models.forEach((element) {
        element.readOnly = readOnly;
      });

  /// whether a field|row is visiable
  bool get visible => _models.every((element) => element.visible);

  Iterable<FormBuilderFieldModel> get _models {
    Iterable<FormBuilderFieldModel> models =
        _resourceManagement.getFormBuilderFieldModelByRow(row);
    if (models.isEmpty)
      throw 'no field can be founded at row $row ,is this row exists?';
    return models;
  }
}

/// used to modify Form Layout
///
/// any method that modify form layout will rebuild form ,especially those fields that
/// does not has a name will also dispose state and create a new one,
/// it means you are lost field states that you setted via update or rebuild
///
/// you should call startEdit first and call apply when finished
class FormLayoutManagement {
  final _ResourceManagement _resourceManagement;
  FormLayout? _formLayout;
  FormLayoutManagement._(this._resourceManagement);

  bool get isEditing => _formLayout != null;

  /// get editing layout rows
  int get rows => _formLayout!.rows.length;

  /// get columns of a row
  int getColumns(int row) {
    _ensureStarted();
    _rangeCheck(row);
    return _formLayout!.rows[row].builders.length;
  }

  // remove field or a row at position
  ///
  /// for better performance , you'd use [FormManagement.newFormFieldManagementByPosition] rather than this method ,
  /// set visible only affect one or several fields,but this method will rebuild form,
  void remove(int row, {int? column}) {
    _ensureStarted();
    _rangeCheck(row, column: column);
    if (column == null) {
      _formLayout!.rows.removeAt(row);
    } else {
      FormRow formRow = _formLayout!.rows[row];
      formRow.builders.removeAt(column);
    }
  }

  /// insert a field at position
  void insert({
    int? column,
    int? row,
    String? name,
    int? flex,
    bool visible = true,
    EdgeInsets? padding,
    bool inline = true,
    bool readOnly = false,
    bool insertRow = false,
    required Widget field,
  }) {
    _ensureStarted();
    if (row != null) _rangeCheck(row, column: column);
    FormRow formRow = row == null
        ? insertRow
            ? _formLayout!.append()
            : _formLayout!.rows[_formLayout!.rows.length - 1]
        : insertRow
            ? _formLayout!.insert(row)
            : _formLayout!.rows[row];
    FormBuilderFieldBuilder builder = FormBuilderFieldBuilder(
      visible: visible,
      name: name,
      flex: flex,
      inline: inline,
      padding: padding,
      readOnly: readOnly,
      child: field,
    );
    if (column == null)
      formRow.append(builder);
    else
      formRow.insert(builder, column);
  }

  void swapRow(int oldRow, int newRow) {
    _ensureStarted();
    _rangeCheck(oldRow);
    _rangeCheck(newRow);
    if (oldRow == newRow) throw 'oldRow must not equals newRow';
    FormRow row = _formLayout!.rows.removeAt(oldRow);
    _formLayout!.rows.insert(newRow, row);
  }

  void startEdit() {
    if (_formLayout != null)
      throw 'call apply or cancel first before you call startEdit again';
    _formLayout = _formModel.formLayout.copy();
    _formLayout!.removeEmptyRow();
  }

  void cancel() {
    _ensureStarted();
    _formLayout = null;
  }

  void apply() {
    _ensureStarted();
    _formLayout!.removeEmptyRow();
    _formModel.formLayout = _formLayout!;
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
      int maxColumn = formRow.builders.length - 1;
      if (column < 0 || column > maxColumn)
        throw 'column is out of range ,range is 0,$maxColumn';
    }
  }

  FormModel get _formModel => _resourceManagement.formModel;
}

mixin AbstractFormFieldState<T extends StatefulWidget> on State<T> {
  bool _init = false;
  late final _ResourceManagement _resourceManagement;

  late FieldInfo fieldInfo;
  late AbstractFieldStateModel model;

  /// get name
  ///
  /// maybe null if not specified
  String? get name => fieldKey.name;

  /// check current field is display inline
  bool get inline => fieldInfo.inline;

  /// get row of field
  int get row => fieldKey.row;

  /// get column of field
  int get column => fieldKey.column;

  /// get flex of field
  int get flex => fieldInfo.flex;

  /// whether field is readOnly
  bool get readOnly =>
      _resourceManagement.formModel.readOnly || fieldInfo.readOnly;

  /// get field key
  FieldKey get fieldKey => fieldInfo.fieldKey;

  /// get current formTheme
  FormThemeData get formThemeData =>
      _resourceManagement.formModel.formThemeData;

  FocusNodes? _focusNode;

  TextSelectionManagement? _textSelectionManagement;

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  ///
  /// you need get focusNode in [initFormManagement]
  FocusNodes get focusNode {
    if (_focusNode == null) {
      _focusNode = FocusNodes(fieldInfo.fieldKey);
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
    if (this is TextSelectionManagement) {
      _resourceManagement
          .registerTextSelectionManagement(this as TextSelectionManagement);
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
    if (_textSelectionManagement != null)
      _resourceManagement
          .unregisterTextSelectionManagement(_textSelectionManagement!);
    if (_focusNode != null)
      _resourceManagement.unregisterFocusNode(_focusNode!);
    _resourceManagement.unregisterFieldModel(model);
    super.dispose();
  }

  AbstractFieldStateModel createModel();
}

abstract class ValueFieldState<T> extends FormFieldState<T>
    with AbstractFormFieldState<FormField<T>> {
  ValueChanged<T?>? get onChanged =>
      (super.widget as ValueField<T, ValueFieldState>).onChanged;

  @override
  void didUpdateWidget(FormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChange(T? value) {
    doChangeValue(value);
  }

  void doChangeValue(T? newValue, {bool trigger = true}) {
    super.didChange(newValue);
    if (trigger && onChanged != null) onChanged!(newValue);
  }

  @override
  void reset() {
    if (!compare(value, widget.initialValue) && onChanged != null) {
      onChanged!(widget.initialValue);
    }
    super.reset();
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
}
