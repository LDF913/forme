import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';
import '../forme_controller.dart';
import '../widget/forme_text_field_widget.dart';
import '../field/forme_text_field.dart';

import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';
import 'forme_datetime_field.dart';

///used to pick datetime and date
class FormeCupertinoDateField
    extends ValueField<DateTime, FormeCupertinoDateFieldModel> {
  FormeCupertinoDateField({
    FormeFieldValueChanged<DateTime, FormeCupertinoDateFieldModel>? onChanged,
    FormFieldValidator<DateTime>? validator,
    AutovalidateMode? autovalidateMode,
    DateTime? initialValue,
    FormFieldSetter<DateTime>? onSaved,
    required String name,
    bool readOnly = false,
    FormeCupertinoDateFieldModel? model,
    ValidateErrorListener<
            FormeValueFieldController<DateTime, FormeCupertinoDateFieldModel>>?
        validateErrorListener,
    FocusListener<
            FormeValueFieldController<DateTime, FormeCupertinoDateFieldModel>>?
        focusListener,
    Key? key,
  }) : super(
          key: key,
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
          model: (model ?? FormeCupertinoDateFieldModel()).copyWith(
              FormeCupertinoDateFieldModel(type: FormeDateTimeFieldType.Date)),
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
                (state as _FormeCupertinoDateFieldState).textEditingController;

            void pickTime() {
              FormeRenderUtils.showFormeModalBottomSheet(
                  context: state.context,
                  bottomSheetRenderData: state.model.bottomSheetRenderData,
                  builder: (context) {
                    return _PickerWidget(
                      model: state.model,
                      initialDateTime: state.initialDateTime,
                      onChanged: (datetime) {
                        Navigator.of(context).pop();
                        state.didChange(datetime);
                      },
                    );
                  }).whenComplete(() {
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
  _FormeCupertinoDateFieldState createState() =>
      _FormeCupertinoDateFieldState();
}

class _FormeCupertinoDateFieldState
    extends ValueFieldState<DateTime, FormeCupertinoDateFieldModel> {
  late final TextEditingController textEditingController;

  @override
  FormeCupertinoDateField get widget => super.widget as FormeCupertinoDateField;

  FormeDateTimeFormatter get _formatter =>
      model.formatter ?? FormeDateTimeField.defaultDateTimeFormatter;

  DateTime get initialDateTime {
    if (value != null) return value!;
    DateTime now = DateTime.now();
    DateTime date =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    if (model.maximumDate != null && model.maximumDate!.isBefore(date))
      date = model.maximumDate!;
    if (model.minimumDate != null && model.minimumDate!.isAfter(date))
      date = model.minimumDate!;
    if (model.maximumYear != null && date.year > model.maximumYear!)
      date = DateTime(
          model.maximumYear!, date.month, date.day, date.hour, date.minute);
    if (model.minimumYear != null && date.year < model.minimumYear!)
      date = DateTime(
          model.minimumYear!, date.month, date.day, date.hour, date.minute);
    if (model.minuteInterval != null &&
        model.minuteInterval != 1 &&
        date.minute % model.minuteInterval! != 0) {
      date = DateTime(date.year, date.month, date.day, date.hour, 0);
    }
    switch (model.type!) {
      case FormeDateTimeFieldType.Date:
        return DateTime(date.year, date.month, date.day);
      case FormeDateTimeFieldType.DateTime:
        return date;
    }
  }

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(
        text: value == null ? '' : _formatter(model.type!, value!));
  }

  @override
  void afterValueChanged(DateTime? oldValue, DateTime? current) {
    textEditingController.text =
        value == null ? '' : _formatter(model.type!, value!);
  }

  @override
  DateTime? beforeSetValue(DateTime? newValue) {
    if (newValue == null) return null;
    newValue = simple(newValue);
    if (model.minuteInterval != null &&
        model.minuteInterval != 1 &&
        newValue.minute % model.minuteInterval! != 0) {
      newValue = DateTime(
          newValue.year, newValue.month, newValue.day, newValue.hour, 0);
    }
    return newValue;
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
  FormeCupertinoDateFieldModel beforeUpdateModel(
      FormeCupertinoDateFieldModel old, FormeCupertinoDateFieldModel current) {
    if (value == null) return current;
    if (current.maximumDate != null && current.maximumDate!.isBefore(value!))
      clearValue();
    if (value != null &&
        current.minimumDate != null &&
        current.minimumDate!.isAfter(value!)) clearValue();
    if (value != null &&
        current.maximumYear != null &&
        current.maximumYear! < value!.year) clearValue();
    if (value != null &&
        current.minimumYear != null &&
        current.minimumYear! > value!.year) clearValue();
    if (value != null &&
        current.minuteInterval != null &&
        current.minuteInterval != 1 &&
        value!.minute % current.minuteInterval! != 0) {
      setValue(DateTime(value!.year, value!.month, value!.day, value!.hour, 0));
      textEditingController.text =
          (current.formatter ?? FormeDateTimeField.defaultDateTimeFormatter)(
              (current.type ?? old.type!), value!);
    }
    if (value != null &&
        (current.formatter != null ||
            (current.type != null && current.type != old.type))) {
      textEditingController.text =
          (current.formatter ?? FormeDateTimeField.defaultDateTimeFormatter)(
              (current.type ?? old.type!), value!);
    }
    if (value != null &&
        current.type != null &&
        current.type != old.type &&
        current.type == FormeDateTimeFieldType.Date) {
      setValue(DateTime(value!.year, value!.month, value!.day));
      textEditingController.text =
          (current.formatter ?? FormeDateTimeField.defaultDateTimeFormatter)(
              FormeDateTimeFieldType.Date, value!);
    }

    return current;
  }

  @override
  FormeCupertinoDateFieldModel beforeSetModel(
      FormeCupertinoDateFieldModel old, FormeCupertinoDateFieldModel current) {
    if (current.type == null)
      current = current.copyWith(
          FormeCupertinoDateFieldModel(type: FormeDateTimeFieldType.Date));
    return beforeUpdateModel(old, current);
  }

  DateTime simple(DateTime dateTime) {
    switch (model.type!) {
      case FormeDateTimeFieldType.Date:
        return DateTime(dateTime.year, dateTime.month, dateTime.day);
      case FormeDateTimeFieldType.DateTime:
        return DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute);
    }
  }
}

class FormeCupertinoDateFieldModel extends FormeModel {
  final bool? use24hFormat;
  final DateTime? maximumDate;
  final DateTime? minimumDate;
  final int? minimumYear;
  final int? maximumYear;
  final int? minuteInterval;
  final FormeTextFieldModel? textFieldModel;
  final FormeBottomSheetRenderData? bottomSheetRenderData;
  final FormeDateTimeFieldType? type;
  final Color? backgroundColor;
  final double? height;
  final FormeDateTimeFormatter? formatter;
  final Widget? confirmWidget;
  final Widget? backWidget;

  FormeCupertinoDateFieldModel({
    this.use24hFormat,
    this.maximumDate,
    this.minimumDate,
    this.minimumYear,
    this.maximumYear,
    this.minuteInterval,
    this.textFieldModel,
    this.bottomSheetRenderData,
    this.type,
    this.backgroundColor,
    this.height,
    this.formatter,
    this.confirmWidget,
    this.backWidget,
  });

  @override
  FormeCupertinoDateFieldModel copyWith(FormeModel oldModel) {
    FormeCupertinoDateFieldModel old = oldModel as FormeCupertinoDateFieldModel;
    return FormeCupertinoDateFieldModel(
      maximumDate: maximumDate ?? old.maximumDate,
      minimumDate: minimumDate ?? old.minimumDate,
      use24hFormat: use24hFormat ?? old.use24hFormat,
      minimumYear: minimumYear ?? old.minimumYear,
      maximumYear: maximumYear ?? old.maximumYear,
      minuteInterval: minuteInterval ?? old.minuteInterval,
      type: type ?? old.type,
      backgroundColor: backgroundColor ?? old.backgroundColor,
      height: height ?? old.height,
      formatter: formatter ?? old.formatter,
      confirmWidget: confirmWidget ?? old.confirmWidget,
      backWidget: backWidget ?? old.backWidget,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
      bottomSheetRenderData: FormeBottomSheetRenderData.copy(
          old.bottomSheetRenderData, bottomSheetRenderData),
    );
  }
}

class _PickerWidget extends StatefulWidget {
  final DateTime initialDateTime;
  final FormeCupertinoDateFieldModel model;
  final ValueChanged<DateTime> onChanged;

  const _PickerWidget({
    Key? key,
    required this.model,
    required this.initialDateTime,
    required this.onChanged,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PickerState();
}

class _PickerState extends State<_PickerWidget> {
  int index = 0;

  late final DateTime initialDateTime;

  DateTime? selectedDateTime;
  bool timeChanged = false;
  bool dateChanged = false;

  @override
  void initState() {
    super.initState();
    initialDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.model.height ?? MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Row(
            children: [
              if (index == 1)
                MaterialButton(
                  child:
                      widget.model.backWidget ?? const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      index = 0;
                    });
                  },
                ),
              Spacer(),
              MaterialButton(
                child: widget.model.confirmWidget ?? const Icon(Icons.check),
                onPressed: () {
                  if (index == 1 ||
                      widget.model.type == FormeDateTimeFieldType.Date) {
                    DateTime selectedDateTime;
                    if (!dateChanged && !timeChanged)
                      selectedDateTime = initialDateTime;
                    else {
                      if (dateChanged && timeChanged) {
                        selectedDateTime = this.selectedDateTime!;
                      } else {
                        if (dateChanged) {
                          selectedDateTime = DateTime(
                              this.selectedDateTime!.year,
                              this.selectedDateTime!.month,
                              this.selectedDateTime!.day,
                              initialDateTime.hour,
                              initialDateTime.minute);
                        } else
                          selectedDateTime = this.selectedDateTime!;
                      }
                    }

                    widget.onChanged(selectedDateTime);
                    return;
                  }
                  if (widget.model.type == FormeDateTimeFieldType.DateTime)
                    setState(() {
                      index = 1;
                    });
                },
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: index,
              children: [
                buildCupertinoDatePicker(
                    initialDateTime, CupertinoDatePickerMode.date, widget.model,
                    (DateTime newdate) {
                  dateChanged = true;
                  if (selectedDateTime == null)
                    selectedDateTime =
                        DateTime(newdate.year, newdate.month, newdate.day);
                  else
                    selectedDateTime = DateTime(
                        newdate.year,
                        newdate.month,
                        newdate.day,
                        selectedDateTime!.hour,
                        selectedDateTime!.minute);
                }),
                buildCupertinoDatePicker(
                    initialDateTime, CupertinoDatePickerMode.time, widget.model,
                    (DateTime newdate) {
                  timeChanged = true;
                  if (selectedDateTime == null) {
                    selectedDateTime = DateTime(initialDateTime.year,
                        initialDateTime.month, initialDateTime.day);
                  }
                  selectedDateTime = DateTime(
                      selectedDateTime!.year,
                      selectedDateTime!.month,
                      selectedDateTime!.day,
                      newdate.hour,
                      newdate.minute);
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  CupertinoDatePicker buildCupertinoDatePicker(
      DateTime initialDateTime,
      CupertinoDatePickerMode mode,
      FormeCupertinoDateFieldModel model,
      ValueChanged<DateTime> onDateTimeChanged) {
    return CupertinoDatePicker(
      initialDateTime: initialDateTime,
      onDateTimeChanged: onDateTimeChanged,
      use24hFormat: widget.model.use24hFormat ?? true,
      maximumDate: widget.model.maximumDate,
      minimumDate: widget.model.minimumDate,
      minimumYear: widget.model.minimumYear ?? 1,
      maximumYear: widget.model.maximumYear,
      minuteInterval: widget.model.minuteInterval ?? 1,
      mode: mode,
      backgroundColor: widget.model.backgroundColor,
    );
  }
}
