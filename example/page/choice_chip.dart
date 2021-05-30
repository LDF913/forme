import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class ChoiceChipFieldPage extends BasePage<String, FormeChoiceChipModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeInputDecorator(
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
              management.update(FormeChoiceChipModel<String>(
                items: FormeUtils.toFormeChipItems(['java', 'c#', 'python']),
              ));
            }),
            createButton('update labelText', () async {
              updateDecoration((_) => _.copyWith(labelText: 'New Label Text'));
            }),
            createButton('update labelStyle', () {
              updateDecoration((_) => _.copyWith(
                  labelStyle:
                      TextStyle(fontSize: 30, color: Colors.pinkAccent)));
            }),
            createButton('set helper text', () {
              updateDecoration((_) => _.copyWith(helperText: 'helper text'));
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
  String get title => 'FormeChoiceChip';
}
