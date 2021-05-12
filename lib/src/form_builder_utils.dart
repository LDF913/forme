import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'field/filter_chip.dart';
import 'field/list_tile.dart';
import 'field/selector.dart';

class FormBuilderUtils {
  FormBuilderUtils._();
  static bool compare(dynamic a, dynamic b) {
    if (a is List && b is List) return listEquals(a, b);
    if (a is Set && b is Set) return setEquals(a, b);
    if (a is Map && b is Map) return mapEquals(a, b);
    return a == b;
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

  static SelectItemProvider toSelectItemProvider<T>(List<T> items) {
    return (page, params) {
      return Future.delayed(Duration.zero, () {
        return SelectItemPage<T>(items, items.length);
      });
    };
  }

  static List<ListTileItem<String>> toListTileItems(
    List<String> items, {
    EdgeInsets? padding,
    TextStyle? style,
    ListTileControlAffinity? controlAffinity,
  }) {
    return items
        .map((e) => ListTileItem<String>(
              title: Text(e, style: style),
              padding: padding,
              data: e,
              controlAffinity: controlAffinity,
            ))
        .toList();
  }
}
