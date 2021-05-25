import 'package:flutter/material.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import 'forme_decoration.dart';
import '../forme_field.dart';

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
    Key? key,
  }) : super(
          key: key,
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

            return FormeDecoration(
              child: Row(
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
                    state.model.formeSwitchRenderData,
                  )
                ],
              ),
              focusNode: state.focusNode,
              errorText: state.errorText,
            );
          },
        );
}

class FormeSingleSwitchModel extends FormeModel {
  final Widget? label;
  final FormeSwitchRenderData? formeSwitchRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  FormeSingleSwitchModel({
    this.label,
    this.formeSwitchRenderData,
    this.formeDecorationFieldRenderData,
  });

  @override
  FormeSingleSwitchModel copyWith({
    Optional<Widget>? label,
    Optional<FormeSwitchRenderData>? formeSwitchRenderData,
    Optional<FormeDecorationRenderData>? formeDecorationFieldRenderData,
  }) {
    return FormeSingleSwitchModel(
      label: Optional.copyWith(label, this.label),
      formeSwitchRenderData:
          Optional.copyWith(formeSwitchRenderData, this.formeSwitchRenderData),
      formeDecorationFieldRenderData: Optional.copyWith(
          formeDecorationFieldRenderData, this.formeDecorationFieldRenderData),
    );
  }
}
