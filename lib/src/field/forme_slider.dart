import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../render/forme_render_utils.dart';
import '../forme_controller.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';
import '../forme_core.dart';

typedef FormeLabelRender = String Function(double value);

class FormeSlider extends NonnullValueField<double, FormeSliderModel> {
  FormeSlider({
    NonnullFormeFieldValueChanged<double, FormeSliderModel>? onChanged,
    NonnullFieldValidator<double>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    NonnullFormFieldSetter<double>? onSaved,
    String? name,
    bool readOnly = false,
    required double min,
    required double max,
    FormeSliderModel? model,
    ValidateErrorListener<FormeValueFieldController<double, FormeSliderModel>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<double, FormeSliderModel>>?
        focusListener,
    Key? key,
  }) : super(
          key: key,
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
          model: (model ?? FormeSliderModel()).copyWith(FormeSliderModel(
            max: max,
            min: min,
          )),
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
            int divisions = state.model.divisions ?? (max - min).floor();
            Color? activeColor = state.model.activeColor;
            Color? inactiveColor = state.model.inactiveColor;

            double value = state.value;

            String? sliderLabel = state.model.labelRender == null
                ? null
                : state.model.labelRender!(value);

            SliderThemeData sliderThemeData =
                state.model.sliderThemeData ?? SliderTheme.of(state.context);
            if (sliderThemeData.thumbShape == null)
              sliderThemeData = sliderThemeData.copyWith(
                  thumbShape: CustomSliderThumbCircle(value: state.value));
            Widget slider = SliderTheme(
              data: sliderThemeData,
              child: Slider(
                value: value,
                min: min,
                max: max,
                focusNode: state.focusNode,
                label: sliderLabel,
                divisions: divisions,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onChangeStart: state.model.onChangeStart,
                onChangeEnd: state.model.onChangeEnd,
                semanticFormatterCallback:
                    state.model.semanticFormatterCallback,
                mouseCursor: state.model.mouseCursor,
                onChanged: readOnly
                    ? null
                    : (double value) {
                        state.didChange(value);
                        state.requestFocus();
                      },
              ),
            );

            return slider;
          },
        );

  @override
  _FormeSliderState createState() => _FormeSliderState();
}

class _FormeSliderState
    extends NonnullValueFieldState<double, FormeSliderModel> {
  @override
  FormeSliderModel beforeUpdateModel(
      FormeSliderModel old, FormeSliderModel current) {
    if (current.min != null && value < current.min!) setValue(current.min!);
    if (current.max != null && value > current.max!) setValue(current.max!);
    return current;
  }

  @override
  FormeSliderModel beforeSetModel(
      FormeSliderModel old, FormeSliderModel current) {
    if (current.min == null) {
      current = current.copyWith(FormeSliderModel(min: old.min));
    }
    if (current.max == null) {
      current = current.copyWith(FormeSliderModel(max: old.max));
    }
    return beforeUpdateModel(old, current);
  }
}

class FormeSliderModel extends FormeModel {
  final SemanticFormatterCallback? semanticFormatterCallback;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double? max;
  final double? min;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final SliderThemeData? sliderThemeData;
  final MouseCursor? mouseCursor;
  final FormeLabelRender? labelRender;

  FormeSliderModel({
    this.max,
    this.min,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.sliderThemeData,
    this.mouseCursor,
    this.onChangeEnd,
    this.onChangeStart,
    this.semanticFormatterCallback,
    this.labelRender,
  });

  @override
  FormeSliderModel copyWith(FormeModel oldModel) {
    FormeSliderModel old = oldModel as FormeSliderModel;
    return FormeSliderModel(
      semanticFormatterCallback:
          semanticFormatterCallback ?? old.semanticFormatterCallback,
      onChangeStart: onChangeStart ?? old.onChangeStart,
      onChangeEnd: onChangeEnd ?? old.onChangeEnd,
      max: max ?? old.max,
      min: min ?? old.min,
      divisions: divisions ?? old.divisions,
      activeColor: activeColor ?? old.activeColor,
      inactiveColor: inactiveColor ?? old.inactiveColor,
      sliderThemeData: FormeRenderUtils.copySliderThemeData(
          old.sliderThemeData, sliderThemeData),
      mouseCursor: mouseCursor ?? old.mouseCursor,
      labelRender: labelRender ?? old.labelRender,
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
