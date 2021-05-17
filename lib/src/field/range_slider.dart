import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../form_field.dart';
import 'decoration_field.dart';
import 'slider.dart';

class RangeSubLabelRender {
  final SubLabelRender startRender;
  final SubLabelRender endRender;
  RangeSubLabelRender(this.startRender, this.endRender);
}

class RangeSliderFormField
    extends BaseNonnullValueField<RangeValues, SliderModel> {
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
    SliderThemeData? sliderThemeData,
    SemanticFormatterCallback? semanticFormatterCallback,
    ValueChanged<RangeValues>? onChangeStart,
    ValueChanged<RangeValues>? onChangeEnd,
    WidgetWrapper? wrapper,
  }) : super(
            model: SliderModel(
              labelText: labelText,
              max: max,
              min: min,
              divisions: divisions ?? (max - min).toInt(),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              sliderThemeData: sliderThemeData,
            ),
            visible: visible,
            readOnly: readOnly,
            flex: flex,
            padding: padding,
            name: name,
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue ?? RangeValues(min, max),
            autovalidateMode: autovalidateMode,
            wrapper: wrapper,
            builder: (state) {
              bool readOnly = state.readOnly;
              int divisions = state.model.divisions!;
              double max = state.model.max!;
              double min = state.model.min!;
              String? labelText = state.model.labelText;
              Color? activeColor = state.model.activeColor;
              Color? inactiveColor = state.model.inactiveColor;

              RangeValues rangeValues = state.value;
              RangeLabels? sliderLabels;

              if (rangeSubLabelRender != null) {
                String start =
                    rangeSubLabelRender.startRender(rangeValues.start);
                String end = rangeSubLabelRender.endRender(rangeValues.end);
                sliderLabels = RangeLabels(start, end);
              }

              SliderThemeData sliderThemeData =
                  state.model.sliderThemeData ?? SliderTheme.of(state.context);
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
                  onChangeStart: onChangeStart,
                  onChangeEnd: onChangeEnd,
                  semanticFormatterCallback: semanticFormatterCallback,
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

  @override
  _RangeSliderFormFieldState createState() => _RangeSliderFormFieldState();
}

class _RangeSliderFormFieldState
    extends BaseNonnullValueFieldState<RangeValues, SliderModel> {
  @override
  void beforeMerge(SliderModel old, SliderModel current) {
    if (current.min != null && value.start < current.min!)
      setValue(RangeValues(current.min!, value.end));
    if (current.max != null && value.end > current.max!)
      setValue(RangeValues(value.start, current.max!));
  }
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
