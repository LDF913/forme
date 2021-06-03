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
                controller.updateModel(FormeFilterChipModel<String>(
                  count: 1,
                ));
              }),
              createButton('update items', () async {
                controller.updateModel(FormeFilterChipModel<String>(
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
    });
  }

  @override
  String get title => 'FormeFilterChip';
}
