import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class SwitchTileFieldPage
    extends BasePage<List<String>, FormeListTileModel<String>> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeInputDecorator(
          decoration: InputDecoration(labelText: 'Switch Tile'),
          child: FormeListTile<String>(
            items: [
              FormeListTileItem(
                title: Text('java'),
                data: 'java',
                secondary: Text('secondary1'),
                subtitle: Text('subtitle'),
              ),
              FormeListTileItem(
                title: Text('c#'),
                data: 'c#',
                secondary: Text('secondary2'),
                subtitle: Text('subtitle'),
              ),
              FormeListTileItem(
                title: Text('python'),
                data: 'python',
                secondary: Text('secondary3'),
                subtitle: Text('subtitle'),
              ),
            ],
            type: FormeListTileType.Switch,
            model: FormeListTileModel<String>(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            validator: (value) => value.isEmpty ? 'select one item!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('update items', () async {
              management.update(FormeListTileModel<String>(
                  items: FormeUtils.toFormeListTileItems(
                      ['flutter', 'dart', 'pub'])));
            }),
            createButton('to List Tile', () async {
              management.update(FormeListTileModel<String>(split: 1));
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
  String get title => 'FormeSwitchTile';
}
