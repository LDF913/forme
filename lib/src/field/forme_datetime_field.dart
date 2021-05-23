import 'package:flutter/material.dart';

import '../forme_core.dart';
import '../widget/forme_clear_button.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';

enum FormeDateTimeType { Date, DateTime }

class FormeDateTime extends ValueField<DateTime, FormeDateTimeModel> {
  FormeDateTime({
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
    FormeDateTimeModel? model,
    Key? key,
  }) : super(
          key: key,
          model: model ?? FormeDateTimeModel(),
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
                (state as _FormeDateTimeState).textEditingController;
            DateTime firstDate = state.model.firstDate ?? DateTime(1970);
            DateTime lastDate = state.model.lastDate ?? DateTime(2099);
            FormeDateTimeType type = state.model.type ?? FormeDateTimeType.Date;

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
                  if (type == FormeDateTimeType.DateTime)
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
              suffixes
                  .add(FormeClearButton(textEditingController, focusNode, () {
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
  _FormeDateTimeState createState() => _FormeDateTimeState();

  static FormeDateTimeFormatter defaultFormeDateTimeFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  static FormeDateTimeFormatter defaultDateFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}

typedef FormeDateTimeFormatter = String Function(DateTime dateTime);

class _FormeDateTimeState
    extends ValueFieldState<DateTime, FormeDateTimeModel> {
  FormeDateTimeFormatter get _formatter =>
      _getFormeDateTimeFormatter(model.type ?? FormeDateTimeType.Date);

  late final TextEditingController textEditingController;

  @override
  FormeDateTime get widget => super.widget as FormeDateTime;

  FormeDateTimeFormatter _getFormeDateTimeFormatter(FormeDateTimeType type) {
    return model.formeDateTimeFormatter ??
        (type == FormeDateTimeType.DateTime
            ? FormeDateTime.defaultFormeDateTimeFormatter
            : FormeDateTime.defaultDateFormatter);
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
  void beforeMerge(FormeDateTimeModel old, FormeDateTimeModel current) {
    if (value == null) return;
    if (current.type != old.type && current.type != null)
      textEditingController.text = value == null
          ? ''
          : _getFormeDateTimeFormatter(current.type!)(value!);
    if (current.firstDate != null && current.firstDate!.isAfter(value!))
      clearValue();
    if (current.lastDate != null && current.lastDate!.isBefore(value!))
      clearValue();
  }
}

class FormeDateTimeModel extends AbstractFormeModel {
  final String? labelText;
  final String? hintText;
  final TextStyle? style;
  final FormeDateTimeType? type;
  final FormeDateTimeFormatter? formeDateTimeFormatter;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final int? maxLines;
  final InputDecorationTheme? inputDecorationTheme;

  FormeDateTimeModel({
    this.labelText,
    this.hintText,
    this.style,
    this.inputDecorationTheme,
    this.type,
    this.formeDateTimeFormatter,
    this.firstDate,
    this.lastDate,
    this.maxLines,
  });

  @override
  FormeDateTimeModel merge(AbstractFormeModel old) {
    FormeDateTimeModel oldModel = old as FormeDateTimeModel;
    return FormeDateTimeModel(
      labelText: labelText ?? oldModel.labelText,
      hintText: hintText ?? oldModel.hintText,
      style: style ?? oldModel.style,
      inputDecorationTheme:
          inputDecorationTheme ?? oldModel.inputDecorationTheme,
      type: type ?? oldModel.type,
      formeDateTimeFormatter:
          formeDateTimeFormatter ?? oldModel.formeDateTimeFormatter,
      firstDate: firstDate ?? oldModel.firstDate,
      lastDate: lastDate ?? oldModel.lastDate,
      maxLines: maxLines ?? oldModel.maxLines,
    );
  }
}
