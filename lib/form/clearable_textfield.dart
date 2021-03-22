import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_util.dart';

class ClearableTextFormField extends FormField<String> {
  final bool obscureText;
  ClearableTextFormField(
    String label, {
    Key key,
    this.controller,
    String initialValue,
    FocusNode focusNode,
    TextInputType keyboardType,
    bool autofocus = false,
    this.obscureText = false,
    int maxLines = 1,
    int minLines,
    int maxLength,
    ValueChanged<String> onChanged,
    GestureTapCallback onTap,
    ValueChanged<String> onSubmitted,
    FormFieldValidator<String> validator,
    AutovalidateMode autovalidateMode,
    ValueChanged<String> onFieldSubmitted,
    bool clearable,
    String controlKey,
    bool passwordVisible,
    Icon prefixIcon,
  }) : super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          validator: validator,
          enabled: true,
          autovalidateMode: (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            Widget buildWidget() {
              List<Widget> suffixes = [];

              if (clearable && !state.readOnly) {
                suffixes.add(_ClearIcon(
                  state._effectiveController,
                ));
              }
              if (passwordVisible) {
                suffixes.add(IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.only(top: 15),
                  icon: Icon(state.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    state.toggleObsureText();
                  },
                ));
              }

              Widget suffixIcon = suffixes.isEmpty
                  ? null
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children: suffixes,
                    );

              final InputDecoration effectiveDecoration = InputDecoration(
                      labelText: label,
                      prefixIcon: prefixIcon,
                      suffixIcon: suffixIcon)
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              void onChangedHandler(String value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              return TextField(
                controller: state._effectiveController,
                focusNode: focusNode,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                keyboardType: keyboardType,
                autofocus: autofocus,
                obscureText: state.obscureText,
                maxLines: maxLines,
                minLines: minLines,
                maxLength: maxLength,
                onChanged: onChangedHandler,
                onTap: onTap,
                onSubmitted: onSubmitted,
                enabled: true,
                readOnly: state.readOnly,
              );
            }

            return Consumer<FormController>(
                builder: (context, c, child) {
                  bool currentReadOnly = c.isReadOnly(controlKey);
                  if (state.readOnly != currentReadOnly) {
                    state.readOnly = currentReadOnly;
                    return buildWidget();
                  }
                  return child;
                },
                child: buildWidget());
          },
        );

  final TextEditingController controller;

  @override
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  bool obscureText = false;
  bool readOnly = false;

  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;

  @override
  void initState() {
    obscureText = widget.obscureText;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
    super.initState();
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void didUpdateWidget(ClearableTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String value) {
    super.didChange(value);

    if (_effectiveController.text != value)
      _effectiveController.text = value ?? '';
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
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
