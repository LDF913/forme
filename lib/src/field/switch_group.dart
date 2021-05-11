import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../state_model.dart';
import '../form_field.dart';
import 'decoration_field.dart';

class SwitchGroupItem {
  final String label;
  final bool readOnly;
  final bool visible;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  SwitchGroupItem(this.label,
      {this.readOnly = false,
      this.visible = true,
      this.textStyle,
      EdgeInsets? padding})
      : this.padding = padding ?? EdgeInsets.all(4);
}

class SwitchGroupFormField extends BaseNonnullValueField<List<int>> {
  SwitchGroupFormField({
    String? labelText,
    required List<SwitchGroupItem> items,
    ValueChanged<List<int>>? onChanged,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    bool hasSelectAllSwitch = true,
    List<int>? initialValue,
    NonnullFormFieldSetter<List<int>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
  }) : super(
          {
            'labelText': StateValue<String?>(labelText),
            'items': StateValue<List<SwitchGroupItem>>(items),
            'hasSelectAllSwitch': StateValue<bool>(hasSelectAllSwitch),
          },
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? List<int>.empty(),
          validator: validator,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.themeData;
            String? labelText = stateMap['labelText'];
            List<SwitchGroupItem> items = stateMap['items'];
            bool hasSelectAllSwitch = stateMap['hasSelectAllSwitch'];

            bool isAllReadOnly = true;
            bool isAllInvisible = true;
            List<int> controllableItems = [];

            items.asMap().forEach((index, element) {
              bool readOnly = element.readOnly;
              bool visible = element.visible;
              if (!readOnly) {
                isAllReadOnly = false;
              }
              if (visible) {
                isAllInvisible = false;
              }
              if (!readOnly && visible) {
                controllableItems.add(index);
              }
            });

            bool selectAll = controllableItems.isNotEmpty &&
                controllableItems
                    .every((element) => state.value.contains(element));

            void changeValue(int index) {
              List<int> value = List.of(state.value);
              if (value.contains(index)) {
                value.remove(index);
              } else {
                value.add(index);
              }
              state.didChange(value);
            }

            void toggleValues() {
              List<int> value = List.of(state.value);
              if (selectAll) {
                state.didChange(value
                    .where((element) => !controllableItems.contains(element))
                    .toList());
              } else {
                state.didChange(value
                  ..addAll(controllableItems)
                  ..toSet()
                  ..toList());
              }
            }

            List<Widget> switchs = [];

            for (int i = 0; i < items.length; i++) {
              SwitchGroupItem item = items[i];
              List<Widget> children = [];
              children.add(Expanded(
                  child: Text(
                item.label,
                style: item.textStyle,
              )));
              bool isReadOnly = readOnly || item.readOnly;
              children.add(CupertinoSwitch(
                value: state.value.contains(i),
                onChanged: isReadOnly
                    ? null
                    : (value) {
                        changeValue(i);
                      },
                activeColor: themeData.primaryColor,
              ));
              switchs.add(Visibility(
                child: InkWell(
                  child: Padding(
                      child: Row(
                        children: children,
                      ),
                      padding: item.padding),
                  onTap: isReadOnly
                      ? null
                      : () {
                          changeValue(i);
                        },
                ),
                visible: item.visible,
              ));
            }

            int index =
                items.length > 1 && hasSelectAllSwitch && !isAllInvisible
                    ? 0
                    : 1;

            IconData iconData =
                selectAll ? Icons.switch_right : Icons.switch_left;
            return DecorationField(
                labelText: labelText,
                readOnly: readOnly || isAllReadOnly,
                errorText: state.errorText,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: switchs,
                ),
                focusNode: state.focusNode,
                icon: IndexedStack(
                  index: index,
                  children: [
                    InkWell(
                      onTap: readOnly || isAllReadOnly ? null : toggleValues,
                      child: IconButton(
                        icon: Icon(
                          iconData,
                        ),
                        onPressed: toggleValues,
                      ),
                    ),
                    SizedBox()
                  ],
                ));
          },
        );
}

class SwitchInlineFormField extends BaseNonnullValueField<bool> {
  SwitchInlineFormField({
    ValueChanged<bool>? onChanged,
    NonnullFieldValidator<bool>? validator,
    AutovalidateMode? autovalidateMode,
    bool initialValue = false,
    NonnullFormFieldSetter<bool>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
  }) : super(
          {},
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          builder: (state) {
            bool readOnly = state.readOnly;
            ThemeData themeData = state.themeData;
            bool value = state.value;
            Widget child = InkWell(
              child: Row(
                children: [
                  CupertinoSwitch(
                    value: value,
                    onChanged: readOnly
                        ? null
                        : (_) {
                            state.didChange(!value);
                          },
                    activeColor: themeData.primaryColor,
                  )
                ],
              ),
              onTap: readOnly
                  ? null
                  : () {
                      state.didChange(!value);
                    },
            );

            return DecorationField(
              child: child,
              focusNode: state.focusNode,
              errorText: state.errorText,
              readOnly: readOnly,
            );
          },
        );
}
