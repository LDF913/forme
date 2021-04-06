import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

class CheckboxButton {
  final String label;
  final String controlKey;
  CheckboxButton(this.label, {this.controlKey});
}

class CheckboxGroupController extends ValueNotifier<List<int>> {
  List<String> _readOnlyKeys = [];
  CheckboxGroupController({List<int> value}) : super(value);

  List<int> get value => super.value == null ? [] : super.value;

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
              FormTheme theme = FormTheme.of(field.context);
              final _CheckboxGroupState state = field as _CheckboxGroupState;
              TextStyle errorStyle = FormTheme.getErrorStyle(field.context);
              bool readOnly =
                  FormController.of(field.context).isReadOnly(controlKey);
              List<Widget> widgets = [];
              if (label != null) {
                Text text;
                if (state.errorText != null) {
                  text = Text(label, style: errorStyle);
                } else {
                  text = Text(
                    label,
                    style:
                        FormTheme.getLabelStyle(field.context, state.hasError),
                  );
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

              TextStyle labelStyle =
                  theme.getCheckboxLabelStyle(controlKey) ?? TextStyle();
              ThemeData themeData = Theme.of(field.context);
              CheckboxThemeData checkboxThemeData =
                  themeData.checkboxTheme ?? CheckboxThemeData();
              for (int i = 0; i < buttons.length; i++) {
                CheckboxButton button = buttons[i];
                bool isReadOnly =
                    readOnly || controller.isReadOnly(button.controlKey);
                widgets.add(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        child: value.contains(i)
                            ? Icon(
                                Icons.check_box,
                                size: labelStyle.fontSize,
                                color: isReadOnly
                                    ? themeData.disabledColor
                                    : checkboxThemeData.checkColor
                                        .resolve({MaterialState.selected}),
                              )
                            : Icon(Icons.check_box_outline_blank,
                                size: labelStyle.fontSize,
                                color: isReadOnly
                                    ? themeData.disabledColor
                                    : null),
                        onTap: isReadOnly
                            ? null
                            : () {
                                if (value.contains(i))
                                  value.remove(i);
                                else
                                  value.add(i);
                                field.didChange(value);
                                if (onChanged != null)
                                  onChanged(List.from(value));
                              }),
                    SizedBox(
                      width: theme.getCheckboxLabeSpace(controlKey),
                    ),
                    Text(
                      button.label,
                      style: labelStyle,
                    ),
                    SizedBox(
                      width: theme.getCheckboxSpace(controlKey),
                    ),
                  ],
                ));
              }

              if (state.errorText != null) {
                widgets.add(Row(
                  children: [
                    Flexible(
                      child: Text(state.errorText, style: errorStyle),
                    )
                  ],
                ));
              }
              return Padding(
                padding: theme.getPadding(controlKey),
                child: Wrap(
                  children: widgets,
                ),
              );
            });

  @override
  _CheckboxGroupState createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends FormFieldState<List<int>> {
  @override
  CheckboxGroup get widget => super.widget as CheckboxGroup;

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
