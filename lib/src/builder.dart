import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/form_builder.dart';
import 'field/filter_chip.dart';
import 'form_key.dart';
import 'field/selector.dart';
import 'field/switch_group.dart';
import 'field/checkbox_group.dart';
import 'form_theme.dart';
import 'field/text_field.dart';
import 'field/radio_group.dart';
import 'field/slider.dart';
import 'text_selection.dart';
import 'package:collection/collection.dart';

/// listen  focusnode change
///
/// key maybe null ,key is null means root node focuschanged,otherwise sub node focused
/// see [FocusNodes]
typedef FocusListener = void Function(String? key, bool hasFocus);

typedef NonnullFieldValidator<T> = String? Function(T t);

class FormBuilder extends StatefulWidget with AbstractFormField {
  static final String readOnlyKey = 'readOnly';
  static final String visibleKey = 'visible';

  final FormManagement formManagement;
  final Map<String, TypedValue> _initStateMap;
  final bool enableLayoutManagement;

  FormBuilder(
      {bool readOnly = false,
      bool visible = true,
      FormThemeData? formThemeData,
      this.enableLayoutManagement = false,
      required this.formManagement})
      : this._initStateMap = {
          'formLayout': TypedValue<_FormLayout>(_FormLayout()),
          'formThemeData': TypedValue<FormThemeData>(
              formThemeData ?? FormThemeData.defaultTheme),
          'readOnly': TypedValue<bool>(readOnly),
          'visible': TypedValue<bool>(visible),
        },
        super(key: formManagement._key);

  _FormLayout get _formLayout => _initStateMap['formLayout']!.value;

  FormBuilder nextLine() {
    _formLayout.lastEmptyRow();
    return this;
  }

