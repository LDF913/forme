import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/form/form_util.dart';
import 'package:provider/provider.dart';

class Button extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final ButtonController controller;
  final String label;
  final Widget child;
  final String controlKey;

  const Button(this.onPressed,
      {Key key,
      this.onLongPress,
      this.controller,
      this.label,
      this.child,
      this.controlKey})
      : assert(label != null || child != null),
        assert(onPressed != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class ButtonController extends ChangeNotifier {
  Widget _child;

  ButtonController({Widget child}) : this._child = child;

  set child(Widget child) {
    if (_child != child) {
      _child = child;
      notifyListeners();
    }
  }
}

class _ButtonState extends State<Button> {
  ButtonController controller;
  ButtonController get _controller => widget.controller ?? controller;

  bool readOnly = false;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<FormController>(
        builder: (context, v, child) {
          bool currentReadOnly = v.isReadOnly(widget.controlKey);
          if (currentReadOnly != readOnly) {
            readOnly = currentReadOnly;
            return buildChild();
          }
          return child;
        },
        child: buildChild());
  }

  Widget buildChild() {
    return TextButton(
        onPressed: readOnly ? null : widget.onPressed,
        onLongPress: readOnly ? null : widget.onLongPress,
        child: _controller._child);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controller = ButtonController(child: widget.child ?? Text(widget.label));
    } else {
      widget.controller._child =
          widget.controller._child ?? widget.child ?? Text(widget.label);
      widget.controller.addListener(_handleChange);
    }
  }

  @override
  void didUpdateWidget(Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null)
        oldWidget.controller.removeListener(_handleChange);
      widget.controller.addListener(_handleChange);
      if (oldWidget.controller != null && widget.controller == null)
        controller = ButtonController(child: oldWidget.controller._child);
      if (widget.controller != null) {
        if (oldWidget.controller == null) controller = null;
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller != null)
      widget.controller.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    setState(() {});
  }
}
