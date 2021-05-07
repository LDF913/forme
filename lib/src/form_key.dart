import 'package:flutter/material.dart';

class FieldKey {
  /// row of field
  final int row;

  /// column of field
  final int column;

  /// name of field
  final String? name;

  FieldKey({required this.row, required this.column, this.name});

  static FieldKey of(String name) {
    return FieldKey(row: -1, column: -1, name: name);
  }

  static FieldKey atPosition(int row, int column) {
    return FieldKey(row: row, column: column);
  }

  @override
  bool operator ==(other) {
    if (other is! FieldKey) return false;
    if (name != null) {
      return name == other.name;
    } else {
      if (other.name != null) return false;
      return row == other.row && column == other.column;
    }
  }

  @override
  int get hashCode => hashValues(name, row, column);
}