  /// append a number field to current row
  FormBuilder numberField({
    String? controlKey,
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
  }) {
    _formLayout.lastStretchableRow().append(_FormBuilderFieldBuilder(
        visible: visible,
        controlKey: controlKey,
        flex: flex,
        inline: true,
        readOnly: readOnly,
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
            inputDecorationTheme: inputDecorationTheme)));
    return this;
  }

  /// add a textfield to current row
  FormBuilder textField({
    String? controlKey,
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
  }) {
    _formLayout.lastStretchableRow().append(_FormBuilderFieldBuilder(
        visible: visible,
        controlKey: controlKey,
        flex: flex,
        inline: true,
        readOnly: readOnly,
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
            inputDecorationTheme: inputDecorationTheme)));
    return this;
  }

  /// add a radio group
  ///
  /// if inline is false,it will be added to current row
  /// otherwise it will be placed in a new row
  FormBuilder radioGroup<T>({
    required List<RadioGroupItem<T>> items,
    String? controlKey,
    String? label,
    ValueChanged? onChanged,
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
  }) {
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormBuilderFieldBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: inline ? flex : 1,
      inline: inline,
      readOnly: readOnly,
      child: RadioGroupFormField<T>(
        label: label,
        items: List.of(items),
        validator: validator,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        split: split,
        initialValue: initialValue,
        errorTextPadding: errorTextPadding,
      ),
    ));
    return this;
  }

  FormBuilder checkboxGroup(
      {required List<CheckboxGroupItem> items,
      String? controlKey,
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
      bool inline = false}) {
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormBuilderFieldBuilder(
      visible: visible,
      controlKey: controlKey,
      inline: inline,
      readOnly: readOnly,
      flex: inline ? flex : 1,
      child: CheckboxGroupFormField(
        items: List.of(items),
        errorTextPadding: errorTextPadding,
        label: label,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        split: split,
        initialValue: initialValue,
      ),
    ));
    return this;
  }

  FormBuilder textButton(
      {String? controlKey,
      String? label,
      Widget? child,
      int? flex = 0,
      required VoidCallback onPressed,
      VoidCallback? onLongPress,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets? padding}) {
    _formLayout.lastStretchableRow().append(
          _FormBuilderFieldBuilder(
              visible: visible,
              controlKey: controlKey,
              flex: flex,
              inline: true,
              padding: padding,
              child: CommonField(
                {
                  'label': TypedValue<String?>(label),
                  'child': TypedValue<Widget?>(child),
                },
                builder: (state, stateMap, readOnly, formThemeData) {
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

  FormBuilder datetimeField(
      {String? controlKey,
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
      InputDecorationTheme? inputDecorationTheme}) {
    _formLayout.lastStretchableRow().append(
          _FormBuilderFieldBuilder(
              visible: visible,
              inline: true,
              controlKey: controlKey,
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
                  onChanged: onChanged)),
        );
    return this;
  }

  FormBuilder selector<T>({
    String? controlKey,
    String? labelText,
    String? hintText,
    bool readOnly = false,
    bool visible = true,
    bool clearable = true,
    NonnullFieldValidator<List>? validator,
    AutovalidateMode? autovalidateMode,
    EdgeInsets? padding,
    bool multi = false,
    ValueChanged<List>? onChanged,
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
  }) {
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(
      _FormBuilderFieldBuilder(
          visible: visible,
          controlKey: controlKey,
          flex: inline ? flex : 1,
          inline: inline,
          child: SelectorFormField<T>(selectItemProvider,
              onChanged: onChanged,
              labelText: labelText,
              hintText: hintText,
              clearable: clearable,
              validator: validator,
              autovalidateMode: autovalidateMode,
              readOnly: readOnly,
              multi: multi,
              initialValue: initialValue,
              selectItemRender: selectItemRender,
              selectedItemRender: selectedItemRender,
              selectedSorter: selectedSorter,
              onTap: onTap,
              selectedItemLayoutType: selectedItemLayoutType,
              queryFormBuilder: queryFormBuilder,
              onSelectDialogShow: onSelectDialogShow,
              inputDecorationTheme: inputDecorationTheme)),
    );
    return this;
  }

  FormBuilder divider(
      {String? controlKey,
      double? height,
      bool visible = true,
      EdgeInsets? padding = const EdgeInsets.symmetric(horizontal: 5)}) {
    _FormRow row = _formLayout.lastEmptyRow();
    row.append(_FormBuilderFieldBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: 1,
      inline: false,
      padding: padding,
      readOnly: true,
      child: CommonField(
        {'height': TypedValue<double>(height ?? 1.0)},
        builder: (state, stateMap, readOnly, formThemeData) {
          return Divider(
            height: stateMap['height'],
          );
        },
      ),
    ));
    return this;
  }

  FormBuilder switchGroup({
    String? controlKey,
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
  }) {
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormBuilderFieldBuilder(
      visible: visible,
      controlKey: controlKey,
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
      ),
    ));
    return this;
  }

  FormBuilder switchInline(
      {String? controlKey,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets? padding,
      int? flex = 0,
      ValueChanged<bool>? onChanged,
      NonnullFieldValidator<bool>? validator,
      AutovalidateMode? autovalidateMode,
      bool initialValue = false}) {
    _formLayout.lastStretchableRow().append(_FormBuilderFieldBuilder(
          visible: visible,
          controlKey: controlKey,
          padding: padding,
          flex: flex,
          inline: true,
          readOnly: readOnly,
          child: SwitchInlineFormField(
            validator: validator,
            autovalidateMode: autovalidateMode,
            onChanged: onChanged,
            initialValue: initialValue,
          ),
        ));
    return this;
  }

  FormBuilder slider(
      {String? controlKey,
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
      int? flex}) {
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormBuilderFieldBuilder(
      visible: visible,
      controlKey: controlKey,
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
      ),
    ));
    return this;
  }

  FormBuilder rangeSlider(
      {String? controlKey,
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
      bool inline = false}) {
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormBuilderFieldBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: 1,
      inline: inline,
      readOnly: readOnly,
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
      ),
    ));
    return this;
  }

  FormBuilder filterChip<T>(
      {required List<FilterChipItem<T>> items,
      List<T>? initialValue,
      AutovalidateMode? autovalidateMode,
      NonnullFieldValidator<List<T>>? validator,
      ValueChanged<List<T>>? onChanged,
      double? pressElevation,
      String? label,
      EdgeInsets? errorTextPadding,
      String? controlKey,
      bool visible = true,
      EdgeInsets? padding}) {
    _FormRow row = _formLayout.lastEmptyRow();
    row.append(_FormBuilderFieldBuilder(
        visible: visible,
        controlKey: controlKey,
        flex: 1,
        inline: false,
        child: FilterChipFormField(
          items: items,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          onChanged: onChanged,
          pressElevation: pressElevation,
          label: label,
          errorTextPadding: errorTextPadding,
        )));
    return this;
  }

  FormBuilder field(
      {String? controlKey,
      int? flex = 0,
      bool visible = true,
      EdgeInsets? padding,
      required AbstractFormField field,
      bool inline = false}) {
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(
      _FormBuilderFieldBuilder(
          visible: visible,
          controlKey: controlKey,
          flex: flex,
          inline: inline,
          padding: padding,
          child: field),
    );
    return this;
  }

  static bool compare(dynamic a, dynamic b) {
    if (a is List && b is List) return listEquals(a, b);
    if (a is Set && b is Set) return setEquals(a, b);
    if (a is Map && b is Map) return mapEquals(a, b);
    return a == b;
  }

  static List<CheckboxGroupItem> toCheckboxGroupItems(List<String> items,
      {EdgeInsets? padding}) {
    return items
        .map((e) => CheckboxGroupItem(label: e, padding: padding))
        .toList();
  }

  static List<FilterChipItem<String>> toFilterChipItems(List<String> items,
      {EdgeInsets? padding,
      EdgeInsets? contentPadding,
      EdgeInsets? labelPadding}) {
    return items
        .map((e) => FilterChipItem<String>(
            label: Text(e),
            padding: padding,
            data: e,
            contentPadding: contentPadding,
            labelPadding: labelPadding))
        .toList();
  }

  static List<RadioGroupItem<String>> toRadioGroupItems(List<String> items,
      {EdgeInsets? padding}) {
    return items
        .map((e) => RadioGroupItem(label: e, value: e, padding: padding))
        .toList();
  }

  static SelectItemProvider toSelectItemProvider<T>(List<T> items) {
    return (page, params) {
      return Future.delayed(Duration.zero, () {
        return SelectItemPage<T>(items, items.length);
      });
    };
  }

  static List<SwitchGroupItem> toSwitchGroupItems(List<String> items,
      {EdgeInsets? padding, TextStyle? style}) {
    return items
        .map((e) => SwitchGroupItem(e, padding: padding, textStyle: style))
        .toList();
  }

  @override
  State<StatefulWidget> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  late final FormManagement formManagement;
  late _FormModel model;

  @override
  void initState() {
    super.initState();
    formManagement = widget.formManagement;
    model = _FormModel(widget._initStateMap, widget.enableLayoutManagement);
    model.addListener(() {
      setState(() {});
    });
    formManagement._formModels.add(model);
  }

  @override
  void didUpdateWidget(FormBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    model.updateInitStateMap(oldWidget, widget);
  }

  @override
  void dispose() {
    model.dispose();
    formManagement._formModels.remove(model);
    formManagement._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _FormLayout formLayout = model.formLayout;
    FormThemeData formThemeData = model.formThemeData;
    bool visible = model.visible;

    formLayout.removeEmptyRow();
    Set<String> controlKeys = {};
    List<Row> rows = [];
    int row = 0;
    for (_FormRow formRow in formLayout.rows) {
      List<_FormBuilderField> children = [];
      int column = 0;
      for (_FormBuilderFieldBuilder builder in formRow.builders) {
        Key? key;
        String? controlKey = builder.controlKey;
        if (controlKey == null) {
          if (model.rebuildLayout) {
            key = UniqueKey();
          }
        } else {
          if (controlKey.contains(','))
            throw 'controlKey can not contains char , ';
          key = formManagement._newFieldKey(controlKey);
          if (controlKeys.contains(controlKey))
            throw 'controlkey must unique in a form';
          controlKeys.add(controlKey);
        }
        children.add(_FormBuilderField(builder, key, row, column));
        column++;
      }
      rows.add(Row(
        children: children,
      ));
      row++;
    }
    controlKeys.clear();
    model.rebuildLayout = false;
    return Theme(
        data: formThemeData.themeData,
        child: Visibility(
            visible: visible,
            maintainState: true,
            child: _FormData(
              formManagement,
              model.readOnly,
              model.formThemeData,
              child: Column(
                children: rows,
              ),
            )));
  }
}

