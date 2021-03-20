import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_util.dart';

class ClearableTextField extends StatefulWidget {
  final GestureTapCallback onTap;
  final ValueChanged<String> onSubmitted;
  final bool obscureText;
  final int flex;
  final int maxLines;
  final FocusNode focusNode;
  final Icon prefixIcon;
  final TextInputType keyboardType;
  final int maxLength;
  final FormFieldValidator<String> validator;
  final InputDecoration decoration;
  final AutovalidateMode autovalidateMode;
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onFieldSubmitted;
  final bool clearable;
  final String controlKey;
  final bool passwordVisible;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const ClearableTextField(this.label,
      {Key key,
      this.onTap,
      this.controlKey,
      this.onSubmitted,
      this.obscureText = false,
      this.flex,
      this.focusNode,
      this.prefixIcon,
      this.keyboardType,
      this.maxLength,
      this.validator,
      this.decoration,
      this.maxLines = 1,
      this.controller,
      this.autovalidateMode,
      this.onFieldSubmitted,
      this.initialValue,
      this.clearable = false,
      this.onChanged,
      this.passwordVisible = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClearableTextFieldState();
}

class _ClearableTextFieldState extends State<ClearableTextField> {
  bool obscureText = false;
  bool readOnly = false;
  TextEditingController controller;
  TextEditingController get _controller => widget.controller ?? controller;

  @override
  void initState() {
    obscureText = widget.obscureText;
    if (widget.controller == null) {
      controller = TextEditingController(text: widget.initialValue);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(ClearableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null && widget.controller == null)
        controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        if (oldWidget.controller == null) controller = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormController>(
      builder: (context, v, child) {
        bool currentReadOnly = v.isReadOnly(widget.controlKey);
        if (currentReadOnly != readOnly) {
          readOnly = currentReadOnly;
          return _textField();
        }
        return child;
      },
      child: _textField(),
    );
  }

  Widget _textField() {
    InputDecoration decoration;
    List<Widget> suffixes = [];
    if (widget.clearable && !readOnly) {
      suffixes.add(_ClearIcon(
        _controller,
      ));
    }
    if (widget.passwordVisible) {
      suffixes.add(IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(top: 15),
        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
      ));
    }
    Widget suffixIcon = suffixes.isEmpty
        ? null
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
            mainAxisSize: MainAxisSize.min, // added line
            children: suffixes,
          );
    if (decoration != null) {
      decoration = decoration.copyWith(suffixIcon: suffixIcon);
    } else {
      decoration = InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon);
    }
    TextFormField field = TextFormField(
        key: widget.key,
        focusNode: widget.focusNode,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        obscureText: obscureText,
        controller: _controller,
        onTap: widget.onTap,
        onFieldSubmitted: widget.onSubmitted,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        readOnly: readOnly,
        onChanged: widget.onChanged,
        decoration: decoration);
    return Padding(
      padding: EdgeInsets.all(5),
      child: field,
    );
  }
}

class _ClearIcon extends StatefulWidget {
  final TextEditingController controller;

  const _ClearIcon(this.controller);
  @override
  State<StatefulWidget> createState() => _ClearIconState();
}

class _ClearIconState extends State<_ClearIcon> {
  bool visible = false;

  void changeListener() {
    setState(() {
      visible = widget.controller.text != '';
    });
  }

  @override
  void initState() {
    widget.controller.addListener(changeListener);
    visible = widget.controller.text != '';
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(changeListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(_ClearIcon old) {
    super.didUpdateWidget(old);
    if (widget.controller != old.controller) {
      old.controller.removeListener(changeListener);
      widget.controller.addListener(changeListener);
      visible = widget.controller.text != '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Visibility(
          visible: visible,
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: EdgeInsets.only(top: 15),
            onPressed: () {
              widget.controller.text = '';
              (context as Element).markNeedsBuild();
            },
            icon: Icon(Icons.clear),
          ));
    });
  }
}
