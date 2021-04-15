import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'switch_group.dart';
import 'button.dart';
import 'checkbox_group.dart';
import 'form_theme.dart';
import 'text_field.dart';
import 'radio_group.dart';
import 'selector.dart';
import 'slider.dart';

class FormBuilder {
  static final String readOnlyKey = 'readOnly';
  static final String visibleKey = 'visible';
  List<_FormItemWidget> _builders = [];
  List<List<_FormItemWidget>> _builderss = [];
  final FormControllerDelegate formControllerDelegate;

  _FormController get _formController => formControllerDelegate._formController;

  FormBuilder(this.formControllerDelegate);

  FormBuilder nextLine() {
    if (_builders.length > 0) {
      _builderss.add(_builders);
      _builders = [];
    }
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
      bool clearable = false,
      bool readOnly = false,
      bool visible = true,
      int decimal = 0,
      EdgeInsets padding,
      TextStyle style,
      num initialValue,
      List<Widget> suffixIcons,
      VoidCallback onEditingComplete,
      TextInputAction textInputAction}) {
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
            padding: padding,
            readOnly: readOnly,
            style: style,
            initialValue: initialValue,
            suffixIcons: suffixIcons,
            onEditingComplete: onEditingComplete,
            textInputAction: textInputAction)));
    return this;
  }

  FormBuilder textField(String controlKey,
      {String hintText,
      String labelText,
      VoidCallback onTap,
      Key key,
      bool obscureText: false,
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
      List<TextInputFormatter> textInputFormatters}) {
    _CustomTextEditingController controller = _formController.newController(
        controlKey, () => _CustomTextEditingController(text: initialValue));
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
            padding: padding,
            readOnly: readOnly,
            style: style,
            initialValue: initialValue,
            toolbarOptions: toolbarOptions,
            selectAllOnFocus: selectAllOnFocus ?? false,
            suffixIcons: suffixIcons,
            textInputAction: textInputAction)));
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
        split: inline ? 0 : split,
        padding: padding,
        readOnly: readOnly,
        initialValue: initialValue,
        inline: inline,
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
      bool inline = false}) {
    CheckboxGroupController controller = _formController._controllers
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
        label: inline ? null : label,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        split: inline ? 0 : split,
        padding: padding,
        readOnly: readOnly,
        initialValue: initialValue,
        inline: inline,
      ),
    ));
    if (!inline) nextLine();
    return this;
  }

  FormBuilder button(String controlKey, VoidCallback onPressed,
      {Key key,
      String label,
      Widget child,
      int flex = 0,
      VoidCallback onLongPress,
      bool readOnly = false,
      bool visible = true,
      Alignment alignment,
      EdgeInsets padding}) {
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: flex,
          child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: Button(
              controlKey,
              onPressed,
              key: key,
              label: label,
              child: child,
              onLongPress: onLongPress,
              padding: padding,
              readOnly: readOnly,
            ),
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
      DateTime initialValue}) {
    DateTimeController controller = _formController._controllers
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
              padding: padding,
              readOnly: readOnly,
              style: style,
              maxLines: maxLines,
              initialValue: initialValue,
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
  }) {
    SelectorController controller = _formController._controllers
        .putIfAbsent(controlKey, () => SelectorController(value: initialValue));
    FocusNode focusNode = _formController.newFocusNode(controlKey);
    nextLine();
    _builders.add(
      _FormItemWidget(visible, controlKey,
          flex: 1,
          child: SelectorFormField(
            focusNode,
            controller,
            selectItemProvider,
            onChanged: onChanged,
            labelText: labelText,
            hintText: hintText,
            clearable: clearable,
            validator: validator,
            autovalidateMode: autovalidateMode,
            padding: padding,
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
          )),
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
      child: Builder(builder: (context) {
        FormThemeData formThemeData = FormThemeData.of(context);
        return Padding(
          padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
          child: Divider(
            height: height ?? 1.0,
          ),
        );
      }),
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
  }) {
    SwitchGroupController controller = _formController.newController(
        controlKey, () => SwitchGroupController(value: initialValue));
    nextLine();
    _builders.add(_FormItemWidget(
      visible,
      controlKey,
      flex: 1,
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
        padding: padding,
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
    SwitchController controller = _formController._controllers
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
        padding: padding,
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
        label: inline ? null : label,
        divisions: divisions,
        initialValue: initialValue ?? min,
        subLabelRender: subLabelRender,
        inline: inline,
        padding: padding,
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
        padding: padding,
      ),
    ));
    if (!inline) nextLine();
    return this;
  }

  Widget build() {
    nextLine();
    return _FormWidget(_builderss, _formController);
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

  void setVisible(String controlKey, bool visible) =>
      _formController.setVisible(controlKey, visible);
  bool isVisible(String controlKey) => _formController.isVisible(controlKey);

  void setReadOnly(String controlKey, bool readOnly) =>
      _formController.setReadOnly(controlKey, readOnly);
  bool isReadOnly(String controlKey) => _formController.isReadOnly(controlKey);

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

  SubControllerDelegate getSubController(String controlKey) =>
      _formController.getSubController(controlKey);
}