mixin AbstractFormField on Widget {
  Map<String, TypedValue> get _initStateMap => {};
}

class BuilderInfo {
  final FieldKey fieldKey;
  final Map<String, dynamic> stateMap;
  final bool readOnly;
  final int flex;
  final bool inline;
  final FormThemeData formThemeData;

  factory BuilderInfo.of(BuildContext context) {
    FieldInfo fieldInfo = FieldInfo.of(context);
    FormManagement formManagement = FormManagement.of(context);
    bool readOnly = formManagement.readOnly || fieldInfo.model.readOnly;
    FormThemeData formThemeData = formManagement._formModel.formThemeData;
    return BuilderInfo._(fieldInfo.fieldKey, fieldInfo.model.currentMap,
        readOnly, fieldInfo.flex, fieldInfo.inline, formThemeData);
  }

  BuilderInfo._(this.fieldKey, this.stateMap, this.readOnly, this.flex,
      this.inline, this.formThemeData);
}

class _FormBuilderField extends StatefulWidget with AbstractFormField {
  final AbstractFormField child;
  final FieldKey fieldKey;
  final bool inline;
  final _FormBuilderFieldBuilder builder;
  _FormBuilderField(this.builder, Key? key, int row, int column)
      : this.child = builder.child,
        this.inline = builder.inline,
        this.fieldKey =
            FieldKey(column: column, row: row, controlKey: builder.controlKey),
        super(key: key);
  @override
  State<StatefulWidget> createState() => _FormBuilderFieldState();

  @override
  Map<String, TypedValue> get _initStateMap => {
        'readOnly': TypedValue<bool>(builder.readOnly),
        'visible': TypedValue<bool>(builder.visible),
        'flex': TypedValue<int>(builder.flex),
        'padding': TypedValue<EdgeInsets?>(builder.padding),
      };
}

class _FormBuilderFieldState extends State<_FormBuilderField> {
  bool _init = false;

  late final FormManagement formManagement;
  late _FormFieldModel model;

  @override
  void didUpdateWidget(_FormBuilderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    model.updateInitStateMap(oldWidget, widget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    formManagement = FormManagement.of(context);
    model = _FormFieldModel(
      widget.fieldKey,
      widget._initStateMap,
    );
    model.addListener(() {
      setState(() {});
    });
    formManagement._formFieldModels.add(model);
  }

  @override
  void dispose() {
    model.dispose();
    formManagement._formFieldModels.remove(model);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool visible = model.visible;
    EdgeInsets padding = model.padding ??
        formManagement.formThemeData.padding ??
        EdgeInsets.zero;
    int flex = model.flex;
    Widget child = Visibility(
        maintainState: true,
        visible: visible,
        child: Padding(
          padding: padding,
          child: widget.child,
        ));
    return _InheritedFieldInfo(
      FieldInfo._(widget.fieldKey, widget.inline, model.flex, model.gen, model),
      Flexible(
        fit: visible ? FlexFit.tight : FlexFit.loose,
        child: child,
        flex: flex,
      ),
    );
  }
}

class FieldInfo {
  final FieldKey fieldKey;
  final bool inline;
  final int flex;
  final int gen;
  final _FormFieldModel model;

