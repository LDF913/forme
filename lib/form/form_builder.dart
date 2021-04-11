import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/form/switch_group.dart';
import 'package:provider/provider.dart';
import 'button.dart';
import 'checkbox_group.dart';
import 'form_theme.dart';
import 'text_field.dart';
import 'radio_group.dart';
import 'selector.dart';

typedef FormWidgetBuilder = Widget Function(
    BuildContext context, Map<String, dynamic> map);

class FormBuilder {
  List<_FormItemWidget> _builders = [];
  List<List<_FormItemWidget>> _builderss = [];
  final FormController formController;

  FormBuilder(this.formController)
      : assert(
          formController != null,
          'FormController can not be null',
        );

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
      ValueChanged<String> onSubmitted,
      Key key,
      int flex,
      Widget prefixIcon,
      int maxLength,
      ValueChanged<double> onChanged,
      FormFieldValidator<double> validator,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      double min,
      double max,
      bool clearable = false,
      bool readOnly = false,
      bool visible = true,
      int decimal = 0,
      EdgeInsets padding,
      TextStyle style}) {
    TextEditingController controller = formController._controllers
        .putIfAbsent(controlKey, () => TextEditingController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      flex: flex,
      builder: (context, map) {
        int _decimal = map['decimal'] ?? decimal;
        double _max = map['max'] ?? max;
        double _min = map['min'] ?? min;
        String regex = r'[0-9' +
            (_decimal > 0 ? '.' : '') +
            (_min != null && _min > 0 ? '' : '-') +
            ']';
        List<TextInputFormatter> formatters = [
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text == '') return newValue;
            if ((_min == null || _min < 0) && newValue.text == '-')
              return newValue;
            double parsed = double.tryParse(newValue.text);
            if (parsed == null) {
              return oldValue;
            }
            if (decimal != null) {
              int indexOfPoint = newValue.text.indexOf(".");
              if (indexOfPoint != -1) {
                int decimalNum = newValue.text.length - (indexOfPoint + 1);
                if (decimalNum > _decimal) {
                  return oldValue;
                }
              }
            }

            if (_max != null && parsed > _max) {
              return oldValue;
            }
            return newValue;
          }),
          FilteringTextInputFormatter.allow(RegExp(regex))
        ];
        FormFieldValidator<String> fieldValidator = (value) {
          if (value == null || value == '') {
            return validator(null);
          }
          String msg;
          double parsedValue = double.parse(value);
          if (validator != null) {
            msg = validator(parsedValue);
          }
          if (msg != null) {
            return msg;
          }
          if (_min != null && _min > parsedValue) {
            return '必须大于:$_min';
          }
          if (_max != null && _max < parsedValue) {
            return '必须小于:$_max';
          }
          return null;
        };

        bool _readOnly = map['readOnly'] ?? readOnly;
        return ClearableTextFormField(
          controlKey,
          controller,
          key: key,
          hintText: map['hintText'] ?? hintText,
          labelText: map['labelText'] ?? labelText,
          focusNode: focusNode,
          maxLines: 1,
          passwordVisible: false,
          obscureText: false,
          onTap: onTap,
          onFieldSubmitted: onSubmitted,
          keyboardType: TextInputType.number,
          validator: fieldValidator,
          autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
          clearable: map['clearable'] ?? clearable,
          prefixIcon: map['prefixIcon'] ?? prefixIcon,
          inputFormatters: formatters,
          padding: map['padding'] ?? padding,
          readOnly: _readOnly,
          style: map['style'] ?? style,
        );
      },
    ));
    return this;
  }

  FormBuilder textField(String controlKey,
      {String hintText,
      String labelText,
      VoidCallback onTap,
      ValueChanged<String> onSubmitted,
      Key key,
      bool obscureText: false,
      int flex,
      int maxLines = 1,
      Widget prefixIcon,
      TextInputType keyboardType,
      int maxLength,
      ValueChanged<String> onChanged,
      FormFieldValidator<String> validator,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      bool clearable = false,
      bool passwordVisible = false,
      bool readOnly = false,
      bool visible = true,
      String regExp,
      List<TextInputFormatter> inputFormatters,
      EdgeInsets padding,
      TextStyle style}) {
    TextEditingController controller = formController._controllers
        .putIfAbsent(controlKey, () => TextEditingController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      flex: flex,
      builder: (context, map) {
        List<TextInputFormatter> formatters = inputFormatters ?? [];
        if (regExp != null) {
          String _regExp = map['regExp'] ?? regExp;
          if (_regExp != null)
            formatters.add(
              FilteringTextInputFormatter.allow(RegExp(_regExp)),
            );
        }
        return ClearableTextFormField(
          controlKey,
          controller,
          key: key,
          hintText: map['hintText'] ?? hintText,
          labelText: map['labelText'] ?? labelText,
          focusNode: focusNode,
          maxLength: map['maxLength'] ?? maxLength,
          maxLines: map['maxLines'] ?? maxLines,
          obscureText: obscureText,
          onTap: onTap,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
          clearable: map['clearable'] ?? clearable,
          prefixIcon: map['prefixIcon'] ?? prefixIcon,
          passwordVisible: map['passwordVisible'] ?? passwordVisible,
          onChanged: onChanged,
          inputFormatters: formatters,
          padding: map['padding'] ?? padding,
          readOnly: map['readOnly'] ?? readOnly,
          style: map['style'] ?? style,
        );
      },
    ));
    return this;
  }

  FormBuilder radios(String controlKey, List<RadioButton> items,
      {RadioGroupController controller,
      Key key,
      ValueChanged onChanged,
      int flex = 0,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets padding}) {
    RadioGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => RadioGroupController());
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      flex: flex,
      builder: (context, map) => RadioGroup(
        controlKey,
        List.of(map['items'] ?? items),
        controller,
        key: key,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.disabled,
        padding: map['padding'] ?? padding,
        split: 0,
        readOnly: map['readOnly'] ?? readOnly,
      ),
    ));
    return this;
  }

  FormBuilder radioGroup(String controlKey, List<RadioButton> items,
      {Key key,
      String label,
      RadioGroupController controller,
      FormFieldValidator validator,
      ValueChanged onChanged,
      bool readOnly = false,
      bool visible = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      int split = 2,
      EdgeInsets padding}) {
    RadioGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => RadioGroupController());
    nextLine();
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      builder: (context, map) => RadioGroup(
        controlKey,
        List.of(map['items'] ?? items),
        controller,
        key: key,
        label: map['label'] ?? label,
        validator: validator,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        split: split,
        padding: map['padding'] ?? padding,
        readOnly: map['readOnly'] ?? readOnly,
      ),
    ));
    nextLine();
    return this;
  }

  FormBuilder checkboxs(String controlKey, List<CheckboxButton> items,
      {CheckboxGroupController controller,
      Key key,
      ValueChanged<List<int>> onChanged,
      bool readOnly = false,
      bool visible = true,
      int flex = 0,
      EdgeInsets padding}) {
    CheckboxGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => CheckboxGroupController());
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      builder: (context, map) {
        return CheckboxGroup(
          controlKey,
          List.of(map['items'] ?? items),
          controller,
          key: key,
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.disabled,
          split: 0,
          padding: map['padding'] ?? padding,
          readOnly: map['readOnly'] ?? readOnly,
        );
      },
      flex: flex,
    ));
    return this;
  }

  FormBuilder checkboxGroup(String controlKey, List<CheckboxButton> items,
      {Key key,
      String label,
      ValueChanged<List<int>> onChanged,
      FormFieldValidator<List<int>> validator,
      bool readOnly = false,
      bool visible = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      int split = 2,
      EdgeInsets padding}) {
    CheckboxGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => CheckboxGroupController());
    nextLine();
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      builder: (context, map) {
        return CheckboxGroup(
          controlKey,
          List.of(map['items'] ?? items),
          controller,
          key: key,
          label: map['label'] ?? label,
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
          split: map['split'] ?? split,
          padding: map['padding'] ?? padding,
          readOnly: map['readOnly'] ?? readOnly,
        );
      },
    ));
    nextLine();
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
      _FormItemWidget(visible, readOnly,
          controlKey: controlKey,
          flex: flex,
          builder: (context, map) => Align(
                alignment: alignment ?? Alignment.centerLeft,
                child: Button(
                  controlKey,
                  onPressed,
                  key: key,
                  label: map['label'] ?? label,
                  child: map['child'] ?? child,
                  onLongPress: onLongPress,
                  padding: map['padding'] ?? padding,
                  readOnly: map['readOnly'] ?? readOnly,
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
      ValueChanged<DateTime> onChanged}) {
    DateTimeController controller = formController._controllers
        .putIfAbsent(controlKey, () => DateTimeController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());
    _builders.add(
      _FormItemWidget(visible, readOnly,
          controlKey: controlKey,
          flex: flex,
          builder: (context, map) => DateTimeFormField(controlKey, controller,
              key: key,
              hintText: map['hintText'] ?? hintText,
              labelText: map['labelText'] ?? labelText,
              focusNode: focusNode,
              formatter: map['formatter'] ?? formatter,
              validator: validator,
              useTime: map['useTime'] ?? useTime,
              padding: map['padding'] ?? padding,
              readOnly: map['readOnly'] ?? readOnly,
              style: map['style'] ?? style,
              maxLines: map['maxLines'] ?? maxLines,
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
    List<SelectorItem> items,
    FormFieldValidator validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    EdgeInsets padding,
    TextStyle style,
    bool loading = false,
    bool multi = false,
    ValueChanged<List> onChanged,
  }) {
    SelectorController controller = formController._controllers
        .putIfAbsent(controlKey, () => SelectorController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());
    _builders.add(
      _FormItemWidget(visible, readOnly,
          controlKey: controlKey,
          flex: 1,
          builder: (context, map) => SelectorFormField(
                controlKey,
                focusNode,
                map['items'] ?? items ?? [],
                controller,
                onChanged: onChanged,
                labelText: map['labelText'] ?? labelText,
                hintText: map['hintText'] ?? hintText,
                clearable: map['clearable'] ?? clearable,
                validator: validator,
                autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
                padding: map['padding'] ?? padding,
                readOnly: map['readOnly'] ?? readOnly,
                style: map['style'] ?? style,
                loading: map['loading'] ?? loading,
                multi: map['multi'] ?? multi,
              )),
    );
    return this;
  }

  FormBuilder divider(String controlKey,
      {double height = 1.0,
      bool visible = true,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 5)}) {
    nextLine();
    _builders.add(_FormItemWidget(
      visible,
      true,
      controlKey: controlKey,
      flex: 1,
      builder: (context, map) {
        FormThemeData formThemeData = FormThemeData.of(context);
        return Padding(
          padding: map['padding'] ??
              padding ??
              formThemeData.padding ??
              EdgeInsets.zero,
          child: Divider(
            height: map['height'] ?? height ?? 1.0,
          ),
        );
      },
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
    List<String> items,
    bool hasSelectAllSwitch,
    ValueChanged<List<int>> onChanged,
    FormFieldValidator<List<int>> validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) {
    SwitchGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => SwitchGroupController());
    nextLine();
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      flex: 1,
      builder: (context, map) {
        return SwitchGroup(
          controlKey,
          controller,
          label: map['label'] ?? label,
          readOnly: map['readOnly'] ?? readOnly,
          items: map['items'] ?? items ?? [],
          hasSelectAllSwitch:
              map['hasSelectAllSwitch'] ?? hasSelectAllSwitch ?? true,
          validator: validator,
          autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
          onChanged: onChanged,
        );
      },
    ));
    nextLine();
    return this;
  }

  FormBuilder switch1(
    String controlKey, {
    bool visible = true,
    bool readOnly = false,
    EdgeInsets padding,
    int flex = 0,
    ValueChanged<List<int>> onChanged,
  }) {
    SwitchGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => SwitchGroupController());
    _builders.add(_FormItemWidget(
      visible,
      readOnly,
      controlKey: controlKey,
      flex: flex,
      builder: (context, map) {
        return SwitchGroup(
          controlKey,
          controller,
          readOnly: map['readOnly'] ?? readOnly,
          items: [''],
          hasSelectAllSwitch: false,
          autovalidateMode: AutovalidateMode.disabled,
          onChanged: onChanged,
        );
      },
    ));
    return this;
  }

  Widget build() {
    nextLine();
    return _FormWidget(_builderss, formController);
  }

  static List<SelectorItem> toSelectorItems(List<String> items) {
    return items.map((e) => SelectorItem(e, e)).toList();
  }

  static List<CheckboxButton> toCheckboxButtons(List<String> items) {
    return items.map((e) => CheckboxButton(e)).toList();
  }
}

