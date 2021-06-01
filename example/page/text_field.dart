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
              management.update(FormeTextFieldModel(
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
              management.update(FormeTextFieldModel(
                decoration: InputDecoration(labelText: 'New Label Text'),
              ));
            }),
            createButton('update labelStyle', () {
              management.update(FormeTextFieldModel(
                decoration: InputDecoration(
                    labelStyle:
                        TextStyle(fontSize: 30, color: Colors.pinkAccent)),
              ));
            }),
            createButton('update style', () {
              management.update(FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              ));
            }),
            createButton('set helper text', () {
              management.update(FormeTextFieldModel(
                decoration: InputDecoration(helperText: 'helper text'),
              ));
            }),
            createButton('set prefix icon', () {
              management.update(FormeTextFieldModel(
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            management.value = 'prefix icon';
                            WidgetsBinding.instance!
                                .addPostFrameCallback((timeStamp) {
                              management.update(FormeTextFieldModel(
                                selection: FormeUtils.selection(
                                    management.value!.length,
                                    management.value!.length),
                              ));
                            });
                          },
                          icon: Icon(Icons.set_meal)))));
            }),
            createButton('set suffix icon', () {
              management.update(FormeTextFieldModel(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            management.value = '';
                          },
                          icon: Icon(Icons.clear)))));
            }),
            createButton('set maxLines to 1', () {
              management.update(FormeTextFieldModel(
                maxLines: 1,
              ));
            }),
            createButton('set maxLength to 10', () {
              management.update(FormeTextFieldModel(
                maxLength: 10,
              ));
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
  String get title => 'FormeTextField';
}
