import 'package:flutter/material.dart';

import 'form_builder.dart';

class FormThemeData {
  final EdgeInsets padding;
  final ThemeData themeData;
  final EdgeInsets labelPadding;

  FormThemeData(
      {this.padding = EdgeInsets.zero,
      @required this.themeData,
      this.labelPadding});

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
  final EdgeInsets itemsPadding;
  final EdgeInsets errorTextPadding;

  const CheckboxGroupTheme({
    this.labelStyle,
    this.itemsPadding,
    this.errorTextPadding,
  });

  CheckboxGroupTheme copyWith({
    TextStyle labelStyle,
    EdgeInsets itemsPadding,
    EdgeInsets errorTextPadding,
    Color selectedColor,
    Color unselectedColor,
    Color disabledColor,
  }) {
    return CheckboxGroupTheme(
      labelStyle: labelStyle ?? this.labelStyle,
      itemsPadding: itemsPadding ?? this.itemsPadding,
      errorTextPadding: errorTextPadding ?? this.errorTextPadding,
    );
  }
}

class RadioGroupTheme extends CheckboxGroupTheme {
  const RadioGroupTheme({
    TextStyle labelStyle,
    EdgeInsets itemsPadding,
    EdgeInsets errorTextPadding,
  }) : super(
          errorTextPadding: errorTextPadding,
          labelStyle: labelStyle,
          itemsPadding: itemsPadding,
        );
}

class SwitchGroupTheme extends CheckboxGroupTheme {
  const SwitchGroupTheme({
    TextStyle labelStyle,
    EdgeInsets itemsPadding,
    EdgeInsets errorTextPadding,
  }) : super(
          errorTextPadding: errorTextPadding,
          labelStyle: labelStyle,
          itemsPadding: itemsPadding,
        );
}

//copied from https://github.com/mitesh77/Best-Flutter-UI-Templates
class DefaultFormThemeData extends FormThemeData {
  DefaultFormThemeData(BuildContext context)
      : super(
            themeData: _buildLightTheme(context),
            padding: EdgeInsets.all(5),
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

  static ThemeData _buildLightTheme(BuildContext context) {
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
        border: UnderlineInputBorder(
            borderSide: Divider.createBorderSide(context, width: 0)),
        focusedBorder: UnderlineInputBorder(
          borderSide: Divider.createBorderSide(context, color: primaryColor),
        ),
      ),
      sliderTheme: SliderThemeData(
          trackShape: _CustomTrackShape(),
          rangeTrackShape: _CustomRangeTrackShape(),
          thumbShape: _CustomThumbShape(),
          rangeThumbShape: _CustomRangeThumbShape()),
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

class _CustomTrackShape extends RoundedRectSliderTrackShape
    with _TrackShapeMixin {}

class _CustomRangeTrackShape extends RoundedRectRangeSliderTrackShape
    with _TrackShapeMixin {}

//copied from https://github.com/flutter/flutter/issues/37057
mixin _TrackShapeMixin {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

//copied from https://github.com/mitesh77/Best-Flutter-UI-Templates
class _CustomRangeThumbShape extends RangeSliderThumbShape {
  static const double _thumbSize = 3.0;
  static const double _disabledThumbSize = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    @required Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop,
    bool isPressed,
    @required SliderThemeData sliderTheme,
    TextDirection textDirection,
    Thumb thumb,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final double size = _thumbSize * sizeTween.evaluate(enableAnimation);
    Path thumbPath;
    switch (textDirection) {
      case TextDirection.rtl:
        switch (thumb) {
          case Thumb.start:
            thumbPath = _rightTriangle(size, center);
            break;
          case Thumb.end:
            thumbPath = _leftTriangle(size, center);
            break;
        }
        break;
      case TextDirection.ltr:
        switch (thumb) {
          case Thumb.start:
            thumbPath = _leftTriangle(size, center);
            break;
          case Thumb.end:
            thumbPath = _rightTriangle(size, center);
            break;
        }
        break;
    }

    canvas.drawPath(
        Path()
          ..addOval(Rect.fromPoints(Offset(center.dx + 12, center.dy + 12),
              Offset(center.dx - 12, center.dy - 12)))
          ..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)));

    final Paint cPaint = Paint();
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(center.dx, center.dy), 12, cPaint);
    cPaint..color = colorTween.evaluate(enableAnimation);
    canvas.drawCircle(Offset(center.dx, center.dy), 10, cPaint);
    canvas.drawPath(thumbPath, Paint()..color = Colors.white);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  Path _rightTriangle(double size, Offset thumbCenter, {bool invert = false}) {
    final Path thumbPath = Path();
    final double sign = invert ? -1.0 : 1.0;
    thumbPath.moveTo(thumbCenter.dx + 5 * sign, thumbCenter.dy);
    thumbPath.lineTo(thumbCenter.dx - 3 * sign, thumbCenter.dy - 5);
    thumbPath.lineTo(thumbCenter.dx - 3 * sign, thumbCenter.dy + 5);
    thumbPath.close();
    return thumbPath;
  }

  Path _leftTriangle(double size, Offset thumbCenter) =>
      _rightTriangle(size, thumbCenter, invert: true);
}

//copied from https://github.com/mitesh77/Best-Flutter-UI-Templates/blob/master/best_flutter_ui_templates
class _CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = 3.0;
  static const double _disabledThumbSize = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    Size sizeWithOverflow,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double textScaleFactor,
    double value,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawPath(
        Path()
          ..addOval(Rect.fromPoints(
              Offset(thumbCenter.dx + 12, thumbCenter.dy + 12),
              Offset(thumbCenter.dx - 12, thumbCenter.dy - 12)))
          ..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)));

    final Paint cPaint = Paint();
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 12, cPaint);
    cPaint..color = colorTween.evaluate(enableAnimation);
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 10, cPaint);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
