import 'package:flutter/material.dart';
import 'form_builder.dart';
import 'form_theme.dart';

class RadioButton {
  final dynamic value;
  final String label;
  final String controlKey;
  final bool ignoreSplit;

  RadioButton(this.value, this.label,
      {this.controlKey, this.ignoreSplit = false});
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
  final int split;

  RadioGroup(this.controlKey, this.buttons,
      {Key key,
      this.controller,
      this.initialValue,
      this.label,
      this.onChanged,
      this.validator,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.split = 0})
      : assert(controlKey != null),
        super(
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            FormThemeData formThemeData =
                FormThemeData.of(controlKey, field.context);
            RadioGroupTheme radioGroupTheme = formThemeData.radioGroupTheme;
            ThemeData themeData = formThemeData.getThemeData(field.context);

            final _RadioGroupState state = field as _RadioGroupState;
            bool readOnly =
                FormController.of(field.context).isReadOnly(controlKey);
            List<Widget> widgets = [];
            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style:
                      FormThemeData.getLabelStyle(themeData, state.hasError));
              widgets.add(Padding(
                padding: formThemeData.labelPadding ?? EdgeInsets.zero,
                child: Row(
                  children: [Flexible(child: text)],
                ),
              ));
            }

            List<Widget> wrapWidgets = [];

            TextStyle labelStyle = radioGroupTheme.labelStyle ?? TextStyle();
            for (int i = 0; i < buttons.length; i++) {
              RadioButton button = buttons[i];
              bool isReadOnly =
                  readOnly || controller.isReadOnly(button.controlKey);
              bool isSelected = button.value == controller.value;
              Color color = isReadOnly
                  ? themeData.disabledColor
                  : isSelected
                      ? themeData.primaryColor
                      : themeData.unselectedWidgetColor;

              Widget checkbox = Padding(
                padding: radioGroupTheme.widgetsPadding ?? EdgeInsets.all(8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      onTap: isReadOnly
                          ? null
                          : () {
                              var value = button.value;
                              field.didChange(value);
                              if (onChanged != null) onChanged(value);
                            },
                      child: Row(
                        children: [
                          Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_checked_outlined,
                              size: labelStyle.fontSize,
                              color: color),
                          SizedBox(
                            width: radioGroupTheme.labelSpace ?? 4.0,
                          ),
                          split == 0
                              ? Text(
                                  button.label,
                                  style: labelStyle,
                                )
                              : Flexible(
                                  child: Text(
                                    button.label,
                                    style: labelStyle,
                                  ),
                                )
                        ],
                      )),
                ),
              );

              if (split <= 0) {
                wrapWidgets.add(checkbox);
                if (i < buttons.length - 1)
                  wrapWidgets.add(SizedBox(
                    width: radioGroupTheme.widgetsSpace,
                  ));
              } else {
                wrapWidgets.add(FractionallySizedBox(
                  widthFactor: button.ignoreSplit ? 1 : 1 / split,
                  child: checkbox,
                ));
              }
            }

            widgets.add(Wrap(children: wrapWidgets));

            if (state.hasError) {
              widgets.add(Padding(
                padding: radioGroupTheme.errorTextPadding ?? EdgeInsets.zero,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(state.errorText,
                          style: FormThemeData.getErrorStyle(themeData)),
                    )
                  ],
                ),
              ));
            }

            return formThemeData.widgetWrapper(
                controlKey,
                Column(
                  children: widgets,
                ),
                field.context);
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
