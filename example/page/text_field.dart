import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class TextFieldPage extends BasePage<String, FormeTextFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeTextField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validateErrorListener: (field, errorText) {
              controller.updateModel(FormeTextFieldModel(
                  decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontSize: 30,
                  color: errorText == null ? Colors.green : Colors.red,
                ),
              )));
            },
            name: name,
            model: FormeTextFieldModel(
              decoration: InputDecoration(labelText: 'TextField'),
            ),
            validator: (value) => value.length < 8
                ? 'value length must bigger than 8,current length is ${value.length}'
                : null,
          ),
        ),
        Wrap(
          children: [
            createButton('update labelText', () {
              controller.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(labelText: 'New Label Text'),
              ));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(
                    labelStyle:
                        TextStyle(fontSize: 30, color: Colors.pinkAccent)),
              ));
            }),
            createButton('update style', () {
              controller.updateModel(FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              ));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(helperText: 'helper text'),
              ));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeTextFieldModel(
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            controller.value = 'prefix icon';
                            WidgetsBinding.instance!
                                .addPostFrameCallback((timeStamp) {
                              controller.updateModel(FormeTextFieldModel(
                                selection: FormeUtils.selection(
                                    controller.value!.length,
                                    controller.value!.length),
                              ));
                            });
                          },
                          icon: Icon(Icons.set_meal)))));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeTextFieldModel(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.value = '';
                          },
                          icon: Icon(Icons.clear)))));
            }),
            createButton('set maxLines to 1', () {
              controller.updateModel(FormeTextFieldModel(
                maxLines: 1,
              ));
            }),
            createButton('set maxLength to 10', () {
              controller.updateModel(FormeTextFieldModel(
                maxLength: 10,
              ));
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
  String get title => 'FormeTextField';
}
