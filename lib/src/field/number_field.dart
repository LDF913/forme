import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/clear_button.dart';
import '../form_field.dart';
import '../state_model.dart';
import '../text_selection.dart';

class NumberFormField extends BaseValueField<num> {
  NumberFormField({
    bool autofocus = false,
    String? labelText,
    String? hintText,
    TextStyle? style,
    ValueChanged<num?>? onChanged,
    FormFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    num? initialValue,
    int decimal = 0,
    double? max,
    bool allowNegative = false,
    bool clearable = true,
    Widget? prefixIcon,
    List<Widget>? suffixIcons,
    VoidCallback? onEditingComplete,
    TextInputAction? textInputAction,
    InputDecorationTheme? inputDecorationTheme,
    FormFieldSetter<num>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
  }) : super(
          {
            'labelText': StateValue<String?>(labelText),
            'hintText': StateValue<String?>(hintText),
            'autofocus': StateValue<bool>(autofocus),
            'clearable': StateValue<bool>(clearable),
            'prefixIcon': StateValue<Widget?>(prefixIcon),
            'style': StateValue<TextStyle?>(style),
            'suffixIcons': StateValue<List<Widget>?>(suffixIcons),
            'textInputAction': StateValue<TextInputAction?>(textInputAction),
            'inputDecorationTheme':
                StateValue<InputDecorationTheme?>(inputDecorationTheme),
            'decimal': StateValue<int>(decimal),
            'allowNegative': StateValue<bool>(allowNegative),
          },
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            FocusNode focusNode = state.focusNode;
            String? labelText = stateMap['labelText'];
            String? hintText = stateMap['hintText'];
            bool clearable = stateMap['clearable'];
            Widget? prefixIcon = stateMap['prefixIcon'];
            TextStyle? style = stateMap['style'];
            List<Widget>? suffixIcons = stateMap['suffixIcons'];
            TextInputAction? textInputAction = stateMap['textInputAction'];
            int decimal = stateMap['decimal'];
            bool allowNegative = stateMap['allowNegative'];
            bool autofocus = stateMap['autofocus'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    Theme.of(state.context).inputDecorationTheme;
            TextEditingController textEditingController =
                (state as _NumberFieldState).textEditingController;

            String regex = r'[0-9' +
                (decimal > 0 ? '.' : '') +
                (allowNegative ? '-' : '') +
                ']';
            List<TextInputFormatter> formatters = [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text == '') return newValue;
                if (allowNegative && newValue.text == '-') return newValue;
                double? parsed = double.tryParse(newValue.text);
                if (parsed == null) {
                  return oldValue;
                }
                int indexOfPoint = newValue.text.indexOf(".");
                if (indexOfPoint != -1) {
                  int decimalNum = newValue.text.length - (indexOfPoint + 1);
                  if (decimalNum > decimal) {
                    return oldValue;
                  }
                }

                if (max != null && parsed > max) {
                  return oldValue;
                }
                return newValue;
              }),
              FilteringTextInputFormatter.allow(RegExp(regex))
            ];

            List<Widget> suffixes = [];

            if (clearable && !readOnly) {
              suffixes
                  .add(ClearButton(state.textEditingController, focusNode, () {
                state.didChange(null);
              }));
            }

            if (suffixIcons != null && suffixIcons.isNotEmpty) {
              suffixes.addAll(suffixIcons);
            }

            Widget? suffixIcon = suffixes.isEmpty
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: suffixes,
                  );

            final InputDecoration effectiveDecoration = InputDecoration(
                    hintText: hintText,
                    suffixIcon: suffixIcon,
                    labelText: labelText,
                    prefixIcon: prefixIcon)
                .applyDefaults(inputDecorationTheme);

            TextField textField = TextField(
              textAlignVertical: TextAlignVertical.center,
              focusNode: focusNode,
              controller: textEditingController,
              textInputAction: textInputAction,
              autofocus: autofocus,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              keyboardType: TextInputType.number,
              obscureText: false,
              maxLines: 1,
              onEditingComplete: onEditingComplete,
              onChanged: (value) {
                num? parsed = num.tryParse(value);
                if (parsed != null && parsed != state.value) {
                  state.doChangeValue(parsed, updateText: false);
                } else {
                  if (value.isEmpty && state.value != null) {
                    state.didChange(null);
                  }
                }
              },
              onTap: null,
              readOnly: readOnly,
              style: style,
              inputFormatters: formatters,
            );

            return textField;
          },
        );

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends BaseValueFieldState<num>
    with TextSelectionManagement {
  late final TextEditingController textEditingController;
  @override
  NumberFormField get widget => super.widget as NumberFormField;

  @override
  num? get value => super.value == null
      ? null
      : getState('decimal') == 0
          ? super.value!.toInt()
          : super.value!.toDouble();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
        text:
            widget.initialValue == null ? '' : widget.initialValue.toString());
  }

  @override
  void doChangeValue(num? value,
      {bool trigger = true, bool updateText = true}) {
    super.doChangeValue(value, trigger: trigger);
    String str = super.value == null ? '' : value.toString();
    if (updateText && textEditingController.text != str) {
      textEditingController.text = str;
    }
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : widget.initialValue.toString();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void selectAll() {
    setSelection(0, textEditingController.text.length);
  }

  @override
  void setSelection(int start, int end) {
    TextSelectionManagement.setSelectionWithTextEditingController(
        start, end, textEditingController);
  }
}
