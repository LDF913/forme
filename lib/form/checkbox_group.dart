import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_util.dart';

class CheckboxButton {
  final String label;
  final String controlKey;
  CheckboxButton(this.label, {this.controlKey});
}

class CheckboxGroupController extends ValueNotifier<List<int>> {
  List<String> _readOnlyKeys = [];
  CheckboxGroupController({List<int> value}) : super(value);

  set readOnlyKeys(List<String> keys) {
    _readOnlyKeys.clear();
    if (keys != null) _readOnlyKeys.addAll(keys);
    notifyListeners();
  }

  bool isReadOnly(String key) {
    return _readOnlyKeys.contains(key);
  }
}

class CheckboxGroup extends FormField<List<int>> {
  final List<CheckboxButton> buttons;
  final CheckboxGroupController controller;
  final List<int> initialValue;
  final String label;
  final FormFieldValidator<List<int>> validator;
  final AutovalidateMode autovalidateMode;
  final String controlKey;
  final ValueChanged<List<int>> onChanged;

  CheckboxGroup(this.controlKey, this.buttons,
      {Key key,
      this.controller,
      this.initialValue,
      this.label,
      this.validator,
      this.onChanged,
      this.autovalidateMode = AutovalidateMode.disabled})
      : assert(controlKey != null),
        super(
            autovalidateMode: autovalidateMode,
            validator: validator,
            initialValue: initialValue,
            builder: (field) {
              final _CheckboxGroupState state = field as _CheckboxGroupState;
              Color errorColor =
                  Theme.of(field.context).errorColor ?? Colors.red;
              Widget buildChild() {
                List<Widget> widgets = [];
                if (label != null) {
                  Text text;
                  if (state.errorText != null) {
                    text = Text(label, style: TextStyle(color: errorColor));
                  } else {
                    text = Text(label);
                  }
                  widgets.add(Container(
                      child: Row(
                    children: [Flexible(child: text)],
                  )));
                }

                List<int> value;
                if (state._controller.value != null) {
                  value = List.from(state._controller.value);
                } else {
                  value = [];
                }

                for (int i = 0; i < buttons.length; i++) {
                  CheckboxButton button = buttons[i];
                  bool isReadOnly = state.readOnly ||
                      state._controller.isReadOnly(button.controlKey);
                  widgets.add(Wrap(
                    children: [
                      Checkbox(
                          value: value.contains(i),
                          onChanged: isReadOnly
                              ? null
                              : (v) {
                                  if (value.contains(i))
                                    value.remove(i);
                                  else
                                    value.add(i);
                                  field.didChange(value);
                                  if (onChanged != null)
                                    onChanged(List.from(value));
                                }),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          button.label,
                        ),
                      ),
                    ],
                  ));
                }

                if (state.errorText != null) {
                  widgets.add(Container(
                      child: Row(
                    children: [
                      Flexible(
                          child: Padding(
                        child: Text(state.errorText,
                            style: TextStyle(color: errorColor)),
                        padding: EdgeInsets.only(left: 15, right: 15),
                      ))
                    ],
                  )));
                }
                return Padding(
                  child: Wrap(
                    children: widgets,
                  ),
                  padding: EdgeInsets.all(5),
                );
              }

              return Consumer<FormController>(
                builder: (context, v, child) {
                  bool currentReadOnly = v.isReadOnly(controlKey);
                  if (currentReadOnly != state.readOnly) {
                    state.readOnly = currentReadOnly;
                    return buildChild();
                  }
                  return child;
                },
                child: buildChild(),
              );
            });

  @override
  _CheckboxGroupState createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends FormFieldState<List<int>> {
  CheckboxGroupController controller;
  CheckboxGroupController get _controller => widget.controller ?? controller;

  @override
  CheckboxGroup get widget => super.widget as CheckboxGroup;

  bool readOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controller = CheckboxGroupController(value: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(CheckboxGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null)
        oldWidget.controller.removeListener(_handleControllerChanged);
      if (widget.controller != null) {
        widget.controller.addListener(_handleControllerChanged);
      }
      if (oldWidget.controller != null && widget.controller == null)
        controller = CheckboxGroupController(value: oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.value);
        if (oldWidget.controller == null) controller = null;
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller != null)
      widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(List<int> value) {
    super.didChange(value);
    if (_controller.value != value) _controller.value = value ?? [];
  }

  @override
  void reset() {
    _controller.value = widget.initialValue ?? [];
    super.reset();
  }

  void _handleControllerChanged() {
    if (_controller.value != value)
      didChange(_controller.value);
    else
      setState(() {});
  }
}
