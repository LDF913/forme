import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class FilterChipFieldPage extends BasePage<List<String>, FormeFilterChipModel> {
  @override
  Widget get body {
    return Builder(builder: (context) {
      return Column(
        children: [
          FormeInputDecorator(
            decoration: InputDecoration(labelText: 'Filter Chip'),
            child: FormeFilterChip<String>(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: name,
              items: FormeUtils.toFormeChipItems(['flutter', 'android', 'iOS']),
              model: FormeFilterChipModel(
                exceedCallback: () =>
                    showError(context, 'you can select only  one item!'),
              ),
              validator: (value) =>
                  value.length < 2 ? 'select at least two items!' : null,
            ),
          ),
          Wrap(
            children: [
              createButton('set selectable count to 1', () async {
                management.update(FormeFilterChipModel<String>(
                  count: 1,
                ));
              }),
              createButton('update items', () async {
                management.update(FormeFilterChipModel<String>(
                  items: FormeUtils.toFormeChipItems(['java', 'c#', 'python']),
                ));
              }),
              createButton('update labelText', () async {
                updateDecoration(
                    (_) => _.copyWith(labelText: 'New Label Text'));
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
    });
  }

  @override
  String get title => 'FormeFilterChip';
}
