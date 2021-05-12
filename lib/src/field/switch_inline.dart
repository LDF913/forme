import 'package:flutter/material.dart';

import '../form_field.dart';
import 'decoration_field.dart';

class SwitchInlineFormField extends BaseNonnullValueField<bool> {
  SwitchInlineFormField({
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
  }) : super(
          {},
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
            ThemeData themeData = Theme.of(state.context);
            bool value = state.value;
            Widget child = InkWell(
              child: Row(
                children: [
                  Switch(
                    value: value,
                    onChanged: readOnly
                        ? null
                        : (_) {
                            state.didChange(!value);
                          },
                    activeColor: themeData.primaryColor,
                  )
                ],
              ),
              onTap: readOnly
                  ? null
                  : () {
                      state.didChange(!value);
                    },
            );

            return DecorationField(
              child: child,
              focusNode: state.focusNode,
              errorText: state.errorText,
              readOnly: readOnly,
            );
          },
        );
}
