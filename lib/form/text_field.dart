import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'form_builder.dart';

class ClearableTextFormField extends ValueField<String> {
  final bool obscureText;
  ClearableTextFormField(
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
          () => _TextController(value: initialValue),
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
          replace: () => '',
          onChanged: onChanged,
          initialValue: initialValue ?? '',
          validator: validator,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          builder: (baseState, context, readOnly, stateMap, themeData,
              formThemeData) {
            _TextController controller = baseState.controller;
            FocusNode focusNode = baseState.focusNode;
            final _TextFormFieldState state = baseState;
            String labelText = stateMap['labelText'];
            String hintText = stateMap['hintText'];
            TextInputType keyboardType = stateMap['keyboardType'];
            bool autofocus = stateMap['autofocus'];
            int maxLines = stateMap['maxLines'];
            int maxLength = stateMap['maxLength'];
            bool clearable = stateMap['clearable'];
            Widget prefixIcon = stateMap['prefixIcon'];
            List<TextInputFormatter> inputFormatters =
                stateMap['inputFormatters'];
            TextStyle style = stateMap['style'];
            ToolbarOptions toolbarOptions = stateMap['toolbarOptions'];
            List<Widget> suffixIcons = stateMap['suffixIcons'];
            TextInputAction textInputAction = stateMap['textInputAction'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    themeData.inputDecorationTheme;

            List<Widget> suffixes = [];
            if (clearable && !readOnly && controller.value.length > 0) {
              suffixes.add(
                  ClearButton(controller.textEditingController, focusNode, () {
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
              key: key,
              style: style,
              textAlignVertical: TextAlignVertical.center,
              controller: controller.textEditingController,
              focusNode: focusNode,
              textInputAction: textInputAction,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              keyboardType: keyboardType,
              autofocus: autofocus,
              obscureText: state.obscureText,
              toolbarOptions: toolbarOptions,
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              onChanged: (value) => state.didChange(value),
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              enabled: true,
              readOnly: readOnly,
              inputFormatters: inputFormatters,
            );

            return textField;
          },
        );

  @override
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextController extends ValueNotifier<String>
    with TextSelectionManagement {
  final TextEditingController textEditingController;
  _TextController({String value})
      : this.textEditingController = TextEditingController(text: value),
        super(value);

  @override
  String get value => super.value ?? '';

  @override
  void setSelection(int start, int end) {
    TextSelectionManagement.setSelectionWithTextEditingController(
        start, end, textEditingController);
  }

  @override
  void selectAll() {
    setSelection(0, textEditingController.text.length);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

class _TextFormFieldState extends ValueFieldState<String> {
  bool obscureText = false;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;
  _TextController get controller => super.controller;
  TextEditingController get textEditingController =>
      controller.textEditingController;

  bool get selectAllOnFocus => getState('selectAllOnFocus');

  void selectAll() {
    if (focusNode.hasFocus) {
      controller.selectAll();
    }
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  void initController() {
    super.initController();
    if (selectAllOnFocus) {
      focusNode.addListener(selectAll);
    }
  }

  @override
  void dispose() {
    if (selectAllOnFocus) {
      focusNode.removeListener(selectAll);
    }
    super.dispose();
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
  void didChange(String value) {
    super.didChange(value);
    if (textEditingController.text != controller.value) {
      textEditingController.text = controller.value;
    }
  }

  @override
  void reset() {
    super.reset();
    if (textEditingController.text != controller.value) {
      textEditingController.text = controller.value;
    }
  }
}

class _DateTimeController extends ValueNotifier<DateTime> {
  TextEditingController controller = new TextEditingController();

  _DateTimeController({DateTime value}) : super(value);

  TimeOfDay get timeOfDay =>
      value == null ? null : TimeOfDay(hour: value.hour, minute: value.minute);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class DateTimeFormField extends ValueField<DateTime> {
  DateTimeFormField(
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
      int maxLines,
      DateTime initialValue,
      InputDecorationTheme inputDecorationTheme})
      : super(
          () => _DateTimeController(value: initialValue),
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
          key: key,
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            _DateTimeController controller = state.controller;
            FocusNode focusNode = state.focusNode;
            String labelText = stateMap['labelText'];
            String hintText = stateMap['hintText'];
            TextStyle style = stateMap['style'];
            bool useTime = stateMap['useTime'];
            int maxLines = stateMap['maxLines'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
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
                      initialTime: controller.timeOfDay ??
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
              suffixes.add(ClearButton(controller.controller, focusNode, () {
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
              controller: controller.controller,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              obscureText: false,
              maxLines: maxLines,
              onTap: null,
              enabled: true,
              readOnly: true,
              style: style,
            );

            return textField;
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
      (super.controller as _DateTimeController).controller;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  void initController() {
    super.initController();
    textEditingController.text =
        widget.initialValue == null ? '' : _formatter(widget.initialValue);
  }

  @override
  void doChangeValue(DateTime value, {bool trigger = true}) {
    super.doChangeValue(value, trigger: trigger);
    textEditingController.text = value == null ? '' : _formatter(value);
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : _formatter(widget.initialValue);
  }
}

class _NumberController extends ValueNotifier<num>
    with TextSelectionManagement {
  TextEditingController controller = new TextEditingController();
  _NumberController({num value}) : super(value);

  @override
  void setSelection(int start, int end) {
    TextSelectionManagement.setSelectionWithTextEditingController(
        start, end, controller);
  }

  @override
  void selectAll() {
    setSelection(0, controller.text.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class NumberFormField extends ValueField<num> {
  NumberFormField(
      {Key key,
      String labelText,
      String hintText,
      TextStyle style,
      bool readOnly,
      ValueChanged<num> onChanged,
      FormFieldValidator<num> validator,
      AutovalidateMode autovalidateMode,
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
          () => _NumberController(value: initialValue),
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
          builder: (baseState, context, readOnly, stateMap, themeData,
              formThemeData) {
            _NumberController controller = baseState.controller;
            FocusNode focusNode = baseState.focusNode;
            _NumberFieldState state = baseState;
            String labelText = stateMap['labelText'];
            String hintText = stateMap['hintText'];
            bool clearable = stateMap['clearable'];
            Widget prefixIcon = stateMap['prefixIcon'];
            TextStyle style = stateMap['style'];
            List<Widget> suffixIcons = stateMap['suffixIcons'];
            TextInputAction textInputAction = stateMap['textInputAction'];
            int decimal = stateMap['decimal'];
            double max = stateMap['max'];
            double min = stateMap['min'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
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
              suffixes.add(ClearButton(controller.controller, focusNode, () {
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
              controller: controller.controller,
              textInputAction: textInputAction,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              keyboardType: TextInputType.number,
              obscureText: false,
              maxLines: 1,
              onEditingComplete: onEditingComplete,
              onChanged: (value) {
                num parsed = num.tryParse(value);
                if (parsed != null) {
                  state.doChangeValue(parsed, updateText: false);
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

            return textField;
          },
        );

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends ValueFieldState<num> {
  TextEditingController get textEditingController =>
      (super.controller as _NumberController).controller;

  @override
  NumberFormField get widget => super.widget as NumberFormField;

  @override
  num get value => super.value == null
      ? null
      : getState('decimal') == 0
          ? super.value.toInt()
          : super.value.toDouble();

  @override
  void initController() {
    super.initController();
    textEditingController.text =
        widget.initialValue == null ? '' : widget.initialValue.toString();
  }

  @override
  void doChangeValue(num value, {bool trigger = true, bool updateText = true}) {
    super.doChangeValue(value, trigger: trigger);
    String str = super.value == null ? '' : value.toString();
    if (updateText && textEditingController.text != str) {
      textEditingController.text = str;
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
  void didUpdateWidget(ClearButton old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(changeListener);
      widget.controller.addListener(changeListener);
    }
    if (old.focusNode != widget.focusNode) {
      old.focusNode.removeListener(changeListener);
      widget.focusNode.addListener(changeListener);
    }
    visible = widget.focusNode.hasFocus && widget.controller.text != '';
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
