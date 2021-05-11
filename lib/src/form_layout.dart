import 'package:flutter/material.dart';

class FormLayout {
  MainAxisAlignment mainAxisAlignment;
  MainAxisSize mainAxisSize;
  CrossAxisAlignment crossAxisAlignment;
  TextDirection? textDirection;
  VerticalDirection verticalDirection;
  TextBaseline? textBaseline;
  List<FormRow> rows = [];
  _Index _index = _Index();

  int get rowCount => rows.length;

  FormLayout({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    this.textDirection,
    VerticalDirection? verticalDirection,
    this.textBaseline,
  })  : this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
        this.mainAxisSize = mainAxisSize ?? MainAxisSize.max,
        this.crossAxisAlignment =
            crossAxisAlignment ?? CrossAxisAlignment.center,
        this.verticalDirection = verticalDirection ?? VerticalDirection.down {
    rows.add(FormRow(_index));
  }

  customize({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start;
    this.mainAxisSize = mainAxisSize ?? MainAxisSize.max;
    this.crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center;
    this.verticalDirection = verticalDirection ?? VerticalDirection.down;
  }

  FormRow append() {
    FormRow row = FormRow(_index);
    rows.add(row);
    return row;
  }

  FormRow insert(int index) {
    if (index < 0 || index >= rows.length)
      throw 'index out of range,range is 0,${rows.length - 1}';
    FormRow row = FormRow(_index);
    rows.insert(index, row);
    return row;
  }

  FormRow lastRow() {
    return rows[rows.length - 1];
  }

  FormRow lastEmptyRow() {
    FormRow? last = lastRow();
    if (last.columnCount > 0) {
      return append();
    }
    return last;
  }

  void removeEmptyRow() {
    rows.removeWhere((element) => element.columnCount == 0);
  }

  FormLayout copy() {
    FormLayout formLayout = FormLayout();
    formLayout.customize(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection);
    formLayout._index = _index;
    formLayout.rows.clear(); //remove first empty row!
    formLayout.rows.addAll(rows.map((e) => e.copy()).toList());
    return formLayout;
  }
}

class FormRow {
  MainAxisAlignment mainAxisAlignment;
  MainAxisSize mainAxisSize;
  CrossAxisAlignment crossAxisAlignment;
  TextDirection? textDirection;
  VerticalDirection verticalDirection;
  TextBaseline? textBaseline;
  List<IndexWidget> columns = [];
  _Index _index;

  int get columnCount => columns.length;

  FormRow(this._index)
      : this.mainAxisAlignment = MainAxisAlignment.start,
        this.mainAxisSize = MainAxisSize.max,
        this.crossAxisAlignment = CrossAxisAlignment.center,
        this.verticalDirection = VerticalDirection.down;

  customize({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  }) {
    this.mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start;
    this.mainAxisSize = mainAxisSize ?? MainAxisSize.max;
    this.crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center;
    this.verticalDirection = verticalDirection ?? VerticalDirection.down;
  }

  void append(Widget child) {
    columns.add(IndexWidget._(child, _index.index));
  }

  void insert(Widget child, int index) {
    rangeCheck(index);
    if (columns.isEmpty) {
      columns.add(IndexWidget._(child, _index.index));
      return;
    }
    if (index == columns.length) {
      columns.add(IndexWidget._(child, _index.index));
    } else {
      columns.insert(index, IndexWidget._(child, _index.index));
    }
  }

  void rangeCheck(int index) {
    if (columns.isEmpty && index != 0)
      throw 'index must be 0 due to current row is empty';
    if (index < 0 || index > columns.length - 1)
      throw 'index is out of range ,current range is 0,${columns.length - 1}';
  }

  FormRow copy() {
    FormRow row = FormRow(_index);
    row.customize(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection);
    row.columns.addAll(List.of(columns));
    return row;
  }
}

class IndexWidget {
  final Widget widget;
  final int index;
  IndexWidget._(this.widget, this.index);
}

class _Index {
  int gen = 0;
  int get index => gen++;
}

/// field's position
///
/// one position may contain multi fields
class Position {
  /// row of field
  final int row;

  /// columns of field
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
