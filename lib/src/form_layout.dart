import 'package:flutter/material.dart';

class FormLayout {
  final List<FormRow> rows = [FormRow()];

  FormLayout();

  FormRow append() {
    FormRow row = FormRow();
    rows.add(row);
    return row;
  }

  FormRow insert(int index) {
    if (index < 0 || index >= rows.length)
      throw 'index out of range,range is 0,${rows.length - 1}';
    FormRow row = FormRow();
    rows.insert(index, row);
    return row;
  }

  FormRow lastRow() {
    return rows[rows.length - 1];
  }

  FormRow lastEmptyRow() {
    FormRow last = lastRow();
    if (last.children.isEmpty) return last;
    return append();
  }

  void removeEmptyRow() {
    rows.removeWhere((element) => element.children.isEmpty);
  }

  FormLayout copy() {
    FormLayout formLayout = FormLayout();
    formLayout.rows.addAll(rows.map((e) => e.copy()).toList());
    return formLayout;
  }
}

class FormRow {
  final List<Widget> children = [];

  FormRow();

  void append(Widget child) {
    children.add(child);
  }

  void insert(Widget child, int index) {
    rangeCheck(index);
    if (children.isEmpty) {
      children.add(child);
      return;
    }
    if (index == children.length) {
      children.add(child);
    } else {
      children.insert(index, child);
    }
  }

  FormRow copy() {
    FormRow row = FormRow();
    row.children.addAll(List.of(children));
    return row;
  }

  void rangeCheck(int index) {
    if (children.isEmpty && index != 0)
      throw 'index must be 0 due to current row is empty';
    if (index < 0 || index > children.length - 1)
      throw 'index is out of range ,current range is 0,${children.length - 1}';
  }
}

/// field's position
///
/// one position may contain multi fields
class Position {
  /// row of field
  final int row;

  /// column of field
  final int column;

  Position({required this.row, required this.column});

  @override
  bool operator ==(other) {
    if (other is! Position) return false;
    if (row == other.row && column == other.column) return true;
    return false;
  }

  @override
  int get hashCode => hashValues(row, column);
}
