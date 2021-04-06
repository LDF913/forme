import 'package:flutter/material.dart';
import 'form_builder.dart';
import 'form_theme.dart';

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

  RadioGroup(this.controlKey, this.buttons,
      {Key key,
      this.controller,
      this.initialValue,
      this.label,
      this.onChanged,
      this.validator,
      this.autovalidateMode = AutovalidateMode.disabled})
      : assert(controlKey != null),
        super(
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            FormTheme theme = FormTheme.of(field.context);
            TextStyle errorStyle = FormTheme.getErrorStyle(field.context);
            final _RadioGroupState state = field as _RadioGroupState;
            List<Widget> widgets = [];
            if (label != null) {
              Text text = Text(
                label,
                style: FormTheme.getLabelStyle(field.context, state.hasError),
              );
              widgets.add(Container(
                  child: Row(
                children: [Flexible(child: text)],
              )));
            }

            bool readOnly =
                FormController.of(field.context).isReadOnly(controlKey);

            for (RadioButton button in buttons) {
              bool isReadOnly =
                  readOnly || controller.isReadOnly(button.controlKey);
              widgets.add(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      value: button.value,
                      groupValue: state.value,
                      onChanged: isReadOnly
                          ? null
                          : (v) {
                              field.didChange(v);
                              if (onChanged != null) onChanged(v);
                            }),
                  Text(
                    button.label,
                  ),
                ],
              ));
            }
            if (state.hasError) {
              widgets.add(Row(
                children: [
                  Flexible(child: Text(state.errorText, style: errorStyle))
                ],
              ));
            }
            return Padding(
              child: Wrap(
                children: widgets,
              ),
              padding: theme.getPadding(controlKey),
            );
          },
        );

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends FormFieldState {
  @override
  RadioGroup get widget => super.widget as RadioGroup;

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
  void didChange(dynamic value) {
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
