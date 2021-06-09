import 'package:flutter/material.dart';
import '../forme_controller.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import '../forme_field.dart';
import '../forme_core.dart';

class FormeSingleSwitch extends ValueField<bool, FormeSingleSwitchModel> {
  FormeSingleSwitch({
    FormeFieldValueChanged<bool, FormeSingleSwitchModel>? onChanged,
    FormFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    FormFieldSetter<bool>? onSaved,
    required String name,
    bool readOnly = false,
    Widget? label,
    FormeSingleSwitchModel? model,
    ValidateErrorListener<
            FormeValueFieldController<bool, FormeSingleSwitchModel>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<bool, FormeSingleSwitchModel>>?
        focusListener,
    Key? key,
  }) : super(
          nullValueReplacement: false,
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
            bool value = state.value!;

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
