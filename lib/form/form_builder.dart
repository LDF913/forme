import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'switch_group.dart';
import 'checkbox_group.dart';
import 'form_theme.dart';
import 'text_field.dart';
import 'radio_group.dart';
import 'selector.dart';
import 'slider.dart';

/// provide a value notifier for ValueField
///
/// it's only create once and maintained in [_FormController]
typedef ControllerProvider<T> = ValueNotifier<T> Function();
typedef _FieldBuilder<T, K extends _BaseFieldState<T>> = Widget Function(
  K state,
  BuildContext context,
  bool readOnly,
  Map<String, dynamic> stateMap,
  ThemeData themeData,
  FormThemeData formThemeData,
);

/// replace null value before set it to ValueField
///
/// it's useful if you don't want your custom value field return a null value
typedef NullValueReplace<T> = T Function();

/// listen sub focusnodes change
typedef SubFocusChanged = void Function(String key, bool hasFocus);

class FormBuilder extends StatefulWidget {
  static final String readOnlyKey = 'readOnly';
  static final String visibleKey = 'visible';
  static final String autovalidateModeKey = 'autovalidateMode';
  static final String initialValueKey = 'initialValue';

  final List<_FormItemWidget> _builders = [];
  final List<List<_FormItemWidget>> _builderss = [];
  final FormControllerDelegate formControllerDelegate;

  _FormController get _formController => formControllerDelegate._formController;

  FormBuilder(this.formControllerDelegate);

  /// add an empty row
  FormBuilder nextLine() {
    if (_builders.length > 0) {
      _builderss.add(List.of(_builders));
      _builders.clear();
    }
    return this;
  }

  /// set theme before build
  FormBuilder theme(FormThemeData themeData) {
    _formController._themeData = themeData;
    return this;
  }

  /// set readonly before build
  FormBuilder readOnly(bool readOnly) {
    _formController._readOnly = readOnly;
    return this;
  }

  /// set visible before build
  FormBuilder visible(bool visible) {
    _formController._visible = visible;
    return this;
  }

  /// add a number field to current row
  FormBuilder numberField(String controlKey,
      {String hintText,
      String labelText,
      VoidCallback onTap,
      Key key,
      int flex,
      Widget prefixIcon,
      ValueChanged<num> onChanged,
      FormFieldValidator<num> validator,
      AutovalidateMode autovalidateMode,
      double min,
      double max,
      bool clearable,
      bool readOnly,
      bool visible,
      int decimal,
      EdgeInsets padding,
      TextStyle style,
      num initialValue,
      List<Widget> suffixIcons,
      VoidCallback onEditingComplete,
      TextInputAction textInputAction,
      InputDecorationTheme inputDecorationTheme}) {
    _builders.add(_FormItemWidget(visible, controlKey,
        flex: flex,
        child: NumberFormField(
            onChanged: onChanged,
            key: key,
            decimal: decimal,
            min: min,
            max: max,
            hintText: hintText,
            labelText: labelText,
            validator: validator,
            autovalidateMode: autovalidateMode,
            clearable: clearable,
            prefixIcon: prefixIcon,
            readOnly: readOnly,
            style: style,
            initialValue: initialValue,
            suffixIcons: suffixIcons,
            onEditingComplete: onEditingComplete,
            textInputAction: textInputAction,
            inputDecorationTheme: inputDecorationTheme)));
    return this;
  }

  /// add a textfield to current row
  FormBuilder textField(String controlKey,
      {String hintText,
      String labelText,
      VoidCallback onTap,
      Key key,
      bool obscureText = false,
      int flex,
      int maxLines = 1,
      Widget prefixIcon,
      TextInputType keyboardType,
      int maxLength,
      ValueChanged<String> onChanged,
      FormFieldValidator<String> validator,
      AutovalidateMode autovalidateMode,
      bool clearable = false,
      bool passwordVisible = false,
      bool readOnly = false,
      bool visible = true,
      List<TextInputFormatter> inputFormatters,
      EdgeInsets padding,
      TextStyle style,
      String initialValue,
      ToolbarOptions toolbarOptions,
      bool selectAllOnFocus,
      List<Widget> suffixIcons,
      VoidCallback onEditingComplete,
      TextInputAction textInputAction,
      List<TextInputFormatter> textInputFormatters,
      InputDecorationTheme inputDecorationTheme}) {
    _builders.add(_FormItemWidget(visible, controlKey,
        flex: flex,
        child: ClearableTextFormField(
            key: key,
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
            inputFormatters: textInputFormatters,
            readOnly: readOnly,
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
  FormBuilder radioGroup(
    String controlKey,
    List<RadioItem> items, {
    Key key,
    String label,
    ValueChanged onChanged,
    bool readOnly = false,
    bool visible = true,
    FormFieldValidator validator,
    AutovalidateMode autovalidateMode,
    int split = 2,
    EdgeInsets padding,
    dynamic initialValue,
    bool inline,
    int flex = 0,
    EdgeInsets errorTextPadding,
  }) {
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: inline ? flex : 1,
      child: RadioGroup(
        List.of(items),
        key: key,
        label: label,
        validator: validator,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        split: split,
        readOnly: readOnly,
        initialValue: initialValue,
        inline: inline,
        errorTextPadding: errorTextPadding,
      ),
    ));
    if (!inline) nextLine();
    return this;
  }

  FormBuilder checkboxGroup(String controlKey, List<CheckboxItem> items,
      {Key key,
      String label,
      ValueChanged<List<int>> onChanged,
      FormFieldValidator<List<int>> validator,
      AutovalidateMode autovalidateMode,
      bool readOnly = false,
      bool visible = true,
      int split = 2,
      int flex = 0,
      EdgeInsets padding,
      List<int> initialValue,
      EdgeInsets errorTextPadding,
      bool inline = false}) {
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: inline ? flex : 1,
      child: CheckboxGroup(
        List.of(items),
        key: key,
        errorTextPadding: errorTextPadding,
        label: label,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        split: split,
        readOnly: readOnly,
        initialValue: initialValue,
        inline: inline,
      ),
    ));
    if (!inline) nextLine();
    return this;
  }