typedef _ControllerProvider<T> = T Function();

class _FormController extends ChangeNotifier {
  bool _visible = true;
  bool _readOnly = false;
  FormThemeData _themeData = FormThemeData();

  final Map<String, dynamic> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, _FormItemWidgetState> _states = {};
  final Map<String, FormBuilderFieldState> _fieldStates = {};
  final Map<String, List<ValueChanged<bool>>> _focusChangeMap = {};
  //when hide a form widget,it's state will dispose,we store it's state map here
  final Map<String, Map<String, dynamic>> _fieldStateMap = {};

  static _FormController of(BuildContext context) {
    return _InheritedFromController.of(context).formController;
  }

  T newController<T>(String controlKey, _ControllerProvider<T> provider) {
    return _controllers.putIfAbsent(controlKey, () => provider());
  }

  FocusNode newFocusNode(String controlKey) {
    FocusNode focusNode = _focusNodes[controlKey];
    if (focusNode != null) {
      return focusNode;
    }
    focusNode = FocusNode();
    _focusNodes[controlKey] = focusNode;
    focusNode.addListener(() {
      List<ValueChanged<bool>> list = _focusChangeMap[controlKey];
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
      _fieldStates.forEach((key, value) {
        value.readOnly = _readOnly;
      });
    }
  }

  void requestFocus(String controlKey) {
    FocusNode focusNode = _focusNodes[controlKey];
    if (focusNode == null) return;
    focusNode.requestFocus();
  }

  void unfocus(String controlKey) {
    FocusNode focusNode = _focusNodes[controlKey];
    if (focusNode == null) return;
    focusNode.unfocus();
  }

  void onFocusChange(String controlKey, ValueChanged<bool> onChanged) {
    List<ValueChanged<bool>> list = _focusChangeMap[controlKey];
    if (list == null) {
      _focusChangeMap[controlKey] = [onChanged];
    } else {
      list.add(onChanged);
    }
  }

  void offFocusChange(String controlKey, ValueChanged<bool> onChanged) {
    List<ValueChanged<bool>> list = _focusChangeMap[controlKey];
    if (list == null) return;
    list.remove(onChanged);
  }

  dynamic getValue(String controlKey) {
    FormBuilderFieldState state = _fieldStates.values
        .where((element) => (element.controlKey == controlKey))
        .first;
    return state == null ? null : state.value;
  }

  void rebuild(String controlKey, Map<String, dynamic> map) {
    FormBuilderFieldState state = _fieldStates[controlKey];
    if (state == null) return;
    state.rebuild(map);
  }

  void update(String controlKey, Map<String, dynamic> map) {
    FormBuilderFieldState state = _fieldStates[controlKey];
    if (state == null) return;
    state.update(map);
  }

  void setVisible(String controlKey, bool visible) {
    _FormItemWidgetState state = _states[controlKey];
    if (state == null) return;
    state.visible = visible;
  }

  void setReadOnly(String controlKey, bool readOnly) {
    FormBuilderFieldState state = _fieldStates[controlKey];
    if (state == null) return;
    state.readOnly = readOnly;
  }

  bool isVisible(String controlKey) {
    _FormItemWidgetState state = _states[controlKey];
    return state == null ? false : state.visible;
  }

  bool isReadOnly(String controlKey) {
    FormBuilderFieldState state = _fieldStates[controlKey];
    return state == null ? false : state.readOnly;
  }

  Map<String, dynamic> getData() {
    Map<String, dynamic> map = {};
    _fieldStates.values.forEach((element) {
      dynamic value = element.value;
      if (value != null) {
        map[element.controlKey] = value;
      }
    });
    return map;
  }

  void setValue(String controlKey, dynamic value, {bool trigger = true}) {
    _fieldStates.values
        .where((element) => (element.controlKey == controlKey))
        .forEach((element) {
      element.doChangeValue(value, trigger: trigger);
    });
  }

  void reset() {
    for (final FormFieldState<dynamic> field in _fieldStates.values)
      field.reset();
  }

  void reset1(String controlKey) {
    _fieldStates.values
        .where((element) => (element.controlKey == controlKey))
        .forEach((element) {
      element.reset();
    });
  }

  bool validate() {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in _fieldStates.values)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  bool validate1(String controlKey) {
    FormBuilderFieldState state = _fieldStates.values
        .where((element) => (element.controlKey == controlKey))
        .first;
    return state == null ? true : state.validate();
  }

  void setSelection(String controlKey, int start, int end) {
    var controller = _controllers[controlKey];
    if (controller != null && controller is TextSelectionMixin) {
      controller.setSelection(start, end);
    }
  }

  SubControllerDelegate getSubController(String controlKey) {
    var controller = _controllers[controlKey];
    if (controller != null && controller is SubController) {
      return SubControllerDelegate._(controller);
    }
    return null;
  }

  @override
  void dispose() {
    _focusNodes.values.forEach((element) {
      element.dispose();
    });
    _controllers.values.forEach((element) {
      element.dispose();
    });
    _focusNodes.clear();
    _controllers.clear();
    _states.clear();
    _fieldStates.clear();
    super.dispose();
  }
}

class _FormWidget extends StatefulWidget {
  final List<List<_FormItemWidget>> builderss;
  final _FormController formController;

