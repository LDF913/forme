import 'package:flutter/material.dart';
import '../state_model.dart';
import '../form_field.dart';
import 'decoration_field.dart';

typedef SubLabelRender = String Function(num value);

class SliderFormField extends BaseNonnullValueField<num> {
  SliderFormField({
    ValueChanged<num>? onChanged,
    NonnullFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    int? divisions,
    required double max,
    required double min,
    SubLabelRender? subLabelRender,
    String? labelText,
    NonnullFormFieldSetter<num>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    Color? activeColor,
    Color? inactiveColor,
  }) : super(
          {
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
          initialValue: initialValue ?? min,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            int divisions = stateMap['divisions'];
            double max = stateMap['max'];
            double min = stateMap['min'];
            String? labelText = stateMap['labelText'];
            Color? activeColor = stateMap['activeColor'];
            Color? inactiveColor = stateMap['inactiveColor'];

            num value = state.value;

            String? sliderLabel =
                subLabelRender == null ? null : subLabelRender(value);

            SliderThemeData sliderThemeData = SliderTheme.of(state.context);
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
                onChanged: readOnly
                    ? null
                    : (double value) {
                        state.didChange(value);
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
          },
        );

  @override
  _SliderFormFieldState createState() => _SliderFormFieldState();
}

class _SliderFormFieldState extends BaseNonnullValueFieldState<num> {
  @override
  void afterStateValueChanged(String key, old, current) {
    super.afterStateValueChanged(key, old, current);
    if (key == 'min' && value < current) setValue(current);
    if (key == 'max' && value > current) setValue(current);
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
