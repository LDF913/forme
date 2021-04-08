import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/form_theme.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final String label;
  final Widget child;
  final String controlKey;
  final EdgeInsets padding;
  final bool readOnly;

  const Button(this.controlKey, this.onPressed,
      {Key key,
      this.onLongPress,
      this.label,
      this.child,
      this.padding,
      this.readOnly = false})
      : assert(label != null || child != null),
        assert(onPressed != null),
        assert(controlKey != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    FormThemeData themeData = FormThemeData.of(context);
    return Padding(
      child: TextButton(
          onPressed: readOnly ? null : onPressed,
          onLongPress: readOnly ? null : onLongPress,
          child: child ?? Text(label)),
      padding: padding ?? themeData.padding ?? EdgeInsets.zero,
    );
  }
}
