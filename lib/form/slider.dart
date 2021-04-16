import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

typedef SubLabelRender = Widget Function(double value);

class SliderController extends ValueNotifier<double> {
  SliderController({double value}) : super(value);
}

class SliderFormField extends ValueField<double> {
  SliderFormField(SliderController controller, FocusNode focusNode,
      {Key key,
      bool readOnly,
      ValueChanged<double> onChanged,
      FormFieldValidator<double> validator,
      AutovalidateMode autovalidateMode,
      EdgeInsets padding,
      double initialValue,
      int divisions,
      double max,
      double min,
      SubLabelRender subLabelRender,
      String label,
      bool inline = false,
      EdgeInsets contentPadding})
      : super(
          controller,
          {
            'divisions': divisions,
            'max': max,
            'min': min,
            'label': label,
            'contentPadding': contentPadding ?? EdgeInsets.zero
          },
          key: key,
          readOnly: readOnly,
          padding: padding,
          onChanged: onChanged,
          replace: () => min,
          validator: validator,
          initialValue: initialValue ?? min,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final FormThemeData formThemeData = FormThemeData.of(field.context);
            final ThemeData themeData = Theme.of(field.context);
            final _SliderFieldState state = field;

            int divisions = state.getState('divisions');
            double max = state.getState('max');
            double min = state.getState('min');
            String label = state.getState('label');
            bool readOnly = state.readOnly;
            EdgeInsets padding = state.padding;
            EdgeInsets contentPadding = state.getState('contentPadding');

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

            if (subLabelRender != null) {
              contentColumns.add(Row(
                children: [
                  Expanded(
                    flex:
                        ((controller.value - min) * 100 / (max - min)).round(),
                    child: const SizedBox(),
                  ),
                  subLabelRender(controller.value),
                  Expanded(
                    flex:
                        ((max - controller.value) * 100 / (max - min)).round(),
                    child: const SizedBox(),
                  ),
                ],
              ));
            }

            Widget slider = SliderTheme(
              data: SliderTheme.of(state.context),
              child: Slider(
                focusNode: focusNode,
                value: controller.value,
                min: min,
                max: max,
                divisions: divisions ?? (max - min).toInt(),
                onChanged: readOnly
                    ? null
                    : (double value) {
                        if (!focusNode.hasFocus) {
                          focusNode.requestFocus();
                        }
                        field.didChange(value);
                      },
                activeColor: themeData.primaryColor,
                inactiveColor: themeData.unselectedWidgetColor.withOpacity(0.4),
              ),
            );

            contentColumns.add(slider);

            if (state.hasError) {
              TextOverflow overflow = inline ? TextOverflow.ellipsis : null;
              Text error = Text(state.errorText,
                  overflow: overflow,
                  style: FormThemeData.getErrorStyle(themeData));
              contentColumns.add(error);
            }

            columns.add(Padding(
              padding: contentPadding,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contentColumns),
            ));
            return Padding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columns,
                ),
                padding: padding ?? formThemeData.padding ?? EdgeInsets.zero);
          },
        );

  @override
  _SliderFieldState createState() => _SliderFieldState();
}

class _SliderFieldState extends ValueFieldState<double> {
  @override
  SliderFormField get widget => super.widget as SliderFormField;
  @override
  double get value => super.value == null ? getState('min') : super.value;
}

class RangeSliderController extends ValueNotifier<RangeValues> {
  RangeSliderController({RangeValues value}) : super(value);
}

class RangeSliderFormField extends ValueField<RangeValues> {
  RangeSliderFormField(RangeSliderController controller,
      {ValueChanged<RangeValues> onChanged,
      FormFieldValidator<RangeValues> validator,
      AutovalidateMode autovalidateMode,
      bool readOnly,
      double max,
      double min,
      String label,
      EdgeInsets padding,
      bool inline,
      int divisions,
      RangeValues initialValue,
      RangeSubLabelRender rangeSubLabelRender,
      EdgeInsets contentPadding})
      : super(
            controller,
            {
              'divisions': divisions,
              'max': max,
              'min': min,
              'label': label,
              'contentPadding': contentPadding ?? EdgeInsets.zero
            },
            readOnly: readOnly,
            padding: padding,
            onChanged: onChanged,
            validator: validator,
            initialValue: initialValue,
            replace: () => RangeValues(min, max),
            autovalidateMode: autovalidateMode,
            builder: (field) {
              final FormThemeData formThemeData =
                  FormThemeData.of(field.context);
              final ThemeData themeData = Theme.of(field.context);
              final ValueFieldState<RangeValues> state = field;

              int divisions = state.getState('divisions');
              double max = state.getState('max');
              double min = state.getState('min');
              String label = state.getState('label');
              bool readOnly = state.readOnly;
              EdgeInsets padding = state.padding;
              EdgeInsets contentPadding = state.getState('contentPadding');

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

              if (rangeSubLabelRender != null) {
                contentColumns.add(Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: ((controller.value.start - min) *
                                  100 /
                                  (max - min))
                              .round(),
                          child: const SizedBox(),
                        ),
                        rangeSubLabelRender.startRender(controller.value.start),
                        Expanded(
                          flex: ((max - controller.value.start) *
                                  100 /
                                  (max - min))
                              .round(),
                          child: const SizedBox(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex:
                              ((controller.value.end - min) * 100 / (max - min))
                                  .round(),
                          child: const SizedBox(),
                        ),
                        rangeSubLabelRender.startRender(controller.value.end),
                        Expanded(
                          flex:
                              ((max - controller.value.end) * 100 / (max - min))
                                  .round(),
                          child: const SizedBox(),
                        ),
                      ],
                    )
                  ],
                ));
              }

              Widget slider = SliderTheme(
                data: SliderTheme.of(field.context),
                child: RangeSlider(
                  values: controller.value,
                  min: min,
                  max: max,
                  divisions: divisions ?? (max - min).toInt(),
                  onChanged: readOnly
                      ? null
                      : (RangeValues values) {
                          field.didChange(values);
                        },
                  activeColor: themeData.primaryColor,
                  inactiveColor:
                      themeData.unselectedWidgetColor.withOpacity(0.4),
                ),
              );

              contentColumns.add(slider);

              if (state.hasError) {
                TextOverflow overflow = inline ? TextOverflow.ellipsis : null;
                Text error = Text(state.errorText,
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

              return Padding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: columns,
                  ),
                  padding: padding ?? formThemeData.padding ?? EdgeInsets.zero);
            });
}

class RangeSubLabelRender {
  final SubLabelRender startRender;
  final SubLabelRender endRender;
  RangeSubLabelRender(this.startRender, this.endRender);
}
