import '../form_builder.dart';

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

  FormRow lastStretchableRow() {
    FormRow lastRow = rows[rows.length - 1];
    if (lastRow.stretchable) {
      return lastRow;
    }
    return append();
  }

  FormRow lastEmptyRow() {
    FormRow lastRow = rows[rows.length - 1];
    if (lastRow.builders.isEmpty) {
      return lastRow;
    }
    return append();
  }

  void removeEmptyRow() {
    rows.removeWhere((element) => element.builders.isEmpty);
  }

  FormLayout copy() {
    FormLayout formLayout = FormLayout();
    formLayout.rows.addAll(rows.map((e) => e.copy()).toList());
    return formLayout;
  }
}

class FormRow {
  bool stretchable = true;
  final List<FormBuilderFieldBuilder> builders = [];

  FormRow();

  void append(FormBuilderFieldBuilder builder) {
    enableInsertable(builder);
    if (!builder.inline) {
      stretchable = false;
    }
    builders.add(builder);
  }

  void insert(FormBuilderFieldBuilder builder, int index) {
    rangeCheck(index);
    if (builders.isEmpty) {
      if (!builder.inline) {
        stretchable = false;
      }
      builders.add(builder);
      return;
    }
    enableInsertable(builder);
    if (index == builders.length) {
      if (!builder.inline) {
        stretchable = false;
      }
      builders.add(builder);
    } else {
      builders.insert(index, builder);
    }
  }

  FormRow copy() {
    FormRow row = FormRow();
    row.builders.addAll(List.of(builders));
    row.stretchable = stretchable;
    return row;
  }

  void enableInsertable(FormBuilderFieldBuilder builder) {
    if (!stretchable) throw 'row is not stretchable,can not insert field';
    if (!builder.inline && builders.isNotEmpty)
      throw 'current field is not support inline mode and one or more field at placed at row,can not insert';
  }

  void rangeCheck(int index) {
    if (builders.isEmpty && index != 0)
      throw 'index must be 0 due to current row is empty';
    if (index < 0 || index > builders.length - 1)
      throw 'index is out of range ,current range is 0,${builders.length - 1}';
  }
}
