import 'package:flutter/material.dart';

import '../widget/slider_theme.dart';
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
  }) : super({
          'labelText': StateValue<String?>(labelText),
          'max': StateValue<double>(max),
          'min': StateValue<double>(min),
          'divisions': StateValue<int>(divisions ?? (max - min).toInt()),
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
          ThemeData themeData = Theme.of(state.context);
          int divisions = stateMap['divisions'];
          double max = stateMap['max'];
          double min = stateMap['min'];
          String? labelText = stateMap['labelText'];

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
              onChanged: readOnly
                  ? null
                  : (RangeValues values) {
                      state.didChange(values);
                    },
              activeColor: themeData.primaryColor,
              inactiveColor: themeData.unselectedWidgetColor.withOpacity(0.4),
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
