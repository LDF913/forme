import 'package:flutter/material.dart';

import '../form_theme.dart';
import '../state_model.dart';
import '../form_field.dart';

typedef SubLabelRender = Widget Function(num value);

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
    String? label,
    EdgeInsets? contentPadding,
    NonnullFormFieldSetter<num>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    EdgeInsets? labelPadding,
  }) : super(
          {
            'label': StateValue<String?>(label),
            'max': StateValue<double>(max),
            'min': StateValue<double>(min),
            'divisions': StateValue<int>(divisions ?? (max - min).toInt()),
            'contentPadding': StateValue<EdgeInsets>(
                contentPadding ?? const EdgeInsets.symmetric(horizontal: 10)),
            'labelPadding': StateValue<EdgeInsets>(
                labelPadding ?? const EdgeInsets.symmetric(vertical: 10))
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
            ThemeData themeData = state.formThemeData;
            FocusNode focusNode = state.focusNode;
            int divisions = stateMap['divisions'];
            double max = stateMap['max'];
            double min = stateMap['min'];
            String? label = stateMap['label'];
            EdgeInsets contentPadding = stateMap['contentPadding'];
            EdgeInsets labelPadding = stateMap['labelPadding'];
            bool inline = state.inline;

            List<Widget> columns = [];
            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style: ThemeUtil.getLabelStyle(themeData, state.hasError));
              columns.add(Padding(
                padding: labelPadding,
                child: text,
              ));
            }

            List<Widget> contentColumns = [];

            num value = state.value;

            if (subLabelRender != null) {
              contentColumns.add(Row(
                children: [
                  Expanded(
                    flex: ((value - min) * 100 / (max - min)).round(),
                    child: const SizedBox(),
                  ),
                  subLabelRender(value),
                  Expanded(
                    flex: ((max - value) * 100 / (max - min)).round(),
                    child: const SizedBox(),
                  ),
                ],
              ));
            }

            Widget slider = SliderTheme(
              data: SliderTheme.of(state.context),
              child: Slider(
                focusNode: focusNode,
                value: value.toDouble(),
                min: min,
                max: max,
                divisions: divisions,
                onChanged: readOnly
                    ? null
                    : (double value) {
                        if (!focusNode.hasFocus) {
                          focusNode.requestFocus();
                        }
                        state.didChange(value);
                      },
                activeColor: themeData.primaryColor,
                inactiveColor: themeData.unselectedWidgetColor.withOpacity(0.4),
              ),
            );

            contentColumns.add(slider);

            if (state.hasError) {
              TextOverflow? overflow = inline ? TextOverflow.ellipsis : null;
              Text error = Text(state.errorText!,
                  overflow: overflow,
                  style: ThemeUtil.getErrorStyle(themeData));
              contentColumns.add(error);
            }

            columns.add(Padding(
              padding: inline ? EdgeInsets.zero : contentPadding,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contentColumns),
            ));
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns,
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
    String? label,
    int? divisions,
    RangeValues? initialValue,
    RangeSubLabelRender? rangeSubLabelRender,
    EdgeInsets? contentPadding,
    NonnullFormFieldSetter<RangeValues>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    EdgeInsets? labelPadding,
  }) : super({
          'label': StateValue<String?>(label),
          'max': StateValue<double>(max),
          'min': StateValue<double>(min),
          'divisions': StateValue<int>(divisions ?? (max - min).toInt()),
          'contentPadding': StateValue<EdgeInsets>(
              contentPadding ?? EdgeInsets.symmetric(horizontal: 20)),
          'labelPadding': StateValue<EdgeInsets>(
              labelPadding ?? const EdgeInsets.symmetric(vertical: 10))
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
          ThemeData themeData = state.formThemeData;
          int divisions = stateMap['divisions'];
          double max = stateMap['max'];
          double min = stateMap['min'];
          String? label = stateMap['label'];
          EdgeInsets contentPadding = stateMap['contentPadding'];
          EdgeInsets labelPadding = stateMap['labelPadding'];
          bool inline = state.inline;

          List<Widget> columns = [];
          if (label != null) {
            Text text = Text(label,
                textAlign: TextAlign.left,
                style: ThemeUtil.getLabelStyle(themeData, state.hasError));
            columns.add(Padding(
              padding: labelPadding,
              child: text,
            ));
          }

          List<Widget> contentColumns = [];

          RangeValues rangeValues = state.value;

          if (rangeSubLabelRender != null) {
            contentColumns.add(Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: ((rangeValues.start - min) * 100 / (max - min))
                          .round(),
                      child: const SizedBox(),
                    ),
                    rangeSubLabelRender.startRender(rangeValues.start),
                    Expanded(
                      flex: ((max - rangeValues.start) * 100 / (max - min))
                          .round(),
                      child: const SizedBox(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex:
                          ((rangeValues.end - min) * 100 / (max - min)).round(),
                      child: const SizedBox(),
                    ),
                    rangeSubLabelRender.startRender(rangeValues.end),
                    Expanded(
                      flex:
                          ((max - rangeValues.end) * 100 / (max - min)).round(),
                      child: const SizedBox(),
                    ),
                  ],
                )
              ],
            ));
          }

          Widget slider = SliderTheme(
            data: SliderTheme.of(state.context),
            child: RangeSlider(
              values: rangeValues,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: readOnly
                  ? null
                  : (RangeValues values) {
                      state.didChange(values);
                    },
              activeColor: themeData.primaryColor,
              inactiveColor: themeData.unselectedWidgetColor.withOpacity(0.4),
            ),
          );

          contentColumns.add(slider);

          if (state.hasError) {
            TextOverflow? overflow = inline ? TextOverflow.ellipsis : null;
            Text error = Text(state.errorText!,
                overflow: overflow, style: ThemeUtil.getErrorStyle(themeData));
            contentColumns.add(error);
          }

          columns.add(Padding(
            padding: contentPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contentColumns,
            ),
          ));

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columns,
          );
        });
}

class RangeSubLabelRender {
  final SubLabelRender startRender;
  final SubLabelRender endRender;
  RangeSubLabelRender(this.startRender, this.endRender);
}
