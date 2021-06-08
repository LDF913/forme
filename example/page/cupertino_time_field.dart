import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forme/forme.dart';
import 'base_page.dart';

class CupertinoTimerFieldPage
    extends BasePage<Duration, FormeCupertinoTimerFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeCupertinoTimerField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeCupertinoTimerFieldModel(
                textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(labelText: 'Cupertino Timer'),
            )),
            validator: (value) => value == null ? 'select a duration!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('change mode to ms', () async {
              controller.updateModel(FormeCupertinoTimerFieldModel(
                mode: CupertinoTimerPickerMode.ms,
              ));
            }),
            createButton('update', () async {
              controller.updateModel(FormeCupertinoTimerFieldModel(
                minuteInterval: 10,
                secondInterval: 10,
                backgroundColor: Colors.purple.withOpacity(0.3),
              ));
            }),
            createButton('update labelText', () async {
              controller.updateModel(FormeCupertinoTimerFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeCupertinoTimerFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              controller.updateModel(FormeCupertinoTimerFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeCupertinoTimerFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeCupertinoTimerFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      controller.value = Duration(minutes: 72);
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeCupertinoTimerFieldModel(
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
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeCupertinoTimerField';
}
