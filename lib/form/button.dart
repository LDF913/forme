import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'form_builder.dart';
import 'package:provider/provider.dart';

class Button extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final String label;
  final Widget child;
  final String controlKey;

  const Button(this.controlKey, this.onPressed,
      {Key key, this.onLongPress, this.label, this.child})
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
    return Consumer<FormController>(
        builder: (context, v, child) {
          return child;
        },
        child: buildChild());
  }

  Widget buildChild() {
    bool readOnly =
        context.read<FormController>().isReadOnly(widget.controlKey);
    return TextButton(
        onPressed: readOnly ? null : widget.onPressed,
        onLongPress: readOnly ? null : widget.onLongPress,
        child: widget.child ?? Text(widget.label));
  }
}