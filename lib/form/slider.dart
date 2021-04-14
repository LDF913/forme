import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

typedef SubLabelRender = Widget Function(double value);

class SliderController extends ValueNotifier<double> {
  SliderController({double value}) : super(value);
}

class SliderFormField extends FormBuilderField<double> {
  final EdgeInsets padding;
  final int divisions;
  final double max;
  final double min;
  final String label;
  final SubLabelRender subLabelRender;
  final bool inline;

  SliderFormField(String controlKey, SliderController controller,
      {Key key,
      bool readOnly,
      ValueChanged<double> onChanged,
      FormFieldValidator<double> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      double initialValue,
      this.divisions,
      this.max,
      this.min,
      this.subLabelRender,
      FocusNode focusNode,
      this.label,
      this.inline = false})
      : assert(controlKey != null, divisions != null),
        super(
          controlKey,
          controller,
          key: key,
          onChanged: onChanged,
          replace: () => min,
          validator: validator,
          initialValue: initialValue ?? min,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final FormThemeData formThemeData = FormThemeData.of(field.context);
            final ThemeData themeData = Theme.of(field.context);
            final _SliderFieldState state = field;
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

            if (subLabelRender != null) {
              columns.add(Row(
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

            columns.add(inline
                ? slider
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: slider,
                  ));

            if (state.hasError) {
              TextOverflow overflow = inline ? TextOverflow.ellipsis : null;
              Text error = Text(state.errorText,
                  overflow: overflow,
                  style: FormThemeData.getErrorStyle(themeData));
              columns.add(error);
            }

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

class _SliderFieldState extends FormBuilderFieldState<double> {
  @override
  SliderFormField get widget => super.widget as SliderFormField;
  @override
  double get value => super.value == null ? widget.min : super.value;
}

class RangeSliderController extends ValueNotifier<RangeValues> {
  RangeSliderController({RangeValues value}) : super(value);
}

class RangeSliderFormField extends FormBuilderField<RangeValues> {
  final EdgeInsets padding;
  final double max;
  final double min;
  final String label;
  final bool inline;
  final int divisions;
  final RangeSubLabelRender rangeSubLabelRender;

  RangeSliderFormField(String controlKey, RangeSliderController controller,
      {ValueChanged<RangeValues> onChanged,
      FormFieldValidator<RangeValues> validator,
      AutovalidateMode autovalidateMode,
      bool readOnly,
      this.max,
      this.min,
      this.label,
      this.padding,
      this.inline,
      this.divisions,
      RangeValues initialValue,
      this.rangeSubLabelRender})
      : super(controlKey, controller,
            onChanged: onChanged,
            validator: validator,
            initialValue: initialValue,
            replace: () => RangeValues(min, max),
            autovalidateMode: autovalidateMode,
            builder: (field) {
              final FormThemeData formThemeData =
                  FormThemeData.of(field.context);
              final ThemeData themeData = Theme.of(field.context);
              final FormBuilderFieldState<RangeValues> state = field;
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

              if (rangeSubLabelRender != null) {
                columns.add(Stack(
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
                  onChanged: (RangeValues values) {
                    field.didChange(values);
                  },
                  activeColor: themeData.primaryColor,
                  inactiveColor:
                      themeData.unselectedWidgetColor.withOpacity(0.4),
                ),
              );

              columns.add(inline
                  ? slider
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: slider,
                    ));

              if (state.hasError) {
                TextOverflow overflow = inline ? TextOverflow.ellipsis : null;
                Text error = Text(state.errorText,
                    overflow: overflow,
                    style: FormThemeData.getErrorStyle(themeData));
                columns.add(error);
              }

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
