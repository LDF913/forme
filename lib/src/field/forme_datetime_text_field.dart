import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widget/forme_text_field_widget.dart';
import '../field/forme_text_field.dart';

import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';

enum FormeDateTimeTextFieldType { Date, DateTime }

///used to pick datetime and date
class FormeDateTimeTextField
    extends ValueField<DateTime, FormeDateTimeTextFieldModel> {
  FormeDateTimeTextField({
    ValueChanged<DateTime?>? onChanged,
    FormFieldValidator<DateTime>? validator,
    AutovalidateMode? autovalidateMode,
    DateTime? initialValue,
    FormFieldSetter<DateTime>? onSaved,
    String? name,
    bool readOnly = false,
    FormeDateTimeTextFieldModel? model,
    Key? key,
    SelectableDayPredicate? selectableDayPredicate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    TransitionBuilder? builder,
    AppPrivateCommandCallback? appPrivateCommandCallback,
    InputCounterWidgetBuilder? buildCounter,
  }) : super(
          key: key,
          model: model ?? FormeDateTimeTextFieldModel(),
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
                (state as _FormeDateTimeTextFieldState).textEditingController;
            DateTime firstDate = state.model.firstDate ?? DateTime(1970);
            DateTime lastDate = state.model.lastDate ?? DateTime(2099);
            FormeDateTimeTextFieldType type =
                state.model.type ?? FormeDateTimeTextFieldType.Date;

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
              ).then((date) {
                if (date != null) {
                  if (type == FormeDateTimeTextFieldType.DateTime)
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
              });
            }

            return FormeTextFieldWidget(
              textEditingController: textEditingController,
              focusNode: focusNode,
              readOnly: true,
              errorText: state.errorText,
              data: FormTextFieldWidgetRenderData(
                appPrivateCommandCallback: appPrivateCommandCallback,
                buildCounter: buildCounter,
                onTap: readOnly ? null : pickTime,
                model: state.model.textFieldModel,
              ),
            );
          },
        );

  @override
  _FormeDateTimeTextFieldState createState() => _FormeDateTimeTextFieldState();

  static FormeDateTimeTextFieldFormatter
      defaultFormeDateTimeTextFieldFormatter = (dateTime) =>
          '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  static FormeDateTimeTextFieldFormatter defaultDateFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}

typedef FormeDateTimeTextFieldFormatter = String Function(DateTime dateTime);

class _FormeDateTimeTextFieldState
    extends ValueFieldState<DateTime, FormeDateTimeTextFieldModel> {
  FormeDateTimeTextFieldFormatter get _formatter =>
      _getFormeDateTimeTextFieldFormatter(
          model.type ?? FormeDateTimeTextFieldType.Date);

  late final TextEditingController textEditingController;

  @override
  FormeDateTimeTextField get widget => super.widget as FormeDateTimeTextField;

  FormeDateTimeTextFieldFormatter _getFormeDateTimeTextFieldFormatter(
      FormeDateTimeTextFieldType type) {
    return model.formeDateTimeFormatter ??
        (type == FormeDateTimeTextFieldType.DateTime
            ? FormeDateTimeTextField.defaultFormeDateTimeTextFieldFormatter
            : FormeDateTimeTextField.defaultDateFormatter);
  }

  void focusChange() {
    setState(() {});
  }

  @override
  void afterSetInitialValue() {
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : _formatter(initialValue!));
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
  void beforeUpdateModel(
      FormeDateTimeTextFieldModel old, FormeDateTimeTextFieldModel current) {
    if (value == null) return;
    if ((current.type != old.type && current.type != null) ||
        current.formeDateTimeFormatter != null)
      textEditingController.text =
          _getFormeDateTimeTextFieldFormatter(current.type!)(value!);
    if (current.firstDate != null && current.firstDate!.isAfter(value!))
      clearValue();
    if (current.lastDate != null && current.lastDate!.isBefore(value!))
      clearValue();
  }
}

class FormeDateTimeTextFieldModel extends FormeModel {
  final FormeDateTimeTextFieldType? type;
  final FormeDateTimeTextFieldFormatter? formeDateTimeFormatter;
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
  final String? timeCancelText;
  final String? timeConfirmText;
  final String? timeHelpText;
  final RouteSettings? timeRouteSettings;
  final FormeTextFieldModel? textFieldModel;

  FormeDateTimeTextFieldModel({
    this.type,
    this.formeDateTimeFormatter,
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
    this.textFieldModel,
  });

  @override
  FormeDateTimeTextFieldModel copyWith({
    Optional<FormeDateTimeTextFieldType>? type,
    Optional<FormeDateTimeTextFieldFormatter>? formeDateTimeFormatter,
    Optional<DateTime>? firstDate,
    Optional<DateTime>? lastDate,
    Optional<String>? helpText,
    Optional<String>? cancelText,
    Optional<String>? confirmText,
    Optional<RouteSettings>? routeSettings,
    Optional<TextDirection>? pickerTextDirection,
    Optional<DatePickerMode>? initialDatePickerMode,
    Optional<String>? errorFormatText,
    Optional<String>? errorInvalidText,
    Optional<String>? fieldHintText,
    Optional<String>? fieldLabelText,
    Optional<TimePickerEntryMode>? initialEntryMode,
    Optional<String>? timeCancelText,
    Optional<String>? timeConfirmText,
    Optional<String>? timeHelpText,
    Optional<RouteSettings>? timeRouteSettings,
    Optional<FormeTextFieldModel>? textFieldModel,
  }) {
    return FormeDateTimeTextFieldModel(
      type: Optional.copyWith(type, this.type),
      formeDateTimeFormatter: Optional.copyWith(
          formeDateTimeFormatter, this.formeDateTimeFormatter),
      firstDate: Optional.copyWith(firstDate, this.firstDate),
      lastDate: Optional.copyWith(lastDate, this.lastDate),
      helpText: Optional.copyWith(helpText, this.helpText),
      cancelText: Optional.copyWith(cancelText, this.cancelText),
      confirmText: Optional.copyWith(confirmText, this.confirmText),
      routeSettings: Optional.copyWith(routeSettings, this.routeSettings),
      pickerTextDirection:
          Optional.copyWith(pickerTextDirection, this.pickerTextDirection),
      initialDatePickerMode:
          Optional.copyWith(initialDatePickerMode, this.initialDatePickerMode),
      errorFormatText: Optional.copyWith(errorFormatText, this.errorFormatText),
      errorInvalidText:
          Optional.copyWith(errorInvalidText, this.errorInvalidText),
      fieldHintText: Optional.copyWith(fieldHintText, this.fieldHintText),
      fieldLabelText: Optional.copyWith(fieldLabelText, this.fieldLabelText),
      initialEntryMode:
          Optional.copyWith(initialEntryMode, this.initialEntryMode),
      timeCancelText: Optional.copyWith(timeCancelText, this.timeCancelText),
      timeConfirmText: Optional.copyWith(timeConfirmText, this.timeConfirmText),
      timeHelpText: Optional.copyWith(timeHelpText, this.timeHelpText),
      timeRouteSettings:
          Optional.copyWith(timeRouteSettings, this.timeRouteSettings),
      textFieldModel: Optional.copyWith(textFieldModel, this.textFieldModel),
    );
  }
}
