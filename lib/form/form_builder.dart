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
/// it's only create once and maintained in [_FormManagement]
typedef ValueNotifierProvider<T> = ValueNotifier<T> Function();

typedef OnPressed = void Function(FormManagement management);

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

/// callback after form initialled
typedef FormInitCallback = void Function(FormManagement formManagement);

class FormBuilder extends StatefulWidget {
  static final String readOnlyKey = 'readOnly';
  static final String visibleKey = 'visible';
  static final String autovalidateModeKey = 'autovalidateMode';
  static final String initialValueKey = 'initialValue';

  final _FormLayout _formLayout = _FormLayout();
  final bool _readOnly;
  final bool _visible;
  final FormThemeData _formThemeData;
  final FormManagement formManagement;
  final FormInitCallback initCallback;

  FormBuilder nextLine() {
    _formLayout.lastEmptyRow();
    return this;
  }

  FormBuilder(
      {bool readOnly,
      bool visible,
      FormThemeData formThemeData,
      FormManagement formManagement,
      bool enableDebugPrint,
      this.initCallback})
      : this._formThemeData = formThemeData ?? FormThemeData.defaultTheme,
        this._readOnly = readOnly ?? false,
        this._visible = visible ?? true,
        this.formManagement = formManagement ?? FormManagement();

