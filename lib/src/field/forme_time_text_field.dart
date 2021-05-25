import 'dart:ui';

import 'package:flutter/material.dart';
import '../widget/forme_text_field_widget.dart';
import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';
import 'forme_text_field.dart';

typedef FormeTimeTextFieldFormatter = String Function(TimeOfDay timeOfDay);

/// used to pick time only
class FormeTimeTextField
    extends ValueField<TimeOfDay, FormeTimeTextFieldModel> {
  FormeTimeTextField({
    ValueChanged<TimeOfDay?>? onChanged,
    FormFieldValidator<TimeOfDay>? validator,
    AutovalidateMode? autovalidateMode,
    TimeOfDay? initialValue,
    FormFieldSetter<TimeOfDay>? onSaved,
    String? name,
    bool readOnly = false,
    FormeTimeTextFieldModel? model,
    TransitionBuilder? builder,
    AppPrivateCommandCallback? appPrivateCommandCallback,
    InputCounterWidgetBuilder? buildCounter,
    Key? key,
  }) : super(
          key: key,
          model: model ?? FormeTimeTextFieldModel(),
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
                (state as _FormeTimeTextFieldState).textEditingController;

            void pickTime() {
              showTimePicker(
                context: state.context,
                initialTime: state.value ?? TimeOfDay.now(),
                builder: builder,
                routeSettings: state.model.routeSettings,
                initialEntryMode:
                    state.model.initialEntryMode ?? TimePickerEntryMode.dial,
                cancelText: state.model.cancelText,
                confirmText: state.model.confirmText,
                helpText: state.model.helpText,
              ).then((value) {
                state.didChange(value);
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
  _FormeTimeTextFieldState createState() => _FormeTimeTextFieldState();

  static FormeTimeTextFieldFormatter defaultFormeTimeTextFieldFormatter = (v) =>
      '${v.hour.toString().padLeft(2, '0')}:${v.minute.toString().padLeft(2, '0')}';
}

class _FormeTimeTextFieldState
    extends ValueFieldState<TimeOfDay, FormeTimeTextFieldModel> {
  FormeTimeTextFieldFormatter get _formatter =>
      model.formeTimeFormatter ??
      FormeTimeTextField.defaultFormeTimeTextFieldFormatter;

  late final TextEditingController textEditingController;

  @override
  FormeTimeTextField get widget => super.widget as FormeTimeTextField;

  @override
  void afterSetInitialValue() {
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : _formatter(initialValue!));
  }

  @override
  void afterValueChanged(TimeOfDay? oldValue, TimeOfDay? current) {
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
}

class FormeTimeTextFieldModel extends FormeModel {
  final TextStyle? style;
  final FormeTimeTextFieldFormatter? formeTimeFormatter;
  final TimePickerEntryMode? initialEntryMode;
  final String? cancelText;
  final String? confirmText;
  final String? helpText;
  final RouteSettings? routeSettings;
  final FormeTextFieldModel? textFieldModel;

  FormeTimeTextFieldModel({
    this.style,
    this.formeTimeFormatter,
    this.initialEntryMode,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.routeSettings,
    this.textFieldModel,
  });

  @override
  FormeTimeTextFieldModel copyWith({
    Optional<TextStyle>? style,
    Optional<FormeTimeTextFieldFormatter>? formeTimeFormatter,
    Optional<TimePickerEntryMode>? initialEntryMode,
    Optional<String>? cancelText,
    Optional<String>? confirmText,
    Optional<String>? helpText,
    Optional<RouteSettings>? routeSettings,
    Optional<FormeTextFieldModel>? textFieldModel,
  }) {
    return FormeTimeTextFieldModel(
      style: Optional.copyWith(style, this.style),
      formeTimeFormatter:
          Optional.copyWith(formeTimeFormatter, this.formeTimeFormatter),
      initialEntryMode:
          Optional.copyWith(initialEntryMode, this.initialEntryMode),
      cancelText: Optional.copyWith(cancelText, this.cancelText),
      confirmText: Optional.copyWith(confirmText, this.confirmText),
      helpText: Optional.copyWith(helpText, this.helpText),
      routeSettings: Optional.copyWith(routeSettings, this.routeSettings),
      textFieldModel: Optional.copyWith(textFieldModel, this.textFieldModel),
    );
  }
}
