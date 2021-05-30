import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class TimeFieldPage extends BasePage<TimeOfDay, FormeTimeFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeTimeField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeTimeFieldModel(
                textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(labelText: 'DateTime'),
            )),
            validator: (value) => value == null ? 'select a time!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('change picker entry mode', () async {
              management.update(FormeTimeFieldModel(
                initialEntryMode: TimePickerEntryMode.input,
              ));
            }),
            createButton('change formatter', () async {
              management.update(FormeTimeFieldModel(
                formatter: (timeOfDay) => timeOfDay.toString(),
              ));
            }),
            createButton('update labelText', () async {
              management.update(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              management.update(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              management.update(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              management.update(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              management.update(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      management.value = TimeOfDay.fromDateTime(DateTime.now());
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              management.update(FormeTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      management.value = null;
                    },
                  ),
                ),
              )));
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
  String get title => 'FormeTimeField';
}
