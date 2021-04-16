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
  SwitchGroupItem(String label,
      {bool readOnly = false,
      bool visible = true,
      String controlKey,
      EdgeInsets padding,
      TextStyle textStyle})
      : super(controlKey, {
          'readOnly': readOnly ?? false,
          'visible': visible ?? true,
          'label': label,
          'textStyle': textStyle,
          'padding': padding ?? EdgeInsets.all(4)
        });
}

class SwitchGroupFormField extends ValueField<List<int>> {
  SwitchGroupFormField(SwitchGroupController controller,
      {Key key,
      String label,
      List<SwitchGroupItem> items,
      bool readOnly = false,
      ValueChanged<List<int>> onChanged,
      FormFieldValidator<List<int>> validator,
      AutovalidateMode autovalidateMode,
      EdgeInsets padding,
      bool hasSelectAllSwitch = true,
      List<int> initialValue,
      EdgeInsets errorTextPadding,
      EdgeInsets selectAllPadding,
      bool selectAllDivier})
      : super(
          controller,
          {
            'label': label,
            'items': items,
            'hasSelectAllSwitch': hasSelectAllSwitch,
            'selectAllPadding':
                selectAllPadding ?? EdgeInsets.symmetric(horizontal: 4),
            'selectAllDivier': selectAllDivier ?? true,
            'errorTextPadding': errorTextPadding ?? EdgeInsets.all(4)
          },
          key: key,
          readOnly: readOnly,
          padding: padding,
          onChanged: onChanged,
          replace: () => [],
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? [],
          validator: validator,
          builder: (field) {
            final ValueFieldState<List<int>> state = field as ValueFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            String label = state.getState('label');
            List<SwitchGroupItem> items = state.getState('items');
            bool hasSelectAllSwitch = state.getState('hasSelectAllSwitch');
            bool readOnly = state.readOnly;
            EdgeInsets padding = state.padding;
            EdgeInsets errorTextPadding = state.getState('errorTextPadding');
            EdgeInsets selectAllPadding = state.getState('selectAllPadding');
            bool selectAllDivier = state.getState('selectAllDivier');

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

            List<int> value = List.of(controller.value);

            bool selectAll = controllableItems.isNotEmpty &&
                controllableItems.every((element) => value.contains(element));

            void changeValue(int index) {
              if (value.contains(index)) {
                value.remove(index);
              } else {
                value.add(index);
              }
              state.didChange(value);
            }

            void toggleValues() {
              if (selectAll) {
                state.didChange(value
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
                  padding: selectAllPadding,
                ),
                onTap: readOnly || isAllReadOnly ? null : toggleValues,
              ));
              if (selectAllDivier) columns.add(Divider());
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
                value: value.contains(i),
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
                    padding: stateMap['padding'],
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
              columns.add(Padding(
                padding: errorTextPadding,
                child: Text(state.errorText,
                    style: FormThemeData.getErrorStyle(themeData)),
              ));
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
  ValueFieldState<List<int>> createState() => ValueFieldState();
}

class SwitchController extends ValueNotifier<bool> {
  SwitchController({value}) : super(value);
  bool get value => super.value ?? false;
}

class SwitchInlineFormField extends ValueField<bool> {
  SwitchInlineFormField(SwitchController controller,
      {Key key,
      bool readOnly = false,
      ValueChanged<bool> onChanged,
      FormFieldValidator<bool> validator,
      AutovalidateMode autovalidateMode,
      EdgeInsets padding,
      bool initialValue})
      : super(
          controller,
          {},
          key: key,
          readOnly: readOnly,
          padding: padding,
          onChanged: onChanged,
          replace: () => false,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? false,
          validator: validator,
          builder: (field) {
            final ValueFieldState state = field as ValueFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            bool readOnly = state.readOnly;
            EdgeInsets padding = state.padding;

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
  ValueFieldState<bool> createState() => ValueFieldState();
}