  FieldInfo._(this.fieldKey, this.inline, this.flex, this.gen, this.model);

  bool operator ==(Object other) =>
      (other is FieldInfo) &&
      other.fieldKey.controlKey == fieldKey.controlKey &&
      other.fieldKey.row == fieldKey.row &&
      other.fieldKey.column == fieldKey.column &&
      other.inline == inline &&
      other.gen == gen;

  @override
  int get hashCode => hashValues(fieldKey, inline);

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
    return fieldInfo != oldWidget.fieldInfo;
  }
}

class TypedValue<T> {
  final T value;

  String? _check(dynamic value) {
    if (null is! T && value == null) {
      return 'value can not be null';
    }
    if (value is! T) {
      return 'value must be type $T but current type is ${value.runtimeType}';
    }
  }

  const TypedValue(this.value);
}

mixin AbstractFormFieldState<T extends StatefulWidget> on State<T> {
  bool _init = false;
  late final FormManagement _formManagement;

  late FieldInfo _fieldInfo;

  /// get controlKey
  ///
  /// maybe null if not specified
  String? get controlKey => _fieldInfo.fieldKey.controlKey;

  /// check current field is display inline
  bool get inline => _fieldInfo.inline;

  /// get row of field
  int get row => _fieldInfo.fieldKey.row;

  /// get column of field
  int get column => _fieldInfo.fieldKey.column;

  /// get flex of field
  int get flex => _fieldInfo.flex;

  FocusNodes? _focusNode;
  TextSelectionManagementDelegate? _textSelectionManagementDelegate;

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  ///
  /// you need get focusNode in [initFormManagement]
  FocusNodes get focusNode {
    if (_focusNode == null) {
      _focusNode = FocusNodes._(_fieldInfo.fieldKey);
      _formManagement._focusNodes.add(_focusNode!);
    }
    return _focusNode!;
  }

  @protected
  dynamic getState(String stateKey) {
    return _fieldInfo.model.getState(stateKey);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    AbstractFormField? old;
    AbstractFormField? current;
    if (oldWidget is AbstractFormField) old = oldWidget as AbstractFormField;
    if (widget is AbstractFormField) current = widget as AbstractFormField;
    _fieldInfo.model.updateInitStateMap(old, current);
  }

  @protected
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fieldInfo = FieldInfo.of(context);
    if (widget is AbstractFormField) {
      _fieldInfo.model.initStateMap
          .addAll(Map.of((widget as AbstractFormField)._initStateMap));
    }
    if (_init) return;
    _init = true;
    _formManagement = FormManagement.of(context);

    if (this is TextSelectionManagement) {
      _textSelectionManagementDelegate = TextSelectionManagementDelegate._(
          this as TextSelectionManagement, _fieldInfo.fieldKey);
      _formManagement._textSelectionManagements
          .add(_textSelectionManagementDelegate!);
    }
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
    if (_textSelectionManagementDelegate != null)
      _formManagement._textSelectionManagements
          .remove(_textSelectionManagementDelegate);
    _focusNode?.dispose();
    if (_focusNode != null) _formManagement._focusNodes.remove(_focusNode!);
    super.dispose();
  }
}

typedef FieldContentBuilder<T extends AbstractFormFieldState> = Widget Function(
    T state,
    Map<String, dynamic> stateMap,
    bool readOnly,
    FormThemeData formThemeData);

class StatelessField extends StatelessWidget with AbstractFormField {
  final WidgetBuilder builder;
  StatelessField({required this.builder});
  @override
  Widget build(BuildContext context) => builder(context);
}

class CommonField extends StatefulWidget with AbstractFormField {
  final Map<String, TypedValue> _initStateMap;
  final FieldContentBuilder<CommonFieldState> builder;
  CommonField(this._initStateMap, {required this.builder});

  @override
  CommonFieldState createState() => CommonFieldState();
}

class CommonFieldState extends State<CommonField> with AbstractFormFieldState {
  @override
  Widget build(BuildContext context) {
    _FormFieldModel model = _fieldInfo.model;
    bool readOnly = _formManagement.readOnly || model.readOnly;
    return widget.builder(
        this, model.currentMap, readOnly, _formManagement.formThemeData);
  }
}

class ValueField<T> extends FormField<T> with AbstractFormField {
  final ValueChanged<T?>? onChanged;
  final Map<String, TypedValue> _initStateMap;

  ValueField(this._initStateMap,
      {Key? key,
      this.onChanged,
      required FieldContentBuilder<ValueFieldState<T>> builder,
      FormFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      T? initialValue,
      bool enabled = true})
      : super(
            key: key,
            enabled: enabled,
            builder: (field) {
              ValueFieldState<T> state = field as ValueFieldState<T>;
              _FormFieldModel model = state._fieldInfo.model;
              bool readOnly = state._formManagement.readOnly || model.readOnly;
              return builder(state, model.currentMap, readOnly,
                  state._formManagement.formThemeData);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue) {
    this._initStateMap.addAll({
      'initialValue': TypedValue<T?>(initialValue),
      'enabled': TypedValue<bool>(enabled),
      'autovalidateMode': TypedValue<AutovalidateMode?>(autovalidateMode),
    });
  }

  @override
  ValueFieldState<T> createState() => ValueFieldState<T>();
}

class ValueFieldState<T> extends FormFieldState<T>
    with AbstractFormFieldState<FormField<T>> {
  ValueChanged<T?>? get onChanged => (super.widget as ValueField<T>).onChanged;

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
    _formManagement._valueFieldStatesList.add(this);
  }

