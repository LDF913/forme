import 'package:flutter/material.dart';

class FieldKey {
  /// row of field
  final int row;

  /// column of field
  final int column;

  /// controlKey of field
  final String? controlKey;

  FieldKey({required this.row, required this.column, this.controlKey});

  @override
  bool operator ==(other) {
    if (other is! FieldKey) return false;
    if (controlKey != null) {
      return controlKey == other.controlKey;
    } else {
      if (other.controlKey != null) return false;
      return row == other.row && column == other.column;
    }
  }

  @override
  int get hashCode => hashValues(controlKey, row, column);
}
