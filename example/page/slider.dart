import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class SliderFieldPage extends BasePage<double, FormeSliderModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeInputDecorator(
          name: name,
          decoration: InputDecoration(labelText: 'Slider'),
          child: FormeSlider(
            min: 1,
            max: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeSliderModel(),
            validator: (value) => value < 50
                ? 'value must bigger than 50 ,current is $value'
                : null,
          ),
        ),
        Wrap(
          children: [
            createButton('set min to 20', () async {
              controller.updateModel(FormeSliderModel(
                min: 20,
              ));
            }),
            createButton('set max to 150', () async {
              controller.updateModel(FormeSliderModel(
                max: 150,
              ));
            }),
            createButton('set divisions to 5', () async {
              controller.updateModel(FormeSliderModel(
                divisions: 5,
              ));
            }),
            createButton('update theme data', () async {
              controller.updateModel(FormeSliderModel(
                sliderThemeData: SliderThemeData(
                  thumbColor: Colors.red,
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.purpleAccent,
                ),
              ));
            }),
            createButton('update labelText', () async {
              updateLabel();
            }),
            createButton('update labelStyle', () {
              updateLabelStyle();
            }),
            createButton('set helper text', () {
              updateHelperStyle();
            }),
            createButton('validate', () {
              controller.validate();
            }),
            Builder(builder: (context) {
              return createButton('quietly validate', () {
                String? error = controller.quietlyValidate();
                if (error != null) showError(context, error);
              });
            }),
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeSlider';
}