  @override
  void dispose() {
    _formManagement._valueFieldStatesList.remove(this);
    super.dispose();
  }

  @protected
  bool compare(T? a, T? b) {
    return FormBuilder.compare(a, b);
  }
}

class NonnullValueField<T> extends ValueField<T> {
  @override
  T get initialValue => super.initialValue!;

  NonnullValueField(Map<String, TypedValue> initStateMap,
      {Key? key,
      required FieldContentBuilder<NonnullValueFieldState<T>> builder,
      ValueChanged<T>? onChanged,
      NonnullFieldValidator<T>? validator,
      AutovalidateMode? autovalidateMode,
      required T initialValue})
      : super(initStateMap,
            key: key,
            onChanged: onChanged == null ? null : (value) => onChanged(value!),
            builder: (state, readOnly, stateMap, formThemeData) => builder(
                state as NonnullValueFieldState<T>,
                readOnly,
                stateMap,
                formThemeData),
            validator: validator == null ? null : (value) => validator(value!),
            autovalidateMode: autovalidateMode,
            initialValue: initialValue) {
    this._initStateMap.addAll({
      'initialValue': TypedValue<T>(initialValue),
    });
  }

  @override
  NonnullValueFieldState<T> createState() => NonnullValueFieldState<T>();
}

class NonnullValueFieldState<T> extends ValueFieldState<T> {
  @override
  NonnullValueField<T> get widget => super.widget as NonnullValueField<T>;
  @override
  T get value => super.value!;

  @override
  void doChangeValue(T? newValue, {bool trigger = true}) {
    super.doChangeValue(newValue == null ? widget.initialValue : newValue,
        trigger: trigger);
  }

  @mustCallSuper
  @override
  void setValue(T? value) {
    super.setValue(value == null ? widget.initialValue : value);
  }
}

class TextSelectionManagementDelegate extends TextSelectionManagement {
  final TextSelectionManagement _management;
  final FieldKey fieldKey;

  TextSelectionManagementDelegate._(this._management, this.fieldKey);

  String? get controlKey => fieldKey.controlKey;

  @override
  void selectAll() {
    _management.selectAll();
  }

  @override
  void setSelection(int start, int end) {
    _management.setSelection(start, end);
  }
}

class FocusNodes extends FocusNode {
  final FieldKey fieldKey;
  final Map<String, FocusNode> _nodes = {};
  FocusListener? _focusListener;

  String? get controlKey => fieldKey.controlKey;

  FocusNodes._(this.fieldKey) {
    this.addListener(() {
      if (_focusListener != null) _focusListener!(null, this.hasFocus);
    });
  }

  /// create a new focus node if not exists
  ///
  /// return old FocusNode if it is exists
  ///
  /// **do not dispose it by yourself,it will auto dispose **
  FocusNode newFocusNode(String key) {
    FocusNode? focusNode = _nodes[key];
    if (focusNode == null) {
      focusNode = new FocusNode();
      focusNode.addListener(() {
        if (_focusListener != null) _focusListener!(key, focusNode!.hasFocus);
      });
      _nodes[key] = focusNode;
    }
    return focusNode;
  }

  @override
  void dispose() {
    _nodes.values.forEach((element) {
      element.dispose();
    });
    _nodes.clear();
    _focusListener = null;
    super.dispose();
  }
}

