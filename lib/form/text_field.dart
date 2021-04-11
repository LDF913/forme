import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_theme.dart';

class ClearableTextFormField extends FormField<String> {
  final bool obscureText;
  final TextEditingController controller;
  final EdgeInsets padding;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  ClearableTextFormField(String controlKey,
      {String labelText,
      String hintText,
      Key key,
      this.controller,
      FocusNode focusNode,
      TextInputType keyboardType,
      bool autofocus = false,
      this.obscureText = false,
      int maxLines = 1,
      int minLines,
      int maxLength,
      this.onChanged,
      GestureTapCallback onTap,
      ValueChanged<String> onSubmitted,
      FormFieldValidator<String> validator,
      AutovalidateMode autovalidateMode,
      ValueChanged<String> onFieldSubmitted,
      bool clearable,
      bool passwordVisible,
      Widget prefixIcon,
      List<TextInputFormatter> inputFormatters,
      this.padding,
      this.readOnly = false,
      TextStyle style})
      : assert(controlKey != null),
        super(
          key: key,
          validator: validator,
          enabled: true,
          autovalidateMode: (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<String> field) {
            final FormThemeData formThemeData = FormThemeData.of(field.context);
            final ThemeData themeData = Theme.of(field.context);
            final _TextFormFieldState state = field as _TextFormFieldState;

            List<Widget> suffixes = [];

            if (clearable && !readOnly) {
              suffixes.add(_ClearIcon(controller, focusNode, () {
                state.didChange('');
              }));
            }
            if (passwordVisible) {
              suffixes.add(IconButton(
                icon: Icon(state.obscureText
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: readOnly
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
                    labelText: labelText,
                    hintText: hintText)
                .applyDefaults(themeData.inputDecorationTheme);

            TextField textField = TextField(
                style: style,
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
                onChanged: (value) => field.didChange(value),
                onTap: onTap,
                onSubmitted: onSubmitted,
                enabled: true,
                readOnly: readOnly,
                inputFormatters: inputFormatters);

            return Padding(
              child: textField,
              padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  bool obscureText = false;

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
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
    if (widget.controller.text != value) {
      widget.controller.text = value ?? '';
    }
  }

  @override
  void reset() {
    widget.controller.text = '';
    if (widget.onChanged != null) {
      widget.onChanged('');
    }
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

class DateTimeController<DateTime> extends ValueNotifier {
  TextEditingController _controller = new TextEditingController();

  DateTimeController({DateTime value}) : super(value);

  TimeOfDay get _timeOfDay =>
      value == null ? null : TimeOfDay(hour: value.hour, minute: value.minute);
}

class DateTimeFormField extends FormField<DateTime> {
  final DateTimeController controller;
  final DateTimeFormatter formatter;
  final String controlKey;
  final bool useTime;
  final Locale locale;
  final EdgeInsets padding;
  final bool readOnly;
  final int maxLines;
  final ValueChanged<DateTime> onChanged;

  DateTimeFormField(this.controlKey,
      {Key key,
      String labelText,
      String hintText,
      TextStyle style,
      this.controller,
      this.formatter,
      this.locale,
      FocusNode focusNode,
      this.useTime = false,
      FormFieldValidator<DateTime> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      this.readOnly = false,
      this.maxLines = 1,
      this.onChanged})
      : assert(controlKey != null),
        super(
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.always,
          key: key,
          builder: (field) {
            print(controller);
            final FormThemeData formThemeData = FormThemeData.of(field.context);
            final ThemeData themeData = Theme.of(field.context);
            _DateTimeFormFieldState state = field as _DateTimeFormFieldState;
            void pickTime() {
              DateTime value = controller.value ?? DateTime.now();
              showDatePicker(
                      locale: locale ?? Locale('zh', 'CN'),
                      context: state.context,
                      initialDate: value,
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

            List<Widget> suffixes = [];

            if (!readOnly) {
              suffixes.add(_ClearIcon(controller._controller, focusNode, () {
                state.didChange(null);
              }));
            }

            suffixes.add(IconButton(
              constraints: BoxConstraints(),
              onPressed: readOnly ? null : pickTime,
              icon: Icon(Icons.calendar_today),
            ));

            Widget suffixIcon = suffixes.isEmpty
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: suffixes,
                  );

            final InputDecoration effectiveDecoration = InputDecoration(
                    hintText: hintText,
                    suffixIcon: suffixIcon,
                    labelText: labelText)
                .applyDefaults(themeData.inputDecorationTheme);

            TextField textField = TextField(
              textAlignVertical: TextAlignVertical.center,
              focusNode: focusNode,
              controller: controller._controller,
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              obscureText: false,
              maxLines: maxLines,
              onTap: null,
              enabled: true,
              readOnly: true,
              style: style,
            );

            return Padding(
                child: textField,
                padding: padding ?? formThemeData.padding ?? EdgeInsets.zero);
          },
        );

  @override
  _DateTimeFormFieldState createState() => _DateTimeFormFieldState();

  static DateTimeFormatter defaultDateTimeFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  static DateTimeFormatter defaultDateFormatter = (dateTime) =>
      '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}

typedef DateTimeFormatter = String Function(DateTime dateTime);

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  DateTimeFormatter get _formatter => widget.formatter ?? widget.useTime
      ? DateTimeFormField.defaultDateTimeFormatter
      : DateTimeFormField.defaultDateFormatter;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  void initState() {
    widget.controller.addListener(_handleChanged);
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
      if (widget.onChanged != null) {
        widget.onChanged(value);
      }
    }
    widget.controller._controller.text = value == null ? '' : _formatter(value);
  }

  @override
  void reset() {
    widget.controller.value = null;
    widget.controller._controller.text = '';
    if (widget.onChanged != null) {
      widget.onChanged(null);
    }
    super.reset();
  }

  void _handleChanged() {
    if (widget.controller.value != value) didChange(widget.controller.value);
  }
}
