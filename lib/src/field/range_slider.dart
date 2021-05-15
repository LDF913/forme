import 'package:flutter/material.dart';

import '../form_field.dart';
import '../state_model.dart';
import 'decoration_field.dart';
import 'slider.dart';

class RangeSubLabelRender {
  final SubLabelRender startRender;
  final SubLabelRender endRender;
  RangeSubLabelRender(this.startRender, this.endRender);
}

class RangeSliderFormField extends BaseNonnullValueField<RangeValues> {
  RangeSliderFormField({
    ValueChanged<RangeValues>? onChanged,
    NonnullFieldValidator<RangeValues>? validator,
    AutovalidateMode? autovalidateMode,
    required double max,
    required double min,
    String? labelText,
    int? divisions,
    RangeValues? initialValue,
    RangeSubLabelRender? rangeSubLabelRender,
    NonnullFormFieldSetter<RangeValues>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    Color? activeColor,
    Color? inactiveColor,
  }) : super({
          'labelText': StateValue<String?>(labelText),
          'max': StateValue<double>(max),
          'min': StateValue<double>(min),
          'divisions': StateValue<int>(divisions ?? (max - min).toInt()),
          'activeColor': StateValue<Color?>(activeColor),
          'inactiveColor': StateValue<Color?>(inactiveColor),
        },
            visible: visible,
            readOnly: readOnly,
            flex: flex,
            padding: padding,
            name: name,
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue ?? RangeValues(min, max),
            autovalidateMode: autovalidateMode, builder: (state) {
          bool readOnly = state.readOnly;
          Map<String, dynamic> stateMap = state.currentMap;
          int divisions = stateMap['divisions'];
          double max = stateMap['max'];
          double min = stateMap['min'];
          String? labelText = stateMap['labelText'];
          Color? activeColor = stateMap['activeColor'];
          Color? inactiveColor = stateMap['inactiveColor'];

          RangeValues rangeValues = state.value;
          RangeLabels? sliderLabels;

          if (rangeSubLabelRender != null) {
            String start = rangeSubLabelRender.startRender(rangeValues.start);
            String end = rangeSubLabelRender.endRender(rangeValues.end);
            sliderLabels = RangeLabels(start, end);
          }

          SliderThemeData sliderThemeData = SliderTheme.of(state.context);
          if (sliderThemeData.thumbShape == null)
            sliderThemeData = sliderThemeData.copyWith(
                rangeThumbShape:
                    CustomRangeSliderThumbCircle(value: state.value));
          Widget slider = SliderTheme(
            data: sliderThemeData,
            child: RangeSlider(
              values: rangeValues,
              min: min,
              max: max,
              divisions: divisions,
              labels: sliderLabels,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onChanged: readOnly
                  ? null
                  : (RangeValues values) {
                      state.didChange(values);
                      state.requestFocus();
                    },
            ),
          );

          return DecorationField(
            child: Padding(
              child: slider,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            focusNode: state.focusNode,
            errorText: state.errorText,
            readOnly: readOnly,
            labelText: labelText,
          );
        });
}

class CustomRangeSliderThumbCircle extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double elevation;
  final double pressedElevation;
  final RangeValues value;

  CustomRangeSliderThumbCircle(
      {this.enabledThumbRadius = 12,
      this.elevation = 1,
      this.pressedElevation = 6,
      required this.value});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    String value;
    Thumb _thumb = thumb ?? Thumb.start;
    switch (_thumb) {
      case Thumb.start:
        value = this.value.start.round().toString();
        break;
      case Thumb.end:
        value = this.value.end.round().toString();
        break;
    }

    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final Color color = colorTween.evaluate(enableAnimation)!;

    final paint = Paint()
      ..color = color //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
          fontSize: enabledThumbRadius * .8,
          fontWeight: FontWeight.w700,
          color: Colors.white, //Text Color of Value on Thumb
        ),
        text: value);

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, enabledThumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }
}
