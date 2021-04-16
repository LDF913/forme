import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_builder.dart';
import 'form_theme.dart';

class ClearableTextFormField extends ValueField<String> {
  final bool obscureText;
  final FocusNode focusNode;
  ClearableTextFormField(TextEditingController controller, this.focusNode,
      {String labelText,
      String hintText,
      Key key,
      TextInputType keyboardType,
      bool autofocus = false,
      this.obscureText = false,
      int maxLines = 1,
      int minLines,
      int maxLength,
      ValueChanged<String> onChanged,
      GestureTapCallback onTap,
      FormFieldValidator<String> validator,
      AutovalidateMode autovalidateMode,
      ValueChanged<String> onFieldSubmitted,
      bool clearable,
      bool passwordVisible,
      Widget prefixIcon,
      List<TextInputFormatter> inputFormatters,
      EdgeInsets padding,
      TextStyle style,
      bool readOnly = false,
      String initialValue,
      ToolbarOptions toolbarOptions,
      bool selectAllOnFocus = false,
      List<Widget> suffixIcons,
      VoidCallback onEditingComplete,
      TextInputAction textInputAction,
      InputDecorationTheme inputDecorationTheme})
      : super(
          controller,
          {
            'labelText': labelText,
            'hintText': hintText,
            'keyboardType': keyboardType,
            'autofocus': autofocus,
            'maxLines': maxLines,
            'maxLength': maxLength,
            'clearable': clearable ?? true,
            'prefixIcon': prefixIcon,
            'inputFormatters': inputFormatters,
            'style': style,
            'toolbarOptions': toolbarOptions,
            'selectAllOnFocus': selectAllOnFocus ?? false,
            'suffixIcons': suffixIcons,
            'textInputAction': textInputAction,
            'inputDecorationTheme': inputDecorationTheme,
          },
          key: key,
          onChanged: onChanged,
          initialValue: initialValue ?? '',
          validator: validator,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          padding: padding,
          builder: (field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            String labelText = state.getState('labelText');
            String hintText = state.getState('hintText');
            TextInputType keyboardType = state.getState('keyboardType');
            bool autofocus = state.getState('autofocus');
            int maxLines = state.getState('maxLines');
            int maxLength = state.getState('maxLength');
            bool clearable = state.getState('clearable');
            Widget prefixIcon = state.getState('prefixIcon');
            List<TextInputFormatter> inputFormatters =
                state.getState('inputFormatters');
            TextStyle style = state.getState('style');
            ToolbarOptions toolbarOptions = state.getState('toolbarOptions');
            List<Widget> suffixIcons = state.getState('suffixIcons');
            TextInputAction textInputAction = state.getState('textInputAction');
            bool readOnly = state.readOnly;
            EdgeInsets padding = state.padding;
            InputDecorationTheme inputDecorationTheme =
                state.getState('inputDecorationTheme') ??
                    themeData.inputDecorationTheme;

            List<Widget> suffixes = [];
            if (clearable && !readOnly && controller.text.length > 0) {
              suffixes.add(ClearButton(controller, focusNode, () {
                state.didChange('');
              }));
            }

            if (passwordVisible) {
              suffixes.add(InkWell(
                child: IconButton(
                  icon: Icon(state.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: readOnly
                      ? null
                      : () {
                          state.toggleObsureText();
                        },
                ),
              ));
            }

            if (suffixIcons != null && suffixIcons.isNotEmpty) {
              suffixes.addAll(suffixIcons);
            }

            Widget suffixIcon = suffixes.isEmpty
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min, // added line
                    children: suffixes,
                  );

            final InputDecoration effectiveDecoration = InputDecoration(
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    labelText: labelText,
                    hintText: hintText)
                .applyDefaults(inputDecorationTheme);

            TextField textField = TextField(
              style: style,
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              focusNode: focusNode,
              textInputAction: textInputAction,
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              keyboardType: keyboardType,
              autofocus: autofocus,
              obscureText: state.obscureText,
              toolbarOptions: toolbarOptions,
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              onChanged: (value) => field.didChange(value),
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              enabled: true,
              readOnly: readOnly,
              inputFormatters: inputFormatters,
            );

            return Padding(
              child: textField,
              padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextFormFieldState extends ValueFieldState<String> {
  bool obscureText = false;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;
  TextEditingController get controller => super.controller;
  FocusNode get focusNode => widget.focusNode;

  bool get selectAllOnFocus => getState('selectAllOnFocus');

  void selectAll() {
    if (focusNode.hasFocus) {
      controller.selection =
          TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    }
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
    if (selectAllOnFocus) {
      focusNode.addListener(selectAll);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (selectAllOnFocus) {
      focusNode.removeListener(selectAll);
    }
  }

  @override
  void didUpdateWidget(ClearableTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode.removeListener(selectAll);
    if (selectAllOnFocus) {
      focusNode.addListener(selectAll);
    }
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void doChangeValue(String value, {bool trigger = true}) {
    String replaceValue = value ?? '';
    super.overrideDidChange(replaceValue);
    if (onChanged != null && trigger) {
      onChanged(replaceValue);
    }
    if (controller.text != replaceValue) {
      controller.text = replaceValue ?? '';
    }
  }

  @override
  void reset() {
    super.overrideReset();
    controller.text = widget.initialValue ?? '';
    if (onChanged != null) {
      onChanged(controller.text);
    }
  }
}

class DateTimeController extends ValueNotifier<DateTime> {
  TextEditingController _controller = new TextEditingController();

  DateTimeController({DateTime value}) : super(value);

  TimeOfDay get _timeOfDay =>
      value == null ? null : TimeOfDay(hour: value.hour, minute: value.minute);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class DateTimeFormField extends ValueField<DateTime> {
  DateTimeFormField(DateTimeController controller, FocusNode focusNode,
      {Key key,
      String labelText,
      String hintText,
      TextStyle style,
      bool readOnly,
      DateTimeFormatter formatter,
      Locale locale,
      bool useTime = false,
      ValueChanged<DateTime> onChanged,
      FormFieldValidator<DateTime> validator,
      AutovalidateMode autovalidateMode,
      EdgeInsets padding,
      int maxLines,
      DateTime initialValue,
      InputDecorationTheme inputDecorationTheme})
      : super(
          controller,
          {
            'labelText': labelText,
            'hintText': hintText,
            'style': style,
            'formatter': formatter,
            'useTime': useTime ?? false,
            'maxLines': maxLines ?? 1,
            'inputDecorationTheme': inputDecorationTheme,
          },
          onChanged: onChanged,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          padding: padding,
          key: key,
          builder: (field) {
            _DateTimeFormFieldState state = field as _DateTimeFormFieldState;
            final FormThemeData formThemeData = FormThemeData.of(field.context);
            final ThemeData themeData = Theme.of(field.context);

            String labelText = state.getState('labelText');
            String hintText = state.getState('hintText');
            TextStyle style = state.getState('style');
            bool useTime = state.getState("useTime");
            int maxLines = state.getState("maxLines");
            bool readOnly = state.readOnly;
            EdgeInsets padding = state.padding;
            InputDecorationTheme inputDecorationTheme =
                state.getState('inputDecorationTheme') ??
                    themeData.inputDecorationTheme;

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
              suffixes.add(ClearButton(controller._controller, focusNode, () {
                state.didChange(null);
              }));
            }

            suffixes.add(InkWell(
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: readOnly ? null : pickTime,
              ),
            ));

            Widget suffixIcon = suffixes.isEmpty
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: suffixes,
                  );

            final InputDecoration effectiveDecoration = InputDecoration(
                    hintText: hintText,
                    suffixIcon: suffixIcon,
                    labelText: labelText)
                .applyDefaults(inputDecorationTheme);

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

class _DateTimeFormFieldState extends ValueFieldState<DateTime> {
  DateTimeFormatter get _formatter =>
      getState('formatter') ?? getState('useTime')
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
  void doChangeValue(DateTime value, {bool trigger = true}) {
    super.doChangeValue(value);
    textEditingController.text = value == null ? '' : _formatter(value);
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : _formatter(widget.initialValue);
  }
}

class NumberController extends ValueNotifier<num> with TextSelectionMixin {
  TextEditingController _controller = new TextEditingController();
  NumberController({num value}) : super(value);

  @override
  void setSelection(int start, int end) {
    TextSelectionMixin.setSelectionWithTextEditingController(
        start, end, _controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class NumberFormField extends ValueField<num> {
  NumberFormField(NumberController controller, FocusNode focusNode,
      {Key key,
      String labelText,
      String hintText,
      TextStyle style,
      bool readOnly,
      ValueChanged<num> onChanged,
      FormFieldValidator<num> validator,
      AutovalidateMode autovalidateMode,
      EdgeInsets padding,
      num initialValue,
      int decimal,
      double max,
      double min,
      bool clearable,
      Widget prefixIcon,
      List<Widget> suffixIcons,
      VoidCallback onEditingComplete,
      TextInputAction textInputAction,
      InputDecorationTheme inputDecorationTheme})
      : super(
          controller,
          {
            'labelText': labelText,
            'hintText': hintText,
            'style': style,
            'decimal': decimal ?? 0,
            'max': max,
            'min': min,
            'clearable': clearable ?? true,
            'prefixIcon': prefixIcon,
            'suffixIcons': suffixIcons,
            'textInputAction': textInputAction,
            'inputDecorationTheme': inputDecorationTheme,
          },
          key: key,
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return validator(null);
            }
            String msg;
            if (validator != null) {
              msg = validator(value);
            }
            if (msg != null) {
              return msg;
            }
            if (min != null && min > value) {
              return '必须大于:$min';
            }
            if (max != null && max < value) {
              return '必须小于:$max';
            }
            return null;
          },
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          padding: padding,
          builder: (field) {
            final FormThemeData formThemeData = FormThemeData.of(field.context);
            final ThemeData themeData = Theme.of(field.context);
            _NumberFieldState state = field as _NumberFieldState;

            String labelText = state.getState('labelText');
            String hintText = state.getState('hintText');
            bool clearable = state.getState('clearable');
            Widget prefixIcon = state.getState('prefixIcon');
            TextStyle style = state.getState('style');
            List<Widget> suffixIcons = state.getState('suffixIcons');
            TextInputAction textInputAction = state.getState('textInputAction');
            bool readOnly = state.readOnly;
            EdgeInsets padding = state.padding;
            int decimal = state.getState('decimal');
            double max = state.getState('max');
            double min = state.getState('min');
            InputDecorationTheme inputDecorationTheme =
                state.getState('inputDecorationTheme') ??
                    themeData.inputDecorationTheme;

            String regex = r'[0-9' +
                (decimal > 0 ? '.' : '') +
                (min != null && min > 0 ? '' : '-') +
                ']';
            List<TextInputFormatter> formatters = [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text == '') return newValue;
                if ((min == null || min < 0) && newValue.text == '-')
                  return newValue;
                double parsed = double.tryParse(newValue.text);
                if (parsed == null) {
                  return oldValue;
                }
                if (decimal != null) {
                  int indexOfPoint = newValue.text.indexOf(".");
                  if (indexOfPoint != -1) {
                    int decimalNum = newValue.text.length - (indexOfPoint + 1);
                    if (decimalNum > decimal) {
                      return oldValue;
                    }
                  }
                }

                if (max != null && parsed > max) {
                  return oldValue;
                }
                return newValue;
              }),
              FilteringTextInputFormatter.allow(RegExp(regex))
            ];

            List<Widget> suffixes = [];

            if (clearable && !readOnly) {
              suffixes.add(ClearButton(controller._controller, focusNode, () {
                state.didChange(null);
              }));
            }

            if (suffixIcons != null && suffixIcons.isNotEmpty) {
              suffixes.addAll(suffixIcons);
            }

            Widget suffixIcon = suffixes.isEmpty
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: suffixes,
                  );

            final InputDecoration effectiveDecoration = InputDecoration(
                    hintText: hintText,
                    suffixIcon: suffixIcon,
                    labelText: labelText,
                    prefixIcon: prefixIcon)
                .applyDefaults(inputDecorationTheme);

            TextField textField = TextField(
              textAlignVertical: TextAlignVertical.center,
              focusNode: focusNode,
              controller: controller._controller,
              textInputAction: textInputAction,
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              keyboardType: TextInputType.number,
              obscureText: false,
              maxLines: 1,
              onEditingComplete: onEditingComplete,
              onChanged: (value) {
                num parsed = num.tryParse(value);
                if (parsed != null) {
                  state.didChangeAndNotChangeText(parsed);
                } else {
                  if (value.isEmpty) {
                    state.didChange(null);
                  }
                }
              },
              onTap: null,
              readOnly: readOnly,
              style: style,
              inputFormatters: formatters,
            );

            return Padding(
                child: textField,
                padding: padding ?? formThemeData.padding ?? EdgeInsets.zero);
          },
        );

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends ValueFieldState<num> {
  TextEditingController get textEditingController =>
      (super.controller as NumberController)._controller;

  @override
  NumberFormField get widget => super.widget as NumberFormField;

  @override
  num get value => super.value == null
      ? null
      : getState('decimal') == 0
          ? super.value.toInt()
          : super.value.toDouble();

  @override
  void initState() {
    super.initState();
    textEditingController.text =
        widget.initialValue == null ? '' : widget.initialValue.toString();
  }

  void didChangeAndNotChangeText(num value) {
    super.didChange(value);
  }

  @override
  void doChangeValue(dynamic value, {bool trigger = true}) {
    num toChange;
    if (value is String) {
      toChange = num.tryParse(value);
    } else {
      toChange = value;
    }
    super.doChangeValue(toChange);
    String numberStr = toChange == null ? '' : toChange.toString();
    if (textEditingController.text != numberStr) {
      textEditingController.text = numberStr;
    }
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : widget.initialValue.toString();
  }
}

class ClearButton extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback clear;
  final FocusNode focusNode;

  const ClearButton(this.controller, this.focusNode, this.clear);
  @override
  State<StatefulWidget> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  bool visible = false;

  void changeListener() {
    setState(() {
      visible = widget.focusNode.hasFocus && widget.controller.text != '';
    });
  }

  @override
  void initState() {
    widget.controller.addListener(changeListener);
    visible = widget.controller.text != '' && widget.focusNode.hasFocus;
    widget.focusNode.addListener(changeListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(changeListener);
    widget.controller.removeListener(changeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: InkWell(
          child: IconButton(
            icon: Icon(Icons.clear),
            onPressed: widget.clear,
          ),
        ));
  }
}
