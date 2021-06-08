import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class ChoiceChipFieldPage extends BasePage<String, FormeChoiceChipModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeInputDecorator(
          name: name,
          decoration: InputDecoration(labelText: 'Choice Chip'),
          child: FormeChoiceChip<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            items: FormeUtils.toFormeChipItems(['flutter', 'android', 'iOS']),
            model: FormeChoiceChipModel(),
            validator: (value) => value == null ? 'select one item!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('update items', () async {
              controller.updateModel(FormeChoiceChipModel<String>(
                items: FormeUtils.toFormeChipItems(['java', 'c#', 'python']),
              ));
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
  String get title => 'FormeChoiceChip';
}
