import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'form_builder.dart';

class ClearableTextFormField extends FormField<String> {
  final bool obscureText;
  final TextEditingController controller;
  ClearableTextFormField(
    String controlKey, {
    String label,
    String hintLabel,
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
    bool passwordVisible,
    Widget prefixIcon,
    List<TextInputFormatter> inputFormatters,
  })  : assert(controlKey != null),
        super(
          key: key,
          initialValue: initialValue ?? '',
          validator: validator,
          enabled: true,
          autovalidateMode: (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            Widget buildWidget() {
              List<Widget> suffixes = [];

              if (clearable && !state.readOnly) {
                suffixes.add(_ClearIcon(controller, focusNode, () {
                  state.didChange('');
                }));
              }
              if (passwordVisible) {
                suffixes.add(IconButton(
                  icon: Icon(state.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: state.readOnly
                      ? null
                      : () {
                          state.toggleObsureText();
                        },
                ));
              }

              Widget suffixIcon = suffixes.isEmpty
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min, // added line
                      children: suffixes,
                    );

              final InputDecoration effectiveDecoration = InputDecoration(
                      prefixIcon: prefixIcon,
                      suffixIcon: suffixIcon,
                      labelText: label,
                      hintText: hintLabel)
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              void onChangedHandler(String value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              TextField textField = TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: controller,
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
                  inputFormatters: inputFormatters);

              return textField;
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

  @override
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  bool obscureText = false;
  bool readOnly = false;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;

  @override
  void initState() {
    obscureText = widget.obscureText;
    widget.controller.addListener(_handleChanged);
    super.initState();
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChanged);
    super.dispose();
  }

  @override
  void didChange(String value) {
    super.didChange(value);
    if (widget.controller.text != value) widget.controller.text = value ?? '';
  }

  @override
  void reset() {
    widget.controller.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleChanged() {
    if (widget.controller.text != value) didChange(widget.controller.text);
  }
}

class _ClearIcon extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback clear;
  final FocusNode focusNode;

  const _ClearIcon(this.controller, this.focusNode, this.clear);
  @override
  State<StatefulWidget> createState() => _ClearIconState();
}

class _ClearIconState extends State<_ClearIcon> {
  bool visible = false;

  void changeListener() {
    setState(() {
      visible = widget.focusNode.hasFocus && widget.controller.text != '';
    });
  }

  @override
  void initState() {
    widget.controller.addListener(changeListener);
    visible = widget.controller.text != '';
    if (widget.focusNode != null) {
      widget.focusNode.addListener(changeListener);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.focusNode != null) {
      widget.focusNode.removeListener(changeListener);
    }
    widget.controller.removeListener(changeListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(_ClearIcon old) {
    super.didUpdateWidget(old);
    if (widget.controller != old.controller) {
      visible = widget.controller.text != '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: IconButton(
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
  final String hintLabel;
  final DateTimeFormatter formatter;
  final String controlKey;
  final FormFieldValidator<DateTime> validator;
  final bool useTime;
  final Locale locale;
  final FocusNode focusNode;

  DateTimeFormField(this.controlKey,
      {Key key,
      this.label,
      this.hintLabel,
      this.controller,
      this.initialValue,
      this.formatter,
      this.validator,
      this.locale,
      this.focusNode,
      this.useTime = false,
      AutovalidateMode autovalidateMode})
      : assert(controlKey != null),
        super(
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.always,
          key: key,
          builder: (field) {
            _DateTimeFormFieldState state = field as _DateTimeFormFieldState;

            void pickTime() {
              DateTime value = initialValue ?? DateTime.now();
              showDatePicker(
                      locale: locale ?? Locale('zh', 'CN'),
                      context: state.context,
                      initialDate: controller.value ?? value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2099))
                  .then((date) {
                if (date != null) {
                  if (useTime)
                    showTimePicker(
                      context: state.context,
                      initialTime: controller._timeOfDay ??
                          TimeOfDay(hour: value.hour, minute: value.minute),
                      builder: (BuildContext context, Widget child) {
                        return Localizations.override(
                          context: context,
                          locale: locale ?? Locale('zh', 'CN'),
                          child: child,
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        DateTime dateTime = DateTime(date.year, date.month,
                            date.day, value.hour, value.minute);
                        state.didChange(dateTime);
                        focusNode.requestFocus();
                      }
                    });
                  else {
                    state.didChange(date);
                    focusNode.requestFocus();
                  }
                }
              });
            }

            Widget buildChild() {
              List<Widget> suffixes = [];

              if (!state.readOnly) {
                suffixes.add(_ClearIcon(controller._controller, focusNode, () {
                  state.didChange(null);
                }));
              }

              suffixes.add(IconButton(
                constraints: BoxConstraints(),
                onPressed: state.readOnly ? null : pickTime,
                icon: Icon(Icons.calendar_today),
              ));

              Widget suffixIcon = suffixes.isEmpty
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: suffixes,
                    );

              final InputDecoration effectiveDecoration = InputDecoration(
                      hintText: hintLabel,
                      suffixIcon: suffixIcon,
                      labelText: label)
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);

              TextField textField = TextField(
                textAlignVertical: TextAlignVertical.center,
                focusNode: focusNode,
                controller: controller._controller,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                obscureText: false,
                maxLines: 1,
                onTap: null,
                enabled: true,
                readOnly: true,
                style: TextStyle(fontSize: 12),
              );
              return textField;
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

typedef DateTimeFormatter = String Function(DateTime dateTime);

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  bool readOnly = false;

  DateTimeFormatter formatter;

  DateTimeFormatter get _formatter => widget.formatter ?? formatter;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  void initState() {
    widget.controller.addListener(_handleChanged);

    if (widget.formatter == null) {
      formatter = (dateTime) {
        if (widget.useTime)
          return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        else
          return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      };
    }

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChanged);
    super.dispose();
  }

  @override
  void didChange(DateTime value) {
    super.didChange(value);
    if (widget.controller.value != value) {
      widget.controller.value = value;
    }
    widget.controller._controller.text = value == null ? '' : _formatter(value);
  }

  @override
  void reset() {
    widget.controller.value = widget.initialValue;
    widget.controller._controller.text = widget.controller.value == null
        ? ''
        : _formatter(widget.controller.value);
    super.reset();
  }

  void _handleChanged() {
    if (widget.controller.value != value) didChange(widget.controller.value);
  }
}

class DateTimeController<DateTime> extends ValueNotifier {
  TextEditingController _controller = new TextEditingController();

  DateTimeController({DateTime value}) : super(value);

  TimeOfDay get _timeOfDay =>
      value == null ? null : TimeOfDay(hour: value.hour, minute: value.minute);
}
