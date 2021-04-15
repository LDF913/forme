import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'form_builder.dart';
import 'form_theme.dart';

class SwitchGroupController extends SubController<List<int>> {
  SwitchGroupController({value}) : super(value);
  List<int> get value => super.value == null ? [] : super.value;
  void set(List<int> value) =>
      super.value = value == null ? [] : List.of(value);
}

class SwitchGroupItem extends SubControllableItem {
  final String label;
  final bool readOnly;
  final bool visible;
  final TextStyle textStyle;
  SwitchGroupItem(this.label,
      {this.readOnly = false,
      this.visible = true,
      String controlKey,
      this.textStyle})
      : super(controlKey);
  @override
  Map<String, dynamic> toMap() {
    return {
      'readOnly': readOnly ?? false,
      'visible': visible ?? true,
      'label': label,
      'textStyle': textStyle
    };
  }
}

class SwitchGroupFormField extends FormBuilderField<List<int>> {
  final List<SwitchGroupItem> items;
  final String label;
  final EdgeInsets padding;
  final bool hasSelectAllSwitch;

  SwitchGroupFormField(
    SwitchGroupController controller, {
    Key key,
    this.label,
    this.items,
    bool readOnly = false,
    ValueChanged<List<int>> onChanged,
    FormFieldValidator<List<int>> validator,
    AutovalidateMode autovalidateMode,
    this.padding,
    this.hasSelectAllSwitch = true,
    List<int> initialValue,
  }) : super(
          controller,
          key: key,
          readOnly: readOnly,
          onChanged: onChanged,
          replace: () => [],
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? [],
          validator: validator,
          builder: (field) {
            final FormBuilderFieldState<List<int>> state =
                field as FormBuilderFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            controller.init(items);
            Map<SwitchGroupItem, Map<String, dynamic>> statesMap = {};

            bool isAllReadOnly = true;
            bool isAllInvisible = true;
            List<int> controllableItems = [];

            items.asMap().forEach((index, element) {
              Map<String, dynamic> stateMap = controller.getUpdatedMap(element);
              bool readOnly = stateMap['readOnly'];
              bool visible = stateMap['visible'];
              if (!readOnly) {
                isAllReadOnly = false;
              }
              if (visible) {
                isAllInvisible = false;
              }
              if (!readOnly && visible) {
                controllableItems.add(index);
              }
              statesMap[element] = stateMap;
            });

            bool selectAll = controllableItems.isNotEmpty &&
                controllableItems
                    .every((element) => controller.value.contains(element));

            void changeValue(int index) {
              List<int> value = controller.value;
              if (value.contains(index)) {
                value.remove(index);
              } else {
                value.add(index);
              }
              state.didChange(value);
            }

            void toggleValues() {
              if (selectAll) {
                state.didChange(controller.value
                    .where((element) => !controllableItems.contains(element))
                    .toList());
              } else {
                state.didChange(state.value
                  ..addAll(controllableItems)
                  ..toSet()
                  ..toList());
              }
            }

            List<Widget> columns = [];
            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style:
                      FormThemeData.getLabelStyle(themeData, state.hasError));
              columns.add(Padding(
                padding: formThemeData.labelPadding ?? EdgeInsets.zero,
                child: text,
              ));
            }

            if (items.length > 1 && hasSelectAllSwitch && !isAllInvisible) {
              columns.add(InkWell(
                child: Padding(
                  child: Row(
                    children: [
                      Expanded(child: Text('全选')),
                      CupertinoSwitch(
                        value: selectAll,
                        onChanged: readOnly || isAllReadOnly
                            ? null
                            : (value) {
                                toggleValues();
                              },
                        activeColor: themeData.primaryColor,
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onTap: readOnly || isAllReadOnly ? null : toggleValues,
              ));
              columns.add(Divider());
            }

            for (int i = 0; i < items.length; i++) {
              SwitchGroupItem item = items[i];
              var stateMap = statesMap[item];
              List<Widget> children = [];
              children.add(Expanded(
                  child: Text(
                stateMap['label'],
                style: stateMap['textStyle'],
              )));
              bool isReadOnly = readOnly || stateMap['readOnly'];
              children.add(CupertinoSwitch(
                value: controller.value.contains(i),
                onChanged: isReadOnly
                    ? null
                    : (value) {
                        changeValue(i);
                      },
                activeColor: themeData.primaryColor,
              ));
              columns.add(Visibility(
                child: InkWell(
                  child: Padding(
                    child: Row(
                      children: children,
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  onTap: isReadOnly
                      ? null
                      : () {
                          changeValue(i);
                        },
                ),
                visible: stateMap['visible'],
              ));
            }
            if (state.hasError) {
              columns.add(Text(state.errorText,
                  style: FormThemeData.getErrorStyle(themeData)));
            }

            return Padding(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns,
              ),
              padding: formThemeData.padding ?? padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  FormBuilderFieldState<List<int>> createState() => FormBuilderFieldState();
}

class SwitchController extends ValueNotifier<bool> {
  SwitchController({value}) : super(value);
  bool get value => super.value ?? false;
}

class SwitchInlineFormField extends FormBuilderField<bool> {
  final EdgeInsets padding;

  SwitchInlineFormField(SwitchController controller,
      {Key key,
      bool readOnly = false,
      ValueChanged<bool> onChanged,
      FormFieldValidator<bool> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      bool initialValue})
      : super(
          controller,
          key: key,
          readOnly: readOnly,
          onChanged: onChanged,
          replace: () => false,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? false,
          validator: validator,
          builder: (field) {
            final FormBuilderFieldState state = field as FormBuilderFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            List<Widget> columns = [];
            columns.add(InkWell(
              child: Padding(
                child: Row(
                  children: [
                    CupertinoSwitch(
                      value: controller.value,
                      onChanged: readOnly
                          ? null
                          : (value) {
                              state.didChange(!controller.value);
                            },
                      activeColor: themeData.primaryColor,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onTap: readOnly
                  ? null
                  : () {
                      state.didChange(!controller.value);
                    },
            ));

            if (state.hasError) {
              columns.add(Text(state.errorText,
                  overflow: TextOverflow.ellipsis,
                  style: FormThemeData.getErrorStyle(themeData)));
            }

            return Padding(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns,
              ),
              padding: formThemeData.padding ?? padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  FormBuilderFieldState<bool> createState() => FormBuilderFieldState();
}
