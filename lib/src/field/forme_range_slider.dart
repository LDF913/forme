import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../render/forme_render_utils.dart';
import '../forme_controller.dart';
import '../forme_state_model.dart';
import 'forme_slider.dart';
import '../forme_field.dart';
import '../forme_core.dart';

class FormRangeLabelRender {
  final FormeLabelRender startRender;
  final FormeLabelRender endRender;
  FormRangeLabelRender(this.startRender, this.endRender);
}

class FormeRangeSlider extends ValueField<RangeValues, FormeRangeSliderModel> {
  FormeRangeSlider({
    FormeFieldValueChanged<RangeValues, FormeRangeSliderModel>? onChanged,
    FormFieldValidator<RangeValues>? validator,
    AutovalidateMode? autovalidateMode,
    RangeValues? initialValue,
    FormFieldSetter<RangeValues>? onSaved,
    required String name,
    bool readOnly = false,
    FormeRangeSliderModel? model,
    required double min,
    required double max,
    ValidateErrorListener<
            FormeValueFieldController<RangeValues, FormeRangeSliderModel>>?
        validateErrorListener,
    FocusListener<
            FormeValueFieldController<RangeValues, FormeRangeSliderModel>>?
        focusListener,
    Key? key,
    FormeDecoratorBuilder<RangeValues>? decoratorBuilder,
  }) : super(
            nullValueReplacement: RangeValues(min, max),
            decoratorBuilder: decoratorBuilder,
            focusListener: focusListener,
            validateErrorListener: validateErrorListener,
            key: key,
            model: (model ?? FormeRangeSliderModel())
                .copyWith(FormeRangeSliderModel(
              max: max,
              min: min,
            )),
            readOnly: readOnly,
            name: name,
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            builder: (state) {
              bool readOnly = state.readOnly;
              double max = state.model.max!;
              double min = state.model.min!;
              int divisions = state.model.divisions ?? (max - min).floor();
              Color? activeColor = state.model.activeColor;
              Color? inactiveColor = state.model.inactiveColor;

              RangeValues rangeValues = state.value!;
              RangeLabels? sliderLabels;

              if (state.model.rangeLabelRender != null) {
                String start = state.model.rangeLabelRender!
                    .startRender(rangeValues.start);
                String end =
                    state.model.rangeLabelRender!.endRender(rangeValues.end);
                sliderLabels = RangeLabels(start, end);
              }

              SliderThemeData sliderThemeData =
                  state.model.sliderThemeData ?? SliderTheme.of(state.context);
              if (sliderThemeData.thumbShape == null)
                sliderThemeData = sliderThemeData.copyWith(
                    rangeThumbShape:
                        CustomRangeSliderThumbCircle(value: rangeValues));
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
                  onChangeStart: state.model.onChangeStart,
                  onChangeEnd: state.model.onChangeEnd,
                  semanticFormatterCallback:
                      state.model.semanticFormatterCallback,
                  onChanged: readOnly
                      ? null
                      : (RangeValues values) {
                          state.didChange(values);
                          state.requestFocus();
                        },
                ),
              );

              return Focus(
                focusNode: state.focusNode,
                child: slider,
              );
            });

  @override
  _FormeRangeSliderState createState() => _FormeRangeSliderState();
}

class _FormeRangeSliderState
    extends ValueFieldState<RangeValues, FormeRangeSliderModel> {
  @override
  FormeRangeSliderModel beforeUpdateModel(
      FormeRangeSliderModel old, FormeRangeSliderModel current) {
    RangeValues value = super.value!;
    if (current.min != null && value.start < current.min!)
      setValue(RangeValues(current.min!, value.end));
    if (current.max != null && value.end > current.max!)
      setValue(RangeValues(value.start, current.max!));
    return current;
  }

  @override
  FormeRangeSliderModel beforeSetModel(
      FormeRangeSliderModel old, FormeRangeSliderModel current) {
    if (current.min == null) {
      current = current.copyWith(FormeRangeSliderModel(min: old.min));
    }
    if (current.max == null) {
      current = current.copyWith(FormeRangeSliderModel(max: old.max));
    }
    return beforeUpdateModel(old, current);
  }
}

class FormeRangeSliderModel extends FormeModel {
  final SemanticFormatterCallback? semanticFormatterCallback;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final double? max;
  final double? min;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final SliderThemeData? sliderThemeData;
  final MouseCursor? mouseCursor;
  final FormRangeLabelRender? rangeLabelRender;
  FormeRangeSliderModel({
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
    this.rangeLabelRender,
  });

  FormeRangeSliderModel copyWith(FormeModel oldModel) {
    FormeRangeSliderModel old = oldModel as FormeRangeSliderModel;
    return FormeRangeSliderModel(
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
      rangeLabelRender: rangeLabelRender ?? old.rangeLabelRender,
    );
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
