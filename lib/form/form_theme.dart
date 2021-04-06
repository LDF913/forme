import 'package:flutter/material.dart';

import 'form_builder.dart';

typedef ThemeBuild<T> = T Function(BuildContext context);

class FormTheme extends ChangeNotifier {
  ThemeBuild<InputDecorationTheme> _inputDecorationThemeBuilder =
      (context) => Theme.of(context).inputDecorationTheme;

  static FormTheme of(BuildContext context) {
    return FormController.of(context).theme;
  }

  get inputDecorationThemeBuilder => _inputDecorationThemeBuilder;

  set inputDecorationThemeBuilder(
      ThemeBuild<InputDecorationTheme> inputDecorationThemeBuilder) {
    if (inputDecorationThemeBuilder != null) {
      _inputDecorationThemeBuilder = inputDecorationThemeBuilder;
      notifyListeners();
    }
  }
}
