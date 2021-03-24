import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'button.dart';
import 'textfield.dart';
import 'radio_group.dart';
import 'checkbox_group.dart';

class FormBuilder {
  List<_FormItemWidget> _builders = [];
  List<List<_FormItemWidget>> _builderss = [];
  FormController formController;

  FormBuilder(this.formController)
      : assert(
          formController != null,
          'FormController can not be null',
        );

  void nextLine() {
    if (_builders.length > 0) {
      _builderss.add(_builders);
      _builders = [];
    }
  }

  void numberField(String label, String controlKey,
      {VoidCallback onTap,
      ValueChanged<String> onSubmitted,
      Key key,
      int flex,
      Icon prefixIcon,
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
            if (decimalNum > decimal) {
              return oldValue;
            }
          }
        }

        if (max != null && parsed > max) {
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
      if (min != null && min > parsedValue) {
        return '必须大于:$min';
      }
      if (max != null && max < parsedValue) {
        return '必须小于:$max';
      }
      return null;
    };
    textField(label, controlKey,
        onTap: onTap,
        onSubmitted: onSubmitted,
        key: key,
        obscureText: false,
        flex: flex,
        maxLines: 1,
        prefixIcon: prefixIcon,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        clearable: clearable,
        readOnly: readOnly,
        visible: visible,
        validator: fieldValidator,
        inputFormatters: formatters);
  }

  void textField(String label, String controlKey,
      {VoidCallback onTap,
      ValueChanged<String> onSubmitted,
      Key key,
      bool obscureText: false,
      int flex,
      int maxLines = 1,
      Icon prefixIcon,
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

    List<TextInputFormatter> formatters = inputFormatters ?? [];
    if (regExp != null) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(regExp)),
      );
    }
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      flex: flex,
      child: ClearableTextFormField(
        label,
        controlKey,
        key: key,
        focusNode: focusNode,
        maxLength: maxLength,
        maxLines: maxLines,
        obscureText: obscureText,
        controller: controller,
        onTap: onTap,
        onFieldSubmitted: onSubmitted,
        keyboardType: keyboardType,
        validator: validator,
        autovalidateMode: autovalidateMode,
        clearable: clearable,
        prefixIcon: prefixIcon,
        passwordVisible: passwordVisible,
        initialValue: initialValue,
        onChanged: onChanged,
        inputFormatters: formatters,
      ),
    ));
  }

  void radios(String controlKey, List<RadioButton> radios,
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
      controlKey: controlKey,
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: RadioGroup(
          controlKey,
          List.from(radios),
          key: key,
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
        ),
      ),
    ));
  }

  void radioGroup(String controlKey, List<RadioButton> radios,
      {Key key,
      String label,
      RadioGroupController controller,
      dynamic initialValue,
      FormFieldValidator validator,
      ValueChanged onChanged,
      bool readOnly = false,
      bool visible = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    RadioGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => RadioGroupController());
    nextLine();
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      child: RadioGroup(
        controlKey,
        List.from(radios),
        key: key,
        controller: controller,
        initialValue: initialValue,
        label: label,
        validator: validator,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
      ),
    ));
    nextLine();
  }

  void checkboxs(String controlKey, List<CheckboxButton> checkboxs,
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
      controlKey: controlKey,
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: CheckboxGroup(
          controlKey,
          List.from(checkboxs),
          key: key,
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
        ),
      ),
      flex: flex,
    ));
  }

  void checkboxGroup(String controlKey, List<CheckboxButton> checkboxs,
      {Key key,
      String label,
      List<int> initialValue,
      ValueChanged<List<int>> onChanged,
      FormFieldValidator<List<int>> validator,
      bool readOnly = false,
      bool visible = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    CheckboxGroupController controller = formController._controllers
        .putIfAbsent(controlKey, () => CheckboxGroupController());
    nextLine();
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      child: CheckboxGroup(
        controlKey,
        List.from(checkboxs),
        key: key,
        controller: controller,
        initialValue: initialValue,
        label: label,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
      ),
    ));
    nextLine();
  }

  void button(String controlKey, VoidCallback onPressed,
      {Key key,
      String label,
      Widget child,
      ButtonController controller,
      int flex = 0,
      VoidCallback onLongPress,
      bool readOnly = false,
      bool visible = true,
      Alignment alignment}) {
    _setInitialStateKey(readOnly, visible, controlKey);
    _builders.add(
      _FormItemWidget(
          controlKey: controlKey,
          flex: flex,
          child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                alignment: alignment ?? Alignment.centerLeft,
                child: Button(
                  controlKey,
                  onPressed,
                  key: key,
                  label: label,
                  child: child,
                  controller: controller,
                  onLongPress: onLongPress,
                ),
              ))),
    );
  }

  void datetimeField(String label, String controlKey,
      {bool readOnly = false,
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
      _FormItemWidget(
          controlKey: controlKey,
          flex: flex,
          child: DateTimeFormField(
            label,
            controlKey,
            focusNode: focusNode,
            controller: controller,
            formatter: formatter,
            validator: validator,
            useTime: useTime,
          )),
    );
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
              if (c._hide) {
                return SizedBox.shrink();
              }
              return Column(
                children: rows,
              );
            },
          ),
        ));
  }

  void _setInitialStateKey(bool readOnly, bool visible, String controlKey) {
    if (readOnly) formController._addReadOnlyKey(controlKey);
    if (!visible) formController._addHideKey(controlKey);
  }
}

class FormController extends ChangeNotifier {
  bool _hide = false;
  bool _readOnly = false;
  final GlobalKey _formKey = GlobalKey<FormState>();
  final Set<String> _hideKeys = {};
  final Set<String> _readOnlyKeys = {};

  final Map<String, ValueNotifier> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

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
  }

  Map<String, dynamic> getData() {
    Map<String, dynamic> map = {};
    _controllers.forEach((key, notifier) {
      dynamic value;
      if (notifier is TextEditingController) {
        value = notifier.text;
      } else {
        value = notifier.value;
      }
      if (value != null) {
        map[key] = value;
      }
    });
    return map;
  }

  ValueNotifier getController(String controlKey) {
    return _controllers[controlKey];
  }

  void _addHideKey(String controlKey) {
    _hideKeys.add(controlKey);
  }

  void _addReadOnlyKey(String controlKey) {
    _readOnlyKeys.add(controlKey);
  }

  get hide => _hide;

  set hide(bool hide) {
    if (_hide != hide) {
      _hide = hide;
      notifyListeners();
    }
  }

  get readOnly => _hide;

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
  final String controlKey;
  final int flex;
  final Widget child;
  const _FormItemWidget({Key key, this.controlKey, this.flex, this.child})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormItemWidgetState();
}

class _FormItemWidgetState extends State<_FormItemWidget> {
  bool hide = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<FormController>(
      builder: (context, v, child) {
        bool currentHide = v.isHide(widget.controlKey);
        if (currentHide != hide) {
          hide = currentHide;
          return buildChild();
        }
        return child;
      },
      child: buildChild(),
    );
  }

  Widget buildChild() {
    return Visibility(
      child: Expanded(
        child: widget.child,
        flex: widget.flex ?? 1,
      ),
      visible: !hide,
    );
  }
}
