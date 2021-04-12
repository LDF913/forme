import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

class SliderController extends ValueNotifier<double> {
  SliderController({double value}) : super(value);
}

class SliderFormField extends FormBuilderField<double> {
  final EdgeInsets padding;
  final int divisions;
  final double max;
  final double min;

  SliderFormField(String controlKey, SliderController controller,
      {Key key,
      String labelText,
      bool readOnly,
      ValueChanged<double> onChanged,
      FormFieldValidator<double> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      double initialValue,
      this.divisions,
      this.max,
      this.min,
      FocusNode focusNode})
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

            return Padding(
                child: Slider(
                  focusNode: focusNode,
                  value: controller.value,
                  min: min,
                  max: max,
                  divisions: divisions ?? (max - min).toInt(),
                  label: controller.value.round().toString(),
                  onChanged: (double value) {
                    field.didChange(value);
                  },
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
  double get value => super.value == null ? widget.min : super.value.round();
}
