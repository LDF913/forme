import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_theme.dart';
import '../state_model.dart';
import 'decoration_field.dart';

class ListTileItem<T> {
  final Widget title;
  final bool readOnly;
  final bool visible;
  final EdgeInsets padding;
  final Widget? secondary;
  final ListTileControlAffinity controlAffinity;
  final Widget? subtitle;
  final bool dense;
  final T data;
  final bool ignoreSplit;

  ListTileItem({
    required this.title,
    this.subtitle,
    this.secondary,
    ListTileControlAffinity? controlAffinity,
    this.readOnly = false,
    this.visible = true,
    this.dense = false,
    EdgeInsets? padding,
    required this.data,
    this.ignoreSplit = false,
  })  : this.controlAffinity =
            controlAffinity ?? ListTileControlAffinity.leading,
        this.padding = padding ?? EdgeInsets.zero;
}

enum ListTileItemType { Checkbox, Switch, Radio }

class ListTileFormField<T> extends BaseNonnullValueField<List<T>> {
  ListTileFormField({
    required List<ListTileItem<T>> items,
    String? labelText,
    ValueChanged<List<T>>? onChanged,
    int split = 2,
    NonnullFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    List<T>? initialValue,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    ListTileItemType type = ListTileItemType.Checkbox,
    bool hasSelectAll = true,
  }) : super({
          'labelText': StateValue<String?>(labelText),
          'split': StateValue<int>(split),
          'items': StateValue<List<ListTileItem<T>>>(items),
          'hasSelectAll': StateValue<bool>(hasSelectAll),
        },
            visible: visible,
            readOnly: readOnly,
            flex: flex,
            padding: padding,
            name: name,
            onChanged: onChanged,
            onSaved: onSaved,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue ?? [],
            validator: validator, builder: (state) {
          bool readOnly = state.readOnly;
          ThemeData themeData = Theme.of(state.context);
          Map<String, dynamic> stateMap = state.currentMap;
          String? labelText = stateMap['labelText'];
          int split = stateMap['split'];
          List<ListTileItem<T>> items = stateMap['items'];
          bool hasSelectAll = stateMap['hasSelectAll'];

          List<Widget> wrapWidgets = [];

          void changeValue(T value) {
            switch (type) {
              case ListTileItemType.Checkbox:
              case ListTileItemType.Switch:
                List<T> values = List.of(state.value);
                if (!values.remove(value)) {
                  values.add(value);
                }
                state.didChange(values);
                break;
              case ListTileItemType.Radio:
                state.didChange([value]);
                break;
            }
          }

          Widget createListTileItem(
              ListTileItem item, bool selected, bool readOnly) {
            switch (type) {
              case ListTileItemType.Radio:
                return RadioListTile<T>(
                  secondary: item.secondary,
                  subtitle: item.subtitle,
                  groupValue: state.value.isEmpty ? null : state.value[0],
                  controlAffinity: item.controlAffinity,
                  contentPadding: item.padding,
                  dense: item.dense,
                  title: item.title,
                  value: item.data,
                  onChanged: readOnly ? null : (v) => changeValue(item.data),
                );
              case ListTileItemType.Checkbox:
                return CheckboxListTile(
                  secondary: item.secondary,
                  subtitle: item.subtitle,
                  controlAffinity: item.controlAffinity,
                  contentPadding: item.padding,
                  dense: item.dense,
                  title: item.title,
                  value: selected,
                  onChanged: readOnly ? null : (v) => changeValue(item.data),
                );
              case ListTileItemType.Switch:
                return SwitchListTile(
                  secondary: item.secondary,
                  subtitle: item.subtitle,
                  controlAffinity: item.controlAffinity,
                  contentPadding: item.padding,
                  dense: item.dense,
                  title: item.title,
                  value: selected,
                  onChanged: readOnly ? null : (v) => changeValue(item.data),
                  activeColor: themeData.primaryColor,
                );
            }
          }

          Widget createCommonItem(
              ListTileItem item, bool selected, bool readOnly) {
            switch (type) {
              case ListTileItemType.Checkbox:
                return Checkbox(
                    activeColor: themeData.primaryColor,
                    value: selected,
                    onChanged: readOnly ? null : (v) => changeValue(item.data));
              case ListTileItemType.Switch:
                return Switch(
                    value: selected,
                    activeColor: themeData.primaryColor,
                    onChanged: readOnly ? null : (v) => changeValue(item.data));
              case ListTileItemType.Radio:
                return Radio<T>(
                    activeColor: themeData.primaryColor,
                    value: item.data,
                    groupValue: state.value.isEmpty ? null : state.value[0],
                    onChanged: readOnly ? null : (v) => changeValue(item.data));
            }
          }

          for (int i = 0; i < items.length; i++) {
            ListTileItem<T> item = items[i];
            bool isReadOnly = readOnly || item.readOnly;
            bool selected = state.value.contains(item.data);
            if (split > 0) {
              double factor = 1 / split;
              if (factor == 1) {
                wrapWidgets.add(createListTileItem(item, selected, isReadOnly));
                continue;
              }
            }

            Widget tileItem = createCommonItem(item, selected, readOnly);

            final Widget title = ThemeUtil.wrapTitle(
                split == 0
                    ? item.title
                    : Flexible(
                        child: item.title,
                      ),
                true,
                !readOnly,
                selected,
                themeData,
                ListTileTheme.of(state.context));

            List<Widget> children;
            switch (item.controlAffinity) {
              case ListTileControlAffinity.leading:
                children = [tileItem, title];
                break;
              default:
                children = [title, tileItem];
                break;
            }

            Row tileItemRow = Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            );

            Widget groupItemWidget = Padding(
              padding: item.padding,
              child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  onTap: isReadOnly
                      ? null
                      : () {
                          changeValue(item.data);
                        },
                  child: tileItemRow),
            );

            bool visible = item.visible;
            if (split <= 0) {
              wrapWidgets.add(Visibility(
                child: groupItemWidget,
                visible: visible,
              ));
              if (visible && i < items.length - 1)
                wrapWidgets.add(SizedBox(
                  width: 8.0,
                ));
            } else {
              double factor = item.ignoreSplit ? 1 : 1 / split;
              wrapWidgets.add(Visibility(
                child: FractionallySizedBox(
                  widthFactor: factor,
                  child: groupItemWidget,
                ),
                visible: visible,
              ));
            }
          }

