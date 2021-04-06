import 'package:flutter/material.dart';

import 'form_builder.dart';

class FormTheme extends ControlTheme {
  ThemeData _themeData;
  Map<String, ControlTheme> _controlThemes = {};

  get themeData => _themeData;

  set themeData(ThemeData themeData) {
    if (_themeData != themeData) {
      _themeData = themeData;
      notifyListeners();
    }
  }

  EdgeInsets getPadding(String controlKey) {
    return _getControlTheme(controlKey).padding ?? padding;
  }

  set padding(EdgeInsets padding) {
    super.padding = padding ?? EdgeInsets.zero;
    notifyListeners();
  }

  double getCheckboxLabeSpace(String controlKey) {
    return _getControlTheme(controlKey).checkboxLabelSpace ??
        checkboxLabelSpace;
  }

  double getCheckboxSpace(String controlKey) {
    return _getControlTheme(controlKey).checkboxSpace ?? checkboxSpace;
  }

  set checkboxLabelSpace(double space) {
    super.checkboxLabelSpace = space ?? 0;
    notifyListeners();
  }

  set checkboxSpace(double space) {
    super.checkboxSpace = space ?? 0;
    notifyListeners();
  }

  TextStyle getCheckboxLabelStyle(String controlKey) {
    return _getControlTheme(controlKey).checkboxLabelStyle ??
        checkboxLabelStyle;
  }

  set checkboxLabelStyle(TextStyle style) {
    super.checkboxLabelStyle = style;
    notifyListeners();
  }

  void setControlTheme(String controlKey, ControlTheme theme) {
    if (theme == null) {
      _controlThemes.remove(controlKey);
    } else {
      _controlThemes[controlKey] = theme;
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

  ControlTheme _getControlTheme(String controlKey) {
    return _controlThemes[controlKey] ?? this;
  }
}

class ControlTheme with ChangeNotifier {
  EdgeInsets padding;
  double checkboxLabelSpace;
  double checkboxSpace;
  TextStyle checkboxLabelStyle;

  ControlTheme({
    this.padding = const EdgeInsets.all(5),
    this.checkboxLabelSpace = 8,
    this.checkboxSpace = 8,
  });
}
