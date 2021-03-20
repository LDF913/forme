import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'clearable_textfield.dart';
import 'radio_group.dart';
import 'checkbox_group.dart';

class FormBuilder {
  List<_FormItemWidget> _builders = [];
  List<List<_FormItemWidget>> _builderss = [];
  FormController formController;

  FormBuilder({this.formController});

  void nextLine() {
    if (_builders.length > 0) {
      _builderss.add(_builders);
      _builders = [];
    }
  }

  void textField(String label,
      {TextEditingController controller,
      VoidCallback onTap,
      ValueChanged<String> onSubmitted,
      Key key,
      String controlKey,
      bool obscureText: false,
      int flex,
      int maxLines = 1,
      FocusNode focusNode,
      Icon prefixIcon,
      TextInputType keyboardType,
      int maxLength,
      ValueChanged<String> onChanged,
      FormFieldValidator<String> validator,
      InputDecoration decoration,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      bool clearable = false,
      bool passwordVisible = false,
      String initialValue}) {
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      flex: flex,
      child: ClearableTextField(
        label,
        key: key,
        controlKey: controlKey,
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
        decoration: decoration,
        clearable: clearable,
        prefixIcon: prefixIcon,
        passwordVisible: passwordVisible,
        initialValue: initialValue,
        onChanged: onChanged,
      ),
    ));
  }

  void radios(List<RadioButton> radios,
      {RadioGroupController controller,
      Key key,
      dynamic initialValue,
      String controlKey,
      FormFieldValidator validator,
      ValueChanged onChanged,
      int flex,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled}) {
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: RadioGroup(
          List.from(radios),
          key: key,
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          controlKey: controlKey,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
        ),
      ),
    ));
  }

  void radioGroup(List<RadioButton> radios,
      {String controlKey,
      Key key,
      String label,
      RadioGroupController controller,
      dynamic initialValue,
      FormFieldValidator validator,
      ValueChanged onChanged,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled}) {
    nextLine();
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      child: RadioGroup(
        List.from(radios),
        key: key,
        controller: controller,
        initialValue: initialValue,
        label: label,
        validator: validator,
        controlKey: controlKey,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
      ),
    ));
    nextLine();
  }

  void checkboxs(List<CheckboxButton> checkboxs,
      {CheckboxGroupController controller,
      Key key,
      List<int> initialValue,
      String controlKey,
      FormFieldValidator validator,
      ValueChanged<List<int>> onChanged,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      int flex}) {
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: CheckboxGroup(
          List.from(checkboxs),
          key: key,
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          controlKey: controlKey,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
        ),
      ),
      flex: flex,
    ));
  }

  void checkboxGroup(List<CheckboxButton> checkboxs,
      {Key key,
      String controlKey,
      String label,
      CheckboxGroupController controller,
      List<int> initialValue,
      ValueChanged<List<int>> onChanged,
      FormFieldValidator<List<int>> validator,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled}) {
    nextLine();
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      child: CheckboxGroup(
        List.from(checkboxs),
        key: key,
        controller: controller,
        initialValue: initialValue,
        label: label,
        validator: validator,
        controlKey: controlKey,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
      ),
    ));
    nextLine();
  }

  void button(String label, VoidCallback onPressed,
      {Key key,
      int flex,
      String controlKey,
      VoidCallback onLongPress,
      Alignment alignment}) {
    _builders.add(_FormItemWidget(
      controlKey: controlKey,
      flex: flex,
      child: Consumer<FormController>(builder: (context, v, child) {
        bool isReadOnly = v.isReadOnly(controlKey);
        return Padding(
          padding: EdgeInsets.only(top: 15),
          child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: TextButton(
              onPressed: isReadOnly ? null : onPressed,
              onLongPress: isReadOnly ? null : onLongPress,
              child: Text(label),
            ),
          ),
        );
      }),
    ));
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
}

class FormController extends ChangeNotifier {
  bool _hide = false;
  bool _readOnly = false;
  final GlobalKey _formKey = GlobalKey<FormState>();
  final List<String> _hideKeys = [];
  final List<String> _readOnlyKeys = [];

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
