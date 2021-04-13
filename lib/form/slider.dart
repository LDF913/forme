import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

typedef SubLabelRender = Widget Function(double value);

class SliderController extends ValueNotifier<double> {
  SliderController({double value}) : super(value);
}

class SliderFormField extends FormBuilderField<double> {
  final EdgeInsets padding;
  final int divisions;
  final double max;
  final double min;
  final String label;
  final SubLabelRender subLabelRender;
  final bool inline;

  SliderFormField(String controlKey, SliderController controller,
      {Key key,
      String labelText,
      bool readOnly,
      ValueChanged<double> onChanged,
      FormFieldValidator<double> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      double initialValue,
      this.divisions,
      this.max,
      this.min,
      this.subLabelRender,
      FocusNode focusNode,
      this.label,
      this.inline = false})
      : assert(controlKey != null, divisions != null),
        super(
          controlKey,
          controller,
          key: key,
          onChanged: onChanged,
          replace: () => min,
          validator: validator,
          initialValue: initialValue ?? min,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final FormThemeData formThemeData = FormThemeData.of(field.context);
            final ThemeData themeData = Theme.of(field.context);
            final _SliderFieldState state = field;
            List<Widget> columns = [];
            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style:
                      FormThemeData.getLabelStyle(themeData, state.hasError));
              columns.add(Padding(
                padding: formThemeData.labelPadding ?? EdgeInsets.zero,
                child: text,
              ));
            }

            if (subLabelRender != null) {
              columns.add(Row(
                children: [
                  Expanded(
                    flex:
                        ((controller.value - min) * 100 / (max - min)).round(),
                    child: const SizedBox(),
                  ),
                  subLabelRender(controller.value),
                  Expanded(
                    flex:
                        ((max - controller.value) * 100 / (max - min)).round(),
                    child: const SizedBox(),
                  ),
                ],
              ));
            }

            Widget slider = SliderTheme(
              data: SliderThemeData(
                trackShape: _CustomTrackShape(),
                thumbShape: _CustomThumbShape(),
              ),
              child: Slider(
                focusNode: focusNode,
                value: controller.value,
                min: min,
                max: max,
                divisions: divisions ?? (max - min).toInt(),
                onChanged: (double value) {
                  if (!focusNode.hasFocus) {
                    focusNode.requestFocus();
                  }
                  field.didChange(value);
                },
                activeColor: themeData.primaryColor,
                inactiveColor: themeData.unselectedWidgetColor.withOpacity(0.4),
              ),
            );

            columns.add(inline
                ? slider
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: slider,
                  ));

            if (state.hasError) {
              TextOverflow overflow = inline ? TextOverflow.ellipsis : null;
              Text error = Text(state.errorText,
                  overflow: overflow,
                  style: FormThemeData.getErrorStyle(themeData));
              columns.add(error);
            }

            return Padding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columns,
                ),
                padding: padding ?? formThemeData.padding ?? EdgeInsets.zero);
          },
        );

  @override
  _SliderFieldState createState() => _SliderFieldState();
}

class _SliderFieldState extends FormBuilderFieldState<double> {
  @override
  SliderFormField get widget => super.widget as SliderFormField;
  @override
  double get value => super.value == null ? widget.min : super.value.round();
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

//copied from https://github.com/flutter/flutter/issues/37057
class _CustomTrackShape extends RoundedRectSliderTrackShape {
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
