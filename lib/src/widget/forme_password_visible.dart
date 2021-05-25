import 'package:flutter/material.dart';
import '../field/forme_text_field.dart';
import '../forme_management.dart';

/// an icon for [FormeTextField] , used to toggle obscureText
class FormePasswordVisibleButton extends StatelessWidget {
  final Widget visibleIcon;
  final Widget invisibleIcon;
  final bool visibleWhenUnfocus;

  const FormePasswordVisibleButton({
    Key? key,
    this.visibleIcon = const Icon(Icons.visibility),
    this.invisibleIcon = const Icon(Icons.visibility_off),
    this.visibleWhenUnfocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormeValueFieldManagement valueField =
        FormeValueFieldManagement.of(context);
    FormeTextFieldModel oldModel = valueField.model as FormeTextFieldModel;
    bool visible =
        !valueField.readOnly && !(!valueField.hasFocus && !visibleWhenUnfocus);
    bool obscureText = oldModel.obscureText ?? false;
    return Visibility(
      child: InkWell(
        child: IconButton(
          icon: (obscureText ? visibleIcon : invisibleIcon),
          onPressed: valueField.readOnly
              ? null
              : () => valueField.update<FormeTextFieldModel>(
                  (current) => current.copyWith(obscureText: !obscureText)),
        ),
      ),
      visible: visible,
    );
  }
}
