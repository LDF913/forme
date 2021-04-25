import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

class CheckboxItem extends SubControllableItem {
  final String label;
  final bool ignoreSplit;
  final bool readOnly;
  final bool visible;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  CheckboxItem(this.label,
      {this.ignoreSplit = false,
      this.readOnly = false,
      this.visible = true,
      this.textStyle,
      this.padding,
      String? controlKey})
      : super(controlKey, {
          'readOnly': readOnly,
          'visible': visible,
          'ignoreSplit': ignoreSplit,
          'label': label,
          'textStyle': textStyle,
          'padding': padding ?? EdgeInsets.all(8),
        });
}

class _CheckboxGroupController extends SubController<List<int>> {
  _CheckboxGroupController({List<int>? value}) : super(value);
  List<int> get value => super.value == null ? [] : super.value!;
  void set(List<int>? value) =>
      super.value = value == null ? [] : List.of(value);
}

class CheckboxGroup extends ValueField<List<int>> {
  CheckboxGroup(
      {required List<CheckboxItem> items,
      String? label,
      ValueChanged<List<int>>? onChanged,
      bool readOnly = false,
      int split = 2,
      NonnullFieldValidator<List<int>>? validator,
      AutovalidateMode? autovalidateMode,
      List<int>? initialValue,
      EdgeInsets? errorTextPadding,
      bool inline = false})
      : super(
            () => _CheckboxGroupController(value: initialValue),
            {
              'label': label,
              'split': split,
              'items': items,
              'errorTextPadding': errorTextPadding ?? EdgeInsets.all(8)
            },
            onChanged: onChanged == null ? null : (value) => onChanged(value!),
            replace: () => [],
            autovalidateMode: autovalidateMode,
            initialValue: initialValue ?? [],
            validator: validator == null ? null : (value) => validator(value!),
            readOnly: readOnly,
            builder:
                (state, context, readOnly, stateMap, themeData, formThemeData) {
              _CheckboxGroupController controller =
                  state.valueNotifier as _CheckboxGroupController;
              String? label = inline ? null : stateMap['label'];
              int split = inline ? 0 : stateMap['split'];
              List<CheckboxItem> items = stateMap['items'];
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

              List<int> value = List.of(controller.value);

              List<Widget> wrapWidgets = [];

              controller.init(items);

              for (int i = 0; i < items.length; i++) {
                CheckboxItem button = items[i];
                var stateMap = controller.getUpdatedMap(button);
                TextStyle labelStyle = stateMap['textStyle'] ?? TextStyle();
                bool isReadOnly = readOnly || stateMap['readOnly'];

                Color color = isReadOnly
                    ? themeData.disabledColor
                    : value.contains(i)
                        ? themeData.primaryColor
                        : themeData.unselectedWidgetColor;

                Widget checkbox = Padding(
                  padding: stateMap['padding'],
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
                Text text = Text(state.errorText!,
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
            });

  @override
  ValueFieldState<List<int>> createState() => ValueFieldState();
}
