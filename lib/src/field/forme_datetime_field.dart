import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../forme_management.dart';
import '../widget/forme_text_field_widget.dart';
import '../field/forme_text_field.dart';

import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';

enum FormeDateTimeFieldType { Date, DateTime }

///used to pick datetime and date
class FormeDateTimeField extends ValueField<DateTime, FormeDateTimeFieldModel> {
  FormeDateTimeField({
    FormeFieldValueChanged<DateTime, FormeDateTimeFieldModel>? onChanged,
    FormFieldValidator<DateTime>? validator,
    AutovalidateMode? autovalidateMode,
    DateTime? initialValue,
    FormFieldSetter<DateTime>? onSaved,
    String? name,
    bool readOnly = false,
    FormeDateTimeFieldModel? model,
    ValidateErrorListener<
            FormeValueFieldManagement<DateTime, FormeDateTimeFieldModel>>?
        validateErrorListener,
    FocusListener<FormeFieldManagement<FormeDateTimeFieldModel>>? focusListener,
    Key? key,
  }) : super(
          key: key,
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
          model: model ?? FormeDateTimeFieldModel(),
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            TextEditingController textEditingController =
                (state as _FormeDateTimeFieldState).textEditingController;
            DateTime firstDate = state.model.firstDate ?? DateTime(1970);
            DateTime lastDate = state.model.lastDate ?? DateTime(2099);
            FormeDateTimeFieldType type =
                state.model.type ?? FormeDateTimeFieldType.Date;

            void pickTime() {
              DateTime value = state.value ?? DateTime.now();
              if (value.isBefore(firstDate)) value = firstDate;
              if (value.isAfter(lastDate)) value = lastDate;
              TimeOfDay? timeOfDay = state.value == null
                  ? null
                  : TimeOfDay(hour: value.hour, minute: value.minute);

              showDatePicker(
                context: state.context,
                initialDate: value,
                firstDate: firstDate,
                lastDate: lastDate,
                helpText: state.model.helpText,
                cancelText: state.model.cancelText,
                confirmText: state.model.confirmText,
                routeSettings: state.model.routeSettings,
                textDirection: state.model.textFieldModel?.textDirection,
                initialDatePickerMode:
                    state.model.initialDatePickerMode ?? DatePickerMode.day,
                errorFormatText: state.model.errorFormatText,
                errorInvalidText: state.model.errorInvalidText,
                fieldHintText: state.model.fieldHintText,
                fieldLabelText: state.model.fieldLabelText,
                initialEntryMode: state.model.dateInitialEntryMode ??
                    DatePickerEntryMode.calendar,
                selectableDayPredicate: state.model.selectableDayPredicate,
              ).then((date) {
                if (date != null) {
                  if (type == FormeDateTimeFieldType.DateTime)
                    showTimePicker(
                      initialEntryMode: state.model.initialEntryMode ??
                          TimePickerEntryMode.dial,
                      cancelText: state.model.timeCancelText,
                      confirmText: state.model.timeConfirmText,
                      helpText: state.model.timeHelpText,
                      routeSettings: state.model.timeRouteSettings,
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
                state.requestFocus();
              });
            }

            return FormeTextFieldWidget(
                textEditingController: textEditingController,
                focusNode: focusNode,
                errorText: state.errorText,
                model: (state.model.textFieldModel ?? FormeTextFieldModel())
                    .copyWith(FormeTextFieldModel(
                  inputFormatters: [],
                  onTap: readOnly ? null : pickTime,
                  readOnly: true,
                )));
          },
        );

  @override
  _FormeDateTimeFieldState createState() => _FormeDateTimeFieldState();

  static FormeDateTimeFieldFormatter defaultFormeDateTimeFieldFormatter =
      (dateTime) =>
          '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  static FormeDateTimeFieldFormatter defaultDateFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}

typedef FormeDateTimeFieldFormatter = String Function(DateTime dateTime);

class _FormeDateTimeFieldState
    extends ValueFieldState<DateTime, FormeDateTimeFieldModel> {
  FormeDateTimeFieldFormatter get _formatter => _getFormeDateTimeFieldFormatter(
      model.type ?? FormeDateTimeFieldType.Date);

  late final TextEditingController textEditingController;

  @override
  FormeDateTimeField get widget => super.widget as FormeDateTimeField;

  FormeDateTimeFieldFormatter _getFormeDateTimeFieldFormatter(
      FormeDateTimeFieldType type) {
    return model.formatter ??
        (type == FormeDateTimeFieldType.DateTime
            ? FormeDateTimeField.defaultFormeDateTimeFieldFormatter
            : FormeDateTimeField.defaultDateFormatter);
  }

  void focusChange() {
    setState(() {});
  }

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController =
        TextEditingController(text: value == null ? '' : _formatter(value!));
    focusNode.addListener(focusChange);
  }

  @override
  void afterValueChanged(DateTime? oldValue, DateTime? current) {
    textEditingController.text = value == null ? '' : _formatter(value!);
  }

  @override
  void dispose() {
    focusNode.removeListener(focusChange);
    textEditingController.dispose();
    super.dispose();
  }

  void clearValue() {
    setValue(null);
    textEditingController.text = '';
  }

  @override
  FormeDateTimeFieldModel beforeUpdateModel(
      FormeDateTimeFieldModel old, FormeDateTimeFieldModel current) {
    if (value == null) return current;
    if (current.firstDate != null &&
        convert(current.firstDate!).isAfter(value!)) clearValue();
    if (value != null &&
        current.lastDate != null &&
        convert(current.lastDate!).isBefore(value!)) clearValue();
    if (current.formatter != null && value != null)
      textEditingController.text = current.formatter!(value!);
    return current;
  }

  DateTime convert(DateTime time) {
    switch (model.type ?? FormeDateTimeFieldType.Date) {
      case FormeDateTimeFieldType.Date:
        return DateTime(time.year, time.month, time.day);
      case FormeDateTimeFieldType.DateTime:
        return DateTime(
            time.year, time.month, time.day, time.hour, time.minute);
    }
  }
}

class FormeDateTimeFieldModel extends FormeModel {
  final FormeDateTimeFieldType? type;
  final FormeDateTimeFieldFormatter? formatter;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final RouteSettings? routeSettings;
  final TextDirection? pickerTextDirection;
  final DatePickerMode? initialDatePickerMode;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final TimePickerEntryMode? initialEntryMode;
  final DatePickerEntryMode? dateInitialEntryMode;
  final String? timeCancelText;
  final String? timeConfirmText;
  final String? timeHelpText;
  final RouteSettings? timeRouteSettings;
  final SelectableDayPredicate? selectableDayPredicate;
  final TransitionBuilder? builder;
  final FormeTextFieldModel? textFieldModel;

