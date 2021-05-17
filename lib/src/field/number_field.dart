import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/clear_button.dart';
import '../form_field.dart';
import '../state_model.dart';
import '../text_selection.dart';

class NumberFormField extends BaseValueField<num, NumberFieldModel> {
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
    WidgetWrapper? wrapper,
  }) : super(
          model: NumberFieldModel(
            labelText: labelText,
            hintText: hintText,
            autofocus: autofocus,
            clearable: clearable,
            prefixIcon: prefixIcon,
            style: style,
            suffixIcons: suffixIcons,
            textInputAction: textInputAction,
            inputDecorationTheme: inputDecorationTheme,
            decimal: decimal,
            max: max,
            allowNegative: allowNegative,
          ),
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
          wrapper: wrapper,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            String? labelText = state.model.labelText;
            String? hintText = state.model.hintText;
            bool clearable = state.model.clearable!;
            Widget? prefixIcon = state.model.prefixIcon;
            TextStyle? style = state.model.style;
            List<Widget>? suffixIcons = state.model.suffixIcons;
            TextInputAction? textInputAction = state.model.textInputAction;
            int decimal = state.model.decimal!;
            bool allowNegative = state.model.allowNegative!;
            bool autofocus = state.model.autofocus!;
            InputDecorationTheme inputDecorationTheme =
                state.model.inputDecorationTheme ??
                    Theme.of(state.context).inputDecorationTheme;
            double? max = state.model.max;
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

class _NumberFieldState extends BaseValueFieldState<num, NumberFieldModel>
    with TextSelectionManagement {
  late final TextEditingController textEditingController;
  @override
  NumberFormField get widget => super.widget as NumberFormField;

  @override
  num? get value => super.value == null
      ? null
      : model.decimal == 0
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

  void clearValue() {
    super.setValue(null);
    textEditingController.text = '';
  }

  @override
  void beforeMerge(NumberFieldModel old, NumberFieldModel current) {
    if (value == null) return;
    if (current.max != null && current.max! < value!) clearValue();
    if (current.allowNegative != null && !current.allowNegative! && value! < 0)
      clearValue();
    int? decimal = current.decimal;
    if (decimal != null) {
      int indexOfPoint = value.toString().indexOf(".");
      if (indexOfPoint == -1) return;
      int decimalNum = value.toString().length - (indexOfPoint + 1);
      if (decimalNum > decimal) clearValue();
    }
  }
}

class NumberFieldModel extends AbstractFieldStateModel {
  final String? labelText;
  final String? hintText;
  final bool? autofocus;
  final bool? clearable;
  final Widget? prefixIcon;
  final TextStyle? style;
  final List<Widget>? suffixIcons;
  final TextInputAction? textInputAction;
  final InputDecorationTheme? inputDecorationTheme;
  final int? decimal;
  final double? max;
  final bool? allowNegative;

  NumberFieldModel({
    this.labelText,
    this.hintText,
    this.autofocus,
    this.clearable,
    this.prefixIcon,
    this.style,
    this.suffixIcons,
    this.textInputAction,
    this.inputDecorationTheme,
    this.decimal,
    this.max,
    this.allowNegative,
  });

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    NumberFieldModel oldModel = old as NumberFieldModel;
    return NumberFieldModel(
      labelText: labelText ?? oldModel.labelText,
      hintText: hintText ?? oldModel.hintText,
      autofocus: autofocus ?? oldModel.autofocus,
      clearable: clearable ?? oldModel.clearable,
      prefixIcon: prefixIcon ?? oldModel.prefixIcon,
      style: style ?? oldModel.style,
      suffixIcons: suffixIcons ?? oldModel.suffixIcons,
      textInputAction: textInputAction ?? oldModel.textInputAction,
      inputDecorationTheme:
          inputDecorationTheme ?? oldModel.inputDecorationTheme,
      decimal: decimal ?? oldModel.decimal,
      max: max ?? oldModel.max,
      allowNegative: allowNegative ?? oldModel.allowNegative,
    );
  }
}
