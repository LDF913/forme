import 'package:flutter/material.dart';
import '../render/theme_data.dart';
import '../render/form_render_utils.dart';

import '../form_field.dart';
import '../form_state_model.dart';
import 'decoration_field.dart';
import 'base_field.dart';

class SingleSwitchFormField
    extends BaseNonnullValueField<bool, SingleSwitchModel> {
  SingleSwitchFormField({
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
    SwitchRenderData? switchRenderData,
    Widget? label,
    WidgetWrapper? wrapper,
    required SingleSwitchModel model,
    LayoutParam? layoutParam,
  }) : super(
          layoutParam: layoutParam ?? LayoutParam(flex: 0),
          model: model,
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

            return DecorationField(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.model.label ?? SizedBox(),
                  FormRenderUtils.adaptiveSwitch(
                    value,
                    readOnly
                        ? null
                        : (_) {
                            state.didChange(!value);
                            state.requestFocus();
                          },
                    state.model.switchRenderData,
                  )
                ],
              ),
              focusNode: state.focusNode,
              errorText: state.errorText,
              readOnly: readOnly,
            );
          },
        );
}

class SingleSwitchModel extends AbstractFieldStateModel {
  final Widget? label;
  final SwitchRenderData? switchRenderData;
  SingleSwitchModel({this.label, this.switchRenderData});
  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    SingleSwitchModel oldModel = old as SingleSwitchModel;
    return SingleSwitchModel(
      label: label ?? oldModel.label,
      switchRenderData: switchRenderData ?? oldModel.switchRenderData,
    );
  }
}
