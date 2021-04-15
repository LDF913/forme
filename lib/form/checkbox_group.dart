import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

class CheckboxItem extends SubControllableItem {
  final String label;
  final bool ignoreSplit;
  final bool readOnly;
  final bool visible;
  final TextStyle textStyle;
  CheckboxItem(this.label,
      {this.ignoreSplit = false,
      this.readOnly = false,
      this.visible = true,
      this.textStyle,
      String controlKey})
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

class CheckboxGroupController extends SubController<List<int>> {
  CheckboxGroupController({List<int> value}) : super(value);
  List<int> get value => super.value == null ? [] : super.value;
  void set(List<int> value) =>
      super.value = value == null ? [] : List.of(value);
}

class CheckboxGroup extends FormBuilderField<List<int>> {
  final List<CheckboxItem> items;
  final String label;
  final int split;
  final EdgeInsets padding;
  final bool inline;

  CheckboxGroup(
      String controlKey, this.items, CheckboxGroupController controller,
      {Key key,
      this.label,
      ValueChanged<List<int>> onChanged,
      final bool readOnly,
      this.padding,
      this.split = 0,
      FormFieldValidator<List<int>> validator,
      AutovalidateMode autovalidateMode,
      List<int> initialValue,
      this.inline = false})
      : assert(controlKey != null),
        super(controlKey, controller,
            key: key,
            onChanged: onChanged,
            replace: () => [],
            autovalidateMode: autovalidateMode,
            initialValue: initialValue ?? [],
            validator: validator,
            builder: (field) {
              FormThemeData formThemeData = FormThemeData.of(field.context);
              CheckboxGroupTheme checkboxGroupTheme =
                  formThemeData.checkboxGroupTheme;
              ThemeData themeData = Theme.of(field.context);
              final FormBuilderFieldState<List<int>> state =
                  field as FormBuilderFieldState;
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

              List<int> value = controller.value;

              List<Widget> wrapWidgets = [];

              controller.init(items);

              for (int i = 0; i < items.length; i++) {
                CheckboxItem button = items[i];
                var stateMap = controller.getUpdatedMap(button);
                TextStyle labelStyle = stateMap['textStyle'] ??
                    checkboxGroupTheme.labelStyle ??
                    TextStyle();
                bool isReadOnly = readOnly || stateMap['readOnly'];

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
                                state.didChange(value);
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

                bool visible = stateMap['visible'];
                if (split <= 0) {
                  wrapWidgets.add(Visibility(
                    child: checkbox,
                    visible: visible,
                  ));
                  if (visible && i < items.length - 1)
                    wrapWidgets.add(SizedBox(
                      width: 8.0,
                    ));
                } else {
                  wrapWidgets.add(Visibility(
                    child: FractionallySizedBox(
                      widthFactor: stateMap['ignoreSplit'] ? 1 : 1 / split,
                      child: checkbox,
                    ),
                    visible: visible,
                  ));
                }
              }

              widgets.add(Wrap(children: wrapWidgets));

              if (state.hasError) {
                Text text = Text(state.errorText,
                    overflow: inline ? TextOverflow.ellipsis : null,
                    style: FormThemeData.getErrorStyle(themeData));
                widgets.add(Padding(
                  padding:
                      checkboxGroupTheme.errorTextPadding ?? EdgeInsets.zero,
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
            });

  @override
  FormBuilderFieldState<List<int>> createState() => FormBuilderFieldState();
}
