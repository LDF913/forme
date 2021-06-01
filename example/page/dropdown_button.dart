import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class DropdownButtonFieldPage
    extends BasePage<String, FormeDropdownButtonModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeDropdownButton<String>(
            items: FormeUtils.toDropdownMenuItems(['flutter', 'react native']),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeDropdownButtonModel(
              decoration: InputDecoration(labelText: 'dropdown'),
            ),
            validator: (value) => value == null ? 'pls select one item!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('update items', () async {
              management.update(FormeDropdownButtonModel<String>(
                  items: FormeUtils.toDropdownMenuItems(
                      ['java', 'dart', 'c#', 'python', 'flutter'])));
            }),
            createButton('update labelText', () async {
              management.update(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              ));
            }),
            createButton('update labelStyle', () {
              management.update(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              ));
            }),
            createButton('update style', () {
              management.update(FormeDropdownButtonModel<String>(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              ));
            }),
            createButton('set helper text', () {
              management.update(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              ));
            }),
            createButton('set prefix icon', () {
              management.update(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_drop_down_circle),
                    onPressed: () {
                      management.value = 'flutter';
                    },
                  ),
                ),
              ));
            }),
            createButton('set suffix icon', () {
              management.update(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      management.value = null;
                    },
                  ),
                ),
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
  String get title => 'FormeNumberField';
}