class _FormBuilderFieldBuilder {
  final String? controlKey;
  final int flex;
  final bool visible;
  final AbstractFormField child;
  final EdgeInsets? padding;
  final bool inline;
  final bool readOnly;
  _FormBuilderFieldBuilder(
      {bool? visible,
      this.controlKey,
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

class _FormLayout {
  final List<_FormRow> rows = [_FormRow()];

  _FormRow append() {
    _FormRow row = _FormRow();
    rows.add(row);
    return row;
  }

  _FormRow insert(int index) {
    if (index < 0 || index >= rows.length)
      throw 'index out of range,range is 0,${rows.length - 1}';
    _FormRow row = _FormRow();
    rows.insert(index, row);
    return row;
  }

  _FormRow lastStretchableRow() {
    _FormRow lastRow = rows[rows.length - 1];
    if (lastRow.stretchable) {
      return lastRow;
    }
    return append();
  }

  _FormRow lastEmptyRow() {
    _FormRow lastRow = rows[rows.length - 1];
    if (lastRow.builders.isEmpty) {
      return lastRow;
    }
    return append();
  }

  void removeEmptyRow() {
    rows.removeWhere((element) => element.builders.isEmpty);
  }

  _FormLayout copy() {
    _FormLayout formLayout = _FormLayout();
    formLayout.rows.addAll(rows.map((e) => e.copy()).toList());
    return formLayout;
  }
}

class _FormRow {
  bool stretchable = true;
  final List<_FormBuilderFieldBuilder> builders = [];

  void append(_FormBuilderFieldBuilder builder) {
    enableInsertable(builder);
    if (!builder.inline) {
      stretchable = false;
    }
    builders.add(builder);
  }

  void insert(_FormBuilderFieldBuilder builder, int index) {
    rangeCheck(index);
    if (builders.isEmpty) {
      if (!builder.inline) {
        stretchable = false;
      }
      builders.add(builder);
      return;
    }
    enableInsertable(builder);
    if (index == builders.length) {
      if (!builder.inline) {
        stretchable = false;
      }
      builders.add(builder);
    } else {
      builders.insert(index, builder);
    }
  }

  _FormRow copy() {
    _FormRow row = _FormRow();
    row.builders.addAll(List.of(builders));
    row.stretchable = stretchable;
    return row;
  }

  void enableInsertable(_FormBuilderFieldBuilder builder) {
    if (!stretchable) throw 'row is not stretchable,can not insert field';
    if (!builder.inline && builders.isNotEmpty)
      throw 'current field is not support inline mode and one or more field at placed at row,can not insert';
  }

  void rangeCheck(int index) {
    if (builders.isEmpty && index != 0)
      throw 'index must be 0 due to current row is empty';
    if (index < 0 || index > builders.length - 1)
      throw 'index is out of range ,current range is 0,${builders.length - 1}';
  }
}

class _AbstractFormModel extends ChangeNotifier {
  final Map<String, TypedValue> initStateMap;
  final Map<String, dynamic> state = {};

  int gen = 0;

//copy initStateMap here ,initStateMap from Widget ,we shouldn't change it
  _AbstractFormModel(Map<String, TypedValue> initStateMap)
      : this.initStateMap = Map.of(initStateMap);

  /// get state value
  ///
  /// it's equals to build method's stateMap\[stateKey\]
  getState(String stateKey) {
    enableKeyExists(stateKey);
    return state.containsKey(stateKey)
        ? state[stateKey]
        : initStateMap[stateKey]!.value;
  }

  Map<String, dynamic> get currentMap {
    Map<String, dynamic> map = {};
    initStateMap.forEach((key, value) {
      map[key] = state.containsKey(key) ? state[key] : value.value;
    });
    return map;
  }

  void rebuild(Map<String, dynamic> state) {
    checkState(state);
    if (mapEquals(state, this.state)) return;
    this.state
      ..clear()
      ..addAll(state);
    gen++;
    notifyListeners();
  }

  void update(Map<String, dynamic> state) {
    checkState(state);
    List<String> keys = [];
    state.forEach((key, value) {
      dynamic currentValue = this.state[key];
      if (!FormBuilder.compare(value, currentValue)) {
        this.state[key] = value;
        keys.add(key);
      }
    });
    if (keys.isNotEmpty) {
      gen++;
      notifyListeners();
    }
  }

  void update1(String key, dynamic value) {
    update({key: value});
  }

  void remove(Set<String> stateKeys) {
    if (stateKeys.isEmpty) return;
    int length = state.length;
    stateKeys.forEach((element) {
      state.remove(element);
    });
    if (length != state.length) {
      gen++;
      notifyListeners();
    }
  }

  void updateInitStateMap(AbstractFormField? old, AbstractFormField? current) {
    if (old != null) {
      Iterable<String> keys = old._initStateMap.keys;
      initStateMap.removeWhere((key, value) => keys.contains(key));
    }
    if (current != null) {
      initStateMap.addAll(Map.of(current._initStateMap));
    }
  }

  @protected
  void enableKeyExists(String stateKey) {
    if (!initStateMap.containsKey(stateKey))
      throw 'did you put key :$stateKey into your initMap';
  }

  @protected
  void checkState(Map<String, dynamic> map) {
    map.forEach((key, value) {
      enableKeyExists(key);
      TypedValue typedValue = initStateMap[key]!;
      String? error = typedValue._check(value);
      if (error != null) throw 'key: $key\'s value error :' + error;
    });
  }

  @mustCallSuper
  void dispose() {
    initStateMap.clear();
    state.clear();
    super.dispose();
  }
}

abstract class _AbstractFormFieldModel extends _AbstractFormModel {
  final FieldKey fieldKey;
  _AbstractFormFieldModel(this.fieldKey, Map<String, TypedValue> value)
      : super(value);
}

class _FormModel extends _AbstractFormModel {
  final bool enableLayoutManagement;
  _FormModel(Map<String, TypedValue> value, this.enableLayoutManagement)
      : super(value);

  bool rebuildLayout = false;

  _FormLayout get formLayout => getState('formLayout');
  set formLayout(_FormLayout formLayout) {
    rebuildLayout = true;
    update1('formLayout', formLayout);
  }

  FormThemeData get formThemeData => getState('formThemeData');
  set formThemeData(FormThemeData formThemeData) =>
      update1('formThemeData', formThemeData);

  bool get visible => getState('visible');
  set visible(bool visible) => update1('visible', visible);

  bool get readOnly => getState('readOnly');
  set readOnly(bool readOnly) => update1('readOnly', readOnly);
}

class _FormFieldModel extends _AbstractFormFieldModel {
  _FormFieldModel(
    FieldKey fieldKey,
    Map<String, TypedValue> value,
  ) : super(
          fieldKey,
          value,
        );

  String? get controlKey => fieldKey.controlKey;

  bool get visible => getState('visible');
  set visible(bool visible) => update1('visible', visible);

  int get flex => getState('flex');
  set flex(int flex) => update1('flex', flex);

  EdgeInsets? get padding => getState('padding');
  set padding(EdgeInsets? padding) => update1('padding', padding);

  bool get readOnly => getState('readOnly');
  set readOnly(bool readOnly) => update1('readOnly', visible);
}

/// a management used to control a form
///
/// ```
/// FormBuilder(formManagement:your form management)
/// ```
///
/// **when you create a FormManagement,it's also created a new  GlobalKey used by FormBuilder,so if your FormManagement instance changed for every builder
/// (eg FormBuilder(formMangement:FormManagement())),your form will rebuild always**
class FormManagement {
  final GlobalKey _key = GlobalKey(); //form key !

  final List<ValueFieldState> _valueFieldStatesList = [];
  final List<_FormFieldModel> _formFieldModels = [];
  final List<_FormModel> _formModels = [];
  final Map<String, Key> _mappings = {};
  final List<TextSelectionManagementDelegate> _textSelectionManagements = [];
  final List<FocusNodes> _focusNodes = [];

  /// get current formthemeData
  FormThemeData get formThemeData => _formModel.formThemeData;

  /// whether form has a controlKey
  bool hasControlKey(String controlKey) => _mappings.containsKey(controlKey);

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

  /// get a new formfieldManagement by controlKey
  ///
  /// if you don't know controlKey,you can use [newFormFieldManagementByPosition] instead
  FormFieldManagement newFormFieldManagement(String controlKey) {
    //fast check
    if (!_mappings.containsKey(controlKey)) {
      throw 'no field can be found ,may be you need newFormFieldManagementByPosition';
    }
    return _newFormFieldManagement(
        FieldKey(row: -1, column: -1, controlKey: controlKey));
  }

  /// create a formfieldmanagement by field's position
  FormFieldManagement newFormFieldManagementByPosition(int row, int column) {
    _rangeCheck(row, column: column);
    return _newFormFieldManagement(FieldKey(row: row, column: column));
  }

  /// get all invalid & focusable field
  Iterable<FocusableInvalidField> getFocusableInvalidFields() {
    return this
        ._valueFieldStatesList
        .sorted((a, b) {
          FieldKey aKey = a._fieldInfo.fieldKey;
          FieldKey bKey = b._fieldInfo.fieldKey;
          int compareRow = aKey.row.compareTo(bKey.row);
          if (compareRow == 0) return aKey.column.compareTo(bKey.column);
          return compareRow;
        })
        .where((element) =>
            element.hasError &&
            element._focusNode != null &&
            element._focusNode!.canRequestFocus)
        .map((e) => FocusableInvalidField._(e.errorText!, e.focusNode));
  }

  FormFieldManagement _newFormFieldManagement(FieldKey fieldKey) {
    _FormFieldModel fieldModel = _formFieldModels.lastWhere(
        (element) => element.fieldKey == fieldKey,
        orElse: () => throw 'no field can be founded ');
    ValueFieldState? state = _valueFieldStatesList
        .lastWhereOrNull((element) => element._fieldInfo.fieldKey == fieldKey);
    TextSelectionManagement? textSelectionManagement = _textSelectionManagements
        .lastWhereOrNull((element) => element.fieldKey == fieldKey);
    FocusNodes? focusNode =
        _focusNodes.lastWhereOrNull((element) => element.fieldKey == fieldKey);
    return FormFieldManagement._(
        fieldModel, state, textSelectionManagement, focusNode);
  }

  /// get form data
  Map<String, dynamic> get data {
    Map<String, dynamic> map = {};
    _valueFieldStatesList.forEach((element) {
      String? controlKey = element.controlKey;
      if (controlKey == null) return;
      dynamic value = element.value;
      map[controlKey] = value;
    });
    return map;
  }

  /// reset form
  ///
  /// **only reset all value fields**
  void reset() {
    _valueFieldStatesList.forEach((element) {
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
    for (final FormFieldState<dynamic> field in _valueFieldStatesList)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  /// whether form is valid or not
  ///
  /// **only check is valid or not , won't show error**
  bool get isValid {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in _valueFieldStatesList)
      hasError = !field.isValid || hasError;
    return !hasError;
  }

  /// get all validate error msgs
  ///
  /// key is controlKey ,value is error message
  Map<FieldKey, String> get error {
    Map<FieldKey, String> errorMap = {};
    _valueFieldStatesList.forEach((element) {
      String? error = element.errorText;
      if (error != null) errorMap[element._fieldInfo.fieldKey] = error;
    });
    return errorMap;
  }

  /// create a row management used to set visible|readOnly on a row
  FormRowManagement newFormRowManagement(int row) {
    _rangeCheck(row);
    return FormRowManagement._(
        _formFieldModels.where((element) => element.fieldKey.row == row));
  }

  /// create a new layout management
  ///
  /// **enableLayoutManagement should be true when you call this method**
  FormLayoutManagement newFormLayoutManagement() {
    _FormModel formModel = _formModel;
    if (!formModel.enableLayoutManagement)
      throw 'you should set enableLayoutManagement to true before you call this method';
    return FormLayoutManagement._(formModel);
  }

  Key _newFieldKey(String controlKey) {
    bool useGlobalKey = _formModel.enableLayoutManagement;
    return _mappings.putIfAbsent(
        controlKey, () => useGlobalKey ? GlobalKey() : UniqueKey());
  }

  void _dispose() {
    _mappings.clear();
    // we don't clear and dispose models|states here
    // let State do that
    if (kDebugMode) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        assert(_formFieldModels.isEmpty,
            'FormFieldModel is not all disposed, may cause a memory leak');
        assert(_valueFieldStatesList.isEmpty,
            'ValueFieldState is not all disposed,may cause a memory leaks');
        assert(_formModels.isEmpty,
            'FormModel is not all disposed, may cause a memory leak');
      });
    }
  }

  _FormModel get _formModel => _formModels.last;

  void _rangeCheck(int row, {int? column}) {
    if (row < 0 || row >= rows)
      throw 'row is out of range,range is 0,${rows - 1}';
    if (column != null) {
      _FormRow _formRow = _formModel.formLayout.rows[row];
      if (column < 0 || column >= _formRow.builders.length)
        throw 'column is out of range,range is 0,${_formRow.builders.length - 1}';
    }
  }

  static FormManagement of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormData>()!.data;
  }
}

class FormFieldManagement {
  final _FormFieldModel _formFieldModel;
  final ValueFieldState? _state;
  final TextSelectionManagement? _textSelectionManagement;
  final FocusNodes? _focusNode;
  ValueFieldManagement? _valueFieldManagement;

