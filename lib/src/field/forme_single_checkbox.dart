import 'package:flutter/material.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import 'forme_decoration.dart';
import '../forme_field.dart';

class FormeSingleCheckbox
    extends NonnullValueField<bool, FormeSingleCheckboxModel> {
  FormeSingleCheckbox({
    ValueChanged<bool>? onChanged,
    NonnullFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    NonnullFormFieldSetter<bool>? onSaved,
    String? name,
    bool readOnly = false,
    FormeSingleCheckboxModel? model,
    Key? key,
  }) : super(
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
            FormeCheckboxRenderData? formeCheckboxRenderData =
                state.model.formeCheckboxRenderData;
            return FormeDecoration(
              formeDecorationFieldRenderData:
                  state.model.formeDecorationFieldRenderData,
              child: Row(
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
                      formeCheckboxRenderData)
                ],
              ),
              focusNode: state.focusNode,
              errorText: state.errorText,
            );
          },
        );
}

class FormeSingleCheckboxModel extends FormeModel {
  final Widget? label;
  final FormeCheckboxRenderData? formeCheckboxRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;
  FormeSingleCheckboxModel({
    this.label,
    this.formeCheckboxRenderData,
    this.formeDecorationFieldRenderData,
  });
  @override
  FormeSingleCheckboxModel copyWith({
    Optional<Widget>? label,
    Optional<FormeCheckboxRenderData>? formeCheckboxRenderData,
    Optional<FormeDecorationRenderData>? formeDecorationFieldRenderData,
  }) {
    return FormeSingleCheckboxModel(
      label: Optional.copyWith(label, this.label),
      formeCheckboxRenderData: Optional.copyWith(
          formeCheckboxRenderData, this.formeCheckboxRenderData),
      formeDecorationFieldRenderData: Optional.copyWith(
          formeDecorationFieldRenderData, this.formeDecorationFieldRenderData),
    );
  }
}
