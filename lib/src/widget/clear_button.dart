import 'package:flutter/material.dart';

class ClearButton extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback clear;
  final FocusNode focusNode;

  const ClearButton(this.controller, this.focusNode, this.clear);
  @override
  State<StatefulWidget> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  bool visible = false;

  void changeListener() {
    setState(() {
      visible = widget.focusNode.hasFocus && widget.controller.text != '';
    });
  }

  @override
  void initState() {
    widget.controller.addListener(changeListener);
    visible = widget.controller.text != '' && widget.focusNode.hasFocus;
    widget.focusNode.addListener(changeListener);
    super.initState();
  }

  @override
  void didUpdateWidget(ClearButton old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(changeListener);
      widget.controller.addListener(changeListener);
    }
    if (old.focusNode != widget.focusNode) {
      old.focusNode.removeListener(changeListener);
      widget.focusNode.addListener(changeListener);
    }
    visible = widget.focusNode.hasFocus && widget.controller.text != '';
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(changeListener);
    widget.controller.removeListener(changeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: InkWell(
          child: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              widget.controller.text = '';
              widget.clear();
            },
          ),
        ));
  }
}
