import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../state_model.dart';
import '../form_field.dart';
import 'decoration_field.dart';

class FilterChipItem<T> {
  final Widget label;
  final Widget? avatar;
  final T data;
  final EdgeInsets? contentPadding;
  final EdgeInsets? labelPadding;
  final EdgeInsets padding;
  final bool readOnly;
  final bool visible;

  FilterChipItem(
      {required this.label,
      this.avatar,
      required this.data,
      EdgeInsets? padding,
      this.readOnly = false,
      this.visible = true,
      this.contentPadding = const EdgeInsets.all(10),
      this.labelPadding})
      : this.padding = padding ?? EdgeInsets.symmetric(horizontal: 10);
}

enum ChipLayoutType { wrap, scroll }

class FilterChipFormField<T> extends BaseNonnullValueField<List<T>> {
  FilterChipFormField({
    required List<FilterChipItem<T>> items,
    List<T>? initialValue,
    AutovalidateMode? autovalidateMode,
    NonnullFieldValidator<List<T>>? validator,
    ValueChanged<List<T>>? onChanged,
    double? pressElevation,
    String? labelText,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    int? count,
    VoidCallback? exceedCallback,
    ChipLayoutType layoutType = ChipLayoutType.wrap,
    ChipThemeData? chipThemeData,
  }) : super(
          {
            'items': StateValue<List<FilterChipItem<T>>>(items),
            'labelText': StateValue<String?>(labelText),
            'pressElevation': StateValue<double?>(pressElevation),
            'count': StateValue<int?>(count),
            'layoutType': StateValue<ChipLayoutType>(layoutType),
            'chipThemeData': StateValue<ChipThemeData?>(chipThemeData),
          },
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? [],
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            List<FilterChipItem<T>> items = stateMap['items'];
            String? labelText = stateMap['labelText'];
            double? pressElevation = stateMap['pressElevation'];
            ChipLayoutType layoutType = stateMap['layoutType'];
            int? count = stateMap['count'];
            ChipThemeData chipThemeData =
                stateMap['chipThemeData'] ?? ChipTheme.of(state.context);

            List<Widget> chips = [];
            for (FilterChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              FilterChip chip = FilterChip(
                selected: state.value.contains(item.data),
                label: item.label,
                avatar: item.avatar,
                padding: item.contentPadding,
                pressElevation: pressElevation,
                onSelected: isReadOnly
                    ? null
                    : (bool selected) {
                        if (selected) {
                          if (count != null && state.value.length >= count) {
                            if (exceedCallback != null) exceedCallback();
                            return;
                          }
                          state.didChange(List.of(state.value)..add(item.data));
                        } else {
                          state.didChange(
                              List.of(state.value)..remove(item.data));
                        }
                        state.requestFocus();
                      },
              );
              chips.add(Visibility(
                  child: Padding(
                    padding: item.padding,
                    child: chip,
                  ),
                  visible: item.visible));
            }

            Widget chipWidget;

            switch (layoutType) {
              case ChipLayoutType.wrap:
                chipWidget = Wrap(
                  children: chips,
                );
                break;
              case ChipLayoutType.scroll:
                chipWidget = SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: chips));
                break;
            }

            return DecorationField(
              child: ChipTheme(
                data: chipThemeData,
                child: chipWidget,
              ),
              focusNode: state.focusNode,
              errorText: state.errorText,
              readOnly: readOnly,
              labelText: labelText,
            );
          },
        );
}
