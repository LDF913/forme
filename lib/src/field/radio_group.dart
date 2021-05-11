import 'package:flutter/material.dart';
import '../form_field.dart';
import '../form_theme.dart';
import '../state_model.dart';
import 'checkbox_group.dart';
import 'decoration_field.dart';

class RadioGroupItem<T> extends CheckboxGroupItem {
  final T value;

  RadioGroupItem(
      {String? label,
      required this.value,
      Widget? secondary,
      Widget? title,
      bool readOnly = false,
      bool visible = true,
      ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
      bool ignoreSplit = false,
      EdgeInsets? padding})
      : super(
            secondary: secondary,
            label: label,
            title: title,
            readOnly: readOnly,
            visible: visible,
            controlAffinity: controlAffinity,
            ignoreSplit: ignoreSplit);
}

class RadioGroupFormField<T> extends BaseValueField<T> {
  RadioGroupFormField({
    required List<RadioGroupItem<T>> items,
    String? labelText,
    ValueChanged<T?>? onChanged,
    FormFieldValidator? validator,
    AutovalidateMode? autovalidateMode,
    int split = 2,
    dynamic initialValue,
    FormFieldSetter<T>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
  }) : super(
          {
            'labelText': StateValue<String?>(labelText),
            'split': StateValue<int>(split),
            'items': StateValue<List<RadioGroupItem<T>>>(items),
          },
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
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.themeData;
            String? labelText = stateMap['labelText'];
            int split = stateMap['split'];
            List<RadioGroupItem<T>> items = stateMap['items'];

            List<Widget> wrapWidgets = [];

            void changeValue(T value) {
              state.didChange(value);
            }

            for (int i = 0; i < items.length; i++) {
              RadioGroupItem<T> item = items[i];
              bool isReadOnly = readOnly || item.readOnly;

              if (split > 0) {
                double factor = 1 / split;
                if (factor == 1) {
                  wrapWidgets.add(RadioListTile<T>(
                    dense: true,
                    contentPadding: item.padding,
                    activeColor: themeData.primaryColor,
                    controlAffinity: item.controlAffinity,
                    secondary: item.secondary,
                    value: item.value,
                    groupValue: state.value,
                    onChanged: isReadOnly
                        ? null
                        : (g) {
                            changeValue(item.value);
                          },
                    title: item.title,
                  ));
                  continue;
                }
              }

              Radio radio = Radio<T>(
                  activeColor: themeData.primaryColor,
                  value: item.value,
                  groupValue: state.value,
                  onChanged: isReadOnly
                      ? null
                      : (v) {
                          changeValue(item.value);
                        });

              final Widget title = ThemeUtil.wrapTitle(
                  split == 0
                      ? item.title
                      : Flexible(
                          child: item.title,
                        ),
                  true,
                  !readOnly,
                  item.value == state.value,
                  themeData,
                  ListTileTheme.of(state.context));

              List<Widget> children;
              switch (item.controlAffinity) {
                case ListTileControlAffinity.leading:
                  children = [radio, title];
                  break;
                default:
                  children = [title, radio];
                  break;
              }

              Row radioRow = Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              );

              Widget groupItemWidget = Padding(
                padding: item.padding,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      onTap: isReadOnly
                          ? null
                          : () {
                              changeValue(item.value);
                            },
                      child: radioRow),
                ),
              );

              if (split <= 0) {
                wrapWidgets.add(
                    Visibility(child: groupItemWidget, visible: item.visible));
                if (item.visible && i < items.length - 1)
                  wrapWidgets.add(SizedBox(
                    width: 8.0,
                  ));
              } else {
                wrapWidgets.add(Visibility(
                  child: FractionallySizedBox(
                    widthFactor: item.ignoreSplit ? 1 : 1 / split,
                    child: groupItemWidget,
                  ),
                  visible: item.visible,
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
          },
        );
}
