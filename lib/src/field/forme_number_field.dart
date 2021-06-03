import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../forme_controller.dart';
import '../widget/forme_text_field_widget.dart';

import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';
import 'forme_text_field.dart';

class FormeNumberField extends ValueField<num, FormeNumberFieldModel> {
  FormeNumberField({
    FormeFieldValueChanged<num, FormeNumberFieldModel>? onChanged,
    FormFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    num? initialValue,
    ValueChanged<num?>? onSubmitted,
    FormFieldSetter<num>? onSaved,
    String? name,
    bool readOnly = false,
    FormeNumberFieldModel? model,
    ValidateErrorListener<
            FormeValueFieldController<num, FormeNumberFieldModel>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<num, FormeNumberFieldModel>>?
        focusListener,
    Key? key,
  }) : super(
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
          key: key,
          model: model ?? FormeNumberFieldModel(),
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

            if (state.model.textFieldModel?.inputFormatters != null) {
              formatters.addAll(state.model.textFieldModel!.inputFormatters!);
            }

            void onChanged(String value) {
              num? parsed = num.tryParse(value);
              if (parsed != null && parsed != state.value) {
                state.updateController = false;
                state.didChange(parsed);
              } else {
                if (value.isEmpty && state.value != null) {
                  state.didChange(null);
                }
              }
            }

            return FormeTextFieldWidget(
                textEditingController: textEditingController,
                focusNode: focusNode,
                errorText: state.errorText,
                model: (state.model.textFieldModel ?? FormeTextFieldModel())
                    .copyWith(FormeTextFieldModel(
                  inputFormatters: formatters,
                  readOnly: readOnly,
                  onTap: readOnly ? () {} : state.model.textFieldModel?.onTap,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  onSubmitted: onSubmitted == null
                      ? null
                      : (v) => onSubmitted(state.value),
                )));
          },
        );

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends ValueFieldState<num, FormeNumberFieldModel> {
  late final TextEditingController textEditingController;
  @override
  FormeNumberField get widget => super.widget as FormeNumberField;

  bool updateController = true;

  @override
  num? get value => super.value == null
      ? null
      : model.decimal == 0
          ? super.value!.toInt()
          : super.value!.toDouble();

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : initialValue.toString());
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
    textEditingController.dispose();
    super.dispose();
  }

  void clearValue() {
    super.setValue(null);
  }

  @override
  FormeNumberFieldModel beforeSetModel(
      FormeNumberFieldModel old, FormeNumberFieldModel current) {
    return beforeUpdateModel(old, current);
  }

  @override
  FormeNumberFieldModel beforeUpdateModel(
      FormeNumberFieldModel old, FormeNumberFieldModel current) {
    if (value == null) return current;
    if (current.max != null && current.max! < value!) clearValue();
    if (current.allowNegative != null && !current.allowNegative! && value! < 0)
      clearValue();
    int? decimal = current.decimal;
    if (decimal != null) {
      int indexOfPoint = value.toString().indexOf(".");
      if (indexOfPoint == -1) return current;
      int decimalNum = value.toString().length - (indexOfPoint + 1);
      if (decimalNum > decimal) clearValue();
    }
    if (current.textFieldModel?.selection != null) {
      textEditingController.selection = current.textFieldModel!.selection!;
    }
    return current;
  }
}

class FormeNumberFieldModel extends FormeModel {
  final int? decimal;
  final double? max;
  final bool? allowNegative;
  final FormeTextFieldModel? textFieldModel;

  FormeNumberFieldModel({
    this.decimal,
    this.max,
    this.allowNegative,
    this.textFieldModel,
  });

  FormeNumberFieldModel copyWith(FormeModel oldModel) {
    FormeNumberFieldModel old = oldModel as FormeNumberFieldModel;
    return FormeNumberFieldModel(
      decimal: decimal ?? old.decimal,
      max: max ?? old.max,
      allowNegative: allowNegative ?? old.allowNegative,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
    );
  }
}