          bool isAllReadOnly = true;
          bool isAllInvisible = true;
          List<T> controllableItems = [];
          items.forEach((element) {
            bool readOnly = element.readOnly;
            bool visible = element.visible;
            if (!readOnly) {
              isAllReadOnly = false;
            }
            if (visible) {
              isAllInvisible = false;
            }
            if (!readOnly && visible) {
              controllableItems.add(element.data);
            }
          });

          Widget? icon;

          if (items.length > 1 &&
              hasSelectAll &&
              type != ListTileItemType.Radio) {
            bool selectAll = controllableItems.isNotEmpty &&
                controllableItems
                    .every((element) => state.value.contains(element));

            if (!isAllInvisible) {
              IconData iconData =
                  selectAll ? Icons.switch_right : Icons.switch_left;
              void toggleValues() {
                List<T> values = List.of(state.value);
                if (selectAll) {
                  state.didChange(values
                      .where((element) => !controllableItems.contains(element))
                      .toList());
                } else {
                  state.didChange(values
                    ..addAll(controllableItems)
                    ..toSet()
                    ..toList());
                }
              }

              icon = InkWell(
                onTap: readOnly || isAllReadOnly ? null : toggleValues,
                child: IconButton(
                  icon: Icon(
                    iconData,
                  ),
                  onPressed: toggleValues,
                ),
              );
            }
          }

          return DecorationField(
              labelText: labelText,
              readOnly: readOnly || isAllReadOnly,
              errorText: state.errorText,
              child: Wrap(children: wrapWidgets),
              focusNode: state.focusNode,
              icon: icon);
        });
}
