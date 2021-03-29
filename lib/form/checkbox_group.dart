import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_builder.dart';

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
                if (controller.value != null) {
                  value = List.from(controller.value);
                } else {
                  value = [];
                }

                for (int i = 0; i < buttons.length; i++) {
                  CheckboxButton button = buttons[i];
                  bool isReadOnly = state.readOnly ||
                      controller.isReadOnly(button.controlKey);
                  widgets.add(Row(
                    mainAxisSize: MainAxisSize.min,
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
                      Text(
                        button.label,
                      ),
                    ],
                  ));
                }

                if (state.errorText != null) {
                  widgets.add(Row(
                    children: [
                      Flexible(
                        child: Text(state.errorText,
                            style: TextStyle(color: errorColor)),
                      )
                    ],
                  ));
                }
                return Wrap(
                  children: widgets,
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
  @override
  CheckboxGroup get widget => super.widget as CheckboxGroup;

  bool readOnly = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(List<int> value) {
    super.didChange(value);
    if (widget.controller.value != value) widget.controller.value = value ?? [];
  }

  @override
  void reset() {
    widget.controller.value = widget.initialValue ?? [];
    super.reset();
  }

  void _handleControllerChanged() {
    if (widget.controller.value != value)
      didChange(widget.controller.value);
    else
      setState(() {});
  }
}