  FormBuilder textButton(String controlKey, VoidCallback onPressed,
      {Key key,
      String label,
      Widget child,
      int flex = 0,
      VoidCallback onLongPress,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets padding}) {
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: flex,
          padding: padding,
          child: CommonField(
            {
              'label': label,
              'child': child,
            },
            builder:
                (state, context, readOnly, stateMap, themeData, formThemeData) {
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

  FormBuilder datetimeField(String controlKey,
      {Key key,
      String labelText,
      String hintText,
      bool readOnly = false,
      bool visible = true,
      int flex = 1,
      DateTimeFormatter formatter,
      FormFieldValidator<DateTime> validator,
      bool useTime,
      EdgeInsets padding,
      TextStyle style,
      int maxLines = 1,
      ValueChanged<DateTime> onChanged,
      DateTime initialValue,
      InputDecorationTheme inputDecorationTheme}) {
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: flex,
          child: DateTimeFormField(
              key: key,
              hintText: hintText,
              labelText: labelText,
              formatter: formatter,
              validator: validator,
              useTime: useTime,
              readOnly: readOnly,
              style: style,
              maxLines: maxLines,
              initialValue: initialValue,
              inputDecorationTheme: inputDecorationTheme,
              onChanged: onChanged)),
    );
    return this;
  }

  FormBuilder selector(
    String controlKey, {
    String labelText,
    String hintText,
    bool readOnly = false,
    bool visible = true,
    bool clearable = true,
    FormFieldValidator validator,
    AutovalidateMode autovalidateMode,
    EdgeInsets padding,
    bool multi = false,
    ValueChanged<List> onChanged,
    List initialValue,
    SelectedChecker selectedChecker,
    SelectItemRender selectItemRender,
    SelectedItemRender selectedItemRender,
    SelectedSorter selectedSorter,
    SelectItemProvider selectItemProvider,
    SelectedItemLayoutType selectedItemLayoutType,
    QueryFormBuilder queryFormBuilder,
    OnSelectDialogShow onSelectDialogShow,
    VoidCallback onTap,
    InputDecorationTheme inputDecorationTheme,
  }) {
    nextLine();
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: 1,
          child: SelectorFormField(selectItemProvider,
              onChanged: onChanged,
              labelText: labelText,
              hintText: hintText,
              clearable: clearable,
              validator: validator,
              autovalidateMode: autovalidateMode,
              readOnly: readOnly,
              multi: multi,
              initialValue: initialValue,
              selectedChecker: selectedChecker,
              selectItemRender: selectItemRender,
              selectedItemRender: selectedItemRender,
              selectedSorter: selectedSorter,
              onTap: onTap,
              selectedItemLayoutType: selectedItemLayoutType,
              queryFormBuilder: queryFormBuilder,
              onSelectDialogShow: onSelectDialogShow,
              inputDecorationTheme: inputDecorationTheme)),
    );
    nextLine();
    return this;
  }

  FormBuilder divider(String controlKey,
      {double height = 1.0,
      bool visible = true,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 5)}) {
    nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: 1,
      padding: padding,
      child: CommonField(
        {'height': height ?? 1.0},
        readOnly: true,
        builder:
            (state, context, readOnly, stateMap, themeData, formThemeData) {
          return Divider(
            height: stateMap['height'],
          );
        },
      ),
    ));
    nextLine();
    return this;
  }

  FormBuilder switchGroup(
    String controlKey, {
    String label,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets padding,
    List<SwitchGroupItem> items,
    bool hasSelectAllSwitch,
    ValueChanged<List<int>> onChanged,
    FormFieldValidator<List<int>> validator,
    AutovalidateMode autovalidateMode,
    List<int> initialValue,
    EdgeInsets errorTextPadding,
    EdgeInsets selectAllPadding,
    bool inline = false,
    int flex = 1,
  }) {
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: inline ? flex : 1,
      padding: padding,
      child: SwitchGroupFormField(
        label: label,
        readOnly: readOnly,
        items: items ?? [],
        hasSelectAllSwitch: hasSelectAllSwitch ?? true,
        validator: validator,
        autovalidateMode: autovalidateMode,
        initialValue: initialValue,
        onChanged: onChanged,
        errorTextPadding: errorTextPadding,
        selectAllPadding: selectAllPadding,
      ),
    ));
    if (!inline) nextLine();
    return this;
  }

  FormBuilder switchInline(String controlKey,
      {bool visible = true,
      bool readOnly = false,
      EdgeInsets padding,
      int flex = 0,
      ValueChanged<bool> onChanged,
      FormFieldValidator<bool> validator,
      AutovalidateMode autovalidateMode,
      bool initialValue}) {
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: flex,
      child: SwitchInlineFormField(
        validator: validator,
        readOnly: readOnly,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        initialValue: initialValue ?? false,
      ),
    ));
    return this;
  }

  FormBuilder slider(String controlKey,
      {bool visible = true,
      bool readOnly = false,
      EdgeInsets padding,
      ValueChanged<double> onChanged,
      FormFieldValidator<double> validator,
      AutovalidateMode autovalidateMode,
      double initialValue,
      double min = 0,
      double max = 100,
      int divisions,
      String label,
      SubLabelRender subLabelRender,
      EdgeInsets contentPadding,
      bool inline = false,
      int flex}) {
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: inline ? flex : 1,
      child: SliderFormField(
        readOnly: readOnly,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        validator: validator,
        min: min,
        max: max,
        label: label,
        divisions: divisions,
        initialValue: initialValue ?? min,
        subLabelRender: subLabelRender,
        inline: inline,
        contentPadding: contentPadding,
      ),
    ));
    if (!inline) nextLine();
    return this;
  }

  FormBuilder rangeSlider(String controlKey,
      {bool visible = true,
      bool readOnly = false,
      EdgeInsets padding,
      ValueChanged<RangeValues> onChanged,
      FormFieldValidator<RangeValues> validator,
      AutovalidateMode autovalidateMode,
      RangeValues initialValue,
      double min = 0,
      double max = 100,
      int divisions,
      String label,
      RangeSubLabelRender rangeSubLabelRender,
      EdgeInsets contentPadding,
      bool inline = false}) {
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: 1,
      child: RangeSliderFormField(
        readOnly: readOnly,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        validator: validator,
        min: min,
        max: max,
        label: inline ? null : label,
        divisions: divisions,
        initialValue: initialValue ?? RangeValues(min, max),
        inline: inline ?? false,
        rangeSubLabelRender: rangeSubLabelRender,
        contentPadding: contentPadding,
      ),
    ));
    if (!inline) nextLine();
    return this;
  }

  FormBuilder commonField(String controlKey,
      {Key key,
      int flex = 0,
      bool visible = true,
      EdgeInsets padding,
      @required CommonField commonField,
      bool inline}) {
    return _baseField(controlKey,
        key: key,
        flex: flex,
        visible: visible,
        padding: padding,
        baseField: commonField,
        inline: inline);
  }

  FormBuilder valueField(String controlKey,
      {Key key,
      int flex = 0,
      bool visible = true,
      EdgeInsets padding,
      @required ValueField valueField,
      bool inline}) {
    return _baseField(controlKey,
        key: key,
        flex: flex,
        visible: visible,
        padding: padding,
        baseField: valueField,
        inline: inline);
  }

  FormBuilder _baseField(String controlKey,
      {Key key,
      int flex = 0,
      bool visible = true,
      EdgeInsets padding,
      @required _BaseField baseField,
      bool inline}) {
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(
      _FormItemWidget(visible, controlKey,
          key: key, flex: flex, padding: padding, child: baseField),
    );
    if (!inline) nextLine();
    return this;
  }

  static List<CheckboxItem> toCheckboxItems(List<String> items,
      {EdgeInsets padding}) {
    return items.map((e) => CheckboxItem(e, padding: padding)).toList();
  }

  static List<RadioItem> toRadioItems(List<String> items,
      {EdgeInsets padding}) {
    return items.map((e) => RadioItem(e, e, padding: padding)).toList();
  }

  static SelectItemProvider toSelectItemProvider(List items) {
    return (page, params) {
      return Future.delayed(Duration.zero, () {
        return SelectItemPage(items, items.length);
      });
    };
  }

  static List<SwitchGroupItem> toSwitchGroupItems(List<String> items,
      {EdgeInsets padding}) {
    return items.map((e) => SwitchGroupItem(e, padding: padding)).toList();
  }

  @override
  State<StatefulWidget> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  List<List<_FormItemWidget>> builderss;
  @override
  void initState() {
    super.initState();
    builderss = widget._builderss;
    widget._formController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget._formController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FormBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget._builderss, oldWidget._builderss)) {
      builderss = widget._builderss;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.nextLine();

    if (widget._formController.themeData == null) {
      widget._formController.themeData = DefaultFormThemeData(context);
    }

    List<Row> rows = [];
    for (List<_FormItemWidget> builders in builderss) {
      rows.add(Row(
        children: builders,
      ));
    }

    return Theme(
        data: widget._formController.themeData.themeData,
        child: _FormControllerScope(widget._formController,
            child: Visibility(
              maintainState: true,
              child: Column(
                children: rows,
              ),
              visible: widget._formController._visible,
            )));
  }
}

