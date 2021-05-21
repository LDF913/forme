import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../form_state_model.dart';
import '../form_field.dart';
import 'decoration_field.dart';
import 'base_field.dart';

typedef SubLabelRender = String Function(num value);

class SliderFormField extends BaseNonnullValueField<num, SliderModel> {
  SliderFormField({
    ValueChanged<num>? onChanged,
    NonnullFieldValidator<num>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    SubLabelRender? subLabelRender,
    NonnullFormFieldSetter<num>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    SemanticFormatterCallback? semanticFormatterCallback,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    MouseCursor? mouseCursor,
    WidgetWrapper? wrapper,
    required SliderModel model,
    LayoutParam? layoutParam,
  }) : super(
          layoutParam: layoutParam,
          model: model,
          readOnly: readOnly,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? model.min ?? 1,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            double max = state.model.max ?? 100;
            double min = state.model.min ?? 1;
            int divisions = state.model.divisions ?? (max - min).round();
            String? labelText = state.model.labelText;
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

class _SliderFormFieldState
    extends BaseNonnullValueFieldState<num, SliderModel> {
  @override
  void beforeMerge(SliderModel old, SliderModel current) {
    if (current.min != null && value < current.min!) setValue(current.min!);
    if (current.max != null && value > current.max!) setValue(current.max!);
  }
}

class SliderModel extends AbstractFieldStateModel {
  final String? labelText;
  final double? max;
  final double? min;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final SliderThemeData? sliderThemeData;

  SliderModel(
      {this.labelText,
      this.max,
      this.min,
      this.divisions,
      this.activeColor,
      this.inactiveColor,
      this.sliderThemeData});
  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    SliderModel oldModel = old as SliderModel;
    return SliderModel(
      labelText: labelText ?? oldModel.labelText,
      max: max ?? oldModel.max,
      min: min ?? oldModel.min,
      divisions: divisions ?? oldModel.divisions,
      activeColor: activeColor ?? oldModel.activeColor,
      inactiveColor: inactiveColor ?? oldModel.inactiveColor,
      sliderThemeData: sliderThemeData ?? oldModel.sliderThemeData,
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
