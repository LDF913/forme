import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'switch_group.dart';
import 'checkbox_group.dart';
import 'form_theme.dart';
import 'text_field.dart';
import 'radio_group.dart';
import 'selector.dart';
import 'slider.dart';

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

  FormBuilder nextLine() {
    if (_builders.length > 0) {
      _builderss.add(List.of(_builders));
      _builders.clear();
    }
    return this;
  }

  FormBuilder theme(FormThemeData themeData) {
    _formController._themeData = themeData;
    return this;
  }

  FormBuilder readOnly(bool readOnly) {
    _formController._readOnly = readOnly;
    return this;
  }

  FormBuilder visible(bool visible) {
    _formController._visible = visible;
    return this;
  }

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
    NumberController controller = _formController.newController(
        controlKey, () => NumberController(value: initialValue));
    FocusNode focusNode = _formController.newFocusNode(controlKey);
    _builders.add(_FormItemWidget(visible, controlKey,
        flex: flex,
        child: NumberFormField(controller, focusNode,
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
    TextController controller = _formController.newController(
        controlKey, () => TextController(value: initialValue));
    FocusNode focusNode = _formController.newFocusNode(controlKey);
    _builders.add(_FormItemWidget(visible, controlKey,
        flex: flex,
        child: ClearableTextFormField(controller, focusNode,
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

  FormBuilder radioGroup(
    String controlKey,
    List<RadioItem> items, {
    Key key,
    String label,
    RadioGroupController controller,
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
    RadioGroupController controller = _formController.newController(
        controlKey, () => RadioGroupController(value: initialValue));
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: inline ? flex : 1,
      child: RadioGroup(
        List.of(items),
        controller,
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
    CheckboxGroupController controller = _formController.controllers
        .putIfAbsent(
            controlKey, () => CheckboxGroupController(value: initialValue));
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: inline ? flex : 1,
      child: CheckboxGroup(
        List.of(items),
        controller,
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
    DateTimeController controller = _formController.controllers
        .putIfAbsent(controlKey, () => DateTimeController(value: initialValue));
    FocusNode focusNode = _formController.newFocusNode(controlKey);
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: flex,
          child: DateTimeFormField(controller, focusNode,
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
    SelectorController controller = _formController.controllers
        .putIfAbsent(controlKey, () => SelectorController(value: initialValue));
    FocusNode focusNode = _formController.newFocusNode(controlKey);
    nextLine();
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: 1,
          child: SelectorFormField(focusNode, controller, selectItemProvider,
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
    bool selectAllDivier,
    EdgeInsets selectAllPadding,
  }) {
    SwitchGroupController controller = _formController.newController(
        controlKey, () => SwitchGroupController(value: initialValue));
    nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: 1,
      padding: padding,
      child: SwitchGroupFormField(
        controller,
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
    nextLine();
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
    SwitchController controller = _formController.controllers
        .putIfAbsent(controlKey, () => SwitchController(value: initialValue));
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: flex,
      child: SwitchInlineFormField(
        controller,
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
      bool inline = false}) {
    SliderController controller = _formController.newController(
        controlKey, () => SliderController(value: initialValue ?? min));
    FocusNode focusNode = _formController.newFocusNode(controlKey);
    inline ??= false;
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: 1,
      child: SliderFormField(
        controller,
        focusNode,
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
    RangeSliderController controller = _formController.newController(
        controlKey,
        () => RangeSliderController(
            value: initialValue ?? RangeValues(min, max)));
    if (!inline) nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: 1,
      child: RangeSliderFormField(
        controller,
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
      bool readOnly = false,
      bool visible = true,
      EdgeInsets padding,
      @required CommonField commonField}) {
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: flex, padding: padding, child: commonField),
    );
    return this;
  }

  static List<CheckboxItem> toCheckboxItems(List<String> items) {
    return items.map((e) => CheckboxItem(e)).toList();
  }

  static List<RadioItem> toRadioItems(List<String> items) {
    return items.map((e) => RadioItem(e, e)).toList();
  }

  static SelectItemProvider toSelectItemProvider(List items) {
    return (page, params) {
      return Future.delayed(Duration.zero, () {
        return SelectItemPage(items, items.length);
      });
    };
  }

  static List<SwitchGroupItem> toSwitchGroupItems(List<String> items) {
    return items.map((e) => SwitchGroupItem(e)).toList();
  }

  @override
  State<StatefulWidget> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    widget.nextLine();

    if (widget._formController.themeData == null) {
      widget._formController.themeData = DefaultFormThemeData(context);
    }

    List<Row> rows = [];
    for (List<_FormItemWidget> builders in widget._builderss) {
      rows.add(Row(
        children: builders,
      ));
    }

    return Theme(
        data: widget._formController.themeData.themeData,
        child: _InheritedFormController(widget._formController,
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

  static FormControllerDelegate of(BuildContext context) {
    return FormControllerDelegate._(_FormController.of(context));
  }

  FormControllerDelegate copyTheme() {
    _FormController formController = _FormController();
    formController._themeData = _formController._themeData;
    return FormControllerDelegate._(formController);
  }

  bool get visible => _formController.visible;
  set visible(bool visible) => _formController.visible = visible;
  bool get readOnly => _formController.readOnly;
  set readOnly(bool readOnly) => _formController.readOnly = readOnly;

  FormThemeData get themeData => _formController.themeData;
  set themeData(FormThemeData themeData) =>
      _formController.themeData = themeData;

  void requestFocus(String controlKey) =>
      _formController.requestFocus(controlKey);
  void unfocus(String controlKey) => _formController.unfocus(controlKey);
  void onFocusChange(String controlKey, ValueChanged<bool> onChanged) =>
      _formController.onFocusChange(controlKey, onChanged);
  void offFocusChange(String controlKey, ValueChanged<bool> onChanged) =>
      _formController.offFocusChange(controlKey, onChanged);

  void rebuild(String controlKey, Map<String, dynamic> map) =>
      _formController.rebuild(controlKey, map);
  void update(String controlKey, Map<String, dynamic> map) =>
      _formController.update(controlKey, map);
  void removeState(String controlKey, Set<String> stateKeys) =>
      _formController.removeState(controlKey, stateKeys);

  void setVisible(String controlKey, bool visible) =>
      _formController.setVisible(controlKey, visible);
  bool isVisible(String controlKey) => _formController.isVisible(controlKey);

  void setReadOnly(String controlKey, bool readOnly) =>
      _formController.setReadOnly(controlKey, readOnly);
  bool isReadOnly(String controlKey) => _formController.isReadOnly(controlKey);

  void setPadding(String controlKey, EdgeInsets padding) =>
      _formController.setPadding(controlKey, padding);
  EdgeInsets getPadding(String controlKey) =>
      _formController.getPadding(controlKey);

  void setInitialValue(String controlKey, initialValue) =>
      _formController.setInitialValue(controlKey, initialValue);
  void setAutovalidateMode(
          String controlKey, AutovalidateMode autovalidateMode) =>
      _formController.setAutovalidateMode(controlKey, autovalidateMode);

  dynamic getValue(String controlKey) => _formController.getValue(controlKey);
  void setValue(String controlKey, dynamic value, {bool trigger = true}) =>
      _formController.setValue(controlKey, value, trigger: trigger);
  Map<String, dynamic> getData() => _formController.getData();

  void reset() => _formController.reset();
  void reset1(String controlKey) => _formController.reset1(controlKey);

  bool validate() => _formController.validate();
  bool validate1(String controlKey) => _formController.validate1(controlKey);

  void setSelection(String controlKey, int start, int end) =>
      _formController.setSelection(controlKey, start, end);
  void selectAll(String controlKey) => _formController.selectAll(controlKey);

  SubControllerDelegate getSubController(String controlKey) =>
      _formController.getSubController(controlKey);

  void remove(String controlKey) => _formController.remove(controlKey);
}

typedef _ControllerProvider = ValueNotifier Function();

class _FormController extends ChangeNotifier {
  bool _visible = true;
  bool _readOnly = false;
  FormThemeData _themeData;

  final Map<String, ValueNotifier> controllers = {};
  final Map<String, FocusNode> focusNodes = {};
  final Map<String, _FormItemWidgetState> states = {};
  final Map<String, ValueFieldState> valueFieldStates = {};
  final Map<String, CommonFieldState> commonFieldStates = {};
  final Map<String, List<ValueChanged<bool>>> focusChangeMap = {};
  final Map<String, Map<String, dynamic>> fieldStateMap =
      {}; //used to hold field state map
  final Map<String, dynamic> dataMap = {};

  static _FormController of(BuildContext context) {
    return _InheritedFormController.of(context).formController;
  }

  ValueNotifier newController(String controlKey, _ControllerProvider provider) {
    return controllers.putIfAbsent(controlKey, () => provider());
  }

  FocusNode newFocusNode(String controlKey) {
    FocusNode focusNode = focusNodes[controlKey];
    if (focusNode != null) {
      return focusNode;
    }
    focusNode = FocusNode();
    focusNodes[controlKey] = focusNode;
    focusNode.addListener(() {
      List<ValueChanged<bool>> list = focusChangeMap[controlKey];
      if (list != null) {
        bool hasFocus = focusNode.hasFocus;
        for (ValueChanged<bool> onChanged in list) {
          onChanged(hasFocus);
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
        value._readOnly = _readOnly;
      });
      commonFieldStates.forEach((key, value) {
        value._readOnly = readOnly;
      });
    }
  }

  void requestFocus(String controlKey) {
    FocusNode focusNode = focusNodes[controlKey];
    if (focusNode == null) return;
    focusNode.requestFocus();
  }

  void unfocus(String controlKey) {
    FocusNode focusNode = focusNodes[controlKey];
    if (focusNode == null) return;
    focusNode.unfocus();
  }

  void onFocusChange(String controlKey, ValueChanged<bool> onChanged) {
    List<ValueChanged<bool>> list = focusChangeMap[controlKey];
    if (list == null) {
      focusChangeMap[controlKey] = [onChanged];
    } else {
      list.add(onChanged);
    }
  }

  void offFocusChange(String controlKey, ValueChanged<bool> onChanged) {
    List<ValueChanged<bool>> list = focusChangeMap[controlKey];
    if (list == null) return;
    list.remove(onChanged);
  }

  dynamic getValue(String controlKey) {
    return dataMap[controlKey];
  }

  void rebuild(String controlKey, Map<String, dynamic> map) {
    _BaseFieldState state =
        valueFieldStates[controlKey] ?? commonFieldStates[controlKey];
    if (state == null) return;
    state._rebuild(map);
  }

  void update(String controlKey, Map<String, dynamic> map) {
    _BaseFieldState state =
        valueFieldStates[controlKey] ?? commonFieldStates[controlKey];
    if (state == null) return;
    state._update(map);
  }

  void setVisible(String controlKey, bool visible) {
    _FormItemWidgetState state = states[controlKey];
    if (state == null) return;
    state.visible = visible;
  }

  void setReadOnly(String controlKey, bool readOnly) {
    _BaseFieldState state =
        valueFieldStates[controlKey] ?? commonFieldStates[controlKey];
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
    _BaseFieldState state =
        valueFieldStates[controlKey] ?? commonFieldStates[controlKey];
    return state == null ? false : state.readOnly;
  }

  Map<String, dynamic> getData({bool removeNull = true}) {
    Map<String, dynamic> dataMap = Map.of(this.dataMap);
    if (removeNull) dataMap.removeWhere((key, value) => value == null);
    return dataMap;
  }

  void setValue(String controlKey, dynamic value, {bool trigger = true}) {
    valueFieldStates.values
        .where((element) => (element.controlKey == controlKey))
        .forEach((element) {
      element.doChangeValue(value, trigger: trigger);
    });
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

  void setSelection(String controlKey, int start, int end) {
    var controller = controllers[controlKey];
    if (controller != null && controller is TextSelectionMixin) {
      (controller as TextSelectionMixin).setSelection(start, end);
    }
  }

  void selectAll(String controlKey) {
    var controller = controllers[controlKey];
    if (controller != null && controller is TextSelectionMixin) {
      (controller as TextSelectionMixin).selectAll();
    }
  }

  void setAutovalidateMode(
      String controlKey, AutovalidateMode autovalidateMode) {
    ValueFieldState state = valueFieldStates[controlKey];
    if (state == null) return;
    state._setInitStateValue(FormBuilder.autovalidateModeKey, autovalidateMode);
  }

  void setInitialValue(String controlKey, initialValue) {
    ValueFieldState state = valueFieldStates[controlKey];
    if (state == null) return;
    state._setInitStateValue(FormBuilder.initialValueKey, initialValue);
  }

  void remove(String controlKey) {
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
      fieldStateMap.remove(controlKey);
    });
  }

  void removeState(String controlKey, Set<String> stateKeys) {
    _BaseFieldState state =
        valueFieldStates[controlKey] ?? commonFieldStates[controlKey];
    if (state == null) return;
    state._remove(stateKeys);
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
    fieldStateMap.clear();
    super.dispose();
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
      _padding ?? FormThemeData.of(context).padding ?? EdgeInsets.zero;
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
  Widget build(BuildContext context) {
    if (_removed) {
      return SizedBox.shrink();
    }
    _FormController.of(context).states[widget.controlKey] = this;
    return _InheritedControlKey(
      widget.controlKey,
      child: Visibility(
        visible: visible,
        child: Expanded(
          child: Padding(
            padding: padding,
            child: widget.child,
          ),
          flex: flex,
        ),
      ),
    );
  }
}

typedef FormFieldBuilder<T> = Widget Function(
    FormFieldState<T> state,
    BuildContext context,
    bool readOnly,
    Map<String, dynamic> stateMap,
    ThemeData themeData,
    FormThemeData formThemeData);

abstract class _BaseField<T> extends FormField<T> {
  final Map<String, dynamic> _initStateMap;
  _BaseField(this._initStateMap,
      {Key key,
      FormFieldBuilder<T> builder,
      FormFieldValidator<T> validator,
      AutovalidateMode autovalidateMode,
      bool readOnly,
      T initialValue})
      : super(
            key: key,
            builder: (field) {
              _BaseFieldState<T> state = field;
              return builder(
                  field,
                  state.context,
                  state.readOnly,
                  state.getUpdatedMap(),
                  Theme.of(state.context),
                  FormThemeData.of(state.context));
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue) {
    _initStateMap[FormBuilder.readOnlyKey] = readOnly;
  }
}

typedef NullValueReplace<T> = T Function();

class ValueField<T> extends _BaseField<T> {
  final ValueNotifier controller;
  final ValueChanged<T> onChanged;
  final NullValueReplace<T> replace;

  @override
  AutovalidateMode get autovalidateMode =>
      _initStateMap[FormBuilder.autovalidateModeKey] ?? super.autovalidateMode;
  @override
  T get initialValue =>
      _initStateMap[FormBuilder.initialValueKey] ?? super.initialValue;

  ValueField(this.controller, Map<String, dynamic> initStateMap,
      {Key key,
      this.replace,
      this.onChanged,
      FormFieldBuilder<T> builder,
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

  _BaseField<T> get widget => super.widget;
  bool get readOnly =>
      _formController._readOnly || (getState(FormBuilder.readOnlyKey) ?? false);

  set _readOnly(bool readOnly) {
    _update({FormBuilder.readOnlyKey: readOnly});
  }

  getState(String stateKey) {
    return _state.containsKey(stateKey)
        ? _state[stateKey]
        : widget._initStateMap[stateKey];
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controlKey == null) {
      controlKey = _InheritedControlKey.of(context).controlKey;
      _formController = _FormController.of(context);
      _state = _formController.fieldStateMap.putIfAbsent(controlKey, () => {});
      init();
    }
  }

  void _setInitStateValue(String stateKey, value) {
    setState(() {
      widget._initStateMap[stateKey] = value;
    });
  }

  @protected
  @mustCallSuper
  void init() {}

  Map<String, dynamic> getUpdatedMap() {
    Map<String, dynamic> map = Map.from(this.widget._initStateMap);
    for (String key in map.keys) {
      if (_state.containsKey(key)) {
        map[key] = _state[key];
      }
    }
    return map;
  }
}

class ValueFieldState<T> extends _BaseFieldState<T> {
  ValueField<T> get widget => super.widget;
  ValueNotifier get controller => widget.controller;
  ValueChanged<T> get onChanged => widget.onChanged;

  @override
  void initState() {
    super.initState();
    controller.addListener(handleUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(handleUpdate);
    super.dispose();
  }

  @override
  void init() {
    super.init();
    _formController.dataMap.putIfAbsent(controlKey, () => _getValue(null));
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
    _formController.dataMap[controlKey] = this.value;
  }

  void doChangeValue(T value, {bool trigger = true}) {
    T replaceValue = _getValue(value);
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
    T value = _getValue(widget.initialValue);
    controller.value = value;
    if (onChanged != null) {
      onChanged(controller.value);
    }
  }

  T _getValue(T value) {
    if (value == null && widget.replace != null) {
      return widget.replace();
    }
    return value;
  }

  void handleUpdate() {
    setState(() {});
  }
}

class CommonField extends _BaseField<Null> {
  CommonField(
    Map<String, dynamic> initStateMap, {
    Key key,
    FormFieldBuilder builder,
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

class _InheritedFormController extends InheritedWidget {
  final _FormController formController;
  final Widget child;

  _InheritedFormController(this.formController, {this.child})
      : super(child: child);

  static _InheritedFormController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedFormController>();
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

  void update1(String controlKey, Map<String, dynamic> state) {
    _controller.update1(controlKey, state);
  }

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