class FormControllerDelegate {
  _FormController _formController;
  FormControllerDelegate._(_FormController formController)
      : _formController = formController;
  FormControllerDelegate() : _formController = _FormController();

  static FormControllerDelegate copyTheme(BuildContext context) {
    _FormController formController = _FormController();
    formController._themeData = _FormController.of(context)._themeData;
    return FormControllerDelegate._(formController);
  }

  ///  whether form is visible or not
  bool get visible => _formController.visible;

  /// set form visible after build
  set visible(bool visible) => _formController.visible = visible;

  ///  whether form is readOnly or not
  bool get readOnly => _formController.readOnly;
  set readOnly(bool readOnly) => _formController.readOnly = readOnly;

  /// get current FormThemeData
  FormThemeData get themeData => _formController.themeData;

  /// set a new theme to form
  ///
  /// this will rebuild all fields
  set themeData(FormThemeData themeData) =>
      _formController.themeData = themeData;

  /// request focus on form field
  ///
  /// nothing  happened if controlKey is not exists or field is not focusable
  void requestFocus(String controlKey) =>
      _formController.requestFocus(controlKey);

  /// unfocus
  ///
  /// nothing  happened if controlKey is not exists or field is not focusable
  void unfocus(String controlKey) => _formController.unfocus(controlKey);

