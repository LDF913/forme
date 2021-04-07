import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/form_theme.dart';
import 'form_builder.dart';

class Button extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final String label;
  final Widget child;
  final String controlKey;
  final EdgeInsets padding;

  const Button(this.controlKey, this.onPressed,
      {Key key, this.onLongPress, this.label, this.child, this.padding})
      : assert(label != null || child != null),
        assert(onPressed != null),
        assert(controlKey != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    bool readOnly = FormController.of(context).isReadOnly(widget.controlKey);
    FormThemeData themeData = FormThemeData.of(context);
    return Padding(
      child: TextButton(
          onPressed: readOnly ? null : widget.onPressed,
          onLongPress: readOnly ? null : widget.onLongPress,
          child: widget.child ?? Text(widget.label)),
      padding: widget.padding ?? themeData.padding ?? EdgeInsets.zero,
    );
  }
}
