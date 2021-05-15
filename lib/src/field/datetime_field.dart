import 'package:flutter/material.dart';

import '../widget/clear_button.dart';
import '../form_field.dart';
import '../state_model.dart';

enum DateTimeType { Date, DateTime }

class DateTimeFormField extends BaseValueField<DateTime> {
  DateTimeFormField({
    String? labelText,
    String? hintText,
    TextStyle? style,
    DateTimeFormatter? formatter,
    DateTimeType type = DateTimeType.Date,
    ValueChanged<DateTime?>? onChanged,
    FormFieldValidator<DateTime>? validator,
    AutovalidateMode? autovalidateMode,
    int? maxLines,
    DateTime? initialValue,
    InputDecorationTheme? inputDecorationTheme,
    FormFieldSetter<DateTime>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    DateTime? firstDate,
    DateTime? lastDate,
  }) : super(
          {
            'labelText': StateValue<String?>(labelText),
            'hintText': StateValue<String?>(hintText),
            'maxLines': StateValue<int>(maxLines ?? 1),
            'type': StateValue<DateTimeType>(type),
            'formatter': StateValue<DateTimeFormatter?>(formatter),
            'style': StateValue<TextStyle?>(style),
            'firstDate': StateValue<DateTime>(firstDate ?? DateTime(2000)),
            'lastDate': StateValue<DateTime>(lastDate ?? DateTime(2099)),
            'inputDecorationTheme':
                StateValue<InputDecorationTheme?>(inputDecorationTheme),
          },
          name: name,
          flex: flex,
          visible: visible,
          padding: padding,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = Theme.of(state.context);
            FocusNode focusNode = state.focusNode;
            String? labelText = stateMap['labelText'];
            String? hintText = stateMap['hintText'];
            TextStyle? style = stateMap['style'];
            int maxLines = stateMap['maxLines'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    themeData.inputDecorationTheme;
            TextEditingController textEditingController =
                (state as _DateTimeFormFieldState).textEditingController;
            DateTime firstDate = stateMap['firstDate'];
            DateTime lastDate = stateMap['lastDate'];
            DateTimeType type = stateMap['type'];

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

class _DateTimeFormFieldState extends BaseValueFieldState<DateTime> {
  DateTimeFormatter get _formatter =>
      getState('formatter') ?? getState('type') == DateTimeType.DateTime
          ? DateTimeFormField.defaultDateTimeFormatter
          : DateTimeFormField.defaultDateFormatter;

  late final TextEditingController textEditingController;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

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

  @override
  void afterStateValueChanged(String key, dynamic old, dynamic current) {
    super.afterStateValueChanged(key, old, current);

    void clearValue() {
      setValue(null);
      textEditingController.text = '';
    }

    if (value == null) return;

    if (key == 'type')
      textEditingController.text = value == null ? '' : _formatter(value!);
    if (key == 'firstDate' && current.isAfter(value!)) clearValue();
    if (key == 'lastDate' && current.isBefore(value!)) clearValue();
  }
}
