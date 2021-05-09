import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'field/checkbox_group.dart';
import 'field/filter_chip.dart';
import 'field/radio_group.dart';
import 'field/selector.dart';
import 'field/switch_group.dart';

class FormBuilderUtils {
  FormBuilderUtils._();
  static bool compare(dynamic a, dynamic b) {
    if (a is List && b is List) return listEquals(a, b);
    if (a is Set && b is Set) return setEquals(a, b);
    if (a is Map && b is Map) return mapEquals(a, b);
    return a == b;
  }

  static List<CheckboxGroupItem> toCheckboxGroupItems(List<String> items,
      {EdgeInsets? padding}) {
    return items
        .map((e) => CheckboxGroupItem(label: e, padding: padding))
        .toList();
  }

  static List<FilterChipItem<String>> toFilterChipItems(List<String> items,
      {EdgeInsets? padding,
      EdgeInsets? contentPadding,
      EdgeInsets? labelPadding}) {
    return items
        .map((e) => FilterChipItem<String>(
            label: Text(e),
            padding: padding,
            data: e,
            contentPadding: contentPadding,
            labelPadding: labelPadding))
        .toList();
  }

  static List<RadioGroupItem<String>> toRadioGroupItems(List<String> items,
      {EdgeInsets? padding}) {
    return items
        .map((e) => RadioGroupItem(label: e, value: e, padding: padding))
        .toList();
  }

  static SelectItemProvider toSelectItemProvider<T>(List<T> items) {
    return (page, params) {
      return Future.delayed(Duration.zero, () {
        return SelectItemPage<T>(items, items.length);
      });
    };
  }

  static List<SwitchGroupItem> toSwitchGroupItems(List<String> items,
      {EdgeInsets? padding, TextStyle? style}) {
    return items
        .map((e) => SwitchGroupItem(e, padding: padding, textStyle: style))
        .toList();
  }

  static T? firstWhereOrNull<T>(
      Iterable<T> collection, bool Function(T element) test) {
    for (var element in collection) {
      if (test(element)) return element;
    }
  }
}
