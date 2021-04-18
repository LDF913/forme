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
  final EdgeInsets padding;

  RadioItem(this.value, this.label,
      {String controlKey,
      this.ignoreSplit = false,
      this.readOnly = false,
      this.visible = true,
      this.padding,
      this.textStyle})
      : super(controlKey, {
          'readOnly': readOnly ?? false,
          'visible': visible ?? true,
          'ignoreSplit': ignoreSplit ?? false,
          'label': label,
          'textStyle': textStyle,
          'padding': padding ?? EdgeInsets.all(8),
        });
}

class _RadioGroupController extends SubController {
  _RadioGroupController({value}) : super(value);
}

class RadioGroup extends ValueField {
  RadioGroup(List<RadioItem> items,
      {Key key,
      String label,
      ValueChanged onChanged,
      FormFieldValidator validator,
      AutovalidateMode autovalidateMode,
      int split = 0,
      bool readOnly = false,
      dynamic initialValue,
      EdgeInsets errorTextPadding,
      @required bool inline})
      : super(
          () => _RadioGroupController(value: initialValue),
          {
            'label': label,
            'split': split ?? 2,
            'items': items,
            'errorTextPadding': errorTextPadding ?? EdgeInsets.all(8)
          },
          key: key,
          readOnly: readOnly,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          builder: (state, context, readOnly, stateMap, themeData,
              formThemeData, focusNodeProvider, notifier) {
            _RadioGroupController controller = notifier;
            String label = inline ? null : stateMap['label'];
            int split = inline ? 0 : stateMap['split'];
            List<RadioItem> items = stateMap['items'];
            EdgeInsets errorTextPadding = stateMap['errorTextPadding'];

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
              TextStyle labelStyle = stateMap['labelStyle'] ?? TextStyle();
              bool isReadOnly = readOnly || stateMap['readOnly'];
              bool isSelected = button.value == controller.value;
              Color color = isReadOnly
                  ? themeData.disabledColor
                  : isSelected
                      ? themeData.primaryColor
                      : themeData.unselectedWidgetColor;

              Widget radio = Padding(
                padding: stateMap['padding'],
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
                padding: errorTextPadding,
                child: text,
              ));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            );
          },
        );

  @override
  ValueFieldState createState() => ValueFieldState();
}
