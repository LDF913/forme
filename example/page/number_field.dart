import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class NumberFieldPage extends BasePage<num, FormeNumberFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeNumberField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeNumberFieldModel(
                max: 99,
                textFieldModel: FormeTextFieldModel(
                  decoration: InputDecoration(labelText: 'Number'),
                )),
            validator: (value) => value == null || value < 50
                ? 'value must bigger than 50,current value is $value'
                : null,
          ),
        ),
        Wrap(
          children: [
            createButton('set max value to 1000', () async {
              management.update(FormeNumberFieldModel(
                max: 1000,
              ));
            }),
            createButton('set decimal to 2', () async {
              management.update(FormeNumberFieldModel(
                decimal: 2,
              ));
            }),
            createButton('allow negative', () async {
              management.update(FormeNumberFieldModel(
                allowNegative: true,
              ));
            }),
            createButton('update labelText', () async {
              management.update(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              management.update(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              management.update(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              management.update(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              management.update(FormeNumberFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      management.value = 10;
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              management.update(FormeNumberFieldModel(
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
  String get title => 'FormeNumberField';
}
