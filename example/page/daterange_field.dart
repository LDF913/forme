import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class DateRangeFieldPage
    extends BasePage<DateTimeRange, FormeDateRangeFieldModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeDateRangeField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeDateRangeFieldModel(
                textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(labelText: 'DateRange'),
            )),
            validator: (value) => value == null ? 'select a date range!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('set firstDate to tomorrow', () async {
              DateTime now = DateTime.now();
              management.update(FormeDateRangeFieldModel(
                firstDate: DateTime(now.year, now.month, now.day + 1),
              ));
            }),
            createButton('set lastDate to next month', () async {
              DateTime now = DateTime.now();
              management.update(FormeDateRangeFieldModel(
                lastDate: DateTime(now.year, now.month + 1, now.day),
              ));
            }),
            createButton('change picker entry mode', () async {
              management.update(FormeDateRangeFieldModel(
                initialEntryMode: DatePickerEntryMode.input,
              ));
            }),
            createButton('change formatter', () async {
              management.update(FormeDateRangeFieldModel(
                formatter: (range) => range.toString(),
              ));
            }),
            createButton('update labelText', () async {
              management.update(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              )));
            }),
            createButton('update labelStyle', () {
              management.update(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              )));
            }),
            createButton('update style', () {
              management.update(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )));
            }),
            createButton('set helper text', () {
              management.update(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              )));
            }),
            createButton('set prefix icon', () {
              management.update(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {
                      DateTime now = DateTime.now();
                      management.value = DateTimeRange(
                          start: now,
                          end: DateTime(now.year, now.month + 1, now.day));
                    },
                  ),
                ),
              )));
            }),
            createButton('set suffix icon', () {
              management.update(FormeDateRangeFieldModel(
                  textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      management.value = null;
                    },
                  ),
                ),
              )));
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
  String get title => 'FormeTimeField';
}
