import 'package:flutter/material.dart';
import '../forme_management.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import '../forme_field.dart';
import '../forme_core.dart';

class FormeSingleSwitch
    extends NonnullValueField<bool, FormeSingleSwitchModel> {
  FormeSingleSwitch({
    ValueChanged<bool>? onChanged,
    NonnullFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    NonnullFormFieldSetter<bool>? onSaved,
    String? name,
    bool readOnly = false,
    Widget? label,
    FormeSingleSwitchModel? model,
    ValidateErrorListener<
            FormeValueFieldManagement<bool, FormeSingleSwitchModel>>?
        validateErrorListener,
    FocusListener<FormeFieldManagement<FormeSingleSwitchModel>>? focusListener,
    Key? key,
  }) : super(
          key: key,
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
          model: model ?? FormeSingleSwitchModel(),
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

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                state.model.label ?? SizedBox(),
                FormeRenderUtils.adaptiveSwitch(
                  value,
                  readOnly
                      ? null
                      : (_) {
                          state.didChange(!value);
                          state.requestFocus();
                        },
                  state.model.switchRenderData,
                  focusNode: state.focusNode,
                )
              ],
            );
          },
        );
}

class FormeSingleSwitchModel extends FormeModel {
  final Widget? label;
  final FormeSwitchRenderData? switchRenderData;

  FormeSingleSwitchModel({
    this.label,
    this.switchRenderData,
  });

  FormeSingleSwitchModel copyWith(FormeModel oldModel) {
    FormeSingleSwitchModel old = oldModel as FormeSingleSwitchModel;
    return FormeSingleSwitchModel(
      label: label ?? old.label,
      switchRenderData:
          FormeSwitchRenderData.copy(old.switchRenderData, switchRenderData),
    );
  }
}