  FormFieldManagement._(this._formFieldModel, this._state,
      this._textSelectionManagement, this._focusNode);

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
    _focusNode!._focusListener = listener;
  }

  /// if current value is valuefield return a [ValueFormFieldManagement] otherwise throw a exception
  ValueFieldManagement get valueFieldManagement {
    if (_state == null) throw 'current field is not a value field';
    return _valueFieldManagement ??= ValueFieldManagement._(_state!);
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
  bool get readOnly => _formFieldModel.readOnly;

  /// set readOnly on a form field
  set readOnly(bool readOnly) => _formFieldModel.readOnly = readOnly;

  /// whether form field is visible
  /// only return field's visible state,if form is visible but field is not
  /// will return false
  bool get visible => _formFieldModel.visible;

  /// set visible on a form field
  set visible(bool visible) => _formFieldModel.visible = visible;

  /// get formfield's padding,will return null if no padding is set
  /// FormThemeData also has a padding works on formfield,but this method won't return it
  EdgeInsets? get padding => _formFieldModel.padding;

  /// update state for a field
  void update(Map<String, dynamic> state) => _formFieldModel.update(state);

  /// rebuild state for a field
  void rebuild(Map<String, dynamic> state) => _formFieldModel.rebuild(state);

  /// update one state for a field
  void update1(String key, dynamic value) =>
      _formFieldModel.update1(key, value);

  /// remove states by keys
  void removeStateKey(Set<String> keys) => _formFieldModel.remove(keys);
}

class ValueFieldManagement {
  final ValueFieldState _valueFieldState;
  ValueFieldManagement._(this._valueFieldState);

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
}

class FormRowManagement {
  final Iterable<_FormFieldModel> _models;