class FormController extends ChangeNotifier {
  bool _visible = true;
  bool _readOnly = false;

  FormThemeData _themeData = FormThemeData();
  final Map<String, dynamic> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, _FormItemWidgetState> _states = {};
  final Set<FormBuilderFieldState<dynamic>> _fields =
      <FormBuilderFieldState<dynamic>>{};
  final ChangeNotifier _themeDataNotifier = ChangeNotifier();

  get themeData => _themeData;

  set themeData(FormThemeData theme) {
    if (theme != null) {
      _themeData = theme;
      _themeDataNotifier.notifyListeners();
    }
  }

  get visible => _visible;

  set visible(bool visible) {
    if (_visible != visible) {
      _visible = visible;
      notifyListeners();
    }
  }

  get readOnly => _readOnly;

  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      _readOnly = readOnly;
      _states.forEach((key, value) {
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

  dynamic getValue(String controlKey) {
    FormBuilderFieldState state =
        _fields.where((element) => (element.controlKey == controlKey)).first;
    return state == null ? null : state.value;
  }

  void rebuild(String controlKey, Map<String, dynamic> map) {
    _ifFormItemWidgetStatePresent(controlKey, (state) => state.rebuild(map));
  }

  void update(String controlKey, Map<String, dynamic> map) {
    _ifFormItemWidgetStatePresent(controlKey, (state) => state.update(map));
  }

  void setVisible(String controlKey, bool visible) {
    _ifFormItemWidgetStatePresent(
        controlKey, (state) => state.visible = visible);
  }

  void setReadOnly(String controlKey, bool readOnly) {
    _ifFormItemWidgetStatePresent(
        controlKey, (state) => state.readOnly = readOnly);
  }

  bool isVisible(String controlKey) {
    return _ifFormItemWidgetStatePresent(
            controlKey, (state) => state.visible) ??
        false;
  }

  bool isReadOnly(String controlKey) {
    return _ifFormItemWidgetStatePresent(
            controlKey, (state) => state.readOnly) ??
        false;
  }

  Map<String, dynamic> getData() {
    Map<String, dynamic> map = {};
    _fields.forEach((element) {
      dynamic value = element.value;
      if (value != null) {
        map[element.controlKey] = value;
      }
    });
    return map;
  }

  void setValue(String controlKey, dynamic value) {
    _fields
        .where((element) => (element.controlKey == controlKey))
        .forEach((element) {
      element.didChange(value);
    });
  }

  dynamic getController(String controlKey) {
    return _controllers[controlKey];
  }

  void reset() {
    for (final FormFieldState<dynamic> field in _fields) field.reset();
  }

  bool validate() {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in _fields)
      hasError = !field.validate() || hasError;
    return !hasError;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNodes.values.forEach((element) {
      element.dispose();
    });
    _controllers.values.forEach((element) {
      element.dispose();
    });
    _states.clear();
    _themeDataNotifier.dispose();
    _fields.clear();
  }

  dynamic _ifFormItemWidgetStatePresent(String controlKey, Function consumer) {
    _FormItemWidgetState state = _states[controlKey];
    if (state != null) {
      return consumer(state);
    }
    return null;
  }

  static FormController of(BuildContext context) {
    return context.read<FormController>();
  }
}

class _FormItemWidget extends StatefulWidget {
  final String controlKey;
  final int flex;
  final bool visible;
  final bool readOnly;
  final FormWidgetBuilder builder;
  const _FormItemWidget(this.visible, this.readOnly,
      {Key key, this.controlKey, this.flex, this.builder})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormItemWidgetState();
}

class _FormItemWidgetState extends State<_FormItemWidget> {
  Map<String, dynamic> map = {};
  get visible => map['visible'] ?? widget.visible ?? true;
  get readOnly => map['readOnly'] ?? widget.readOnly ?? false;
  get flex => map['flex'] ?? widget.flex ?? 1;

