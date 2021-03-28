import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'form_util.dart';

class ClearableTextFormField extends FormField<String> {
  final bool obscureText;
  final TextEditingController controller;
  ClearableTextFormField(
    String label,
    String controlKey, {
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
    Icon prefixIcon,
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
                  padding: EdgeInsets.zero,
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
                      contentPadding: EdgeInsets.zero,
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
                inputFormatters: inputFormatters,
              );

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
    widget.controller.addListener(_handleControllerChanged);
    super.initState();
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
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

  void _handleControllerChanged() {
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
          padding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
  final Locale locale;
  final FocusNode focusNode;

  DateTimeFormField(this.label, this.controlKey,
      {Key key,
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
            Widget buildChild() {
              List<Widget> suffixes = [];

              if (!state.readOnly) {
                suffixes.add(_ClearIcon(controller._controller, focusNode, () {
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
                      contentPadding: EdgeInsets.zero,
                      labelText: label,
                      suffixIcon: suffixIcon)
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);

              TextField textField = TextField(
                focusNode: focusNode,
                controller: controller._controller,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                obscureText: false,
                maxLines: 1,
                onTap: () {
                  if (state.suffixPressed) {
                    state.suffixPressed = false;
                    return;
                  }
                  showDatePicker(
                          locale: locale ?? Locale('zh', 'CN'),
                          context: state.context,
                          initialDate: controller.value ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2099))
                      .then((date) {
                    if (date != null) {
                      if (useTime)
                        showTimePicker(
                          context: state.context,
                          initialTime: controller._timeOfDay,
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
                          }
                        });
                      else
                        state.didChange(date);
                    }
                  });
                },
                enabled: true,
                readOnly: true,
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

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  bool readOnly = false;
  bool suffixPressed = false;

  DateTimeFormatter formatter;

  DateTimeFormatter get _formatter => widget.formatter ?? formatter;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  void initState() {
    widget.controller.addListener(_handleControllerChanged);

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
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(DateTime value) {
    super.didChange(value);

    if (widget.controller.value != value) {
      widget.controller.value = value;
      widget.controller._controller.text =
          value == null ? '' : _formatter(value);
    }
  }

  @override
  void reset() {
    widget.controller.value = widget.initialValue;
    widget.controller._controller.text = widget.controller.value == null
        ? ''
        : _formatter(widget.controller.value);
    super.reset();
  }

  void _handleControllerChanged() {
    if (widget.controller.value != value) didChange(widget.controller.value);
  }
}

class DateTimeController<DateTime> extends ValueNotifier {
  TextEditingController _controller = new TextEditingController();

  DateTimeController({DateTime value}) : super(value);

  TimeOfDay get _timeOfDay => value == null
      ? TimeOfDay(hour: 0, minute: 0)
      : TimeOfDay(hour: value.hour, minute: value.minute);
}

typedef DateTimeFormatter = String Function(DateTime dateTime);
