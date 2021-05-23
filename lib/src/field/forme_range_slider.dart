import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'forme_decoration_field.dart';
import 'forme_slider.dart';
import '../forme_field.dart';

class FormRangeLabelRender {
  final FormeLabelRender startRender;
  final FormeLabelRender endRender;
  FormRangeLabelRender(this.startRender, this.endRender);
}

class FormeRangeSlider
    extends NonnullValueField<RangeValues, FormeSliderModel> {
  FormeRangeSlider({
    ValueChanged<RangeValues>? onChanged,
    NonnullFieldValidator<RangeValues>? validator,
    AutovalidateMode? autovalidateMode,
    RangeValues? initialValue,
    FormRangeLabelRender? rangeFormeLabelRender,
    NonnullFormFieldSetter<RangeValues>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    SemanticFormatterCallback? semanticFormatterCallback,
    ValueChanged<RangeValues>? onChangeStart,
    ValueChanged<RangeValues>? onChangeEnd,
    FormeSliderModel? model,
    required double min,
    required double max,
    Key? key,
  }) : super(
            key: key,
            model: (model ?? FormeSliderModel()).merge(FormeSliderModel(
              max: max,
              min: min,
              divisions: (max - min).toInt(),
            )),
            readOnly: readOnly,
            name: name,
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue ?? RangeValues(min, max),
            autovalidateMode: autovalidateMode,
            builder: (state) {
              bool readOnly = state.readOnly;
              double max = state.model.max!;
              double min = state.model.min!;
              int divisions = state.model.divisions!;
              Color? activeColor = state.model.activeColor;
              Color? inactiveColor = state.model.inactiveColor;

              RangeValues rangeValues = state.value;
              RangeLabels? sliderLabels;

              if (rangeFormeLabelRender != null) {
                String start =
                    rangeFormeLabelRender.startRender(rangeValues.start);
                String end = rangeFormeLabelRender.endRender(rangeValues.end);
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

              return FormeDecoration(
                formeDecorationFieldRenderData:
                    state.model.formeDecorationFieldRenderData,
                child: Padding(
                  child: slider,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                focusNode: state.focusNode,
                errorText: state.errorText,
                helperText: state.model.helperText,
                labelText: state.model.labelText,
              );
            });

  @override
  _FormeRangeSliderState createState() => _FormeRangeSliderState();
}

class _FormeRangeSliderState
    extends NonnullValueFieldState<RangeValues, FormeSliderModel> {
  @override
  void beforeMerge(FormeSliderModel old, FormeSliderModel current) {
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
