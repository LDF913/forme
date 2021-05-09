import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../form_theme.dart';
import '../state_model.dart';
import '../form_field.dart';

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
    String? label,
    required List<SwitchGroupItem> items,
    ValueChanged<List<int>>? onChanged,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    bool hasSelectAllSwitch = true,
    List<int>? initialValue,
    EdgeInsets? errorTextPadding,
    EdgeInsets? selectAllPadding,
    NonnullFormFieldSetter<List<int>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    EdgeInsets? labelPadding,
  }) : super(
          {
            'label': StateValue<String?>(label),
            'items': StateValue<List<SwitchGroupItem>>(items),
            'hasSelectAllSwitch': StateValue<bool>(hasSelectAllSwitch),
            'selectAllPadding': StateValue<EdgeInsets>(
                selectAllPadding ?? const EdgeInsets.symmetric(horizontal: 4)),
            'errorTextPadding': StateValue<EdgeInsets>(
                errorTextPadding ?? const EdgeInsets.all(4)),
            'labelPadding': StateValue<EdgeInsets>(
                labelPadding ?? const EdgeInsets.symmetric(vertical: 10))
          },
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? List<int>.empty(growable: true),
          validator: validator,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.formThemeData;
            String? label = stateMap['label'];
            List<SwitchGroupItem> items = stateMap['items'];
            bool hasSelectAllSwitch = stateMap['hasSelectAllSwitch'];
            EdgeInsets errorTextPadding = stateMap['errorTextPadding'];
            EdgeInsets selectAllPadding = stateMap['selectAllPadding'];
            EdgeInsets labelPadding = stateMap['labelPadding'];

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
              if (state.value.contains(index)) {
                state.value.remove(index);
              } else {
                state.value.add(index);
              }
              state.didChange(state.value);
            }

            void toggleValues() {
              if (selectAll) {
                state.didChange(state.value
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

            List<Widget> headerRow = [];

            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style: ThemeUtil.getLabelStyle(themeData, state.hasError));
              headerRow.add(Padding(
                padding: labelPadding,
                child: text,
              ));
            }

            if (items.length > 1 && hasSelectAllSwitch && !isAllInvisible) {
              headerRow.add(Spacer());
              headerRow.add(InkWell(
                child: Padding(
                  child: CupertinoSwitch(
                    value: selectAll,
                    onChanged: readOnly || isAllReadOnly
                        ? null
                        : (value) {
                            toggleValues();
                          },
                    activeColor: themeData.primaryColor,
                  ),
                  padding: selectAllPadding,
                ),
                onTap: readOnly || isAllReadOnly ? null : toggleValues,
              ));
            }

            if (headerRow.isNotEmpty) {
              columns.add(Row(
                children: headerRow,
              ));
            }

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
              columns.add(Visibility(
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
            if (state.hasError) {
              columns.add(Padding(
                padding: errorTextPadding,
                child: Text(state.errorText!,
                    style: ThemeUtil.getErrorStyle(themeData)),
              ));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns,
            );
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
            ThemeData themeData = state.formThemeData;
            bool value = state.value;
            List<Widget> columns = [];
            columns.add(InkWell(
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
            ));

            if (state.hasError) {
              columns.add(Text(state.errorText!,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeUtil.getErrorStyle(themeData)));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns,
            );
          },
        );
}
