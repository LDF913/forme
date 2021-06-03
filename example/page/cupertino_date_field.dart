import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forme/forme.dart';

import 'base_page.dart';

class CupertinoDateFieldPage
    extends BasePage<DateTime, FormeCupertinoDateFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeCupertinoDateField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            validator: (value) => value == null ? 'select a date!' : null,
            model: FormeCupertinoDateFieldModel(
                bottomSheetRenderData: FormeBottomSheetRenderData(
                  afterClose: () => print('close'),
                ),
                textFieldModel: FormeTextFieldModel(
                  decoration: InputDecoration(labelText: 'Cupertino Date'),
                )),
          ),
        ),
        Wrap(
          children: [
            createButton('set type to datetime', () async {
              controller.updateModel(FormeCupertinoDateFieldModel(
                type: FormeDateTimeFieldType.DateTime,
              ));
            }),
            createButton('set type to date', () async {
              controller.updateModel(FormeCupertinoDateFieldModel(
                type: FormeDateTimeFieldType.Date,
              ));
            }),
            createButton('set maximumDate to prev day', () async {
              controller.updateModel(FormeCupertinoDateFieldModel(
                maximumDate: DateTime.now().add(Duration(days: -1)),
              ));
            }),
            createButton('set minuteInterval to 5', () async {
              controller.updateModel(FormeCupertinoDateFieldModel(
                minuteInterval: 5,
              ));
            }),
            createButton('update labelText', () async {
              controller.updateModel(FormeCupertinoDateFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeCupertinoDateFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              controller.updateModel(FormeCupertinoDateFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeCupertinoDateFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeCupertinoDateFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      controller.value = DateTime(2021, 6, 3);
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeCupertinoDateFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      controller.value = null;
                    },
                  ),
                ),
              )));
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
  String get title => 'FormeCupertinoTimerField';
}
