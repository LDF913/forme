import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_builder.dart';
import 'form_theme.dart';

class ClearableTextFormField extends FormBuilderField<String> {
  final bool obscureText;
  final EdgeInsets padding;
  ClearableTextFormField(String controlKey, TextEditingController controller,
      {String labelText,
      String hintText,
      Key key,
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
      this.padding,
      TextStyle style,
      bool readOnly = false,
      String initialValue})
      : assert(controlKey != null),
        super(
          controlKey,
          controller,
          readOnly,
          onChanged,
          key: key,
          initialValue: initialValue,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);
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

class _TextFormFieldState extends FormBuilderFieldState<String> {
  bool obscureText = false;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;
  TextEditingController get controller => super.controller;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void didChange(String value) {
    super.superDidChange(value);
    if (onChanged != null) {
      onChanged(value);
    }
    if (controller.text != value) {
      controller.text = value ?? '';
    }
  }

  @override
  void reset() {
    super.superReset();
    controller.text = widget.initialValue;
    if (onChanged != null) {
      onChanged('');
    }
  }

  @protected
  void handleChanged() {
    if (controller.text != value) didChange(controller.text);
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

class DateTimeFormField extends FormBuilderField<DateTime> {
  final DateTimeFormatter formatter;
  final bool useTime;
  final Locale locale;
  final EdgeInsets padding;
  final int maxLines;

  DateTimeFormField(String controlKey, DateTimeController controller,
      {Key key,
      String labelText,
      String hintText,
      TextStyle style,
      bool readOnly,
      this.formatter,
      this.locale,
      FocusNode focusNode,
      this.useTime = false,
      ValueChanged<DateTime> onChanged,
      FormFieldValidator<DateTime> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      this.maxLines = 1,
      DateTime initialValue})
      : assert(controlKey != null),
        super(
          controlKey,
          controller,
          readOnly,
          onChanged,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          key: key,
          builder: (field) {
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

class _DateTimeFormFieldState extends FormBuilderFieldState<DateTime> {
  DateTimeFormatter get _formatter => widget.formatter ?? widget.useTime
      ? DateTimeFormField.defaultDateTimeFormatter
      : DateTimeFormField.defaultDateFormatter;

  TextEditingController get textEditingController =>
      (super.controller as DateTimeController)._controller;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  void initState() {
    super.initState();
    textEditingController.text =
        widget.initialValue == null ? '' : _formatter(widget.initialValue);
  }

  @override
  void didChange(DateTime value) {
    super.didChange(value);
    textEditingController.text = value == null ? '' : _formatter(value);
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : _formatter(widget.initialValue);
  }
}
