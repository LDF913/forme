import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

typedef FormeDurationFormatter = String Function(
    Duration duration, CupertinoTimerPickerMode mode);

/// used to pick time only
class FormeCupertinoTimerField
    extends ValueField<Duration, FormeCupertinoTimerFieldModel> {
  FormeCupertinoTimerField({
    FormeValueChanged<Duration, FormeCupertinoTimerFieldModel>? onValueChanged,
    FormFieldValidator<Duration>? validator,
    AutovalidateMode? autovalidateMode,
    Duration? initialValue,
    FormFieldSetter<Duration>? onSaved,
    required String name,
    bool readOnly = false,
    FormeCupertinoTimerFieldModel? model,
    FormeErrorChanged<
            FormeValueFieldController<Duration, FormeCupertinoTimerFieldModel>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<Duration, FormeCupertinoTimerFieldModel>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<Duration, FormeCupertinoTimerFieldModel>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<Duration>? decoratorBuilder,
    InputDecoration? decoration,
    int? maxLines = 1,
  }) : super(
          onInitialed: onInitialed,
          decoratorBuilder: decoratorBuilder,
          key: key,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          model: (model ?? FormeCupertinoTimerFieldModel()).copyWith(
            FormeCupertinoTimerFieldModel(
              textFieldModel: FormeTextFieldModel(
                maxLines: maxLines,
                decoration: decoration,
              ),
            ),
          ),
          name: name,
          onValueChanged: onValueChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            TextEditingController textEditingController =
                (state as _FormeCupertinoTimerFieldState).textEditingController;

            void pickDuration() {
              state.duration = null;
              FormeRenderUtils.showFormeModalBottomSheet(
                      context: state.context,
                      builder: (context) {
                        return Wrap(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (state.duration == null) {
                                    if (state.value == null) {
                                      state.didChange(Duration.zero);
                                    }
                                  } else {
                                    state.didChange(state.duration);
                                  }
                                  state.duration = null;
                                  Navigator.of(context).pop();
                                },
                                child: (state.model.confirmWidget ??
                                    const Icon(
                                      Icons.check,
                                      size: 24,
                                    )),
                              ),
                            ],
                          ),
                          CupertinoTimerPicker(
                            minuteInterval: state.model.minuteInterval ?? 1,
                            secondInterval: state.model.secondInterval ?? 1,
                            backgroundColor: state.model.backgroundColor,
                            alignment:
                                state.model.alignment ?? Alignment.center,
                            initialTimerDuration: state.value ?? Duration.zero,
                            mode: state.mode,
                            onTimerDurationChanged: (Duration changedtimer) {
                              state.duration = changedtimer;
                            },
                          ),
                        ]);
                      },
                      bottomSheetRenderData: state.model.bottomSheetRenderData)
                  .whenComplete(() => state.requestFocus());
            }

            return FormeTextFieldWidget(
                textEditingController: textEditingController,
                focusNode: focusNode,
                errorText: state.errorText,
                model: FormeTextFieldModel(
                  inputFormatters: [],
                  onTap: readOnly ? () {} : pickDuration,
                  readOnly: true,
                ).copyWith(
                    state.model.textFieldModel ?? FormeTextFieldModel()));
          },
        );

  @override
  _FormeCupertinoTimerFieldState createState() =>
      _FormeCupertinoTimerFieldState();

  static FormeDurationFormatter defaultDurationFormatter = (v, mode) {
    switch (mode) {
      case CupertinoTimerPickerMode.hm:
        return '${v.inHours.toString().padLeft(2, '0')}:${v.inMinutes.remainder(60).toString().padLeft(2, '0')}';
      case CupertinoTimerPickerMode.ms:
        return '${v.inMinutes.remainder(60).toString().padLeft(2, '0')}:${v.inSeconds.remainder(60).toString().padLeft(2, '0')}';
      case CupertinoTimerPickerMode.hms:
        return '${v.inHours.toString().padLeft(2, '0')}:${v.inMinutes.remainder(60).toString().padLeft(2, '0')}:${v.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }
  };
}

class _FormeCupertinoTimerFieldState
    extends ValueFieldState<Duration, FormeCupertinoTimerFieldModel> {
  FormeDurationFormatter get _formatter =>
      model.formatter ?? FormeCupertinoTimerField.defaultDurationFormatter;

  late final TextEditingController textEditingController;

  Duration? duration;

  CupertinoTimerPickerMode get mode =>
      model.mode ?? CupertinoTimerPickerMode.hm;

  @override
  FormeCupertinoTimerField get widget =>
      super.widget as FormeCupertinoTimerField;

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(
        text: initialValue == null ? '' : _formatter(initialValue!, mode));
  }

  @override
  void onValueChanged(Duration? value) {
    textEditingController.text = value == null ? '' : _formatter(value, mode);
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
  FormeCupertinoTimerFieldModel beforeUpdateModel(
      FormeCupertinoTimerFieldModel old,
      FormeCupertinoTimerFieldModel current) {
    if (value == null) return current;
    if (current.minuteInterval != null &&
        value!.inMinutes % current.minuteInterval! != 0) {
      clearValue();
    }
    if (value != null &&
        current.secondInterval != null &&
        value!.inSeconds % current.secondInterval! != 0) {
      clearValue();
    }
    if (value != null && current.formatter != null ||
        (current.mode != null && current.mode != old.mode)) {
      textEditingController.text = value == null
          ? ''
          : (current.formatter ?? _formatter)(value!, current.mode ?? mode);
    }
    return current;
  }

  @override
  FormeCupertinoTimerFieldModel beforeSetModel(
      FormeCupertinoTimerFieldModel old,
      FormeCupertinoTimerFieldModel current) {
    return beforeUpdateModel(old, current);
  }
}

class FormeCupertinoTimerFieldModel extends FormeModel {
  final FormeDurationFormatter? formatter;
  final FormeTextFieldModel? textFieldModel;

  /// **it's a child of [MaterialButton]**
  final Widget? confirmWidget;

  final CupertinoTimerPickerMode? mode;
  final int? minuteInterval;
  final int? secondInterval;
  final Alignment? alignment;
  final Color? backgroundColor;
  final FormeBottomSheetRenderData? bottomSheetRenderData;

  FormeCupertinoTimerFieldModel({
    this.formatter,
    this.textFieldModel,
    this.confirmWidget,
    this.mode,
    this.minuteInterval,
    this.secondInterval,
    this.alignment,
    this.backgroundColor,
    this.bottomSheetRenderData,
  });
  @override
  FormeCupertinoTimerFieldModel copyWith(FormeModel oldModel) {
    FormeCupertinoTimerFieldModel old =
        oldModel as FormeCupertinoTimerFieldModel;
    return FormeCupertinoTimerFieldModel(
      formatter: formatter ?? old.formatter,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
      confirmWidget: confirmWidget ?? old.confirmWidget,
      mode: mode ?? old.mode,
      minuteInterval: minuteInterval ?? old.minuteInterval,
      secondInterval: secondInterval ?? old.secondInterval,
      alignment: alignment ?? old.alignment,
      backgroundColor: backgroundColor ?? old.backgroundColor,
      bottomSheetRenderData: FormeBottomSheetRenderData.copy(
          old.bottomSheetRenderData, bottomSheetRenderData),
    );
  }
}
