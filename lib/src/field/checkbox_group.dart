import 'package:flutter/material.dart';
import '../form_field.dart';
import '../form_theme.dart';
import '../state_model.dart';
import 'decoration_field.dart';

class CheckboxGroupItem {
  final Widget title;
  final bool readOnly;
  final bool visible;
  final EdgeInsets padding;

  /// not worked when split != 1
  final Widget? secondary;
  final ListTileControlAffinity controlAffinity;
  final bool ignoreSplit;
  CheckboxGroupItem(
      {String? label,
      this.secondary,
      Widget? title,
      this.readOnly = false,
      this.visible = true,
      this.controlAffinity = ListTileControlAffinity.leading,
      this.ignoreSplit = false,
      EdgeInsets? padding})
      : assert(label != null || title != null),
        this.padding = padding ?? EdgeInsets.zero,
        this.title = title == null ? Text(label!) : title;
}

class CheckboxGroupFormField extends BaseNonnullValueField<List<int>> {
  CheckboxGroupFormField({
    required List<CheckboxGroupItem> items,
    String? labelText,
    ValueChanged<List<int>>? onChanged,
    int split = 2,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    List<int>? initialValue,
    NonnullFormFieldSetter<List<int>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
  }) : super({
          'labelText': StateValue<String?>(labelText),
          'split': StateValue<int>(split),
          'items': StateValue<List<CheckboxGroupItem>>(items),
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
          ThemeData themeData = state.themeData;
          Map<String, dynamic> stateMap = state.currentMap;
          String? labelText = stateMap['labelText'];
          int split = stateMap['split'];
          List<CheckboxGroupItem> items = stateMap['items'];

          List<Widget> wrapWidgets = [];

          void changeValue(int i) {
            List<int> value = List.of(state.value);
            if (value.contains(i))
              value.remove(i);
            else
              value.add(i);
            state.didChange(value);
          }

          for (int i = 0; i < items.length; i++) {
            CheckboxGroupItem item = items[i];
            bool isReadOnly = readOnly || item.readOnly;

            if (split > 0) {
              double factor = 1 / split;
              if (factor == 1) {
                wrapWidgets.add(CheckboxListTile(
                  dense: true,
                  contentPadding: item.padding,
                  controlAffinity: item.controlAffinity,
                  secondary: item.secondary,
                  value: state.value.contains(i),
                  onChanged: isReadOnly
                      ? null
                      : (g) {
                          changeValue(i);
                        },
                  title: item.title,
                ));
                continue;
              }
            }

            bool selected = state.value.contains(i);
            Checkbox checkbox = Checkbox(
                activeColor: themeData.primaryColor,
                value: selected,
                onChanged: isReadOnly
                    ? null
                    : (v) {
                        changeValue(i);
                      });

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
                children = [checkbox, title];
                break;
              default:
                children = [title, checkbox];
                break;
            }

            Row checkBoxRow = Row(
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
                          changeValue(i);
                        },
                  child: checkBoxRow),
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

          return DecorationField(
            child: Wrap(children: wrapWidgets),
            focusNode: state.focusNode,
            errorText: state.errorText,
            readOnly: readOnly,
            labelText: labelText,
          );
        });
}