  /// append a number field to current row
  FormBuilder numberField(
      {String controlKey,
      int flex,
      String hintText,
      String labelText,
      EdgeInsets padding,
      VoidCallback onTap,
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
      TextStyle style,
      num initialValue,
      List<Widget> suffixIcons,
      VoidCallback onEditingComplete,
      TextInputAction textInputAction,
      InputDecorationTheme inputDecorationTheme}) {
    _formLayout.lastStretchableRow().append(_FormItemBuilder(
        visible: visible,
        controlKey: controlKey,
        flex: flex,
        inline: true,
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
  FormBuilder textField(
      {String controlKey,
      String hintText,
      String labelText,
      VoidCallback onTap,
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
    _formLayout.lastStretchableRow().append(_FormItemBuilder(
        visible: visible,
        controlKey: controlKey,
        flex: flex,
        inline: true,
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
    List<RadioItem> items, {
    String controlKey,
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
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormItemBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: inline ? flex : 1,
      inline: inline,
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
    return this;
  }

  FormBuilder checkboxGroup(List<CheckboxItem> items,
      {String controlKey,
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
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormItemBuilder(
      visible: visible,
      controlKey: controlKey,
      inline: inline,
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
    return this;
  }

  FormBuilder textButton(OnPressed onPressed,
      {String controlKey,
      String label,
      Widget child,
      int flex = 0,
      VoidCallback onLongPress,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets padding}) {
    _formLayout.lastStretchableRow().append(
          _FormItemBuilder(
              visible: visible,
              controlKey: controlKey,
              flex: flex,
              inline: true,
              padding: padding,
              child: CommonField(
                {
                  'label': label,
                  'child': child,
                },
                builder: (state, context, readOnly, stateMap, themeData,
                    formThemeData) {
                  Widget child = stateMap['child'] ?? Text(stateMap['label']);
                  return TextButton(
                      onPressed: readOnly
                          ? null
                          : () {
                              onPressed(formManagement);
                            },
                      onLongPress: readOnly ? null : onLongPress,
                      child: child);
                },
              )),
        );
    return this;
  }

  FormBuilder datetimeField(
      {String controlKey,
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
    _formLayout.lastStretchableRow().append(
          _FormItemBuilder(
              visible: visible,
              inline: true,
              controlKey: controlKey,
              padding: padding,
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

  FormBuilder selector({
    String controlKey,
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
    bool inline = false,
    int flex = 1,
  }) {
    inline ??= false;
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(
      _FormItemBuilder(
          visible: visible,
          controlKey: controlKey,
          flex: inline ? flex : 1,
          inline: inline,
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
    inline ??= false;
    return this;
  }

  FormBuilder divider(
      {String controlKey,
      double height = 1.0,
      bool visible = true,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 5)}) {
    _FormRow row = _formLayout.lastEmptyRow();
    row.append(_FormItemBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: 1,
      inline: false,
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
    return this;
  }

  FormBuilder switchGroup({
    String controlKey,
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
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormItemBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: inline ? flex : 1,
      padding: padding,
      inline: inline,
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
    return this;
  }

  FormBuilder switchInline(
      {String controlKey,
      bool visible = true,
      bool readOnly = false,
      EdgeInsets padding,
      int flex = 0,
      ValueChanged<bool> onChanged,
      FormFieldValidator<bool> validator,
      AutovalidateMode autovalidateMode,
      bool initialValue}) {
    _formLayout.lastStretchableRow().append(_FormItemBuilder(
          visible: visible,
          controlKey: controlKey,
          padding: padding,
          flex: flex,
          inline: true,
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

  FormBuilder slider(
      {String controlKey,
      bool visible = true,
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
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormItemBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: inline ? flex : 1,
      padding: padding,
      inline: inline,
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
    return this;
  }

  FormBuilder rangeSlider(
      {String controlKey,
      bool visible = true,
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
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(_FormItemBuilder(
      visible: visible,
      controlKey: controlKey,
      flex: 1,
      inline: inline,
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
    return this;
  }

  FormBuilder field(
      {String controlKey,
      int flex = 0,
      bool visible = true,
      EdgeInsets padding,
      @required Widget field,
      bool inline}) {
    assert(field is _BaseField, 'field must be ValueField|CommonField');
    inline ??= false;
    _FormRow row =
        inline ? _formLayout.lastStretchableRow() : _formLayout.lastEmptyRow();
    row.append(
      _FormItemBuilder(
          visible: visible,
          controlKey: controlKey,
          flex: flex,
          inline: inline,
          padding: padding,
          child: field),
    );
    return this;
  }

  static List<CheckboxItem> toCheckboxItems(List<String> items,
      {EdgeInsets padding, TextStyle style}) {
    return items
        .map((e) => CheckboxItem(e, padding: padding, textStyle: style))
        .toList();
  }

  static List<RadioItem> toRadioItems(List<String> items,
      {EdgeInsets padding, TextStyle style}) {
    return items
        .map((e) => RadioItem(e, e, padding: padding, textStyle: style))
        .toList();
  }

  static SelectItemProvider toSelectItemProvider(List items) {
    return (page, params) {
      return Future.delayed(Duration.zero, () {
        return SelectItemPage(items, items.length);
      });
    };
  }

  static List<SwitchGroupItem> toSwitchGroupItems(List<String> items,
      {EdgeInsets padding, TextStyle style}) {
    return items
        .map((e) => SwitchGroupItem(e, padding: padding, textStyle: style))
        .toList();
  }

  @override
  State<StatefulWidget> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  bool _readOnly;
  bool _visible;
  bool rebuildLayout = false;

  _FormResourceManagement formResourceManagement;
  _FormLayout _formLayout;
  FormThemeData _formThemeData;

  set formThemeData(FormThemeData formThemeData) {
    if (formThemeData != _formThemeData) {
      setState(() {
        _formThemeData = formThemeData;
        formResourceManagement.gen++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _readOnly = widget._readOnly;
    _visible = widget._visible;
    _formLayout = widget._formLayout;
    _formThemeData = widget._formThemeData;
    formResourceManagement = _FormResourceManagement(this);
    widget.formManagement._formResourceManagement = formResourceManagement;
    if (widget.initCallback != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.initCallback(widget.formManagement);
      });
    }
  }

  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      _readOnly = readOnly ?? false;
      formResourceManagement.commonFieldStatesList.forEach((element) {
        element._readOnly = _readOnly;
      });
      formResourceManagement.valueFieldStatesList.forEach((element) {
        element._readOnly = _readOnly;
      });
    }
  }

  set visible(bool visible) {
    if (_visible != visible) {
      setState(() {
        _visible = visible ?? true;
      });
    }
  }

  set formLayout(_FormLayout formLayout) {
    if (this._formLayout != formLayout) {
      setState(() {
        _formLayout = formLayout;
        rebuildLayout = true;
      });
    }
  }

  @override
  void dispose() {
    formResourceManagement.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FormBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _formLayout = widget._formLayout;
    if (oldWidget._visible != widget._visible) {
      _visible = widget._visible;
    }
    if (oldWidget._readOnly != widget._readOnly) {
      _readOnly = widget._readOnly;
    }
    if (oldWidget._formThemeData != widget._formThemeData) {
      _formThemeData = widget._formThemeData;
    }
    _FormResourceManagement newManagement =
        widget.formManagement._formResourceManagement;
    if (newManagement == null) {
      widget.formManagement._formResourceManagement =
          formResourceManagement; // we do not call init again ! formManagement are always same!
    } else {
      assert(newManagement == formResourceManagement,
          'this form management is used to control another form ,you can not use this form management to control this form ,try to create a new one!');
    }
  }

  @override
  Widget build(BuildContext context) {
    _formLayout.removeEmptyRow();
    Set<String> controlKeys = {};
    List<Row> rows = [];
    int row = 0;
    for (_FormRow formRow in _formLayout.rows) {
      List<_FormItemWidget> children = [];
      int column = 0;
      for (_FormItemBuilder builder in formRow.builders) {
        Key key;
        String controlKey = builder.controlKey;
        if (controlKey == null) {
          controlKey = '$row,$column'; //use location as it's control key
          if (rebuildLayout) {
            key = UniqueKey();
          }
        } else {
          assert(
              !controlKey.contains(','), 'controlKey can not contains char , ');
          key = formResourceManagement.newFieldKey(controlKey);
        }
        assert(!controlKeys.contains(controlKey),
            'controlkey must unique in a form');
        controlKeys.add(controlKey);
        children.add(_FormItemWidget(builder, controlKey, key, row, column));
        column++;
      }
      rows.add(Row(
        children: children,
      ));
      row++;
    }
    rebuildLayout = false;
    controlKeys = null;
    return Theme(
        data: _formThemeData.themeData,
        child: Visibility(
            visible: _visible,
            maintainState: true,
            child: _FormManagementData(
              formResourceManagement,
              child: Column(
                children: rows,
              ),
            )));
  }
}

class _FormItemWidget extends StatefulWidget {
  final String controlKey;
  final int flex;
  final bool visible;
  final _BaseField child;
  final EdgeInsets padding;
  final int row;
  final int column;
  _FormItemWidget(
      _FormItemBuilder builder, this.controlKey, Key key, this.row, this.column)
      : this.visible = builder.visible,
        this.child = builder.child,
        this.flex = builder.flex,
        this.padding = builder.padding,
        super(key: key);
  @override
  State<StatefulWidget> createState() => _FormItemWidgetState();
}

class _FormItemWidgetState extends State<_FormItemWidget> {
  bool _visible;
  int _flex;
  EdgeInsets _padding;
  bool _removed = false;

  _FormResourceManagement formResourceManagement;

  get visible => _visible;
  set visible(bool visible) {
    if (!_removed && visible != _visible) {
      setState(() {
        _visible = visible ?? true;
      });
    }
  }

  get flex => _flex;
  set flex(int flex) {
    if (!_removed && flex != _flex) {
      setState(() {
        _flex = flex ?? 1;
      });
    }
  }

  get padding =>
      _padding ??
      _FormResourceManagement.of(context).state._formThemeData.padding;
  set padding(EdgeInsets padding) {
    if (!_removed && _padding != padding) {
      setState(() {
        _padding = padding ?? EdgeInsets.zero;
      });
    }
  }

  bool get removed => _removed;
  set remove(bool remove) {
    if (_removed == remove) return;
    setState(() {
      _removed = remove;
    });
  }

  @override
  void initState() {
    super.initState();
    _visible = widget.visible;
    _flex = widget.flex;
    _padding = widget.padding;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (formResourceManagement == null) {
      formResourceManagement = _FormResourceManagement.of(context);
      formResourceManagement.statesList.add(this);
    }
  }

  @override
  void didUpdateWidget(_FormItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      _visible = widget.visible;
    }
    if (oldWidget.flex != widget.flex) {
      _flex = widget.flex;
    }
    if (oldWidget.padding != widget.padding) {
      _padding = widget.padding;
    }
  }

  @override
  void dispose() {
    formResourceManagement.statesList.remove(this);
    formResourceManagement.mapping.remove(widget.controlKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_removed) {
      return SizedBox.shrink();
    }
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
                  _FormResourceManagement.of(state.context)
                      .state
                      ._formThemeData;
              return builder(state, state.context, state.readOnly,
                  state._stateMap, formThemeData.themeData, formThemeData);
            },
            validator: validator,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue) {
    _initStateMap[FormBuilder.readOnlyKey] = readOnly;
  }
}

class _BaseFieldState<T> extends FormFieldState<T> {
  Map<String, dynamic> _state;
  String controlKey;
  _FormResourceManagement _formResourceManagement;

  /// current widget whether is readonly or not
  ///
  /// **call this method in initController()**
  bool get readOnly =>
      _formResourceManagement.state._readOnly ||
      (getState(FormBuilder.readOnlyKey) ?? false);

  FocusNodes _focusNode;

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  ///
  /// you need get focusNode in [initFormResourceManagement]
  FocusNodes get focusNode {
    if (_focusNode == null) {
      _focusNode = FocusNodes._(subFocusChanged: notifyFocusChange);
      _focusNode.addListener(() {
        notifyFocusChange(null, _focusNode.hasFocus);
      });
    }
    return _focusNode;
  }

  void notifyFocusChange(String key, bool hasFocus) {
    FocusListener listener =
        _formResourceManagement.focusListenerMap[controlKey];
    if (listener == null) return;
    if (key == null && listener.rootChanged != null)
      listener.rootChanged(hasFocus);
    if (key != null && listener.subChanged != null)
      listener.subChanged(key, hasFocus);
  }

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
    controlKey = _InheritedControlKey.of(context).controlKey;
    if (_formResourceManagement == null) {
      _formResourceManagement = _FormResourceManagement.of(context);
      initFormResourceManagement();
    }
  }

  @mustCallSuper
  void initFormResourceManagement() {}

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

  @override
  void dispose() {
    if (focusNode != null) focusNode.dispose();
    super.dispose();
  }
}

class ValueField<T> extends _BaseField<T, ValueFieldState<T>> {
  final ValueChanged<T> onChanged;
  final NullValueReplace<T> replace;
  final ValueNotifierProvider<T> formValueNotifierProvider;

  @override
  AutovalidateMode get autovalidateMode =>
      _initStateMap[FormBuilder.autovalidateModeKey] ?? super.autovalidateMode;
  @override
  T get initialValue =>
      _initStateMap[FormBuilder.initialValueKey] ?? super.initialValue;

  ValueField(this.formValueNotifierProvider, Map<String, dynamic> initStateMap,
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

class ValueFieldState<T> extends _BaseFieldState<T> {
  ValueField<T> get widget => super.widget;
  ValueChanged<T> get onChanged => widget.onChanged;

  ValueNotifier<T> _valueNotifier;

  /// **you need to get valueNotifier in initValueNotifier()**
  ValueNotifier<T> get valueNotifier {
    if (_valueNotifier == null) {
      _valueNotifier = widget.formValueNotifierProvider();
      _valueNotifier.addListener(handleUpdate);
      initValueNotifier();
    }
    return _valueNotifier;
  }

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

  /// initController will  be  called immediately after new controller created via ControllerProvider
  @mustCallSuper
  void initValueNotifier() {}

  @override
  void didChange(T value) {
    doChangeValue(value);
  }

  void doChangeValue(T value, {bool trigger = true}) {
    T replaceValue = getReplacedValue(value);
    super.didChange(replaceValue);
    if (valueNotifier.value != replaceValue) {
      valueNotifier.value = replaceValue;
      if (onChanged != null && trigger) {
        onChanged(replaceValue);
      }
    }
  }

  @override
  void reset() {
    super.reset();
    T value = getReplacedValue(widget.initialValue);
    valueNotifier.value = value;
    if (onChanged != null) {
      onChanged(valueNotifier.value);
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

  @override
  void initFormResourceManagement() {
    super.initFormResourceManagement();
    _formResourceManagement.valueFieldStatesList.add(this);
  }

  @override
  void dispose() {
    if (valueNotifier != null) valueNotifier.dispose();
    _formResourceManagement.valueFieldStatesList.remove(this);
    super.dispose();
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
  void initFormResourceManagement() {
    super.initFormResourceManagement();
    _formResourceManagement.commonFieldStatesList.add(this);
  }

  @override
  void dispose() {
    super.dispose();
    _formResourceManagement.commonFieldStatesList.remove(this);
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

mixin TextSelectionManagement {
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

class _InheritedControlKey extends InheritedWidget {
  final Widget child;
  final String controlKey;

  _InheritedControlKey(this.controlKey, {this.child}) : super(child: child);

  static _InheritedControlKey of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedControlKey>();
  }

  @override
  bool updateShouldNotify(covariant _InheritedControlKey oldWidget) {
    return oldWidget.controlKey != controlKey;
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
class FocusListener {
  final ValueChanged<bool> rootChanged;
  final SubFocusChanged subChanged;
  FocusListener({this.rootChanged, this.subChanged});
}

class FocusNodes extends FocusNode {
  final Map<String, FocusNode> _nodes = {};
  final SubFocusChanged _subChanged;

  FocusNodes._({SubFocusChanged subFocusChanged})
      : this._subChanged = subFocusChanged;

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
      if (_subChanged != null) {
        focusNode.addListener(() {
          _subChanged(key, focusNode.hasFocus);
        });
      }
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
    super.dispose();
  }
}

class _FormItemBuilder {
  final String controlKey;
  final int flex;
  final bool visible;
  final Widget child;
  final EdgeInsets padding;
  final bool inline;
  _FormItemBuilder(
      {bool visible,
      this.controlKey,
      int flex,
      this.child,
      EdgeInsets padding,
      this.inline = false})
      : this.visible = visible ?? true,
        this.flex = flex ?? 1,
        this.padding = padding;
}

/// used to holder,dipose and get form resources
///
/// this class should  not be accessed by user
class _FormResourceManagement {
  _FormBuilderState state;
  final Map<String, FocusListener> focusListenerMap = {};
  final Map<String, Key> mapping = {};

  List<_FormItemWidgetState> statesList = [];
  List<ValueFieldState> valueFieldStatesList = [];
  List<CommonFieldState> commonFieldStatesList = [];

  int gen = 0;
  int _gen = 0; //used to compare and update notifier

  _FormResourceManagement(this.state);

  Key newFieldKey(String controlKey) {
    return mapping.putIfAbsent(
        controlKey,
        () =>
            GlobalKey()); //use global key here to hold state ... any good way to do this without a lib?
  }

  FocusNode getFocusNode(String controlKey) {
    _BaseFieldState state = getBaseFieldState(controlKey);
    assert(state._focusNode != null);
    return state._focusNode;
  }

  _FormItemWidgetState getItemState(String controlKey) {
    _FormItemWidgetState state = statesList.firstWhere(
        (element) => element.widget.controlKey == controlKey,
        orElse: () => null);
    assert(
        state != null, 'not item can be founded by controlKey : $controlKey');
    return state;
  }

  ValueFieldState getValueFieldState(String controlKey) {
    ValueFieldState state = valueFieldStatesList.firstWhere(
        (element) => element.controlKey == controlKey,
        orElse: () => null);
    assert(state != null,
        'value field can be founded by controlKey : $controlKey');
    return state;
  }

  _BaseFieldState getBaseFieldState(String controlKey) {
    _BaseFieldState state = valueFieldStatesList.firstWhere(
        (element) => element.controlKey == controlKey,
        orElse: () => null);
    if (state == null) {
      state = commonFieldStatesList.firstWhere(
          (element) => element.controlKey == controlKey,
          orElse: () => null);
    }
    assert(
        state != null, 'not field can be founded by controlKey : $controlKey');
    return state;
  }

  ValueNotifier getValueNotifier(String controlKey) {
    ValueFieldState state = getValueFieldState(controlKey);
    assert(state._valueNotifier != null);
    return state._valueNotifier;
  }

  void dispose() {
    focusListenerMap.clear();
    statesList.clear();
    valueFieldStatesList.clear();
    commonFieldStatesList.clear();
    mapping.clear();
    state = null;
  }

  static _FormResourceManagement of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FormManagementData>()
        .data;
  }
}

class _FormManagementData extends InheritedWidget {
  final _FormResourceManagement data;

  _FormManagementData(this.data, {Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant _FormManagementData oldWidget) {
    bool notify = data.gen != data._gen;
    if (notify) {
      data._gen = data.gen;
    }
    return notify;
  }
}

/// a management used to control a form
///
/// ```
/// FormBuilder(formManagement:your form management)
/// ```
///
/// any method in formmanagement can only be used after a formmangement is initialled,
/// you can pass a initCallback argument to listen when formmanament is initialled,
/// in fact formmanagement is initialled after form state initState() is called,so it's
/// safely to control form after a frame is completed,if you are used to commonfield
/// to control form , you can also get a useable formmanagement via FormManagement.of(context)
/// **context is from commonfield's build method ,not you own!**
///
/// **if your form field does not has a controlKey , you can not use those methods relies on ValueNotifier/FocusNode**
/// **because the location will be changed by widget tree, try [FormLayoutManagement] at this time**
///
/// **a initCallback will only be called once in form state's lifecycle due to _FormManagement's instance won't change**
class FormManagement {
  static FormManagement of(BuildContext context) {
    FormManagement formManagement = FormManagement();
    formManagement._formResourceManagement =
        _FormResourceManagement.of(context);
    return formManagement;
  }

  _FormResourceManagement _formResourceManagement;
  FormLayoutManagement _formLayoutManagement;
  FormWidgetTreeManagement _formWidgetTreeManagement;

  FormManagement();

  bool get initialled => _formResourceManagement != null;

  ///  whether form is visible or not
  bool get visible => _formResourceManagement.state._visible;

  /// set form visible after build
  set visible(bool visible) => _formResourceManagement.state.visible = visible;

  ///  whether form is readOnly or not
  bool get readOnly => _formResourceManagement.state._readOnly;

  set readOnly(bool readOnly) =>
      _formResourceManagement.state.readOnly = readOnly;

  /// get current FormThemeData
  FormThemeData get formThemeData =>
      _formResourceManagement.state._formThemeData;

  /// set a new theme to form
  ///
  /// this will rebuild all fields
  set formThemeData(FormThemeData formThemeData) =>
      _formResourceManagement.state.formThemeData = formThemeData;

  /// get form data
  Map<String, dynamic> get data => getData();

  Map<String, dynamic> getData({bool removeNull = true}) {
    Map<String, dynamic> map = {};
    _formResourceManagement.valueFieldStatesList.forEach((element) {
      dynamic value = element.value;
      if (removeNull && value == null) return;
      map[element.controlKey] = value;
    });
    return map;
  }

  /// reset form
  ///
  /// **only reset all value fields**
  void reset() {
    _formResourceManagement.valueFieldStatesList.forEach((element) {
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
    for (final FormFieldState<dynamic> field in _formResourceManagement
        .valueFieldStatesList) hasError = !field.validate() || hasError;
    return !hasError;
  }

  /// whether form is valid or not
  ///
  /// **only check is valid or not , won't show error**
  bool get isValid {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in _formResourceManagement
        .valueFieldStatesList) hasError = !field.isValid || hasError;
    return !hasError;
  }

  bool hasControlKey(String controlKey) {
    return _formResourceManagement.statesList
        .any((element) => element.widget.controlKey == controlKey);
  }

  FormLayoutManagement get formLayoutManagement {
    assert(_formResourceManagement != null);
    return _formLayoutManagement ??=
        FormLayoutManagement._(_formResourceManagement);
  }

  /// get form layout editor
  /// used to insert/remove fields or rows in widget tree
  FormWidgetTreeManagement get formWidgetTreeManagement {
    assert(_formResourceManagement != null);
    return _formWidgetTreeManagement ??=
        FormWidgetTreeManagement._(_formResourceManagement);
  }

  FormFieldManagement getFormFieldManagement(String controlKey) {
    assert(_formResourceManagement != null);
    assert(_formResourceManagement.mapping.containsKey(controlKey),
        'form field doesn\'t has a controlKey ! use FormLayoutManagement instead');
    return FormFieldManagement._(controlKey, _formResourceManagement);
  }
}

abstract class _AbstractFormFieldManagement {
  final String _controlKey;
  final _FormResourceManagement _formResourceManagement;

  _AbstractFormFieldManagement(this._controlKey, this._formResourceManagement);

  bool get isValueField => _baseFieldState is ValueFieldState;

  bool get readOnly => _baseFieldState.readOnly;
  set readOnly(bool readOnly) => _baseFieldState._readOnly = readOnly;

  bool get removed => _itemState._removed;

  /// mark a field as removed and you can not control this field any more,
  /// related resources will be disposed after form state disposed,
  ///
  /// this method won't remove field in widget tree , so when you get row count var [FormLayoutManagement],
  /// this field will also be calculated
  ///
  /// if you really need to remove a field or a row in widget tree, see [FormWidgetTreeManagement]
  set remove(bool remove) => _itemState.remove = remove;

  bool get visible => _itemState._visible;
  set visible(bool visible) => _itemState.visible = visible;

  set autovalidateMode(AutovalidateMode autovalidateMode) =>
      _valueFieldState._setAutoValidateMode(autovalidateMode);

  /// set value field's initialValue state
  set initialValue(dynamic initialValue) =>
      _valueFieldState._setInitialValue(initialValue);

  /// validate a form field and return is valid or not
  ///
  /// **will display error if invalid ,
  /// if you only want to know the field is valid or not ,
  /// use [isValid1] instead**
  bool validate() => _valueFieldState.validate();

  /// whether a form field is valid or not
  ///
  /// **only check is valid or not , won't show error**
  bool get isValid => _valueFieldState.isValid;

  /// reset on field
  ///
  /// **will set field value to it's initialValue**
  void reset() => _valueFieldState.reset();

  get padding => _itemState.padding;
  set padding(EdgeInsets padding) => _itemState.padding = padding;

  // whether a form field has focused or not
  get focus => _focusNode.hasFocus;

  set focus(bool focus) {
    if (focus)
      _focusNode.requestFocus();
    else
      _focusNode.unfocus();
  }

  /// get value field's value
  dynamic get value => _valueFieldState.value;

  /// set value
  ///
  /// [trigger] whether trigger onChanged
  void setValue(dynamic value, {bool trigger = true}) {
    _valueFieldState.doChangeValue(value, trigger: trigger);
  }

  set state(Map<String, dynamic> map) => _baseFieldState._rebuild(map);
  void update(Map<String, dynamic> map) => _baseFieldState._update(map);
  void removeState(Set<String> stateKeys) => _baseFieldState._remove(stateKeys);

  /// get textSelectionManagement
  ///
  /// only support textfield|numberfield
  ///
  TextSelectionManagement get textSelectionManagement {
    var valueNotifier = _valueNotifier;
    assert(valueNotifier is TextSelectionManagement,
        'ValueNotifier is not implemented TextSelectionManagement');
    return valueNotifier as TextSelectionManagement;
  }

  /// get SubController
  ///
  /// used to control sub item's state (like radiogroup's radio item)
  SubControllerDelegate get subController {
    var valueNotifier = _valueNotifier;
    assert(valueNotifier is SubController,
        'ValueNotifier is not implemented SubController');
    return SubControllerDelegate._(valueNotifier);
  }

  set focusListener(FocusListener listener) =>
      _formResourceManagement.focusListenerMap[_controlKey] = listener;

  _FormItemWidgetState get _itemState =>
      _formResourceManagement.getItemState(_controlKey);

  ValueFieldState get _valueFieldState =>
      _formResourceManagement.getValueFieldState(_controlKey);

  _BaseFieldState get _baseFieldState =>
      _formResourceManagement.getBaseFieldState(_controlKey);

  FocusNode get _focusNode => _formResourceManagement.getFocusNode(_controlKey);

  ValueNotifier get _valueNotifier =>
      _formResourceManagement.getValueNotifier(_controlKey);
}

/// used to control form field which has a controlKey
class FormFieldManagement extends _AbstractFormFieldManagement {
  FormFieldManagement._(
      String controlKey, _FormResourceManagement formResourceManagement)
      : super(controlKey, formResourceManagement);
}

/// used to control form  field by it's position of layout
///
/// if your form field has a controlKey,use [FormManagement] first if it meet you needs!
///
/// **for some methods that relies on valuenotifier|focusnode (eg:requestFocus|unfocus...)**
/// **you should call them only you confirm that the layout of form won't changed!**
class FormLayoutManagement {
  final _FormResourceManagement _formResourceManagement;
  FormLayoutManagement._(this._formResourceManagement);

  /// get rows of form
  int get rows => _formResourceManagement.state._formLayout.rows.length;

  FormLayoutRowManagement getFormLayoutRowManagement(int row) {
    assert(_formResourceManagement != null);
    assert(row >= 0 && row < rows);
    return FormLayoutRowManagement._(row, _formResourceManagement);
  }

  FormLayoutFieldManagement getFormLayoutFieldManagement(int row, int column) {
    assert(_formResourceManagement != null);
    assert(row >= 0 && row < rows);
    assert(column >= 0 &&
        column <
            _formResourceManagement
                .state._formLayout.rows[row].builders.length);
    return FormLayoutFieldManagement._(row, column, _formResourceManagement);
  }
}

class FormLayoutRowManagement {
  final int row;
  final _FormResourceManagement _formResourceManagement;

  FormLayoutRowManagement._(this.row, this._formResourceManagement);

  int get columns =>
      _formResourceManagement.state._formLayout.rows[row].builders.length;

  set visible(bool visible) => _itemStates.forEach((element) {
        element.visible = visible;
      });

  set readOnly(bool readOnly) => _itemStates
          .map((element) => _formResourceManagement
              .getBaseFieldState(element.widget.controlKey))
          .forEach((element) {
        element._readOnly = readOnly;
      });

  set remove(bool remove) => _itemStates.forEach((element) {
        element.remove = remove;
      });

  /// whether a field|row is visiable
  bool get visible {
    List<_FormItemWidgetState> states = _itemStates;
    for (_FormItemWidgetState state in states) {
      if (!state.visible) return false;
    }
    return true;
  }

  List<_FormItemWidgetState> get _itemStates {
    List<_FormItemWidgetState> states =
        _formResourceManagement.statesList.where((element) {
      return element.widget.row == row;
    }).toList();
    assert(states.isNotEmpty, 'no item states can be founded at row : $row');
    return states;
  }
}

class FormLayoutFieldManagement extends _AbstractFormFieldManagement {
  final int row;
  final int column;

  FormLayoutFieldManagement._(
      this.row, this.column, _FormResourceManagement _formResourceManagement)
      : super(
            _formResourceManagement.statesList
                .where((element) {
                  return element.widget.row == row &&
                      element.widget.column == column;
                })
                .toList()
                .first
                .widget
                .controlKey,
            _formResourceManagement);
}

/// used to modify widget tree
///
/// any method that modify widget tree will rebuild form ,especially those fields that
/// does not has a controlKey will also dispose state and create a new one,
/// it means you are lost field states that you setted via update or rebuild
///
/// you should call startEdit first and call apply when finished
class FormWidgetTreeManagement {
  _FormLayout _formLayout;
  final _FormResourceManagement _formResourceManagement;
  FormWidgetTreeManagement._(this._formResourceManagement);

  bool get isEditing => _formLayout != null;

  /// get editing layout rows
  int get rows {
    assert(_formLayout != null, 'you should call startEdit first!');
    return _formLayout.rows.length;
  }

  /// get columns of a row
  int getColumns(int row) {
    assert(row >= 0);
    assert(_formLayout != null, 'you should call startEdit first!');
    return _formLayout.rows[row].builders.length;
  }

  // remove a field in widget tree
  // if row only has this field ,it will be also removed
  void remove(String controlKey) {
    assert(_formLayout != null, 'you should call startEdit first!');
    _formLayout.rows.forEach((element) {
      element.builders
          .removeWhere((element) => element.controlKey == controlKey);
    });
  }

  // remove field or a row at position
  ///
  /// for better performance , you'd use [FormLayoutManagement.setVisibleAtPosition] rather than this method ,
  /// setVisibleAtPosition only affect one or several fields,but this method will rebuild form,
  void removeAtPosition(int row, {int column}) {
    assert(_formLayout != null, 'you should call startEdit first!');
    assert(row >= 0 && row < _formLayout.rows.length);
    if (column == null) {
      _formLayout.rows.removeAt(row);
    } else {
      _FormRow formRow = _formLayout.rows[row];
      assert(column >= 0 && column < formRow.builders.length);
      formRow.builders.removeAt(column);
    }
  }

  /// insert a field at position
  void insert(
      {int column,
      int row,
      String controlKey,
      int flex = 1,
      bool visible = true,
      EdgeInsets padding,
      @required Widget field,
      bool inline = true,
      bool insertRow = false}) {
    assert(_formLayout != null, 'you should call startEdit first!');
    assert(field is ValueField || field is CommonField,
        'field must valuefield or commonfield');
    assert(row == null ||
        (row >= 0 &&
            ((row < _formLayout.rows.length && !insertRow) ||
                (row <= _formLayout.rows.length && insertRow))));
    _FormRow formRow = row == null
        ? insertRow
            ? _formLayout.append()
            : _formLayout.rows[_formLayout.rows.length - 1]
        : insertRow
            ? _formLayout.insert(row)
            : _formLayout.rows[row];
    _FormItemBuilder builder = _FormItemBuilder(
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
    assert(_formLayout != null, 'you should call startEdit first!');
    assert(oldRow != newRow);
    int rows = _formLayout.rows.length;
    assert(oldRow >= 0 && oldRow < rows);
    assert(newRow >= 0 && newRow < rows);
    _FormRow row = _formLayout.rows.removeAt(oldRow);
    _formLayout.rows.insert(newRow, row);
  }

  void startEdit() {
    assert(_formLayout == null,
        'call apply first before you call startEdit again');
    _formLayout = _formResourceManagement.state._formLayout.copy();
    _formLayout.removeEmptyRow();
  }

  void cancel() {
    assert(_formLayout != null, 'call startEdit first before you cancel');
    _formLayout = null;
  }

  void apply() {
    assert(_formLayout != null, 'call startEdit first before you apply');
    _formLayout.removeEmptyRow();
    _formResourceManagement.state.formLayout = _formLayout;
    _formLayout = null;
  }
}

class _FormLayout {
  final List<_FormRow> rows = [_FormRow()];

  _FormRow append() {
    _FormRow row = _FormRow();
    rows.add(row);
    return row;
  }

  _FormRow insert(int index) {
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
  final List<_FormItemBuilder> builders = [];

  void append(_FormItemBuilder builder) {
    assert(stretchable, 'row is not stretchable,can not append field again');
    assert((!builder.inline && builders.isEmpty) || builder.inline,
        'current field is not support inline mode,can not append');
    if (!builder.inline) {
      stretchable = false;
    }
    builders.add(builder);
  }

  void insert(_FormItemBuilder builder, int index) {
    if (builders.isEmpty) {
      assert(index == 0);
      if (!builder.inline) {
        stretchable = false;
      }
      builders.add(builder);
      return;
    }
    assert(index >= 0 && index < builders.length);
    assert((!builder.inline && builders.isEmpty) || builder.inline,
        'current field is not support inline mode,can not insert');
    if (index == builders.length)
      append(builder);
    else {
      assert(stretchable, 'row is not stretchable,can not insert field');
      builders.insert(index, builder);
    }
  }

  _FormRow copy() {
    _FormRow row = _FormRow();
    row.builders.addAll(List.of(builders));
    row.stretchable = stretchable;
    return row;
  }
}
