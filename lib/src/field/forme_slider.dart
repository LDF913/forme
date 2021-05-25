import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../forme_state_model.dart';
import 'forme_decoration.dart';
import '../forme_field.dart';
import '../forme_core.dart';

typedef FormeLabelRender = String Function(num value);

class FormeSlider extends NonnullValueField<num, FormeSliderModel> {
  FormeSlider({
    ValueChanged<num>? onChanged,
    NonnullFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    FormeLabelRender? subLabelRender,
    NonnullFormFieldSetter<num>? onSaved,
    String? name,
    bool readOnly = false,
    SemanticFormatterCallback? semanticFormatterCallback,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    MouseCursor? mouseCursor,
    required double min,
    required double max,
    FormeSliderModel? model,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeSliderModel()).copyWith(
            max: max,
            min: min,
            divisions: (max - min).toInt(),
          ),
          readOnly: readOnly,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? min,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            double max = state.model.max!;
            double min = state.model.min!;
            int divisions = state.model.divisions!;
            Color? activeColor = state.model.activeColor;
            Color? inactiveColor = state.model.inactiveColor;

            num value = state.value;

            String? sliderLabel =
                subLabelRender == null ? null : subLabelRender(value);

            SliderThemeData sliderThemeData =
                state.model.sliderThemeData ?? SliderTheme.of(state.context);
            if (sliderThemeData.thumbShape == null)
              sliderThemeData = sliderThemeData.copyWith(
                  thumbShape:
                      CustomSliderThumbCircle(value: state.value.toDouble()));
            Widget slider = SliderTheme(
              data: sliderThemeData,
              child: Slider(
                value: value.toDouble(),
                min: min,
                max: max,
                label: sliderLabel,
                divisions: divisions,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onChangeStart: onChangeStart,
                onChangeEnd: onChangeEnd,
                semanticFormatterCallback: semanticFormatterCallback,
                mouseCursor: mouseCursor,
                onChanged: readOnly
                    ? null
                    : (double value) {
                        state.didChange(value);
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
              labelText: state.model.labelText,
              helperText: state.model.helperText,
            );
          },
        );

  @override
  _FormeSliderState createState() => _FormeSliderState();
}

class _FormeSliderState extends NonnullValueFieldState<num, FormeSliderModel> {
  @override
  void beforeUpdateModel(FormeSliderModel old, FormeSliderModel current) {
    if (current.min != null && value < current.min!) setValue(current.min!);
    if (current.max != null && value > current.max!) setValue(current.max!);
  }
}

class FormeSliderModel extends FormeModel {
  final String? labelText;
  final String? helperText;
  final double? max;
  final double? min;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final SliderThemeData? sliderThemeData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  FormeSliderModel({
    this.labelText,
    this.max,
    this.min,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.sliderThemeData,
    this.formeDecorationFieldRenderData,
    this.helperText,
  });
  @override
  FormeSliderModel copyWith({
    Optional<String>? labelText,
    Optional<String>? helperText,
    double? max,
    double? min,
    int? divisions,
    Optional<Color>? activeColor,
    Optional<Color>? inactiveColor,
    Optional<SliderThemeData>? sliderThemeData,
    Optional<FormeDecorationRenderData>? formeDecorationFieldRenderData,
  }) {
    return FormeSliderModel(
      labelText: Optional.copyWith(labelText, this.labelText),
      helperText: Optional.copyWith(helperText, this.helperText),
      max: max ?? this.max,
      min: min ?? this.min,
      divisions: divisions ?? this.divisions,
      activeColor: Optional.copyWith(activeColor, this.activeColor),
      inactiveColor: Optional.copyWith(inactiveColor, this.inactiveColor),
      sliderThemeData: Optional.copyWith(sliderThemeData, this.sliderThemeData),
      formeDecorationFieldRenderData: Optional.copyWith(
          formeDecorationFieldRenderData, this.formeDecorationFieldRenderData),
    );
  }
}

// copied from https://medium.com/flutter-community/flutter-sliders-demystified-4b3ea65879c
class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final double value;

  const CustomSliderThumbCircle({
    this.thumbRadius = 12,
    required this.value,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
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
          fontSize: thumbRadius * .8,
          fontWeight: FontWeight.w700,
          color: Colors.white, //Text Color of Value on Thumb
        ),
        text: this.value.round().toString());
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }
}
