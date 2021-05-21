import 'package:flutter/widgets.dart';

/// form layout used by LayoutForm
class FormLayout {
  MainAxisAlignment mainAxisAlignment;
  MainAxisSize mainAxisSize;
  CrossAxisAlignment crossAxisAlignment;
  TextDirection? textDirection;
  VerticalDirection verticalDirection;
  TextBaseline? textBaseline;
  List<FormRow> rows = [];

  ///used to create & find a global key
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
    rows.add(FormRow(_index, _index.index));
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
    this.textBaseline = textBaseline;
    this.textDirection = textDirection;
  }

  FormRow append() {
    FormRow row = FormRow(_index, _index.index);
    rows.add(row);
    return row;
  }

  FormRow insert(int index) {
    if (index < 0 || index >= rows.length)
      throw 'index out of range,range is 0,${rows.length - 1}';
    FormRow row = FormRow(_index, _index.index);
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
  int _gen;

  int get columnCount => columns.length;

  int get index => _gen;

  FormRow(this._index, this._gen)
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
    this.textBaseline = textBaseline;
    this.textDirection = textDirection;
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
    FormRow row = FormRow(_index, _gen);
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
  Widget widget;
  final int index;
  IndexWidget._(this.widget, this.index);
}

class _Index {
  int gen = 0;
  int get index => gen++;
}
