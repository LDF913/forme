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
  }) : super(
          {
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
          initialValue: initialValue ?? min,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.themeData;
            int divisions = stateMap['divisions'];
            double max = stateMap['max'];
            double min = stateMap['min'];
            String? labelText = stateMap['labelText'];

            num value = state.value;

            String? sliderLabel =
                subLabelRender == null ? null : subLabelRender(value);

            Widget slider = SliderTheme(
              data: SliderTheme.of(state.context),
              child: Slider(
                focusNode: state.focusNode,
                value: value.toDouble(),
                min: min,
                max: max,
                label: sliderLabel,
                divisions: divisions,
                onChanged: readOnly
                    ? null
                    : (double value) {
                        state.didChange(value);
                      },
                activeColor: themeData.primaryColor,
                inactiveColor: themeData.unselectedWidgetColor.withOpacity(0.4),
              ),
            );

            return DecorationField(
              child: slider,
              errorText: state.errorText,
              readOnly: readOnly,
              labelText: labelText,
            );
          },
        );
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
          ThemeData themeData = state.themeData;
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

          Widget slider = SliderTheme(
            data: SliderTheme.of(state.context),
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
            child: slider,
            focusNode: state.focusNode,
            errorText: state.errorText,
            readOnly: readOnly,
            labelText: labelText,
          );
        });
}

class RangeSubLabelRender {
  final SubLabelRender startRender;
  final SubLabelRender endRender;
  RangeSubLabelRender(this.startRender, this.endRender);
}