  FormeDateTimeFieldModel({
    this.type,
    this.formatter,
    this.firstDate,
    this.lastDate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.routeSettings,
    this.pickerTextDirection,
    this.initialDatePickerMode,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.initialEntryMode,
    this.timeCancelText,
    this.timeConfirmText,
    this.timeHelpText,
    this.timeRouteSettings,
    this.selectableDayPredicate,
    this.builder,
    this.dateInitialEntryMode,
    this.textFieldModel,
  });

  @override
  FormeDateTimeFieldModel copyWith(FormeModel oldModel) {
    FormeDateTimeFieldModel old = oldModel as FormeDateTimeFieldModel;
    return FormeDateTimeFieldModel(
      type: type ?? old.type,
      formatter: formatter ?? old.formatter,
      firstDate: firstDate ?? old.firstDate,
      lastDate: lastDate ?? old.lastDate,
      helpText: helpText ?? old.helpText,
      cancelText: cancelText ?? old.cancelText,
      confirmText: confirmText ?? old.confirmText,
      routeSettings: routeSettings ?? old.routeSettings,
      pickerTextDirection: pickerTextDirection ?? old.pickerTextDirection,
      initialDatePickerMode: initialDatePickerMode ?? old.initialDatePickerMode,
      errorFormatText: errorFormatText ?? old.errorFormatText,
      errorInvalidText: errorInvalidText ?? old.errorInvalidText,
      fieldHintText: fieldHintText ?? old.fieldHintText,
      fieldLabelText: fieldLabelText ?? old.fieldLabelText,
      initialEntryMode: initialEntryMode ?? old.initialEntryMode,
      dateInitialEntryMode: dateInitialEntryMode ?? old.dateInitialEntryMode,
      timeCancelText: timeCancelText ?? old.timeCancelText,
      timeConfirmText: timeConfirmText ?? old.timeConfirmText,
      timeHelpText: timeHelpText ?? old.timeHelpText,
      timeRouteSettings: timeRouteSettings ?? old.timeRouteSettings,
      selectableDayPredicate:
          selectableDayPredicate ?? old.selectableDayPredicate,
      builder: builder ?? old.builder,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
    );
  }
}
