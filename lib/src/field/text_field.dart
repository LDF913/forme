import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../form_theme.dart';
import '../state_model.dart';
import '../text_selection.dart';
import '../form_field.dart';

class ClearableTextFormField extends BaseNonnullValueField<String> {
  final bool obscureText;
  ClearableTextFormField({
    String? labelText,
    String? hintText,
    TextInputType? keyboardType,
    bool autofocus = false,
    this.obscureText = false,
    int? maxLines,
    int? minLines,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    NonnullFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    ValueChanged<String>? onFieldSubmitted,
    bool clearable = true,
    bool passwordVisible = false,
    Widget? prefixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextStyle? style,
    String? initialValue,
    ToolbarOptions? toolbarOptions,
    bool selectAllOnFocus = false,
    List<Widget>? suffixIcons,
    VoidCallback? onEditingComplete,
    TextInputAction? textInputAction,
    InputDecorationTheme? inputDecorationTheme,
    NonnullFormFieldSetter<String>? onSaved,
  }) : super(
          {
            'labelText': StateValue<String?>(labelText),
            'hintText': StateValue<String?>(hintText),
            'keyboardType': StateValue<TextInputType?>(keyboardType),
            'autofocus': StateValue<bool>(autofocus),
            'maxLines': StateValue<int?>(maxLines),
            'maxLength': StateValue<int?>(maxLength),
            'clearable': StateValue<bool>(clearable),
            'prefixIcon': StateValue<Widget?>(prefixIcon),
            'inputFormatters':
                StateValue<List<TextInputFormatter>?>(inputFormatters),
            'style': StateValue<TextStyle?>(style),
            'toolbarOptions': StateValue<ToolbarOptions?>(toolbarOptions),
            'selectAllOnFocus': StateValue<bool>(selectAllOnFocus),
            'suffixIcons': StateValue<List<Widget>?>(suffixIcons),
            'textInputAction': StateValue<TextInputAction?>(textInputAction),
            'inputDecorationTheme':
                StateValue<InputDecorationTheme?>(inputDecorationTheme),
          },
          onChanged: onChanged,
          onSaved: onSaved,
          initialValue: initialValue ?? '',
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (baseState) {
            bool readOnly = baseState.readOnly;
            _TextFormFieldState state = baseState as _TextFormFieldState;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.formThemeData.themeData;
            FocusNode focusNode = baseState.focusNode;
            String? labelText = stateMap['labelText'];
            String? hintText = stateMap['hintText'];
            TextInputType? keyboardType = stateMap['keyboardType'];
            bool autofocus = stateMap['autofocus'];
            int? maxLines = stateMap['maxLines'];
            int? maxLength = stateMap['maxLength'];
            bool clearable = stateMap['clearable'];
            Widget? prefixIcon = stateMap['prefixIcon'];
            List<TextInputFormatter>? inputFormatters =
                stateMap['inputFormatters'];
            TextStyle? style = stateMap['style'];
            ToolbarOptions? toolbarOptions = stateMap['toolbarOptions'];
            List<Widget>? suffixIcons = stateMap['suffixIcons'];
            TextInputAction? textInputAction = stateMap['textInputAction'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    themeData.inputDecorationTheme;

            List<Widget> suffixes = [];
            if (clearable && !readOnly && state.value.length > 0) {
              suffixes
                  .add(ClearButton(state.textEditingController, focusNode, () {
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

            Widget? suffixIcon = suffixes.isEmpty
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
              controller: state.textEditingController,
              focusNode: focusNode,
              textInputAction: textInputAction,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              keyboardType: keyboardType,
              autofocus: autofocus,
              obscureText: state.obscureText,
              toolbarOptions: toolbarOptions,
              maxLines: obscureText ? 1 : maxLines,
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

class _TextFormFieldState extends BaseNonnullValueFieldState<String>
    with TextSelectionManagement {
  bool obscureText = false;

  late final TextEditingController textEditingController;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;

  bool get selectAllOnFocus => getState('selectAllOnFocus');

  void doSelectAll() {
    if (focusNode.hasFocus) {
      selectAll();
    }
  }

  @override
  void doChangeValue(String? value, {bool trigger = true}) {
    super.doChangeValue(value, trigger: trigger);
    if (textEditingController.text != this.value)
      textEditingController.text = this.value;
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
    textEditingController = TextEditingController(text: widget.initialValue);
  }

  @override
  void initFormManagement() {
    super.initFormManagement();
    if (selectAllOnFocus) {
      focusNode.addListener(doSelectAll);
    }
  }

  @override
  void dispose() {
    if (selectAllOnFocus) {
      focusNode.removeListener(doSelectAll);
    }
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ClearableTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode.removeListener(doSelectAll);
    if (selectAllOnFocus) {
      focusNode.addListener(doSelectAll);
    }
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void reset() {
    super.reset();
    if (textEditingController.text != widget.initialValue)
      textEditingController.text = widget.initialValue;
  }

  @override
  void setSelection(int start, int end) {
    TextSelectionManagement.setSelectionWithTextEditingController(
        start, end, textEditingController);
  }

  @override
  void selectAll() {
    setSelection(0, textEditingController.text.length);
  }
}

class DateTimeFormField extends BaseValueField<DateTime> {
  DateTimeFormField(
      {String? labelText,
      String? hintText,
      TextStyle? style,
      DateTimeFormatter? formatter,
      Locale? locale,
      bool useTime = false,
      ValueChanged<DateTime?>? onChanged,
      FormFieldValidator<DateTime>? validator,
      AutovalidateMode? autovalidateMode,
      int? maxLines,
      DateTime? initialValue,
      InputDecorationTheme? inputDecorationTheme,
      FormFieldSetter<DateTime>? onSaved})
      : super(
          {
            'labelText': StateValue<String?>(labelText),
            'hintText': StateValue<String?>(hintText),
            'maxLines': StateValue<int>(maxLines ?? 1),
            'useTime': StateValue<bool>(useTime),
            'formatter': StateValue<DateTimeFormatter?>(formatter),
            'style': StateValue<TextStyle?>(style),
            'inputDecorationTheme':
                StateValue<InputDecorationTheme?>(inputDecorationTheme),
          },
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.formThemeData.themeData;
            FocusNode focusNode = state.focusNode;
            String? labelText = stateMap['labelText'];
            String? hintText = stateMap['hintText'];
            TextStyle? style = stateMap['style'];
            bool useTime = stateMap['useTime'];
            int maxLines = stateMap['maxLines'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    themeData.inputDecorationTheme;
            TextEditingController textEditingController =
                (state as _DateTimeFormFieldState).textEditingController;

            void pickTime() {
              DateTime value = state.value ?? DateTime.now();
              TimeOfDay? timeOfDay = state.value == null
                  ? null
                  : TimeOfDay(hour: value.hour, minute: value.minute);
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
                      initialTime: timeOfDay ??
                          TimeOfDay(hour: value.hour, minute: value.minute),
                      builder: (BuildContext context, Widget? child) {
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
              suffixes.add(ClearButton(textEditingController, focusNode, () {
                state.didChange(null);
              }));
            }

            suffixes.add(InkWell(
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: readOnly ? null : pickTime,
              ),
            ));

            Widget? suffixIcon = suffixes.isEmpty
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
              controller: textEditingController,
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

class _DateTimeFormFieldState extends BaseValueFieldState<DateTime> {
  DateTimeFormatter get _formatter =>
      getState('formatter') ?? getState('useTime')
          ? DateTimeFormField.defaultDateTimeFormatter
          : DateTimeFormField.defaultDateFormatter;

  late final TextEditingController textEditingController;

  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
        text: widget.initialValue == null
            ? ''
            : _formatter(widget.initialValue!));
  }

  @override
  void doChangeValue(DateTime? value, {bool trigger = true}) {
    super.doChangeValue(value, trigger: trigger);
    textEditingController.text = value == null ? '' : _formatter(value);
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : _formatter(widget.initialValue!);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

class NumberFormField extends BaseValueField<num> {
  NumberFormField(
      {bool autofocus = false,
      String? labelText,
      String? hintText,
      TextStyle? style,
      ValueChanged<num?>? onChanged,
      FormFieldValidator<num>? validator,
      AutovalidateMode? autovalidateMode,
      num? initialValue,
      int decimal = 0,
      double? max,
      double? min,
      bool clearable = true,
      Widget? prefixIcon,
      List<Widget>? suffixIcons,
      VoidCallback? onEditingComplete,
      TextInputAction? textInputAction,
      InputDecorationTheme? inputDecorationTheme,
      FormFieldSetter<num>? onSaved})
      : super(
          {
            'labelText': StateValue<String?>(labelText),
            'hintText': StateValue<String?>(hintText),
            'autofocus': StateValue<bool>(autofocus),
            'clearable': StateValue<bool>(clearable),
            'prefixIcon': StateValue<Widget?>(prefixIcon),
            'style': StateValue<TextStyle?>(style),
            'suffixIcons': StateValue<List<Widget>?>(suffixIcons),
            'textInputAction': StateValue<TextInputAction?>(textInputAction),
            'inputDecorationTheme':
                StateValue<InputDecorationTheme?>(inputDecorationTheme),
            'decimal': StateValue<int>(decimal),
            'max': StateValue<double?>(max),
            'min': StateValue<double?>(min),
          },
          onSaved: onSaved,
          onChanged: onChanged,
          validator: (value) {
            if (validator == null) return null;
            if (value == null) {
              return validator(null);
            }
            String? msg = validator(value);
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
          builder: (state) {
            bool readOnly = state.readOnly;
            FormThemeData formThemeData = state.formThemeData;
            Map<String, dynamic> stateMap = state.currentMap;
            FocusNode focusNode = state.focusNode;
            String? labelText = stateMap['labelText'];
            String? hintText = stateMap['hintText'];
            bool clearable = stateMap['clearable'];
            Widget? prefixIcon = stateMap['prefixIcon'];
            TextStyle? style = stateMap['style'];
            List<Widget>? suffixIcons = stateMap['suffixIcons'];
            TextInputAction? textInputAction = stateMap['textInputAction'];
            int decimal = stateMap['decimal'];
            double? max = stateMap['max'];
            double? min = stateMap['min'];
            bool autofocus = stateMap['autofocus'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    formThemeData.themeData.inputDecorationTheme;
            TextEditingController textEditingController =
                (state as _NumberFieldState).textEditingController;

            String regex = r'[0-9' +
                (decimal > 0 ? '.' : '') +
                (min != null && min > 0 ? '' : '-') +
                ']';
            List<TextInputFormatter> formatters = [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text == '') return newValue;
                if ((min == null || min < 0) && newValue.text == '-')
                  return newValue;
                double? parsed = double.tryParse(newValue.text);
                if (parsed == null) {
                  return oldValue;
                }
                int indexOfPoint = newValue.text.indexOf(".");
                if (indexOfPoint != -1) {
                  int decimalNum = newValue.text.length - (indexOfPoint + 1);
                  if (decimalNum > decimal) {
                    return oldValue;
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
              suffixes
                  .add(ClearButton(state.textEditingController, focusNode, () {
                state.didChange(null);
              }));
            }

            if (suffixIcons != null && suffixIcons.isNotEmpty) {
              suffixes.addAll(suffixIcons);
            }

            Widget? suffixIcon = suffixes.isEmpty
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
              controller: textEditingController,
              textInputAction: textInputAction,
              autofocus: autofocus,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              keyboardType: TextInputType.number,
              obscureText: false,
              maxLines: 1,
              onEditingComplete: onEditingComplete,
              onChanged: (value) {
                num? parsed = num.tryParse(value);
                if (parsed != null && parsed != state.value) {
                  state.doChangeValue(parsed, updateText: false);
                } else {
                  if (value.isEmpty && state.value != null) {
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

class _NumberFieldState extends BaseValueFieldState<num>
    with TextSelectionManagement {
  late final TextEditingController textEditingController;
  @override
  NumberFormField get widget => super.widget as NumberFormField;

  @override
  num? get value => super.value == null
      ? null
      : getState('decimal') == 0
          ? super.value!.toInt()
          : super.value!.toDouble();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
        text:
            widget.initialValue == null ? '' : widget.initialValue.toString());
  }

  @override
  void doChangeValue(num? value,
      {bool trigger = true, bool updateText = true}) {
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

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void selectAll() {
    setSelection(0, textEditingController.text.length);
  }

  @override
  void setSelection(int start, int end) {
    TextSelectionManagement.setSelectionWithTextEditingController(
        start, end, textEditingController);
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
            onPressed: () {
              widget.controller.text = '';
              widget.clear();
            },
          ),
        ));
  }
}