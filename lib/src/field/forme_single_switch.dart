import 'package:flutter/material.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import 'forme_decoration_field.dart';
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
    int flex = 0,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    FormeSwitchRenderData? formeSwitchRenderData,
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

class FormeSingleSwitchModel extends AbstractFormeModel {
  final Widget? label;
  final FormeSwitchRenderData? formeSwitchRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  FormeSingleSwitchModel({
    this.label,
    this.formeSwitchRenderData,
    this.formeDecorationFieldRenderData,
  });
  @override
  AbstractFormeModel merge(AbstractFormeModel old) {
    FormeSingleSwitchModel oldModel = old as FormeSingleSwitchModel;
    return FormeSingleSwitchModel(
      label: label ?? oldModel.label,
      formeSwitchRenderData:
          formeSwitchRenderData ?? oldModel.formeSwitchRenderData,
      formeDecorationFieldRenderData: formeDecorationFieldRenderData ??
          oldModel.formeDecorationFieldRenderData,
    );
  }
}
