import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class SliderFieldPage extends BasePage<double, FormeSliderModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeInputDecorator(
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
              management.update(FormeSliderModel(
                min: 20,
              ));
            }),
            createButton('set max to 150', () async {
              management.update(FormeSliderModel(
                max: 150,
              ));
            }),
            createButton('set divisions to 5', () async {
              management.update(FormeSliderModel(
                divisions: 5,
              ));
            }),
            createButton('update theme data', () async {
              management.update(FormeSliderModel(
                sliderThemeData: SliderThemeData(
                  thumbColor: Colors.red,
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.purpleAccent,
                ),
              ));
            }),
            createButton('update labelText', () async {
              updateDecoration((_) => _.copyWith(labelText: 'New Label Text'));
            }),
            createButton('update labelStyle', () {
              updateDecoration((_) => _.copyWith(
                  labelStyle:
                      TextStyle(fontSize: 30, color: Colors.pinkAccent)));
            }),
            createButton('set helper text', () {
              updateDecoration((_) => _.copyWith(helperText: 'helper text'));
            }),
            createButton('validate', () {
              management.validate();
            }),
            Builder(builder: (context) {
              return createButton('quietly validate', () {
                String? error = management.quietlyValidate();
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
