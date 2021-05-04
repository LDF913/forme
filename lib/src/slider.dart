import 'package:flutter/material.dart';

import 'builder.dart';
import 'form_theme.dart';

typedef SubLabelRender = Widget Function(double value);

class SliderFormField extends NonnullValueField<double> {
  SliderFormField(
      {ValueChanged<double>? onChanged,
      NonnullFieldValidator<double>? validator,
      AutovalidateMode? autovalidateMode,
      double? initialValue,
      int? divisions,
      required double max,
      required double min,
      SubLabelRender? subLabelRender,
      String? label,
      EdgeInsets? contentPadding})
      : super(
          {
            'label': TypedValue<String?>(label),
            'max': TypedValue<double>(max),
            'min': TypedValue<double>(min),
            'divisions': TypedValue<int>(divisions ?? (max - min).toInt()),
            'contentPadding': TypedValue<EdgeInsets>(
                contentPadding ?? const EdgeInsets.symmetric(horizontal: 10))
          },
          onChanged: onChanged,
          validator: validator,
          initialValue: initialValue ?? min,
          autovalidateMode: autovalidateMode,
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            FocusNode focusNode = state.focusNode;
            int divisions = stateMap['divisions'];
            double max = stateMap['max'];
            double min = stateMap['min'];
            String? label = stateMap['label'];
            EdgeInsets contentPadding = stateMap['contentPadding'];
            bool inline = state.inline;

            List<Widget> columns = [];
            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style:
                      FormThemeData.getLabelStyle(themeData, state.hasError));
              columns.add(Padding(
                padding: formThemeData.labelPadding ?? EdgeInsets.zero,
                child: text,
              ));
            }

            List<Widget> contentColumns = [];

            double value = state.value;

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
                value: value,
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
                  style: FormThemeData.getErrorStyle(themeData));
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

  @override
  NonnullValueFieldState<double> createState() => NonnullValueFieldState();
}

class RangeSliderFormField extends NonnullValueField<RangeValues> {
  RangeSliderFormField(
      {ValueChanged<RangeValues>? onChanged,
      NonnullFieldValidator<RangeValues>? validator,
      AutovalidateMode? autovalidateMode,
      required double max,
      required double min,
      String? label,
      int? divisions,
      RangeValues? initialValue,
      RangeSubLabelRender? rangeSubLabelRender,
      EdgeInsets? contentPadding})
      : super({
          'label': TypedValue<String?>(label),
          'max': TypedValue<double>(max),
          'min': TypedValue<double>(min),
          'divisions': TypedValue<int>(divisions ?? (max - min).toInt()),
          'contentPadding': TypedValue<EdgeInsets>(
              contentPadding ?? EdgeInsets.symmetric(horizontal: 20))
        },
            onChanged: onChanged,
            validator: validator,
            initialValue: initialValue ?? RangeValues(min, max),
            autovalidateMode: autovalidateMode, builder:
                (state, context, readOnly, stateMap, themeData, formThemeData) {
          int divisions = stateMap['divisions'];
          double max = stateMap['max'];
          double min = stateMap['min'];
          String? label = stateMap['label'];
          EdgeInsets contentPadding = stateMap['contentPadding'];
          bool inline = state.inline;

          List<Widget> columns = [];
          if (label != null) {
            Text text = Text(label,
                textAlign: TextAlign.left,
                style: FormThemeData.getLabelStyle(themeData, state.hasError));
            columns.add(Padding(
              padding: formThemeData.labelPadding ?? EdgeInsets.zero,
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
            data: SliderTheme.of(context),
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
                overflow: overflow,
                style: FormThemeData.getErrorStyle(themeData));
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
