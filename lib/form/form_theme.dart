import 'package:flutter/material.dart';

import 'form_builder.dart';

typedef ThemeBuild<T> = T Function(BuildContext context);

class FormTheme extends ChangeNotifier {
  TextfieldTheme _textfieldTheme = TextfieldTheme();

  get textfieldTheme => _textfieldTheme;

  static FormTheme of(BuildContext context) {
    return FormController.of(context).theme;
  }

  FormTheme() {
    _textfieldTheme.addListener(() {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _textfieldTheme.dispose();
    super.dispose();
  }
}

class TextfieldTheme extends ChangeNotifier {
  ThemeBuild<InputDecorationTheme> _inputDecorationThemeBuilder;

  TextfieldTheme() {
    _inputDecorationThemeBuilder = (context) {
      return Theme.of(context).inputDecorationTheme;
    };
  }

  InputDecorationTheme getInputDecorationTheme(BuildContext context) {
    return _inputDecorationThemeBuilder(context);
  }

  set inputDecorationThemeBuilder(ThemeBuild<InputDecorationTheme> builder) {
    _inputDecorationThemeBuilder = builder;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LabelTheme extends ChangeNotifier {
  EdgeInsets padding;
  ThemeBuild<TextStyle> textStyleBuilder;
  LabelTheme() {
    padding = EdgeInsets.zero;
    textStyleBuilder = (context) => TextStyle();
  }
}
