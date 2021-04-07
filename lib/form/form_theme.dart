import 'package:flutter/material.dart';

import 'form_builder.dart';

typedef WidgetWrapper = Widget Function(
    String controlKey, Widget child, BuildContext context);
typedef ThemeDataBuilder = ThemeData Function(BuildContext context);

class FormTheme {
  final ThemeDataBuilder themeDataBuilder;
  final EdgeInsets labelPadding;
  final Map<String, EdgeInsets> controlPaddings;
  final CheckboxGroupTheme checkboxGroupTheme;
  final RadioGroupTheme radioGroupTheme;
  final WidgetWrapper wrapper;

  get widgetWrapper => wrapper == null ? (a, b, c) => b : wrapper;

  FormTheme(
      {this.themeDataBuilder,
      this.labelPadding,
      this.controlPaddings,
      this.checkboxGroupTheme = const CheckboxGroupTheme(),
      this.radioGroupTheme = const RadioGroupTheme(),
      this.wrapper});

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

  static DefaultTheme defaultTheme = DefaultTheme._();
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

  const CheckboxGroupTheme(
      {this.labelSpace,
      this.widgetsSpace,
      this.labelStyle,
      this.widgetsPadding,
      this.errorTextPadding});
}

class RadioGroupTheme extends CheckboxGroupTheme {
  const RadioGroupTheme({
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

class DefaultTheme extends FormTheme {
  DefaultTheme._()
      : super(
            checkboxGroupTheme: RadioGroupTheme(labelSpace: 10),
            radioGroupTheme: RadioGroupTheme(labelSpace: 10),
            wrapper: (controlKey, child, context) => Padding(
                  padding: EdgeInsets.all(5),
                  child: child,
                ),
            themeDataBuilder: (context) => _buildLightTheme(context),
            labelPadding: const EdgeInsets.only(top: 10, bottom: 10));

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
      platform: TargetPlatform.iOS,
    );
  }
}
