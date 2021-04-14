import 'package:flutter/material.dart';

import 'form_builder.dart';

class FormThemeData {
  final EdgeInsets padding;
  final ThemeData themeData;
  final EdgeInsets labelPadding;
  final CheckboxGroupTheme checkboxGroupTheme;
  final RadioGroupTheme radioGroupTheme;

  FormThemeData(
      {this.padding = EdgeInsets.zero,
      this.themeData,
      this.labelPadding,
      this.checkboxGroupTheme = const CheckboxGroupTheme(),
      this.radioGroupTheme = const RadioGroupTheme()});

  static FormThemeData of(BuildContext context) {
    return FormControllerDelegate.of(context).themeData;
  }

  static TextStyle getErrorStyle(ThemeData themeData) {
    InputDecorationTheme inputDecorationTheme = themeData.inputDecorationTheme;
    final Color color = themeData.errorColor;
    return themeData.textTheme.caption
        .copyWith(color: color)
        .merge(inputDecorationTheme.errorStyle);
  }

  static TextStyle getLabelStyle(ThemeData themeData, bool hasError) {
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
  final TextStyle labelStyle;
  final EdgeInsets widgetsPadding;
  final EdgeInsets errorTextPadding;

  const CheckboxGroupTheme({
    this.labelStyle,
    this.widgetsPadding,
    this.errorTextPadding,
  });

  CheckboxGroupTheme copyWith({
    TextStyle labelStyle,
    EdgeInsets widgetsPadding,
    EdgeInsets errorTextPadding,
    Color selectedColor,
    Color unselectedColor,
    Color disabledColor,
  }) {
    return CheckboxGroupTheme(
      labelStyle: labelStyle ?? this.labelStyle,
      widgetsPadding: widgetsPadding ?? this.widgetsPadding,
      errorTextPadding: errorTextPadding ?? this.errorTextPadding,
    );
  }
}

class RadioGroupTheme extends CheckboxGroupTheme {
  const RadioGroupTheme({
    TextStyle labelStyle,
    EdgeInsets widgetsPadding,
    EdgeInsets errorTextPadding,
  }) : super(
          errorTextPadding: errorTextPadding,
          labelStyle: labelStyle,
          widgetsPadding: widgetsPadding,
        );
}

class DefaultThemeData extends FormThemeData {
  DefaultThemeData(BuildContext context)
      : super(
            themeData: _buildLightTheme(context),
            padding: EdgeInsets.all(5),
            checkboxGroupTheme: CheckboxGroupTheme(),
            radioGroupTheme: RadioGroupTheme(),
            labelPadding: const EdgeInsets.symmetric(vertical: 10));

  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      headline1: base.headline1.copyWith(fontFamily: fontName),
      headline2: base.headline2.copyWith(fontFamily: fontName),
      headline3: base.headline3.copyWith(fontFamily: fontName),
      headline4: base.headline4.copyWith(fontFamily: fontName),
      headline5: base.headline5.copyWith(fontFamily: fontName),
      headline6: base.headline6.copyWith(fontFamily: fontName),
      button: base.button.copyWith(fontFamily: fontName),
      caption: base.caption.copyWith(fontFamily: fontName),
      bodyText1: base.bodyText1.copyWith(fontFamily: fontName),
      bodyText2: base.bodyText2.copyWith(fontFamily: fontName),
      subtitle1: base.subtitle1.copyWith(fontFamily: fontName),
      subtitle2: base.subtitle2.copyWith(fontFamily: fontName),
      overline: base.overline.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData _buildLightTheme(context) {
    final Color primaryColor = HexColor('#54D3C2');
    final Color secondaryColor = HexColor('#54D3C2');
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide:
                Divider.createBorderSide(context, color: base.errorColor)),
        errorBorder: UnderlineInputBorder(
            borderSide:
                Divider.createBorderSide(context, color: base.errorColor)),
        enabledBorder:
            UnderlineInputBorder(borderSide: Divider.createBorderSide(context)),
        border:
            UnderlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder: UnderlineInputBorder(
          borderSide: Divider.createBorderSide(context, color: primaryColor),
        ),
      ),
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      unselectedWidgetColor: Colors.grey.withOpacity(0.6),
      backgroundColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
    );
  }
}
