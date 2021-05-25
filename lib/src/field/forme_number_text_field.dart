import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../widget/forme_text_field_widget.dart';

import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';
import 'forme_text_field.dart';

class FormeNumberTextField extends ValueField<num, FormeNumberTextFieldModel> {
  FormeNumberTextField({
    GestureTapCallback? onTap,
    ValueChanged<num?>? onChanged,
    FormFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    num? initialValue,
    VoidCallback? onEditingComplete,
    ValueChanged<num?>? onSubmitted,
    FormFieldSetter<num>? onSaved,
    String? name,
    bool readOnly = false,
    FormeNumberTextFieldModel? model,
    List<TextInputFormatter>? inputFormatters,
    AppPrivateCommandCallback? appPrivateCommandCallback,
    InputCounterWidgetBuilder? buildCounter,
    Key? key,
  }) : super(
          key: key,
          model: model ?? FormeNumberTextFieldModel(),
          readOnly: readOnly,
          name: name,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            //List<Widget>? suffixIcons = state.model.suffixIcons;
            int decimal = state.model.decimal ?? 0;
            bool allowNegative = state.model.allowNegative ?? false;
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

            if (inputFormatters != null) {
              formatters.addAll(inputFormatters);
            }

            return FormeTextFieldWidget(
              textEditingController: textEditingController,
              focusNode: focusNode,
              readOnly: readOnly,
              errorText: state.errorText,
              data: FormTextFieldWidgetRenderData(
                appPrivateCommandCallback: appPrivateCommandCallback,
                buildCounter: buildCounter,
                formatters: formatters,
                onTap: readOnly ? null : onTap,
                onChanged: (value) {
                  num? parsed = num.tryParse(value);
                  if (parsed != null && parsed != state.value) {
                    state.updateController = false;
                    state.didChange(parsed);
                  } else {
                    if (value.isEmpty && state.value != null) {
                      state.didChange(null);
                    }
                  }
                },
                onEditingComplete: readOnly ? null : onEditingComplete,
                onSubmitted: readOnly
                    ? null
                    : onSubmitted == null
                        ? null
                        : (v) => onSubmitted(state.value),
                model: state.model.textFieldModel?.copyWith(
                    keyboardType:
                        Optional<TextInputType>(TextInputType.number)),
              ),
            );
          },
        );

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState
    extends ValueFieldState<num, FormeNumberTextFieldModel> {
  late final TextEditingController textEditingController;
  @override
  FormeNumberTextField get widget => super.widget as FormeNumberTextField;

  bool updateController = true;

  @override
  num? get value => super.value == null
      ? null
      : model.decimal == 0
          ? super.value!.toInt()
          : super.value!.toDouble();

  void focusChange() {
    setState(() {});
  }

  @override
  void afterSetInitialValue() {
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : initialValue.toString());
    focusNode.addListener(focusChange);
  }

  @override
  void afterValueChanged(num? oldValue, num? current) {
    if (updateController) {
      String str = super.value == null ? '' : value.toString();
      if (textEditingController.text != str) {
        textEditingController.text = str;
      }
    } else {
      updateController = true;
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(focusChange);
    textEditingController.dispose();
    super.dispose();
  }

  void clearValue() {
    super.setValue(null);
    textEditingController.text = '';
  }

  @override
  void beforeUpdateModel(
      FormeNumberTextFieldModel old, FormeNumberTextFieldModel current) {
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
    if (current.textFieldModel?.selection != null) {
      textEditingController.selection = current.textFieldModel!.selection!;
    }
  }
}

class FormeNumberTextFieldModel extends FormeModel {
  final int? decimal;
  final double? max;
  final bool? allowNegative;
  final FormeTextFieldModel? textFieldModel;

  FormeNumberTextFieldModel({
    this.decimal,
    this.max,
    this.allowNegative,
    this.textFieldModel,
  });

  @override
  FormeNumberTextFieldModel copyWith({
    Optional<int>? decimal,
    Optional<double>? max,
    bool? allowNegative,
    Optional<FormeTextFieldModel>? textFieldModel,
  }) {
    return FormeNumberTextFieldModel(
      decimal: Optional.copyWith(decimal, this.decimal),
      max: Optional.copyWith(max, this.max),
      allowNegative: allowNegative ?? allowNegative,
      textFieldModel: Optional.copyWith(textFieldModel, this.textFieldModel),
    );
  }
}
