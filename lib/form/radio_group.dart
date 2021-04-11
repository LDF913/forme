import 'package:flutter/material.dart';
import 'form_theme.dart';

class RadioButton {
  final dynamic value;
  final String label;
  final String controlKey;
  final bool ignoreSplit;
  final bool readOnly;
  final bool visible;

  RadioButton(this.value, this.label,
      {this.controlKey,
      this.ignoreSplit = false,
      this.readOnly = false,
      this.visible = true});
}

class RadioGroupController extends ValueNotifier {
  RadioGroupController({value}) : super(value);
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
  final EdgeInsets padding;
  final bool readOnly;

  RadioGroup(this.controlKey, this.buttons,
      {Key key,
      this.controller,
      this.initialValue,
      this.label,
      this.onChanged,
      this.validator,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.split = 0,
      this.padding,
      this.readOnly = false})
      : assert(controlKey != null),
        super(
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            FormThemeData formThemeData = FormThemeData.of(field.context);
            RadioGroupTheme radioGroupTheme = formThemeData.radioGroupTheme;
            ThemeData themeData = Theme.of(field.context);

            final _RadioGroupState state = field as _RadioGroupState;
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
              bool isReadOnly = readOnly || button.readOnly;
              bool isSelected = button.value == controller.value;
              Color color = isReadOnly
                  ? themeData.disabledColor
                  : isSelected
                      ? themeData.primaryColor
                      : themeData.unselectedWidgetColor;

              Widget radio = Padding(
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              size: labelStyle.fontSize,
                              color: color),
                          SizedBox(
                            width: 4.0,
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
                wrapWidgets.add(Visibility(
                  child: radio,
                  visible: button.visible,
                ));
                if (button.visible && i < buttons.length - 1)
                  wrapWidgets.add(SizedBox(
                    width: 8.0,
                  ));
              } else {
                wrapWidgets.add(Visibility(
                  child: FractionallySizedBox(
                    widthFactor: button.ignoreSplit ? 1 : 1 / split,
                    child: radio,
                  ),
                  visible: button.visible,
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

            return Padding(
              padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              ),
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
