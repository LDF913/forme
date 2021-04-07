import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'button.dart';
import 'form_theme.dart';
import 'text_field.dart';
import 'radio_group.dart';
import 'checkbox_group.dart';
import 'drop_down.dart';

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
      {String hintLabel,
      String label,
      VoidCallback onTap,
      ValueChanged<String> onSubmitted,
      Key key,
      int flex,
      Widget prefixIcon,
      int maxLength,
      ValueChanged<String> onChanged,
      FormFieldValidator<double> validator,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      double min,
      double max,
      double initialValue,
      bool clearable = false,
      bool readOnly = false,
      bool visible = true,
      int decimal = 0}) {
    TextEditingController controller = formController._controllers
        .putIfAbsent(controlKey, () => TextEditingController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());

    _builders.add(_FormItemWidget(
      formController,
      controlKey: controlKey,
      flex: flex,
      builder: (context, map) {
        int _decimal = map['decimal'] ?? decimal;
        double _max = map['max'] ?? max;
        double _min = map['min'] ?? min;
        List<TextInputFormatter> formatters = [
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text == '') return newValue;
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
          FilteringTextInputFormatter.allow(
              decimal > 0 ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'))
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

        return ClearableTextFormField(
          controlKey,
          key: key,
          hintLabel: map['hintLabel'] ?? hintLabel,
          label: map['label'] ?? label,
          focusNode: focusNode,
          maxLines: 1,
          passwordVisible: false,
          obscureText: false,
          controller: controller,
          onTap: onTap,
          onFieldSubmitted: onSubmitted,
          keyboardType: TextInputType.number,
          validator: fieldValidator,
          autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
          clearable: map['clearable'] ?? clearable,
          prefixIcon: map['prefixIcon'] ?? prefixIcon,
          initialValue: map['initialValue'] ?? initialValue,
          onChanged: onChanged,
          inputFormatters: formatters,
        );
      },
    ));
    return this;
  }

  FormBuilder textField(String controlKey,
      {String hintLabel,
      String label,
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
      String initialValue,
      String regExp,
      List<TextInputFormatter> inputFormatters}) {
    _setInitialStateKey(readOnly, visible, controlKey);

    TextEditingController controller = formController._controllers
        .putIfAbsent(controlKey, () => TextEditingController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());

    _builders.add(_FormItemWidget(
      formController,
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
          key: key,
          hintLabel: map['hintLabel'] ?? hintLabel,
          label: map['label'] ?? label,
          focusNode: focusNode,
          maxLength: map['maxLength'] ?? maxLength,
          maxLines: map['maxLines'] ?? maxLines,
          obscureText: obscureText,
          controller: controller,
          onTap: onTap,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
          clearable: map['clearable'] ?? clearable,
          prefixIcon: map['prefixIcon'] ?? prefixIcon,
          passwordVisible: map['passwordVisible'] ?? passwordVisible,
          initialValue: map['initialValue'] ?? initialValue,
          onChanged: onChanged,
          inputFormatters: formatters,
        );
      },
    ));
    return this;
  }

  FormBuilder radios(String controlKey, List<RadioButton> items,
      {RadioGroupController controller,
      Key key,
      dynamic initialValue,
      FormFieldValidator validator,
      ValueChanged onChanged,
      int flex = 0,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      bool readOnly = false,
      bool visible = true}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    RadioGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => RadioGroupController());
    _builders.add(_FormItemWidget(
      formController,
      controlKey: controlKey,
      flex: flex,
      builder: (context, map) => RadioGroup(
        controlKey,
        List.from(map['items'] ?? items),
        key: key,
        controller: controller,
        initialValue: map['initialValue'] ?? initialValue,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
      ),
    ));
    return this;
  }

  FormBuilder radioGroup(String controlKey, List<RadioButton> items,
      {Key key,
      String label,
      RadioGroupController controller,
      dynamic initialValue,
      FormFieldValidator validator,
      ValueChanged onChanged,
      bool readOnly = false,
      bool visible = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      int split = 2}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    RadioGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => RadioGroupController());
    nextLine();
    _builders.add(_FormItemWidget(
      formController,
      controlKey: controlKey,
      builder: (context, map) => RadioGroup(
        controlKey,
        List.from(map['items'] ?? items),
        key: key,
        controller: controller,
        initialValue: map['initialValue'] ?? initialValue,
        label: map['label'] ?? label,
        validator: validator,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        split: split,
      ),
    ));
    nextLine();
    return this;
  }

  FormBuilder checkboxs(String controlKey, List<CheckboxButton> items,
      {CheckboxGroupController controller,
      Key key,
      List<int> initialValue,
      FormFieldValidator validator,
      ValueChanged<List<int>> onChanged,
      bool readOnly = false,
      bool visible = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      int flex = 0}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    CheckboxGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => CheckboxGroupController());
    _builders.add(_FormItemWidget(
      formController,
      controlKey: controlKey,
      builder: (context, map) => CheckboxGroup(
        controlKey,
        List.from(map['items'] ?? items),
        key: key,
        controller: controller,
        initialValue: map['initialValue'] ?? initialValue,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
        split: 0,
      ),
      flex: flex,
    ));
    return this;
  }

  FormBuilder checkboxGroup(String controlKey, List<CheckboxButton> items,
      {Key key,
      String label,
      List<int> initialValue,
      ValueChanged<List<int>> onChanged,
      FormFieldValidator<List<int>> validator,
      bool readOnly = false,
      bool visible = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      int split = 2}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    CheckboxGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => CheckboxGroupController());
    nextLine();
    _builders.add(_FormItemWidget(
      formController,
      controlKey: controlKey,
      builder: (context, map) => CheckboxGroup(
        controlKey,
        List.from(map['items'] ?? items),
        key: key,
        controller: controller,
        initialValue: map['initialValue'] ?? initialValue,
        label: map['label'] ?? label,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
        split: split,
      ),
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
      Alignment alignment}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    _builders.add(
      _FormItemWidget(formController,
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
                ),
              )),
    );
    return this;
  }

  FormBuilder datetimeField(String controlKey,
      {String label,
      String hintLabel,
      bool readOnly = false,
      bool visible = true,
      int flex = 1,
      DateTimeFormatter formatter,
      FormFieldValidator<DateTime> validator,
      bool useTime}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    DateTimeController controller = formController._controllers
        .putIfAbsent(controlKey, () => DateTimeController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());
    _builders.add(
      _FormItemWidget(formController,
          controlKey: controlKey,
          flex: flex,
          builder: (context, map) => DateTimeFormField(
                controlKey,
                hintLabel: map['hintLabel'] ?? hintLabel,
                label: map['label'] ?? label,
                focusNode: focusNode,
                controller: controller,
                formatter: formatter,
                validator: validator,
                useTime: map['useTime'] ?? useTime,
              )),
    );
    return this;
  }

  FormBuilder dropdown(String controlKey,
      {bool readOnly = false,
      bool visible = true,
      bool clearable = true,
      List<DropdownMenuItem> items,
      DropdownButtonBuilder selectedItemBuilder,
      FormFieldValidator validator,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled}) {
    DropdownController controller = formController._controllers
        .putIfAbsent(controlKey, () => DropdownController());
    FocusNode focusNode =
        formController._focusNodes.putIfAbsent(controlKey, () => FocusNode());
    _builders.add(
      _FormItemWidget(formController,
          controlKey: controlKey,
          flex: 1,
          builder: (context, map) => DropdownFormField(
                controlKey,
                controller,
                focusNode,
                map['items'] ?? items ?? [],
                clearable: map['clearable'] ?? clearable,
                validator: validator,
                autovalidateMode: map['autovalidateMode'] ?? autovalidateMode,
                selectedItemBuilder:
                    map['selectedItemBuilder'] ?? selectedItemBuilder,
              )),
    );
    return this;
  }

  Widget build() {
    nextLine();
    List<Row> rows = [];
    for (List<_FormItemWidget> builders in _builderss) {
      rows.add(Row(
        children: builders,
      ));
    }
    return Form(
        key: formController._formKey,
        child: ChangeNotifierProvider(
          create: (context) => formController,
          child: Consumer<FormController>(
            builder: (context, c, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                c._rebuild = false;
              });
              return Theme(
                  data: formController.theme.themeData ?? Theme.of(context),
                  child: Visibility(
                    maintainState: true,
                    child: Column(
                      children: rows,
                    ),
                    visible: !c._hide,
                  ));
            },
          ),
        ));
  }

  void _setInitialStateKey(bool readOnly, bool visible, String controlKey) {
    if (readOnly) formController._addReadOnlyKey(controlKey);
    if (!visible) formController._addHideKey(controlKey);
  }

  static List<DropdownMenuItem> toDropdownItems(List<String> items) {
    return items
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
  }

  static List<CheckboxButton> toCheckboxButtons(List<String> items) {
    return items.map((e) => CheckboxButton(e)).toList();
  }
}

