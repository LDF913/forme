import 'package:flutter/material.dart';

import '../widget/clear_button.dart';
import '../form_state_model.dart';
import 'base_field.dart';

enum DateTimeType { Date, DateTime }

class DateTimeFormField extends BaseValueField<DateTime, DateTimeFieldModel> {
  DateTimeFormField({
    ValueChanged<DateTime?>? onChanged,
    FormFieldValidator<DateTime>? validator,
    AutovalidateMode? autovalidateMode,
    DateTime? initialValue,
    FormFieldSetter<DateTime>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    WidgetWrapper? wrapper,
    required DateTimeFieldModel model,
    LayoutParam? layoutParam,
  }) : super(
          layoutParam: layoutParam,
          model: model,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            ThemeData themeData = Theme.of(state.context);
            FocusNode focusNode = state.focusNode;
            String? labelText = state.model.labelText;
            String? hintText = state.model.hintText;
            TextStyle? style = state.model.style;
            int maxLines = state.model.maxLines ?? 1;
            InputDecorationTheme inputDecorationTheme =
                state.model.inputDecorationTheme ??
                    themeData.inputDecorationTheme;
            TextEditingController textEditingController =
                (state as _DateTimeFormFieldState).textEditingController;
            DateTime firstDate = state.model.firstDate ?? DateTime(1970);
            DateTime lastDate = state.model.lastDate ?? DateTime(2099);
            DateTimeType type = state.model.type ?? DateTimeType.Date;

            void pickTime() {
              DateTime value = state.value ?? DateTime.now();
              if (value.isBefore(firstDate)) value = firstDate;
              if (value.isAfter(lastDate)) value = lastDate;
              TimeOfDay? timeOfDay = state.value == null
                  ? null
                  : TimeOfDay(hour: value.hour, minute: value.minute);
              showDatePicker(
                      locale: Localizations.localeOf(state.context),
                      context: state.context,
                      initialDate: value,
                      firstDate: firstDate,
                      lastDate: lastDate)
                  .then((date) {
                if (date != null) {
                  if (type == DateTimeType.DateTime)
                    showTimePicker(
                      context: state.context,
                      initialTime: timeOfDay ??
                          TimeOfDay(hour: value.hour, minute: value.minute),
                    ).then((value) {
                      if (value != null) {
                        DateTime dateTime = DateTime(date.year, date.month,
                            date.day, value.hour, value.minute);
                        state.didChange(dateTime);
                      }
                    });
                  else {
                    state.didChange(date);
                  }
                }
              });
            }

            List<Widget> suffixes = [];

            if (!readOnly) {
              suffixes.add(ClearButton(textEditingController, focusNode, () {
                state.didChange(null);
              }));
            }

            suffixes.add(InkWell(
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: readOnly ? null : pickTime,
              ),
            ));

            Widget? suffixIcon = suffixes.isEmpty
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: suffixes,
                  );

            final InputDecoration effectiveDecoration = InputDecoration(
                    hintText: hintText,
                    suffixIcon: suffixIcon,
                    labelText: labelText)
                .applyDefaults(inputDecorationTheme);

            TextField textField = TextField(
              textAlignVertical: TextAlignVertical.center,
              focusNode: focusNode,
              controller: textEditingController,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              obscureText: false,
              maxLines: maxLines,
              onTap: null,
              enabled: true,
              readOnly: true,
              style: style,
            );

            return textField;
          },
        );

  @override
  _DateTimeFormFieldState createState() => _DateTimeFormFieldState();

  static DateTimeFormatter defaultDateTimeFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  static DateTimeFormatter defaultDateFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}

typedef DateTimeFormatter = String Function(DateTime dateTime);

class _DateTimeFormFieldState
    extends BaseValueFieldState<DateTime, DateTimeFieldModel> {
  DateTimeFormatter get _formatter =>
      _getDateTimeFormatter(model.type ?? DateTimeType.Date);

  late final TextEditingController textEditingController;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  DateTimeFormatter _getDateTimeFormatter(DateTimeType type) {
    return model.dateTimeFormatter ??
        (type == DateTimeType.DateTime
            ? DateTimeFormField.defaultDateTimeFormatter
            : DateTimeFormField.defaultDateFormatter);
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
        text: widget.initialValue == null
            ? ''
            : _formatter(widget.initialValue!));
  }

  @override
  void doChangeValue(DateTime? value, {bool trigger = true}) {
    super.doChangeValue(value, trigger: trigger);
    textEditingController.text = value == null ? '' : _formatter(value);
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : _formatter(widget.initialValue!);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void clearValue() {
    setValue(null);
    textEditingController.text = '';
  }

  @override
  void beforeMerge(DateTimeFieldModel old, DateTimeFieldModel current) {
    if (value == null) return;
    if (current.type != old.type && current.type != null)
      textEditingController.text =
          value == null ? '' : _getDateTimeFormatter(current.type!)(value!);
    if (current.firstDate != null && current.firstDate!.isAfter(value!))
      clearValue();
    if (current.lastDate != null && current.lastDate!.isBefore(value!))
      clearValue();
  }
}

class DateTimeFieldModel extends AbstractFieldStateModel {
  final String? labelText;
  final String? hintText;
  final TextStyle? style;
  final DateTimeType? type;
  final DateTimeFormatter? dateTimeFormatter;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final int? maxLines;
  final InputDecorationTheme? inputDecorationTheme;

  DateTimeFieldModel({
    this.labelText,
    this.hintText,
    this.style,
    this.inputDecorationTheme,
    this.type,
    this.dateTimeFormatter,
    this.firstDate,
    this.lastDate,
    this.maxLines,
  });

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    DateTimeFieldModel oldModel = old as DateTimeFieldModel;
    return DateTimeFieldModel(
      labelText: labelText ?? oldModel.labelText,
      hintText: hintText ?? oldModel.hintText,
      style: style ?? oldModel.style,
      inputDecorationTheme:
          inputDecorationTheme ?? oldModel.inputDecorationTheme,
      type: type ?? oldModel.type,
      dateTimeFormatter: dateTimeFormatter ?? oldModel.dateTimeFormatter,
      firstDate: firstDate ?? oldModel.firstDate,
      lastDate: lastDate ?? oldModel.lastDate,
      maxLines: maxLines ?? oldModel.maxLines,
    );
  }
}