  /// listen form field's focus change
  void onFocusChange(String controlKey, FocusChanged onChanged) =>
      _formController.onFocusChange(controlKey, onChanged);

  /// stop listen form field's focus change
  void offFocusChange(String controlKey, FocusChanged onChanged) =>
      _formController.offFocusChange(controlKey, onChanged);

  void rebuild(String controlKey, Map<String, dynamic> map) =>
      _formController.rebuild(controlKey, map);
  void update(String controlKey, Map<String, dynamic> map) =>
      _formController.update(controlKey, map);
  void removeState(String controlKey, Set<String> stateKeys) =>
      _formController.removeState(controlKey, stateKeys);

  void setVisible(String controlKey, bool visible) =>
      _formController.setVisible(controlKey, visible);

  /// whether form field is visible or not
  bool isVisible(String controlKey) => _formController.isVisible(controlKey);

  void setReadOnly(String controlKey, bool readOnly) =>
      _formController.setReadOnly(controlKey, readOnly);

  /// whether form field is readOnly or not
  bool isReadOnly(String controlKey) => _formController.isReadOnly(controlKey);

  /// set form field's padding
  void setPadding(String controlKey, EdgeInsets padding) =>
      _formController.setPadding(controlKey, padding);

  /// get form field's padding
  EdgeInsets getPadding(String controlKey) =>
      _formController.getPadding(controlKey);

  /// get value field's value
  dynamic getValue(String controlKey) => _formController.getValue(controlKey);

  /// set value
  ///
  /// [trigger] whether trigger onChanged
  void setValue(String controlKey, dynamic value, {bool trigger = true}) =>
      _formController.setValue(controlKey, value, trigger: trigger);

  /// get form data
  Map<String, dynamic> getData() => _formController.getData();

  /// reset form
  ///
  /// **only reset all value fields**
  void reset() => _formController.reset();

  /// reset on field
  ///
  /// **will set field value to it's initialValue**
  void reset1(String controlKey) => _formController.reset1(controlKey);

  /// validate form and return is valid or not
  ///
  /// **will display error if invalid ,
  /// if you only want to know the form is valid or not ,
  /// use [isValid() instead**
  bool validate() => _formController.validate();

  /// validate a form field and return is valid or not
  ///
  /// **will display error if invalid ,
  /// if you only want to know the field is valid or not ,
  /// use [isValid(String controlKey)] instead**
  bool validate1(String controlKey) => _formController.validate1(controlKey);

  /// whether form is valid or not
  ///
  /// **only check is valid or not , won't show error**
  bool get isValid => _formController.isValid;

  /// whether a form field is valid or not
  ///
  /// **only check is valid or not , won't show error**
  bool isValid1(String controlkey) => _formController.isValid1(controlkey);

  void setAutovalidateMode(
          String controlKey, AutovalidateMode autovalidateMode) =>
      _formController.setAutovalidateMode(controlKey, autovalidateMode);

  void setInitialValue(String controlKey, dynamic initialValue) =>
      _formController.setInitialValue(controlKey, initialValue);

  /// set selection on form field
  ///
  /// **only works on textfield & numberfield**
  void setSelection(String controlKey, int start, int end) =>
      _formController.setSelection(controlKey, start, end);

  /// select all text in form field
  ///
  /// **only works on textfield & numberfield**
  void selectAll(String controlKey) => _formController.selectAll(controlKey);

  /// get SubController
  ///
  /// used to control sub item's state (like radiogroup's radio item)
  SubControllerDelegate getSubController(String controlKey) =>
      _formController.getSubController(controlKey);

  /// remove a field completely
  void remove(String controlKey, {VoidCallback removed}) =>
      _formController.remove(controlKey, removed: removed);
}

class _FormController extends ChangeNotifier {
  bool _visible = true;
  bool _readOnly = false;
  FormThemeData _themeData;

  final Map<String, ValueNotifier> controllers = {};
  final Map<String, FocusNode> focusNodes = {};
  final Map<String, _FormItemWidgetState> states = {};
  final Map<String, ValueFieldState> valueFieldStates = {};
  final Map<String, CommonFieldState> commonFieldStates = {};
  final Map<String, List<FocusChanged>> focusChangeMap = {};

  static _FormController of(BuildContext context) {
    return _FormControllerScope.of(context).formController;
  }

  ValueNotifier newController(String controlKey, ControllerProvider provider) {
    return controllers.putIfAbsent(controlKey, () => provider());
  }

  FocusNodes newFocusNode(String controlKey) {
    FocusNodes focusNode = focusNodes[controlKey];
    if (focusNode != null) {
      return focusNode;
    }
    focusNode = FocusNodes._((key, hasFocus) {
      List<FocusChanged> list = focusChangeMap[controlKey];
      if (list == null || list.isEmpty) return;
      bool hasFocus = focusNode.hasFocus;
      for (FocusChanged focusChanged in list) {
        if (focusChanged.subChanged != null) {
          focusChanged.subChanged(key, hasFocus);
        }
      }
    });
    focusNodes[controlKey] = focusNode;
    focusNode.addListener(() {
      List<FocusChanged> list = focusChangeMap[controlKey];
      if (list == null || list.isEmpty) return;
      bool hasFocus = focusNode.hasFocus;
      for (FocusChanged focusChanged in list) {
        if (focusChanged.rootChanged != null) {
          focusChanged.rootChanged(hasFocus);
        }
      }
    });
    return focusNode;
  }