  FormRowManagement._(this._models);

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
}

class _FormData extends InheritedWidget {
  final FormManagement data;
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

/// used to modify Form Layout
///
/// any method that modify form layout will rebuild form ,especially those fields that
/// does not has a controlKey will also dispose state and create a new one,
/// it means you are lost field states that you setted via update or rebuild
///
/// you should call startEdit first and call apply when finished
class FormLayoutManagement {
  final _FormModel _formModel;
  _FormLayout? _formLayout;
  FormLayoutManagement._(this._formModel);

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
      _FormRow formRow = _formLayout!.rows[row];
      formRow.builders.removeAt(column);
    }
  }

  /// insert a field at position
  void insert(
      {int? column,
      int? row,
      String? controlKey,
      int? flex,
      bool visible = true,
      EdgeInsets? padding,
      required AbstractFormField field,
      bool inline = true,
      bool insertRow = false}) {
    _ensureStarted();
    if (row != null) _rangeCheck(row, column: column);
    _FormRow formRow = row == null
        ? insertRow
            ? _formLayout!.append()
            : _formLayout!.rows[_formLayout!.rows.length - 1]
        : insertRow
            ? _formLayout!.insert(row)
            : _formLayout!.rows[row];
    _FormBuilderFieldBuilder builder = _FormBuilderFieldBuilder(
        visible: visible,
        controlKey: controlKey,
        flex: flex,
        inline: inline,
        padding: padding,
        child: field);
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
    _FormRow row = _formLayout!.rows.removeAt(oldRow);
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
      _FormRow formRow = _formLayout!.rows[row];
      int maxColumn = formRow.builders.length - 1;
      if (column < 0 || column > maxColumn)
        throw 'column is out of range ,range is 0,$maxColumn';
    }
  }
}

class FocusableInvalidField {
  final String errorText;
  final FocusNode _node;

  FocusableInvalidField._(this.errorText, this._node);

  void requestFocus() {
    _node.requestFocus();
  }
}
