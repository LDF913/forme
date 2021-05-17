import 'package:flutter/material.dart';
import '../render/theme_data.dart';
import '../render/form_render_utils.dart';

import '../form_field.dart';
import '../state_model.dart';
import 'decoration_field.dart';

enum InlineFieldType { Switch, Checkbox }

class SingleCheckboxFormField
    extends BaseNonnullValueField<bool, SingleCheckboxModel> {
  SingleCheckboxFormField({
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
    Widget? label,
    CheckboxRenderData? checkboxRenderData,
    WidgetWrapper? wrapper,
  }) : super(
          model: SingleCheckboxModel(
              checkboxRenderData: checkboxRenderData, label: label),
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          wrapper: wrapper,
          builder: (state) {
            bool readOnly = state.readOnly;
            bool value = state.value;
            CheckboxRenderData? checkboxRenderData =
                state.model.checkboxRenderData;
            return DecorationField(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.model.label ?? SizedBox(),
                  FormRenderUtils.checkbox(
                      value,
                      readOnly
                          ? null
                          : (_) {
                              state.didChange(!value);
                              state.requestFocus();
                            },
                      checkboxRenderData)
                ],
              ),
              focusNode: state.focusNode,
              errorText: state.errorText,
              readOnly: readOnly,
            );
          },
        );
}

class SingleCheckboxModel extends AbstractFieldStateModel {
  final Widget? label;
  final CheckboxRenderData? checkboxRenderData;
  SingleCheckboxModel({this.label, this.checkboxRenderData});
  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    SingleCheckboxModel oldModel = old as SingleCheckboxModel;
    return SingleCheckboxModel(
      label: label ?? oldModel.label,
      checkboxRenderData: checkboxRenderData ?? oldModel.checkboxRenderData,
    );
  }
}