class FormController extends ChangeNotifier {
  bool _hide = false;
  bool _readOnly = false;
  bool _rebuild = false;

  final GlobalKey _formKey = GlobalKey<FormState>();
  final Set<String> _hideKeys = {};
  final Set<String> _readOnlyKeys = {};
  final FormTheme theme = FormTheme();

  FormController() {
    theme.addListener(_themeChange);
  }

  static FormController of(BuildContext context) {
    return context.read<FormController>();
  }

  final Map<String, dynamic> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  final Map<String, _FormItemWidgetState> _states = {};

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
    dynamic valueNotifier = getController(controlKey);
    return valueNotifier == null ? null : _getValue(valueNotifier);
  }

  void rebuild(String controlKey, Map<String, dynamic> map) {
    _FormItemWidgetState state = _states[controlKey];
    if (state != null) state.rebuild(map);
  }

  void _themeChange() {
    _rebuild = true;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _hideKeys.clear();
    _readOnlyKeys.clear();
    _focusNodes.values.forEach((element) {
      element.dispose();
    });
    _controllers.values.forEach((element) {
      element.dispose();
    });
    _states.clear();
    theme.dispose();
  }

  Map<String, dynamic> getData() {
    Map<String, dynamic> map = {};
    _controllers.forEach((key, notifier) {
      dynamic value = _getValue(notifier);
      if (value != null) {
        map[key] = value;
      }
    });
    return map;
  }

  void setValue(String controlKey, dynamic value) {
    var controller = getController(controlKey);
    if (controller != null) _setValue(controller, value);
  }

  dynamic getController(String controlKey) {
    return _controllers[controlKey];
  }

  void _addHideKey(String controlKey) {
    _hideKeys.add(controlKey);
  }

  void _addReadOnlyKey(String controlKey) {
    _readOnlyKeys.add(controlKey);
  }

  dynamic _getValue(dynamic valueNotifier) {
    if (valueNotifier is ValueNotifier) {
      if (valueNotifier is TextEditingController) {
        return valueNotifier.text;
      } else {
        return valueNotifier.value;
      }
    }
    return null;
  }

  void _setValue(dynamic valueNotifier, dynamic value) {
    if (valueNotifier is ValueNotifier) {
      if (valueNotifier is TextEditingController) {
        valueNotifier.text = value.toString();
      } else {
        valueNotifier.value = value;
      }
    }
  }

  get hide => _hide;

  set hide(bool hide) {
    if (_hide != hide) {
      _hide = hide;
      notifyListeners();
    }
  }

  get readOnly => _readOnly;

  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      _readOnly = readOnly;
      notifyListeners();
    }
  }

  void reset() {
    _state.reset();
  }

  bool validate() {
    return _state.validate();
  }

  get _state => _formKey.currentState;

  set hideKeys(List<String> keys) {
    _hideKeys.clear();
    if (keys != null) _hideKeys.addAll(keys);
    notifyListeners();
  }

  set readOnlyKeys(List<String> keys) {
    _readOnlyKeys.clear();
    if (keys != null) _readOnlyKeys.addAll(keys);
    notifyListeners();
  }

  bool isHide(String key) {
    return _hide || _hideKeys.contains(key);
  }

  bool isReadOnly(String key) {
    return _readOnly || _readOnlyKeys.contains(key);
  }
}

