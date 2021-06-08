import 'dart:ui';

import 'package:flutter/material.dart';
import '../forme_controller.dart';
import '../widget/forme_text_field_widget.dart';
import 'forme_datetime_field.dart';
import '../field/forme_text_field.dart';
import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';

class FormeDateRangeField
    extends ValueField<DateTimeRange, FormeDateRangeFieldModel> {
  FormeDateRangeField({
    FormeFieldValueChanged<DateTimeRange, FormeDateRangeFieldModel>? onChanged,
    FormFieldValidator<DateTimeRange>? validator,
    AutovalidateMode? autovalidateMode,
    DateTimeRange? initialValue,
    FormFieldSetter<DateTimeRange>? onSaved,
    required String name,
    bool visible = true,
    FormeDateRangeFieldModel? model,
    ValidateErrorListener<
            FormeValueFieldController<DateTimeRange, FormeDateRangeFieldModel>>?
        validateErrorListener,
    FocusListener<
            FormeValueFieldController<DateTimeRange, FormeDateRangeFieldModel>>?
        focusListener,
    Key? key,
  }) : super(
          focusListener: focusListener,
          key: key,
          model: model ?? FormeDateRangeFieldModel(),
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validateErrorListener: validateErrorListener,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            TextEditingController textEditingController =
                (state as _FormeDateRangeFieldState).textEditingController;
            DateTime firstDate = state.model.firstDate ?? DateTime(1970);
            DateTime lastDate = state.model.lastDate ?? DateTime(2099);

            void pickRange() {
              showDateRangePicker(
                initialDateRange: state.value,
                context: state.context,
                firstDate: firstDate,
                lastDate: lastDate,
                builder: state.model.builder,
                initialEntryMode: state.model.initialEntryMode ??
                    DatePickerEntryMode.calendar,
                helpText: state.model.helpText,
                cancelText: state.model.cancelText,
                confirmText: state.model.confirmText,
                saveText: state.model.saveText,
                errorFormatText: state.model.errorFormatText,
                errorInvalidText: state.model.errorInvalidText,
                errorInvalidRangeText: state.model.errorInvalidRangeText,
                fieldStartHintText: state.model.fieldStartHintText,
                fieldEndHintText: state.model.fieldEndHintText,
                fieldStartLabelText: state.model.fieldStartLabelText,
                fieldEndLabelText: state.model.fieldEndLabelText,
                routeSettings: state.model.routeSettings,
                textDirection: state.model.textDirection,
              ).then((value) {
                if (value != null) state.didChange(value);
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
                  onTap: readOnly ? () {} : pickRange,
                  readOnly: true,
                )));
          },
        );

  @override
  _FormeDateRangeFieldState createState() => _FormeDateRangeFieldState();

  static final FormeDateRangeFieldFormatter defaultRangeDateFormatter = (range) =>
      '${FormeDateTimeField.defaultDateTimeFormatter(FormeDateTimeFieldType.Date, range.start)} - ${FormeDateTimeField.defaultDateTimeFormatter(FormeDateTimeFieldType.Date, range.end)}';
}

typedef FormeDateRangeFieldFormatter = String Function(DateTimeRange range);

class _FormeDateRangeFieldState
    extends ValueFieldState<DateTimeRange, FormeDateRangeFieldModel> {
  FormeDateRangeFieldFormatter get _formatter =>
      model.formatter ?? FormeDateRangeField.defaultRangeDateFormatter;

  late final TextEditingController textEditingController;

  @override
  FormeDateRangeField get widget => super.widget as FormeDateRangeField;

  @override
  DateTimeRange? beforeSetValue(DateTimeRange? newValue) {
    if (newValue == null) return null;
    return DateTimeRange(
        start: simple(newValue.start), end: simple(newValue.end));
  }

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : _formatter(initialValue!));
  }

  @override
  void afterValueChanged(DateTimeRange? oldValue, DateTimeRange? current) {
    textEditingController.text = value == null ? '' : _formatter(value!);
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
  FormeDateRangeFieldModel beforeSetModel(
      FormeDateRangeFieldModel old, FormeDateRangeFieldModel current) {
    return beforeUpdateModel(old, current);
  }

  @override
  FormeDateRangeFieldModel beforeUpdateModel(
      FormeDateRangeFieldModel old, FormeDateRangeFieldModel current) {
    if (value == null) return current;
    if (current.firstDate != null && current.firstDate!.isAfter(value!.start))
      clearValue();
    if (value != null &&
        current.lastDate != null &&
        current.lastDate!.isBefore(value!.end)) clearValue();
    if (current.formatter != null && value != null)
      textEditingController.text = current.formatter!(value!);
    return current;
  }

  DateTime simple(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}

class FormeDateRangeFieldModel extends FormeModel {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DatePickerEntryMode? initialEntryMode;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final String? saveText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? errorInvalidRangeText;
  final String? fieldStartHintText;
  final String? fieldEndHintText;
  final String? fieldStartLabelText;
  final String? fieldEndLabelText;
  final RouteSettings? routeSettings;
  final TextDirection? textDirection;
  final FormeDateRangeFieldFormatter? formatter;
  final TransitionBuilder? builder;
  final FormeTextFieldModel? textFieldModel;

  FormeDateRangeFieldModel({
    this.firstDate,
    this.lastDate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.routeSettings,
    this.textDirection,
    this.errorFormatText,
    this.errorInvalidText,
    this.initialEntryMode,
    this.saveText,
    this.errorInvalidRangeText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.formatter,
    this.builder,
    this.textFieldModel,
  });
  FormeDateRangeFieldModel copyWith(FormeModel oldModel) {
    FormeDateRangeFieldModel old = oldModel as FormeDateRangeFieldModel;
    return FormeDateRangeFieldModel(
      firstDate: firstDate ?? old.firstDate,
      lastDate: lastDate ?? old.lastDate,
      initialEntryMode: initialEntryMode ?? old.initialEntryMode,
      helpText: helpText ?? old.helpText,
      cancelText: cancelText ?? old.cancelText,
      confirmText: confirmText ?? old.confirmText,
      saveText: saveText ?? old.saveText,
      errorFormatText: errorFormatText ?? old.errorFormatText,
      errorInvalidText: errorInvalidText ?? old.errorInvalidText,
      errorInvalidRangeText: errorInvalidRangeText ?? old.errorInvalidRangeText,
      fieldStartHintText: fieldStartHintText ?? old.fieldStartHintText,
      fieldEndHintText: fieldEndHintText ?? old.fieldEndHintText,
      fieldStartLabelText: fieldStartLabelText ?? old.fieldStartLabelText,
      fieldEndLabelText: fieldEndLabelText ?? old.fieldEndLabelText,
      routeSettings: routeSettings ?? old.routeSettings,
      textDirection: textDirection ?? old.textDirection,
      formatter: formatter ?? old.formatter,
      builder: builder ?? old.builder,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
    );
  }
}
