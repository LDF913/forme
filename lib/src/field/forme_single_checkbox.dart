import 'package:flutter/material.dart';
import '../forme_controller.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import '../forme_field.dart';
import '../forme_core.dart';

class FormeSingleCheckbox
    extends NonnullValueField<bool, FormeSingleCheckboxModel> {
  FormeSingleCheckbox({
    NonnullFormeFieldValueChanged<bool, FormeSingleCheckboxModel>? onChanged,
    NonnullFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    NonnullFormFieldSetter<bool>? onSaved,
    required String name,
    bool readOnly = false,
    FormeSingleCheckboxModel? model,
    ValidateErrorListener<
            FormeValueFieldController<bool, FormeSingleCheckboxModel>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<bool, FormeSingleCheckboxModel>>?
        focusListener,
    Key? key,
  }) : super(
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
          key: key,
          model: model ?? FormeSingleCheckboxModel(),
          readOnly: readOnly,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          builder: (state) {
            bool readOnly = state.readOnly;
            bool value = state.value;
            FormeCheckboxRenderData? checkboxRenderData =
                state.model.checkboxRenderData;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state.model.label ?? SizedBox(),
                FormeRenderUtils.checkbox(
                    value,
                    readOnly
                        ? null
                        : (_) {
                            state.didChange(!value);
                            state.requestFocus();
                          },
                    checkboxRenderData,
                    focusNode: state.focusNode)
              ],
            );
          },
        );
}

class FormeSingleCheckboxModel extends FormeModel {
  final Widget? label;
  final FormeCheckboxRenderData? checkboxRenderData;
  FormeSingleCheckboxModel({
    this.label,
    this.checkboxRenderData,
  });
  FormeSingleCheckboxModel copyWith(FormeModel oldModel) {
    FormeSingleCheckboxModel old = oldModel as FormeSingleCheckboxModel;
    return FormeSingleCheckboxModel(
      label: label ?? old.label,
      checkboxRenderData: FormeCheckboxRenderData.copy(
          old.checkboxRenderData, checkboxRenderData),
    );
  }
}
