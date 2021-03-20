import 'package:flutter/material.dart';
import 'package:my_flutter/form/form_util.dart';
import 'package:provider/provider.dart';

class RadioButton {
  final dynamic value;
  final String label;
  final String controlKey;

  RadioButton(this.value, this.label, {this.controlKey});
}

class RadioGroupController extends ValueNotifier {
  List<String> _readOnlyKeys = [];
  RadioGroupController({value}) : super(value);

  set readOnlyKeys(List<String> keys) {
    _readOnlyKeys.clear();
    if (keys != null) _readOnlyKeys.addAll(keys);
    notifyListeners();
  }

  bool isReadOnly(String key) {
    return _readOnlyKeys.contains(key);
  }
}

class RadioGroup extends FormField {
  final List<RadioButton> buttons;
  final RadioGroupController controller;
  final dynamic initialValue;
  final String label;
  final FormFieldValidator validator;
  final AutovalidateMode autovalidateMode;
  final String controlKey;
  final ValueChanged onChanged;

  RadioGroup(this.buttons,
      {Key key,
      this.controlKey,
      this.controller,
      this.initialValue,
      this.label,
      this.onChanged,
      this.validator,
      this.autovalidateMode = AutovalidateMode.disabled})
      : super(
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            final _RadioGroupState state = field as _RadioGroupState;
            Color errorColor = Theme.of(field.context).errorColor ?? Colors.red;
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

              for (RadioButton button in buttons) {
                bool isReadOnly = state.readOnly ||
                    state._controller.isReadOnly(button.controlKey);
                widgets.add(Wrap(
                  children: [
                    Radio(
                        key: UniqueKey(),
                        value: button.value,
                        groupValue: state.value,
                        onChanged: isReadOnly
                            ? null
                            : (v) {
                                field.didChange(v);
                                if (onChanged != null) onChanged(v);
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
          },
        );

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends FormFieldState {
  RadioGroupController controller;
  RadioGroupController get _controller => widget.controller ?? controller;

  bool readOnly = false;

  @override
  RadioGroup get widget => super.widget as RadioGroup;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controller = RadioGroupController(value: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(RadioGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null)
        oldWidget.controller.removeListener(_handleControllerChanged);
      if (widget.controller != null) {
        widget.controller.addListener(_handleControllerChanged);
      }
      if (oldWidget.controller != null && widget.controller == null)
        controller = RadioGroupController(value: oldWidget.controller.value);
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
  void didChange(dynamic value) {
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