  FormThemeData get themeData => _themeData;

  set themeData(FormThemeData theme) {
    if (theme != null) {
      _themeData = theme;
      notifyListeners();
    }
  }

  bool get visible => _visible;

  set visible(bool visible) {
    if (_visible != visible) {
      _visible = visible;
      notifyListeners();
    }
  }

  bool get readOnly => _readOnly;

  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      _readOnly = readOnly;
      valueFieldStates.forEach((key, value) {
        value._readOnly = readOnly;
      });
      commonFieldStates.forEach((key, value) {
        value._readOnly = readOnly;
      });
    }
  }

  void requestFocus(String controlKey) {
    FocusNodes focusNode = focusNodes[controlKey];
    if (focusNode == null) return;
    focusNode.requestFocus();
  }

  void unfocus(String controlKey) {
    FocusNodes focusNode = focusNodes[controlKey];
    if (focusNode == null) return;
    focusNode.unfocus();
  }

  void onFocusChange(String controlKey, FocusChanged onChanged) {
    List<FocusChanged> list = focusChangeMap[controlKey];
    if (list == null) {
      focusChangeMap[controlKey] = [onChanged];
    } else {
      list.add(onChanged);
    }
  }

  void offFocusChange(String controlKey, FocusChanged onChanged) {
    List<FocusChanged> list = focusChangeMap[controlKey];
    if (list == null) return;
    list.remove(onChanged);
  }

  void rebuild(String controlKey, Map<String, dynamic> map) {
    _BaseFieldState state = getBaseFieldState(controlKey);
    if (state == null) return;
    state._rebuild(map);
  }

  void update(String controlKey, Map<String, dynamic> map) {
    _BaseFieldState state = getBaseFieldState(controlKey);
    if (state == null) return;
    state._update(map);
  }

  void setVisible(String controlKey, bool visible) {
    _FormItemWidgetState state = states[controlKey];
    if (state == null) return;
    state.visible = visible;
  }

  void setReadOnly(String controlKey, bool readOnly) {
    _BaseFieldState state = getBaseFieldState(controlKey);
    if (state == null) return;
    state._readOnly = readOnly;
  }

  void setPadding(String controlKey, EdgeInsets padding) {
    _FormItemWidgetState state = states[controlKey];
    if (state == null) return;
    state.padding = padding;
  }

  EdgeInsets getPadding(String controlKey) {
    _FormItemWidgetState state = states[controlKey];
    if (state == null) return null;
    return state.padding;
  }

  bool isVisible(String controlKey) {
    _FormItemWidgetState state = states[controlKey];
    return state == null ? false : state.visible;
  }

  bool isReadOnly(String controlKey) {
    _BaseFieldState state = getBaseFieldState(controlKey);
    return state == null ? false : state.readOnly;
  }

  Map<String, dynamic> getData({bool removeNull = true}) {
    Map<String, dynamic> map = {};
    valueFieldStates.values.forEach((element) {
      dynamic value = element.value;
      if (removeNull && value == null) return;
      map[element.controlKey] = value;
    });
    return map;
  }

  dynamic getValue(String controlKey) {
    ValueFieldState state = valueFieldStates[controlKey];
    if (state == null) return null;
    return state.value;
  }

  void setValue(String controlKey, dynamic value, {bool trigger = true}) {
    ValueFieldState state = valueFieldStates[controlKey];
    if (state == null) return;
    state.doChangeValue(value, trigger: trigger);
  }

  void reset() {
    for (final FormFieldState<dynamic> field in valueFieldStates.values)
      field.reset();
  }

  void reset1(String controlKey) {
    valueFieldStates.values
        .where((element) => (element.controlKey == controlKey))
        .forEach((element) {
      element.reset();
    });
  }

  bool validate() {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in valueFieldStates.values)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  bool validate1(String controlKey) {
    ValueFieldState state = valueFieldStates[controlKey];
    if (state == null) return true;
    return state.validate();
  }

  bool get isValid {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in valueFieldStates.values)
      hasError = !field.isValid || hasError;
    return !hasError;
  }

  bool isValid1(String controlKey) {
    ValueFieldState state = valueFieldStates[controlKey];
    if (state == null) return true;
    return state.isValid;
  }

  void setSelection(String controlKey, int start, int end) {
    TextSelectionMixin controller = getTextSelectionMixin(controlKey);
    if (controller != null) controller.setSelection(start, end);
  }

  void selectAll(String controlKey) {
    TextSelectionMixin controller = getTextSelectionMixin(controlKey);
    if (controller != null) controller.selectAll();
  }

  void remove(String controlKey, {VoidCallback removed}) {
    _FormItemWidgetState state = states[controlKey];
    if (state == null) return;
    state.remove();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusChangeMap.remove(controlKey);
      ValueNotifier controller = controllers.remove(controlKey);
      if (controller != null) controller.dispose();
      FocusNode focusNode = focusNodes.remove(controlKey);
      if (focusNode != null) focusNode.dispose();
      states.remove(controlKey);
      valueFieldStates.remove(controlKey);
      commonFieldStates.remove(controlKey);
      if (removed != null) removed();
    });
  }

  void removeState(String controlKey, Set<String> stateKeys) {
    _BaseFieldState state = getBaseFieldState(controlKey);
    if (state == null) return;
    state._remove(stateKeys);
  }

  void setAutovalidateMode(
      String controlkey, AutovalidateMode autovalidateMode) {
    ValueFieldState state = valueFieldStates[controlkey];
    if (state == null) return;
    state._setAutoValidateMode(autovalidateMode);
  }

  void setInitialValue(String controlkey, dynamic initialValue) {
    ValueFieldState state = valueFieldStates[controlkey];
    if (state == null) return;
    state._setInitialValue(initialValue);
  }

  SubControllerDelegate getSubController(String controlKey) {
    var controller = controllers[controlKey];
    if (controller != null && controller is SubController) {
      return SubControllerDelegate._(controller);
    }
    return null;
  }

  @override
  void dispose() {
    focusChangeMap.clear();
    focusNodes.values.forEach((element) {
      element.dispose();
    });
    controllers.values.forEach((element) {
      element.dispose();
    });
    focusNodes.clear();
    controllers.clear();
    states.clear();
    valueFieldStates.clear();
    commonFieldStates.clear();
    super.dispose();
  }

  _BaseFieldState getBaseFieldState(String controlKey) {
    return valueFieldStates[controlKey] ?? commonFieldStates[controlKey];
  }

  TextSelectionMixin getTextSelectionMixin(String controlKey) {
    var controller = controllers[controlKey];
    if (controller != null && controller is TextSelectionMixin)
      return controller as TextSelectionMixin;
    return null;
  }
}

