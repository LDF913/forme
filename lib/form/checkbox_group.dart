import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

class CheckboxButton {
  final String label;
  final String controlKey;
  final bool ignoreSplit;
  CheckboxButton(this.label, {this.controlKey, this.ignoreSplit = false});
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
  final int split;

  CheckboxGroup(this.controlKey, this.buttons,
      {Key key,
      this.controller,
      this.initialValue,
      this.label,
      this.validator,
      this.onChanged,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.split = 0})
      : assert(controlKey != null),
        super(
            autovalidateMode: autovalidateMode,
            validator: validator,
            initialValue: initialValue,
            builder: (field) {
              FormThemeData formThemeData =
                  FormThemeData.of(controlKey, field.context);
              CheckboxGroupTheme checkboxGroupTheme =
                  formThemeData.checkboxGroupTheme;
              ThemeData themeData = formThemeData.getThemeData(field.context);
              final _CheckboxGroupState state = field as _CheckboxGroupState;
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

              List<int> value;
              if (controller.value != null) {
                value = List.from(controller.value);
              } else {
                value = [];
              }

              List<Widget> wrapWidgets = [];

              TextStyle labelStyle =
                  checkboxGroupTheme.labelStyle ?? TextStyle();
              for (int i = 0; i < buttons.length; i++) {
                CheckboxButton button = buttons[i];
                bool isReadOnly =
                    readOnly || controller.isReadOnly(button.controlKey);

                Color color = isReadOnly
                    ? themeData.disabledColor
                    : value.contains(i)
                        ? themeData.primaryColor
                        : themeData.unselectedWidgetColor;

                Widget checkbox = Padding(
                  padding:
                      checkboxGroupTheme.widgetsPadding ?? EdgeInsets.all(8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
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
                              },
                        child: Row(
                          children: [
                            value.contains(i)
                                ? Icon(Icons.check_box,
                                    size: labelStyle.fontSize, color: color)
                                : Icon(Icons.check_box_outline_blank,
                                    size: labelStyle.fontSize, color: color),
                            SizedBox(
                              width: checkboxGroupTheme.labelSpace ?? 4.0,
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
                      width: checkboxGroupTheme.widgetsSpace ?? 4.0,
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
                  padding:
                      checkboxGroupTheme.errorTextPadding ?? EdgeInsets.zero,
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
