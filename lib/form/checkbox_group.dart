import 'package:flutter/material.dart';

import 'form_theme.dart';

class CheckboxButton {
  final String label;
  final bool ignoreSplit;
  final bool readOnly;
  final bool visible;
  final TextStyle textStyle;
  CheckboxButton(this.label,
      {this.ignoreSplit = false,
      this.readOnly = false,
      this.visible = true,
      this.textStyle});
}

class CheckboxGroupController extends ValueNotifier<List<int>> {
  CheckboxGroupController({List<int> value}) : super(value);

  List<int> get value => super.value == null ? [] : super.value;
  void set(List<int> value) =>
      super.value = value == null ? [] : List.of(value);
}

class CheckboxGroup extends FormField<List<int>> {
  final List<CheckboxButton> buttons;
  final CheckboxGroupController controller;
  final String label;
  final String controlKey;
  final ValueChanged<List<int>> onChanged;
  final int split;
  final EdgeInsets padding;
  final bool readOnly;

  CheckboxGroup(this.controlKey, this.buttons,
      {Key key,
      this.controller,
      this.label,
      this.onChanged,
      this.padding,
      this.split = 0,
      FormFieldValidator<List<int>> validator,
      AutovalidateMode autovalidateMode,
      this.readOnly = false})
      : assert(controlKey != null),
        super(
            key: key,
            autovalidateMode: autovalidateMode,
            validator: validator,
            builder: (field) {
              FormThemeData formThemeData = FormThemeData.of(field.context);
              CheckboxGroupTheme checkboxGroupTheme =
                  formThemeData.checkboxGroupTheme;
              ThemeData themeData = Theme.of(field.context);
              final _CheckboxGroupState state = field as _CheckboxGroupState;
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

              List<int> value = controller.value;

              List<Widget> wrapWidgets = [];

              for (int i = 0; i < buttons.length; i++) {
                CheckboxButton button = buttons[i];
                TextStyle labelStyle = button.textStyle ??
                    checkboxGroupTheme.labelStyle ??
                    TextStyle();
                bool isReadOnly = readOnly || button.readOnly;

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
                                if (onChanged != null) onChanged(value);
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            value.contains(i)
                                ? Icon(Icons.check_box,
                                    size: labelStyle.fontSize, color: color)
                                : Icon(Icons.check_box_outline_blank,
                                    size: labelStyle.fontSize, color: color),
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
                    child: checkbox,
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
                      child: checkbox,
                    ),
                    visible: button.visible,
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

              return Padding(
                padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
    widget.controller.value = [];
    super.reset();
  }

  void _handleControllerChanged() {
    if (widget.controller.value != value)
      didChange(widget.controller.value);
    else
      setState(() {});
  }
}
