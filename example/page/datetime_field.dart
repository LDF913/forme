import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class DateTimeFieldPage extends BasePage<DateTime, FormeDateTimeFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeDateTimeField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeDateTimeFieldModel(
                textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(labelText: 'DateTime'),
            )),
            validator: (value) => value == null ? 'select a datetime!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('change type to DateTime', () async {
              management.update(FormeDateTimeFieldModel(
                type: FormeDateTimeFieldType.DateTime,
              ));
            }),
            createButton('change picker entry mode', () async {
              management.update(FormeDateTimeFieldModel(
                initialEntryMode: TimePickerEntryMode.input,
              ));
            }),
            createButton('change formatter', () async {
              management.update(FormeDateTimeFieldModel(
                formatter: (time) => time.toString(),
              ));
            }),
            createButton('update labelText', () async {
              management.update(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              management.update(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              management.update(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              management.update(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              management.update(FormeDateTimeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      management.value = DateTime.now();
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              management.update(FormeDateTimeFieldModel(
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
