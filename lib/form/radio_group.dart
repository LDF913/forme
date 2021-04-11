import 'package:flutter/material.dart';
import 'form_builder.dart';
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

class RadioGroup extends FormBuilderField {
  final List<RadioButton> buttons;
  final String label;
  final int split;
  final EdgeInsets padding;

  RadioGroup(String controlKey, this.buttons, RadioGroupController controller,
      {Key key,
      this.label,
      ValueChanged onChanged,
      FormFieldValidator validator,
      AutovalidateMode autovalidateMode,
      this.split = 0,
      this.padding,
      bool readOnly = false})
      : assert(controlKey != null),
        super(
          controlKey,
          controller,
          readOnly,
          onChanged,
          key: key,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            FormThemeData formThemeData = FormThemeData.of(field.context);
            RadioGroupTheme radioGroupTheme = formThemeData.radioGroupTheme;
            ThemeData themeData = Theme.of(field.context);

            final FormBuilderFieldState state = field as FormBuilderFieldState;
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
                              if (value != controller.value) {
                                state.didChange(value);
                              }
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
  FormBuilderFieldState createState() => FormBuilderFieldState();
}
