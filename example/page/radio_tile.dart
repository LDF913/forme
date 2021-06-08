import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';
import 'package:forme/src/field/forme_radio_group.dart';

class RadioTileFieldPage
    extends BasePage<String, FormeRadioGroupModel<String>> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeInputDecorator(
          name: name,
          decoration: InputDecoration(labelText: 'Radio Tile'),
          child: FormeRadioGroup<String>(
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
            model: FormeRadioGroupModel<String>(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            validator: (value) => value == null ? 'select one item!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('update items', () async {
              controller.updateModel(FormeRadioGroupModel<String>(
                  items: FormeUtils.toFormeListTileItems(
                      ['flutter', 'dart', 'pub'])));
            }),
            createButton('to List Tile', () async {
              controller.updateModel(FormeRadioGroupModel<String>(split: 1));
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
              controller.validate();
            }),
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeRadioTile';
}