class _FormItemWidget extends StatefulWidget {
  final String controlKey;
  final int flex;
  final bool visible;
  final Widget child;
  final EdgeInsets padding;
  const _FormItemWidget(this.visible, this.controlKey,
      {Key key, this.flex, this.child, this.padding})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormItemWidgetState();
}

class _FormItemWidgetState extends State<_FormItemWidget> {
  bool _visible;
  int _flex;
  EdgeInsets _padding;
  bool _removed = false;

  get visible => _visible;
  set visible(bool visible) {
    if (!_removed && visible != _visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  get flex => _flex;
  set flex(int flex) {
    if (!_removed && flex != _flex) {
      setState(() {
        _flex = flex;
      });
    }
  }

  get padding =>
      _padding ??
      _FormController.of(context)._themeData.padding ??
      EdgeInsets.zero;
  set padding(EdgeInsets padding) {
    if (!_removed && _padding != padding) {
      setState(() {
        _padding = padding;
      });
    }
  }

  bool get removed => _removed;
  void remove() {
    if (_removed) return;
    setState(() {
      _removed = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _visible = widget.visible ?? true;
    _flex = widget.flex ?? 1;
    _padding = widget.padding;
  }

  @override
  void deactivate() {
    _FormController.of(context).states.remove(widget.controlKey);
    super.deactivate();
  }

  @override
  void didUpdateWidget(_FormItemWidget old) {
    super.didUpdateWidget(old);
    _flex = widget.flex ?? 1;
    _padding = widget.padding;
    _visible = widget.visible ?? true;
  }

  @override
  Widget build(BuildContext context) {
    if (_removed) {
      return SizedBox.shrink();
    }
    _FormController.of(context).states[widget.controlKey] = this;
    if (widget.controlKey == 'username') print(flex);
    return _InheritedControlKey(widget.controlKey,
        child: Flexible(
          fit: visible ? FlexFit.tight : FlexFit.loose,
          child: Visibility(
              maintainState: true,
              visible: visible,
              child: Padding(
                padding: padding,
                child: widget.child,
              )),
          flex: flex,
        ));
  }
}

abstract class _BaseField<T, K extends _BaseFieldState<T>>
    extends FormField<T> {
  final Map<String, dynamic> _initStateMap;
  _BaseField(this._initStateMap,
      {Key key,
      FormFieldValidator<T> validator,
      AutovalidateMode autovalidateMode,
      bool readOnly,
      _FieldBuilder<T, K> builder,
      T initialValue})
      : super(
            key: key,
            builder: (field) {
              K state = field;
              FormThemeData formThemeData =
                  _FormController.of(state.context).themeData;
              return builder(state, state.context, state.readOnly,
                  state._stateMap, formThemeData.themeData, formThemeData);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue) {
    _initStateMap[FormBuilder.readOnlyKey] = readOnly;
  }
}

class ValueField<T> extends _BaseField<T, ValueFieldState<T>> {
  final ValueChanged<T> onChanged;
  final NullValueReplace<T> replace;
  final ControllerProvider<T> controllerProvider;

  @override
  AutovalidateMode get autovalidateMode =>
      _initStateMap[FormBuilder.autovalidateModeKey] ?? super.autovalidateMode;
  @override
  T get initialValue =>
      _initStateMap[FormBuilder.initialValueKey] ?? super.initialValue;

  ValueField(this.controllerProvider, Map<String, dynamic> initStateMap,
      {Key key,
      this.replace,
      this.onChanged,
      @required _FieldBuilder<T, ValueFieldState<T>> builder,
      FormFieldValidator<T> validator,
      AutovalidateMode autovalidateMode,
      bool readOnly,
      T initialValue})
      : super(initStateMap,
            key: key,
            builder: builder,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue) {
    super._initStateMap[FormBuilder.autovalidateModeKey] = autovalidateMode;
    super._initStateMap[FormBuilder.initialValueKey] = initialValue;
  }

  @override
  ValueFieldState<T> createState() => ValueFieldState<T>();
}

class _BaseFieldState<T> extends FormFieldState<T> {
  Map<String, dynamic> _state;
  String controlKey;
  _FormController _formController;

  /// current widget whether is readonly or not
  ///
  /// **call this method in initControl()**
  bool get readOnly =>
      _formController._readOnly || (getState(FormBuilder.readOnlyKey) ?? false);

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  ///
  /// **call this method in initControl()**
  FocusNodes get focusNode => _formController.newFocusNode(controlKey);

  Map<String, dynamic> get _getInitStateMap =>
      (widget as _BaseField)._initStateMap;

  @override
  void initState() {
    super.initState();
    _state = {};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controlKey == null) {
      controlKey = _InheritedControlKey.of(context).controlKey;
      _formController = _FormController.of(context);
      initControl();
    }
  }

  /// override this method if you want to safely get focusnode & readonly
  ///
  /// this method only run once in state's lifecycle
  @mustCallSuper
  void initControl() {}

  set _readOnly(bool readOnly) {
    _update({FormBuilder.readOnlyKey: readOnly});
  }

  /// get state value
  ///
  /// it's equals to build method's stateMap[stateKey]
  getState(String stateKey) {
    return _state.containsKey(stateKey)
        ? _state[stateKey]
        : _getInitStateMap[stateKey];
  }

  Map<String, dynamic> get _stateMap {
    Map<String, dynamic> map = {};
    _getInitStateMap.forEach((key, value) {
      map[key] = _state.containsKey(key) ? _state[key] : value;
    });
    return map;
  }

  void _rebuild(Map<String, dynamic> state) {
    setState(() {
      this._state = state ?? {};
    });
  }

  void _update(Map<String, dynamic> state) {
    if (state == null) return;
    setState(() {
      state.forEach((key, value) {
        _state[key] = value;
      });
    });
  }

  void _remove(Set<String> stateKeys) {
    if (stateKeys == null || stateKeys.isEmpty) return;
    setState(() {
      stateKeys.forEach((element) {
        _state.remove(element);
      });
    });
  }
}

class ValueFieldState<T> extends _BaseFieldState<T> {
  ValueField<T> get widget => super.widget;
  ValueChanged<T> get onChanged => widget.onChanged;

  /// **you need to get controller in initControl()**
  ValueNotifier<T> controller;

  void _setAutoValidateMode(AutovalidateMode autovalidateMode) {
    setState(() {
      widget._initStateMap[FormBuilder.autovalidateModeKey] = autovalidateMode;
    });
  }

  void _setInitialValue(T initialValue) {
    setState(() {
      widget._initStateMap[FormBuilder.initialValueKey] = initialValue;
    });
  }

  @override
  void initControl() {
    super.initControl();
    controller =
        _formController.newController(controlKey, widget.controllerProvider);
    controller.addListener(handleUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(handleUpdate);
    super.dispose();
  }

  @override
  void deactivate() {
    _formController.valueFieldStates.remove(controlKey);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _formController.valueFieldStates[controlKey] = this;
    return super.build(context);
  }

  @override
  void didChange(T value) {
    doChangeValue(value);
  }

  void doChangeValue(T value, {bool trigger = true}) {
    T replaceValue = getReplacedValue(value);
    super.didChange(replaceValue);
    if (controller.value != replaceValue) {
      controller.value = replaceValue;
      if (onChanged != null && trigger) {
        onChanged(replaceValue);
      }
    }
  }

  @override
  void reset() {
    super.reset();
    T value = getReplacedValue(widget.initialValue);
    controller.value = value;
    if (onChanged != null) {
      onChanged(controller.value);
    }
  }

  @protected
  T getReplacedValue(T value) {
    if (value == null && widget.replace != null) {
      return widget.replace();
    }
    return value;
  }

  void handleUpdate() {
    setState(() {});
  }
}

class CommonField extends _BaseField<Null, CommonFieldState> {
  CommonField(
    Map<String, dynamic> initStateMap, {
    Key key,
    @required _FieldBuilder<Null, CommonFieldState> builder,
    bool readOnly,
  }) : super(initStateMap, key: key, readOnly: readOnly, builder: builder);

  @override
  CommonFieldState createState() => CommonFieldState();
}

class CommonFieldState extends _BaseFieldState<Null> {
  @override
  void deactivate() {
    _formController.commonFieldStates.remove(controlKey);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _formController.commonFieldStates[controlKey] = this;
    return super.build(context);
  }

  @override
  Null get value => null;
  @override
  String get errorText => null;
  @override
  bool get hasError => false;
  @override
  bool get isValid => true;
  @override
  void save() {}
  @override
  void reset() {}
  @override
  bool validate() => false;
  @override
  void didChange(Null value) {}
  @override
  @protected
  void setValue(Null value) {}
}

mixin TextSelectionMixin {
  void setSelection(int start, int end);
  void selectAll();

  static void setSelectionWithTextEditingController(
      int start, int end, TextEditingController controller) {
    int extendsOffset =
        end > controller.text.length ? controller.text.length : end;
    int baseOffset = start < 0
        ? 0
        : start > extendsOffset
            ? extendsOffset
            : start;
    controller.selection =
        TextSelection(baseOffset: baseOffset, extentOffset: extendsOffset);
  }
}

class _FormControllerScope extends InheritedWidget {
  final _FormController formController;
  final Widget child;

  _FormControllerScope(this.formController, {this.child}) : super(child: child);

  static _FormControllerScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormControllerScope>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class _InheritedControlKey extends InheritedWidget {
  final Widget child;
  final String controlKey;

  _InheritedControlKey(this.controlKey, {this.child}) : super(child: child);

  static _InheritedControlKey of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedControlKey>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

abstract class SubControllableItem {
  final String controlKey;
  final Map<String, dynamic> initStateMap;
  SubControllableItem(this.controlKey, this.initStateMap);
}

//used to control form field's item's state
class SubController<T> extends ValueNotifier<T> {
  final Map<String, Map<String, dynamic>> states = {};
  final Map<String, Map<String, dynamic>> _initStates = {};

  SubController(value) : super(value);

  void remove(String controlKey, Set<String> stateKeys) {
    var state = states[controlKey];
    if (state == null) return;
    if (stateKeys == null || stateKeys.isEmpty) return;
    stateKeys.forEach((element) {
      state.remove(element);
    });
    notifyListeners();
  }

  void update1(String controlKey, Map<String, dynamic> state) {
    _doUpdate(controlKey, state);
    notifyListeners();
  }

  void update(Map<String, Map<String, dynamic>> states) {
    if (states == null) return;
    states.forEach((key, value) {
      _doUpdate(key, value);
    });
    notifyListeners();
  }

  dynamic getState(String controlKey, String key) {
    var state = states[controlKey];
    return state == null
        ? null
        : state.containsKey(key)
            ? state[key]
            : _initStates[controlKey][key];
  }

  Map<String, dynamic> getUpdatedMap(SubControllableItem item) {
    if (item == null) {
      return null;
    }
    if (item.controlKey == null) return item.initStateMap;
    var currentStateMap = states[item.controlKey];
    if (currentStateMap == null) return _initStates[item.controlKey];
    Map<String, dynamic> updated = {};
    _initStates[item.controlKey].forEach((key, value) {
      updated[key] =
          currentStateMap.containsKey(key) ? currentStateMap[key] : value;
    });
    return updated;
  }

  void init(List<SubControllableItem> items) {
    _initStates.clear();
    items.forEach((element) {
      if (element.controlKey != null) {
        _initStates[element.controlKey] = element.initStateMap;
        states.putIfAbsent(element.controlKey, () => {});
      }
    });
    states.removeWhere(
        (key, value) => !items.any((element) => element.controlKey == key));
  }

  void _doUpdate(String controlKey, Map<String, dynamic> state) {
    if (state == null) return;
    var oldState = states[controlKey];
    if (oldState == null) return;
    var initState = _initStates[controlKey];
    state.forEach((key, value) {
      if (!initState.containsKey(key)) return;
      oldState[key] = value;
    });
  }

  @override
  void dispose() {
    _initStates.clear();
    states.clear();
    super.dispose();
  }
}

class SubControllerDelegate {
  final SubController _controller;

  SubControllerDelegate._(this._controller);

  /// update sub item by it's controlkey
  ///
  /// this will rebuild whole form field , not only the sub item
  void update1(String controlKey, Map<String, dynamic> state) {
    _controller.update1(controlKey, state);
  }

  /// if you want to update several sub items at one time ,
  /// you should call this method for better performance
  /// due to it's only rebuild form field once
  void update(Map<String, Map<String, dynamic>> states) {
    _controller.update(states);
  }

  dynamic getState(String controlKey, String key) {
    return _controller.getState(controlKey, key);
  }

  void setVisible(String controlKey, bool visible) {
    _controller.update1(controlKey, {
      FormBuilder.visibleKey: visible,
    });
  }

  void setReadOnly(String controlKey, bool readOnly) {
    _controller.update1(controlKey, {
      FormBuilder.readOnlyKey: readOnly,
    });
  }

  bool isVisible(String controlKey) {
    return _controller.getState(controlKey, FormBuilder.visibleKey);
  }

  bool isReadOnly(String controlKey) {
    return _controller.getState(controlKey, FormBuilder.readOnlyKey);
  }

  bool hasState(String controlKey) {
    return _controller._initStates.containsKey(controlKey);
  }
}

/// used to listen focus change
class FocusChanged {
  final ValueChanged<bool> rootChanged;
  final SubFocusChanged subChanged;
  FocusChanged({this.rootChanged, this.subChanged});
}

class FocusNodes extends FocusNode {
  final Map<String, FocusNode> _nodes = {};
  final SubFocusChanged _subChanged;

  FocusNodes._(this._subChanged);

  /// create a new focus node if not exists
  ///
  /// return old FocusNode if it is exists
  ///
  /// **do not dispose it by yourself,it will auto dispose **
  FocusNode newFocusNode(String key) {
    assert(_nodes != null);
    FocusNode focusNode = _nodes[key];
    if (focusNode == null) {
      focusNode = new FocusNode();
      focusNode.addListener(() {
        _subChanged(key, focusNode.hasFocus);
      });
      _nodes[key] = focusNode;
    }
    return focusNode;
  }

  @override
  void dispose() {
    super.dispose();
    _nodes.values.forEach((element) {
      element.dispose();
    });
    _nodes.clear();
  }
}
