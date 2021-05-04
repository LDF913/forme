import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'builder.dart';
import 'form_theme.dart';

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

class FilterChipFormField<T> extends NonnullValueField<List<T>> {
  FilterChipFormField(
      {required List<FilterChipItem<T>> items,
      List<T>? initialValue,
      AutovalidateMode? autovalidateMode,
      NonnullFieldValidator<List<T>>? validator,
      ValueChanged<List<T>>? onChanged,
      double? pressElevation,
      String? label,
      EdgeInsets? errorTextPadding})
      : super(
          {
            'items': TypedValue<List<FilterChipItem<T>>>(items),
            'label': TypedValue<String?>(label),
            'errorTextPadding': TypedValue<EdgeInsets>(errorTextPadding ??
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
            'pressElevation': TypedValue<double?>(pressElevation)
          },
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? [],
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            List<FilterChipItem<T>> items = stateMap['items'];
            String? label = stateMap['label'];
            EdgeInsets errorTextPadding = stateMap['errorTextPadding'];
            double? pressElevation = stateMap['pressElevation'];

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

            List<Widget> chips = [];
            for (FilterChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              FilterChip chip = FilterChip(
                selected: state.value.contains(item.data),
                label: item.label,
                avatar: item.avatar,
                padding: item.contentPadding,
                pressElevation: pressElevation,
                disabledColor: themeData.primaryColor.withOpacity(0.5),
                backgroundColor: themeData.primaryColor.withOpacity(0.5),
                selectedColor: themeData.primaryColor,
                onSelected: isReadOnly
                    ? null
                    : (bool selected) {
                        if (selected)
                          state.didChange(state.value..add(item.data));
                        else
                          state.didChange(state.value..remove(item.data));
                      },
              );
              chips.add(Visibility(
                  child: Padding(
                    padding: item.padding,
                    child: chip,
                  ),
                  visible: item.visible));
            }

            widgets.add(Wrap(
              children: chips,
            ));

            if (state.hasError) {
              Text text = Text(state.errorText!,
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
          },
        );
}