  const _FormWidget(this.builderss, this.formController, {Key key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  @override
  void initState() {
    super.initState();
    widget.formController.addListener(handleThemeChange);
  }

  @override
  void dispose() {
    widget.formController.dispose();
    super.dispose();
  }

  void handleThemeChange() {
    //  setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Row> rows = [];
    for (List<_FormItemWidget> builders in widget.builderss) {
      rows.add(Row(
        children: builders,
      ));
    }

    return Theme(
        data: widget.formController.themeData.themeData ?? Theme.of(context),
        child: _InheritedFromController(widget.formController,
            child: Visibility(
              maintainState: true,
              child: Column(
                children: rows,
              ),
              visible: widget.formController._visible,
            )));
  }
}

class _FormItemWidget extends StatefulWidget {
  final String controlKey;
  final int flex;
  final bool visible;
  final Widget child;
  const _FormItemWidget(this.visible, this.controlKey,
      {Key key, this.flex, this.child})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormItemWidgetState();
}

class _FormItemWidgetState extends State<_FormItemWidget> {
  bool _visible;
  int _flex;

  get visible => _visible;
  set visible(bool visible) {
    if (visible != _visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  get flex => _flex;
  set flex(int flex) {
    if (flex != _flex) {
      setState(() {
        _flex = flex;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _visible = widget.visible ?? true;
    _flex = widget.flex ?? 1;
  }

  @override
  void deactivate() {
    _FormController.of(context)._states.remove(widget.controlKey);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _FormController.of(context)._states[widget.controlKey] = this;
    return _InheritedControlKey(
      widget.controlKey,
      child: Visibility(
        visible: visible,
        child: Expanded(
          child: widget.child,
          flex: visible ? flex : 0,
        ),
      ),
    );
  }
}

typedef NullValueReplace<T> = T Function();

class FormBuilderField<T> extends FormField<T> {
  final ValueNotifier controller;
  final ValueChanged<T> onChanged;
  final NullValueReplace<T> replace;
  final bool readOnly;

  FormBuilderField(this.controller,
      {Key key,
      this.replace,
      this.onChanged,
      this.readOnly = false,
      FormFieldBuilder<T> builder,
      FormFieldValidator<T> validator,
      AutovalidateMode autovalidateMode,
      T initialValue})
      : super(
            key: key,
            builder: builder,
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);

  @override
  FormBuilderFieldState<T> createState() => FormBuilderFieldState<T>();
}

class FormBuilderFieldState<T> extends FormFieldState<T> {
  FormBuilderField<T> get widget => super.widget;
  ValueNotifier get controller => widget.controller;
  ValueChanged<T> get onChanged => widget.onChanged;
  _FormController get formController => _FormController.of(context);
  String get controlKey => _InheritedControlKey.of(context).controlKey;
  bool get readOnly =>
      _state[FormBuilder.readOnlyKey] ?? widget.readOnly ?? false;
  set readOnly(bool readOnly) {
    if (this.readOnly != readOnly) {
      update({FormBuilder.readOnlyKey: readOnly});
    }
  }

  Map<String, dynamic> _state = {};

  K getState<K>(String stateKey, K value) {
    return _state[stateKey] ?? value;
  }

  @override
  void initState() {
    super.initState();
    if (controller is SubController) {
      controller.addListener(handleSubControllerChange);
    }
    _state ??= formController._fieldStateMap.remove(controlKey);
  }

  @override
  void dispose() {
    if (controller is SubController) {
      controller.removeListener(handleSubControllerChange);
    }
    super.dispose();
  }

  @override
  void deactivate() {
    formController._fieldStateMap[controlKey] = _state;
    formController._fieldStates.remove(controlKey);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    formController._fieldStates[controlKey] = this;
    return super.build(context);
  }

  @override
  void didChange(T value) {
    doChangeValue(value);
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

  @protected
  void superDidChange(T value) {
    super.didChange(value);
  }

  @protected
  void superReset() {
    super.reset();
  }

  void rebuild(Map<String, dynamic> state) {
    setState(() {
      this._state = state ?? {};
    });
  }

  void update(Map<String, dynamic> state) {
    if (state == null) return;
    setState(() {
      state.forEach((key, value) {
        if (value == null) {
          this._state.remove(key);
        } else {
          this._state[key] = value;
        }
      });
    });
  }

  T _getValue(T value) {
    if (value == null && widget.replace != null) {
      return widget.replace();
    }
    return value;
  }

  void handleSubControllerChange() {
    setState(() {});
  }
}

mixin TextSelectionMixin {
  void setSelection(int start, int end);

  static void setSelectionWithTextEditingController(
      int start, int end, TextEditingController controller) {
    int extendsOffset =
        end > controller.text.length ? controller.text.length : end;
    int baseOffset = start < 0 ? 0 : start;
    controller.selection =
        TextSelection(baseOffset: baseOffset, extentOffset: extendsOffset);
  }
}

class _CustomTextEditingController extends TextEditingController
    with TextSelectionMixin {
  _CustomTextEditingController({String text}) : super(text: text);

  @override
  void setSelection(int start, int end) {
    TextSelectionMixin.setSelectionWithTextEditingController(start, end, this);
  }
}

class _InheritedFromController extends InheritedWidget {
  final _FormController formController;
  final Widget child;

  _InheritedFromController(this.formController, {this.child})
      : super(child: child);

  static _InheritedFromController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedFromController>();
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
  SubControllableItem(this.controlKey);
  Map<String, dynamic> toMap();
}

//used to control form field's item's state
class SubController<T> extends ValueNotifier<T> {
  final Map<String, Map<String, dynamic>> _states = {};
  final Map<String, Map<String, dynamic>> _initStates = {};

  SubController(value) : super(value);

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
    var state = _states[controlKey];
    return state == null ? null : state[key] ?? _initStates[controlKey][key];
  }

  Map<String, dynamic> getUpdatedMap(SubControllableItem item) {
    if (item == null) {
      return null;
    }
    if (item.controlKey == null) return item.toMap();
    var currentStateMap = _states[item.controlKey];
    if (currentStateMap == null) return _initStates[item.controlKey];
    Map<String, dynamic> updated = {};
    _initStates[item.controlKey].forEach((key, value) {
      updated[key] = currentStateMap[key] ?? value;
    });
    return updated;
  }

  void init(List<SubControllableItem> items) {
    _initStates.clear();
    items.forEach((element) {
      if (element.controlKey != null) {
        _initStates[element.controlKey] = element.toMap();
        _states.putIfAbsent(element.controlKey, () => {});
      }
    });
    _states.removeWhere(
        (key, value) => !items.any((element) => element.controlKey == key));
  }

  void _doUpdate(String controlKey, Map<String, dynamic> state) {
    if (state == null) return;
    var oldState = _states[controlKey];
    if (oldState == null) return;
    var initState = _initStates[controlKey];
    state.forEach((key, value) {
      if (!initState.containsKey(key)) return;
      if (value == null) {
        oldState.remove(key);
      } else {
        oldState[key] = value;
      }
    });
  }

  @override
  void dispose() {
    _initStates.clear();
    _states.clear();
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
      'visible': visible,
    });
  }

  void setReadOnly(String controlKey, bool readOnly) {
    _controller.update1(controlKey, {
      'readOnly': readOnly,
    });
  }

  bool isVisible(String controlKey) {
    return _controller.getState(controlKey, 'visible');
  }

  bool isReadOnly(String controlKey) {
    return _controller.getState(controlKey, 'readOnly');
  }

  bool hasState(String controlKey) {
    return _controller._initStates.containsKey(controlKey);
  }
}
