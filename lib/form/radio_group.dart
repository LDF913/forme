import 'package:flutter/material.dart';
import 'form_builder.dart';
import 'form_theme.dart';

class RadioItem extends SubControllableItem {
  final dynamic value;
  final String label;
  final bool ignoreSplit;
  final bool readOnly;
  final bool visible;
  final TextStyle textStyle;

  RadioItem(this.value, this.label,
      {String controlKey,
      this.ignoreSplit = false,
      this.readOnly = false,
      this.visible = true,
      this.textStyle})
      : super(controlKey);
  Map<String, dynamic> toMap() {
    return {
      'readOnly': readOnly ?? false,
      'visible': visible ?? true,
      'ignoreSplit': ignoreSplit ?? false,
      'label': label,
      'textStyle': textStyle
    };
  }
}

class RadioGroupController extends SubController {
  RadioGroupController({value}) : super(value);
}

class RadioGroup extends FormBuilderField {
  final List<RadioItem> items;
  final String label;
  final int split;
  final EdgeInsets padding;
  final bool inline;

  RadioGroup(this.items, RadioGroupController controller,
      {Key key,
      this.label,
      ValueChanged onChanged,
      FormFieldValidator validator,
      AutovalidateMode autovalidateMode,
      this.split = 0,
      this.padding,
      bool readOnly = false,
      dynamic initialValue,
      this.inline = false})
      : super(
          controller,
          key: key,
          readOnly: readOnly,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
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
                child: text,
              ));
            }

            List<Widget> wrapWidgets = [];

            controller.init(items);

            for (int i = 0; i < items.length; i++) {
              RadioItem button = items[i];
              var stateMap = controller.getUpdatedMap(button);
              TextStyle labelStyle = stateMap['labelStyle'] ??
                  radioGroupTheme.labelStyle ??
                  TextStyle();
              bool isReadOnly = readOnly || stateMap['readOnly'];
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
                                  stateMap['label'],
                                  style: labelStyle,
                                )
                              : Flexible(
                                  child: Text(
                                    stateMap['label'],
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
                  visible: stateMap['visible'],
                ));
                if (button.visible && i < items.length - 1)
                  wrapWidgets.add(SizedBox(
                    width: 8.0,
                  ));
              } else {
                wrapWidgets.add(Visibility(
                  child: FractionallySizedBox(
                    widthFactor: button.ignoreSplit ? 1 : 1 / split,
                    child: radio,
                  ),
                  visible: stateMap['visible'],
                ));
              }
            }

            widgets.add(Wrap(children: wrapWidgets));

            if (state.hasError) {
              Text text = Text(state.errorText,
                  overflow: inline ? TextOverflow.ellipsis : null,
                  style: FormThemeData.getErrorStyle(themeData));
              widgets.add(Padding(
                padding: radioGroupTheme.errorTextPadding ?? EdgeInsets.zero,
                child: text,
              ));
            }

            return Padding(
              padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              ),
            );
          },
        );

  @override
  FormBuilderFieldState createState() => FormBuilderFieldState();
}