  set readOnly(bool readOnly) {
    if (readOnly != this.readOnly) {
      setState(() {
        map['readOnly'] = readOnly;
      });
    }
  }

  set visible(bool visible) {
    if (visible != this.visible) {
      setState(() {
        map['visible'] = visible;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    print('deactivate');
    FormController.of(context)._states.remove(widget.controlKey);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    FormController.of(context)._states[widget.controlKey] = this;
    return Visibility(
      child: Expanded(
        child: widget.builder(context, map),
        flex: flex,
      ),
      visible: visible,
    );
  }

  void rebuild(Map<String, dynamic> map) {
    setState(() {
      this.map = map ?? {};
    });
  }

  void update(Map<String, dynamic> map) {
    if (map == null) return;
    setState(() {
      map.forEach((key, value) {
        if (value == null) {
          this.map.remove(key);
        } else {
          this.map[key] = value;
        }
      });
    });
  }
}

class _FormWidget extends StatefulWidget {
  final List<List<_FormItemWidget>> builderss;
  final FormController formController;

  const _FormWidget(this.builderss, this.formController, {Key key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  @override
  void initState() {
    super.initState();
    widget.formController._themeDataNotifier.addListener(handleThemeChange);
  }

  void dispose() {
    super.dispose();
    widget.formController._themeDataNotifier.removeListener(handleThemeChange);
  }

  void handleThemeChange() {
    setState(() {});
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
        data: getThemeData(context),
        child: ChangeNotifierProvider<FormController>(
          create: (context) => widget.formController,
          child: Consumer<FormController>(
            builder: (context, c, child) {
              return Visibility(
                maintainState: true,
                child: Column(
                  children: rows,
                ),
                visible: c._visible,
              );
            },
          ),
        ));
  }

  ThemeData getThemeData(BuildContext context) {
    ThemeData themeData;
    if (widget.formController.themeData.themeDataBuilder != null) {
      themeData = widget.formController.themeData.themeDataBuilder(context);
    } else {
      themeData = Theme.of(context);
    }
    return themeData;
  }
}

class FormBuilderFieldState<T> extends FormFieldState<T> {
  ValueNotifier get controller => (widget as FormBuilderField<T>)._controller;
  bool get readOnly => (widget as FormBuilderField)._readOnly;
  ValueChanged<T> get onChanged => (widget as FormBuilderField<T>)._onChanged;
  String get controlKey => (widget as FormBuilderField<T>)._controlKey;

  @override
  void deactivate() {
    FormController.of(context)._fields.remove(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    FormController.of(context)._fields.add(this);
    return widget.builder(this);
  }

  @override
  void initState() {
    controller.addListener(handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(handleChanged);
    super.dispose();
  }

  @override
  void didChange(T value) {
    super.didChange(value);
    if (controller.value != value) {
      controller.value = value;
      if (onChanged != null) {
        onChanged(value);
      }
    }
  }

  @override
  void reset() {
    super.reset();
    controller.value = null;
    if (onChanged != null) {
      onChanged(null);
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

  @protected
  void handleChanged() {
    if (controller.value != value) didChange(controller.value);
  }

  @override
  void setValue(T value) {
    super.setValue(value);
  }
}

class FormBuilderField<T> extends FormField<T> {
  final ValueNotifier _controller;
  final bool _readOnly;
  final ValueChanged<T> _onChanged;
  final String _controlKey;

  FormBuilderField(
    this._controlKey,
    this._controller,
    this._readOnly,
    this._onChanged, {
    Key key,
    FormFieldBuilder<T> builder,
    FormFieldValidator<T> validator,
    AutovalidateMode autovalidateMode,
  }) : super(
            key: key,
            builder: builder,
            validator: validator,
            autovalidateMode: autovalidateMode);

  @override
  FormBuilderFieldState<T> createState() => FormBuilderFieldState<T>();
}