class _FormItemWidget extends StatefulWidget {
  final FormController formController;
  final String controlKey;
  final int flex;
  final FormWidgetBuilder builder;
  const _FormItemWidget(this.formController,
      {Key key, this.controlKey, this.flex, this.builder})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormItemWidgetState();
}

class _FormItemWidgetState extends State<_FormItemWidget> {
  bool hide = false;
  bool readOnly = false;
  bool forceRebuild = false;
  Map<String, dynamic> map = {};
  get flex => map['flex'] ?? widget.flex ?? 1;

  @override
  void initState() {
    super.initState();
    widget.formController._states[widget.controlKey] = this;
  }

  @override
  void dispose() {
    super.dispose();
    widget.formController._states.remove(widget.controlKey);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildChild() {
      return Visibility(
        child: Expanded(
          child: widget.builder(context, map),
          flex: flex,
        ),
        visible: !hide,
      );
    }

    return Consumer<FormController>(
      builder: (context, v, child) {
        if (forceRebuild || v._rebuild) {
          forceRebuild = false;
          return buildChild();
        }
        bool currentHide = v.isHide(widget.controlKey);
        bool currentReadOnly = v.isReadOnly(widget.controlKey);
        if (currentHide != hide || currentReadOnly != readOnly) {
          hide = currentHide;
          readOnly = currentReadOnly;
          return buildChild();
        }
        return child;
      },
      child: buildChild(),
    );
  }

  void rebuild(Map<String, dynamic> map) {
    setState(() {
      this.forceRebuild = true;
      this.map = map;
    });
  }
}
