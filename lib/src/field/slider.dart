import 'package:flutter/material.dart';
import '../widget/slider_theme.dart';
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
            ThemeData themeData = Theme.of(state.context);
            int divisions = stateMap['divisions'];
            double max = stateMap['max'];
            double min = stateMap['min'];
            String? labelText = stateMap['labelText'];

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
              child: Padding(
                child: slider,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              errorText: state.errorText,
              readOnly: readOnly,
              labelText: labelText,
            );
          },
        );
}
