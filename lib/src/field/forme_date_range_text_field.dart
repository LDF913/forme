import 'dart:ui';

import 'package:flutter/material.dart';
import '../widget/forme_text_field_widget.dart';
import '../field/forme_datetime_text_field.dart';
import '../field/forme_text_field.dart';
import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';

class FormeDateRangeTextField
    extends ValueField<DateTimeRange, FormeDateRangeTextFieldModel> {
  FormeDateRangeTextField({
    ValueChanged<DateTimeRange?>? onChanged,
    FormFieldValidator<DateTimeRange>? validator,
    AutovalidateMode? autovalidateMode,
    DateTimeRange? initialValue,
    FormFieldSetter<DateTimeRange>? onSaved,
    String? name,
    bool visible = true,
    FormeDateRangeTextFieldModel? model,
    Key? key,
    TransitionBuilder? builder,
    AppPrivateCommandCallback? appPrivateCommandCallback,
    InputCounterWidgetBuilder? buildCounter,
  }) : super(
          key: key,
          model: model ?? FormeDateRangeTextFieldModel(),
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
                (state as _FormeDateRangeTextFieldState).textEditingController;
            DateTime firstDate = state.model.firstDate ?? DateTime(1970);
            DateTime lastDate = state.model.lastDate ?? DateTime(2099);

            void pickRange() {
              showDateRangePicker(
                initialDateRange: state.value,
                context: state.context,
                firstDate: firstDate,
                lastDate: lastDate,
                builder: builder,
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
                onTap: readOnly ? null : pickRange,
                model: state.model.textFieldModel,
              ),
            );
          },
        );

  @override
  _FormeDateRangeTextFieldState createState() =>
      _FormeDateRangeTextFieldState();

  static final FormeDateRangeTextFieldFormatter defaultRangeDateFormatter =
      (range) =>
          '${FormeDateTimeTextField.defaultDateFormatter(range.start)} - ${FormeDateTimeTextField.defaultDateFormatter(range.end)}';
}

typedef FormeDateRangeTextFieldFormatter = String Function(DateTimeRange range);

class _FormeDateRangeTextFieldState
    extends ValueFieldState<DateTimeRange, FormeDateRangeTextFieldModel> {
  FormeDateRangeTextFieldFormatter get _formatter =>
      model.dateRangeFormatter ??
      FormeDateRangeTextField.defaultRangeDateFormatter;

  late final TextEditingController textEditingController;

  @override
  FormeDateRangeTextField get widget => super.widget as FormeDateRangeTextField;

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
  void afterValueChanged(DateTimeRange? oldValue, DateTimeRange? current) {
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
      FormeDateRangeTextFieldModel old, FormeDateRangeTextFieldModel current) {
    if (value == null) return;
    if (current.firstDate != null && current.firstDate!.isAfter(value!.start))
      clearValue();
    if (current.lastDate != null && current.lastDate!.isBefore(value!.end))
      clearValue();
    if (current.dateRangeFormatter != null && value != null) _formatter(value!);
  }
}

class FormeDateRangeTextFieldModel extends FormeModel {
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
  final FormeDateRangeTextFieldFormatter? dateRangeFormatter;
  final FormeTextFieldModel? textFieldModel;

  FormeDateRangeTextFieldModel({
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
    this.dateRangeFormatter,
    this.textFieldModel,
  });
  @override
  FormeDateRangeTextFieldModel copyWith({
    Optional<DateTime>? firstDate,
    Optional<DateTime>? lastDate,
    Optional<DatePickerEntryMode>? initialEntryMode,
    Optional<String>? helpText,
    Optional<String>? cancelText,
    Optional<String>? confirmText,
    Optional<String>? saveText,
    Optional<String>? errorFormatText,
    Optional<String>? errorInvalidText,
    Optional<String>? errorInvalidRangeText,
    Optional<String>? fieldStartHintText,
    Optional<String>? fieldEndHintText,
    Optional<String>? fieldStartLabelText,
    Optional<String>? fieldEndLabelText,
    Optional<RouteSettings>? routeSettings,
    Optional<TextDirection>? textDirection,
    Optional<FormeDateRangeTextFieldFormatter>? dateRangeFormatter,
    Optional<FormeTextFieldModel>? textFieldModel,
  }) {
    return FormeDateRangeTextFieldModel(
      firstDate: Optional.copyWith(firstDate, this.firstDate),
      lastDate: Optional.copyWith(lastDate, this.lastDate),
      initialEntryMode:
          Optional.copyWith(initialEntryMode, this.initialEntryMode),
      helpText: Optional.copyWith(helpText, this.helpText),
      cancelText: Optional.copyWith(cancelText, this.cancelText),
      confirmText: Optional.copyWith(confirmText, this.confirmText),
      saveText: Optional.copyWith(saveText, this.saveText),
      errorFormatText: Optional.copyWith(errorFormatText, this.errorFormatText),
      errorInvalidText:
          Optional.copyWith(errorInvalidText, this.errorInvalidText),
      errorInvalidRangeText:
          Optional.copyWith(errorInvalidRangeText, this.errorInvalidRangeText),
      fieldStartHintText:
          Optional.copyWith(fieldStartHintText, this.fieldStartHintText),
      fieldEndHintText:
          Optional.copyWith(fieldEndHintText, this.fieldEndHintText),
      fieldStartLabelText:
          Optional.copyWith(fieldStartLabelText, this.fieldStartLabelText),
      fieldEndLabelText:
          Optional.copyWith(fieldEndLabelText, this.fieldEndLabelText),
      routeSettings: Optional.copyWith(routeSettings, this.routeSettings),
      textDirection: Optional.copyWith(textDirection, this.textDirection),
      dateRangeFormatter:
          Optional.copyWith(dateRangeFormatter, this.dateRangeFormatter),
      textFieldModel: Optional.copyWith(textFieldModel, this.textFieldModel),
    );
  }
}
