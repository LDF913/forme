import 'package:flutter/material.dart';

import 'form_builder.dart';

class FormTheme extends ChangeNotifier {
  ThemeData _themeData;
  EdgeInsets _padding;
  EdgeInsets _labelPadding;

  Map<String, EdgeInsets> _controlPaddings = {};

  CheckboxGroupTheme _checkboxGroupTheme = CheckboxGroupTheme();
  RadioGroupTheme _radioGroupTheme = RadioGroupTheme();

  get labelPadding => _labelPadding;
  get checkboxGroupTheme => _checkboxGroupTheme;
  get radioGroupTheme => _radioGroupTheme;
  get themeData => _themeData;

  void set(
      {ThemeData themeData,
      EdgeInsets padding,
      EdgeInsets labelPadding,
      CheckboxGroupTheme checkboxGroupTheme,
      RadioGroupTheme radioGroupTheme}) {
    _themeData = themeData ?? this._themeData;
    _padding = padding ?? this._padding;
    _checkboxGroupTheme = checkboxGroupTheme ?? _checkboxGroupTheme;
    _radioGroupTheme = radioGroupTheme ?? _radioGroupTheme;
    notifyListeners();
  }

  EdgeInsets getPadding(String controlKey) {
    return _controlPaddings[controlKey] ?? _padding ?? EdgeInsets.all(5);
  }

  void setPadding(String controlKey, EdgeInsets padding) {
    if (padding == null) {
      _controlPaddings.remove(controlKey);
    } else {
      _controlPaddings[controlKey] = padding;
    }
    notifyListeners();
  }

  static FormTheme of(BuildContext context) {
    return FormController.of(context).theme;
  }

  static TextStyle getErrorStyle(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    InputDecorationTheme inputDecorationTheme = themeData.inputDecorationTheme;
    final Color color = themeData.errorColor;
    return themeData.textTheme.caption
        .copyWith(color: color)
        .merge(inputDecorationTheme.errorStyle);
  }

  static TextStyle getLabelStyle(BuildContext context, bool hasError) {
    ThemeData themeData = Theme.of(context);
    InputDecorationTheme inputDecorationTheme = themeData.inputDecorationTheme;
    TextStyle errorStyle = inputDecorationTheme.errorStyle;
    return themeData.textTheme.subtitle1
        .copyWith(
            color: hasError
                ? (errorStyle == null
                    ? themeData.errorColor
                    : errorStyle.color ?? themeData.errorColor)
                : themeData.hintColor)
        .merge(inputDecorationTheme.labelStyle);
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class CheckboxGroupTheme {
  final double labelSpace;
  final double widgetsSpace;
  final TextStyle labelStyle;
  final EdgeInsets widgetsPadding;
  final EdgeInsets errorTextPadding;

  CheckboxGroupTheme(
      {this.labelSpace,
      this.widgetsSpace,
      this.labelStyle,
      this.widgetsPadding,
      this.errorTextPadding});
}

class RadioGroupTheme extends CheckboxGroupTheme {
  RadioGroupTheme({
    double labelSpace,
    double widgetsSpace,
    TextStyle labelStyle,
    EdgeInsets widgetsPadding,
    EdgeInsets errorTextPadding,
  }) : super(
            errorTextPadding: errorTextPadding,
            labelSpace: labelSpace,
            labelStyle: labelStyle,
            widgetsPadding: widgetsPadding,
            widgetsSpace: widgetsSpace);
}
