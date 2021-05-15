import 'package:flutter/material.dart';
import '../render/theme_data.dart';
import '../render/form_render_utils.dart';

import '../form_field.dart';
import '../state_model.dart';
import 'decoration_field.dart';

enum InlineFieldType { Switch, Checkbox }

class SingleCheckboxFormField extends BaseNonnullValueField<bool> {
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
  }) : super(
          {
            'label': StateValue<Widget?>(label),
            'checkboxRenderData':
                StateValue<CheckboxRenderData?>(checkboxRenderData),
          },
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
          builder: (state) {
            bool readOnly = state.readOnly;
            bool value = state.value;
            Map<String, dynamic> stateMap = state.currentMap;
            CheckboxRenderData? checkboxRenderData =
                stateMap['checkboxRenderData'];
            return DecorationField(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  stateMap['label'] ?? SizedBox(),
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
