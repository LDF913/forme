import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'form_util.dart';

class ClearableTextFormField extends FormField<String> {
  final bool obscureText;
  ClearableTextFormField(
    String label, {
    Key key,
    this.controller,
    String initialValue,
    FocusNode focusNode,
    TextInputType keyboardType,
    bool autofocus = false,
    this.obscureText = false,
    int maxLines = 1,
    int minLines,
    int maxLength,
    ValueChanged<String> onChanged,
    GestureTapCallback onTap,
    ValueChanged<String> onSubmitted,
    FormFieldValidator<String> validator,
    AutovalidateMode autovalidateMode,
    ValueChanged<String> onFieldSubmitted,
    bool clearable,
    String controlKey,
    bool passwordVisible,
    Icon prefixIcon,
    List<TextInputFormatter> inputFormatters,
  }) : super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          validator: validator,
          enabled: true,
          autovalidateMode: (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            Widget buildWidget() {
              List<Widget> suffixes = [];

              if (clearable && !state.readOnly) {
                suffixes.add(_ClearIcon(state._effectiveController, () {
                  state.didChange('');
                }));
              }
              if (passwordVisible) {
                suffixes.add(IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.only(top: 15),
                  icon: Icon(state.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    state.toggleObsureText();
                  },
                ));
              }

              Widget suffixIcon = suffixes.isEmpty
                  ? null
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children: suffixes,
                    );

              final InputDecoration effectiveDecoration = InputDecoration(
                      labelText: label,
                      prefixIcon: prefixIcon,
                      suffixIcon: suffixIcon)
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              void onChangedHandler(String value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              TextField textField = TextField(
                controller: state._effectiveController,
                focusNode: focusNode,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                keyboardType: keyboardType,
                autofocus: autofocus,
                obscureText: state.obscureText,
                maxLines: maxLines,
                minLines: minLines,
                maxLength: maxLength,
                onChanged: onChangedHandler,
                onTap: onTap,
                onSubmitted: onSubmitted,
                enabled: true,
                readOnly: state.readOnly,
                inputFormatters: inputFormatters,
              );

              return Padding(
                child: textField,
                padding: EdgeInsets.all(5),
              );
            }

            return Consumer<FormController>(
                builder: (context, c, child) {
                  bool currentReadOnly = c.isReadOnly(controlKey);
                  if (state.readOnly != currentReadOnly) {
                    state.readOnly = currentReadOnly;
                    return buildWidget();
                  }
                  return child;
                },
                child: buildWidget());
          },
        );

  final TextEditingController controller;

  @override
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  bool obscureText = false;
  bool readOnly = false;

  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;

  @override
  void initState() {
    obscureText = widget.obscureText;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
    super.initState();
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void didUpdateWidget(ClearableTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String value) {
    super.didChange(value);

    if (_effectiveController.text != value)
      _effectiveController.text = value ?? '';
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }
}

class _ClearIcon extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback clear;

  const _ClearIcon(this.controller, this.clear);
  @override
  State<StatefulWidget> createState() => _ClearIconState();
}

class _ClearIconState extends State<_ClearIcon> {
  bool visible = false;

  void changeListener() {
    setState(() {
      visible = widget.controller.text != '';
    });
  }

  @override
  void initState() {
    widget.controller.addListener(changeListener);
    visible = widget.controller.text != '';
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(changeListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(_ClearIcon old) {
    super.didUpdateWidget(old);
    if (widget.controller != old.controller) {
      old.controller.removeListener(changeListener);
      widget.controller.addListener(changeListener);
      visible = widget.controller.text != '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.only(top: 15),
          onPressed: () {
            widget.clear();
          },
          icon: Icon(Icons.clear),
        ));
  }
}

class DateTimeFormField extends FormField<DateTime> {
  final DateTimeController controller;
  final DateTime initialValue;
  final String label;
  final DateTimeFormatter formatter;
  final String controlKey;
  final FormFieldValidator<DateTime> validator;
  final bool useTime;

