import 'package:flutter/material.dart';
import '../render/theme_data.dart';
import '../render/form_render_utils.dart';

import '../form_field.dart';
import '../state_model.dart';
import 'decoration_field.dart';

class SingleSwitchFormField extends BaseNonnullValueField<bool> {
  SingleSwitchFormField(
      {ValueChanged<bool>? onChanged,
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
      Widget? label})
      : super(
          {
            'label': StateValue<Widget?>(label),
            'switchRenderData': StateValue<SwitchRenderData?>(
                switchRenderData), //can we save listener|image provider here ??
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

            return DecorationField(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  stateMap['label'] ?? SizedBox(),
                  FormRenderUtils.adaptiveSwitch(
                    value,
                    readOnly
                        ? null
                        : (_) {
                            state.didChange(!value);
                            state.requestFocus();
                          },
                    stateMap['switchRenderData'],
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