  DateTimeFormField(this.label,
      {Key key,
      this.controller,
      this.initialValue,
      this.formatter,
      this.controlKey,
      this.validator,
      this.useTime = false,
      AutovalidateMode autovalidateMode})
      : super(
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.always,
          key: key,
          builder: (field) {
            _DateTimeFormFieldState state = field as _DateTimeFormFieldState;
            Widget buildChild() {
              List<Widget> suffixes = [];

              if (!state.readOnly) {
                suffixes.add(_ClearIcon(state.controller, () {
                  state.suffixPressed = true;
                  state.didChange(null);
                }));
              }

              Widget suffixIcon = suffixes.isEmpty
                  ? null
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children: suffixes,
                    );

              final InputDecoration effectiveDecoration = InputDecoration(
                      labelText: label,
                      prefixIcon: Icon(Icons.timer),
                      suffixIcon: suffixIcon)
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);

              TextField textField = TextField(
                controller: state.controller,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                autofocus: false,
                obscureText: false,
                maxLines: 1,
                onTap: () {
                  if (state.suffixPressed) {
                    state.suffixPressed = false;
                    return;
                  }
                  showDatePicker(
                          locale: Locale('zh', 'CN'),
                          context: state.context,
                          initialDate: state._effectiveController.value ??
                              DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2099))
                      .then((date) {
                    if (date != null) {
                      if (useTime)
                        showTimePicker(
                                context: state.context,
                                initialTime: state._controller._timeOfDay)
                            .then((value) {
                          TimeOfDay timeOfDay =
                              value ?? TimeOfDay(hour: 0, minute: 0);
                          DateTime dateTime = DateTime(date.year, date.month,
                              date.day, timeOfDay.hour, timeOfDay.minute);
                          state.didChange(dateTime);
                        });
                      else
                        state.didChange(date);
                    }
                  });
                },
                enabled: true,
                readOnly: true,
              );
              return Padding(
                child: textField,
                padding: EdgeInsets.all(5),
              );
            }

            return Consumer<FormController>(
                builder: (context, c, child) {
                  bool currentReadOnly = c.isReadOnly(controlKey);
                  if (state.readOnly != currentReadOnly) {
                    state.readOnly = currentReadOnly;
                    return buildChild();
                  }
                  return child;
                },
                child: buildChild());
          },
        );

  @override
  _DateTimeFormFieldState createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  TextEditingController controller = TextEditingController();
  DateTimeController _controller;
  bool readOnly = false;
  bool suffixPressed = false;

  DateTimeController get _effectiveController =>
      widget.controller ?? _controller;

  DateTimeFormatter formatter;

  DateTimeFormatter get _formatter => widget.formatter ?? formatter;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  void initState() {
    if (widget.controller == null) {
      _controller = DateTimeController(value: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }

    if (widget.formatter == null) {
      formatter = (dateTime) {
        if (widget.useTime)
          return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}-${dateTime.minute.toString().padLeft(2, '0')}';
        else
          return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      };
    }

    super.initState();
  }

  @override
  void didUpdateWidget(DateTimeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = DateTimeController(value: oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.value);
        controller.text = _formatter(widget.controller.value);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChange(DateTime value) {
    super.didChange(value);

    if (_effectiveController.value != value) {
      _effectiveController.value = value;
      controller.text = value == null ? '' : _formatter(value);
    }
  }

  @override
  void reset() {
    _effectiveController.value = widget.initialValue;
    controller.text = _effectiveController.value == null
        ? ''
        : _formatter(_effectiveController.value);
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.value != value)
      didChange(_effectiveController.value);
  }
}

class DateTimeController<DateTime> extends ValueNotifier {
  DateTimeController({DateTime value}) : super(value);

  TimeOfDay get _timeOfDay => value == null
      ? TimeOfDay(hour: 0, minute: 0)
      : TimeOfDay(hour: value.hour, minute: value.minute);
}

typedef DateTimeFormatter = String Function(DateTime dateTime);
