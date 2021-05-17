import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class DateTimeFieldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DateTimeFieldFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(DateTimeFormField(
                  name: 'dateTimeField',
                  onChanged: (v) {
                    formManagement.newFormFieldManagement('text').model =
                        ChangeTextModel(
                            text:
                                'value changed, current value is ${v.toString()}');
                  },
                ))
                .oneRowField(ChangeText()),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('dateTimeField')
                              .model =
                          DateTimeFieldModel(labelText: 'filter dateTimeField');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement
                              .newFormFieldManagement('dateTimeField')
                              .model =
                          DateTimeFieldModel(
                              style:
                                  TextStyle(fontSize: 20, color: Colors.green),
                              inputDecorationTheme: InputDecorationTheme(
                                  labelStyle: TextStyle(fontSize: 30),
                                  suffixStyle: TextStyle(color: Colors.green)));
                    },
                    child: Text('update dateTimeField render data')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement
                              .newFormFieldManagement('dateTimeField')
                              .model =
                          DateTimeFieldModel(
                              firstDate: DateTime.now().add(Duration(days: 1)));
                    },
                    child: Text('set first day to tomorrow')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('dateTimeField')
                              .model =
                          DateTimeFieldModel(type: DateTimeType.DateTime);
                    },
                    child: Text('allow datetime')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('dateTimeField')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('dateTimeField')
                      .cast<BaseFormValueFieldManagement>();
                  return OutlinedButton(
                      onPressed: () {
                        management.visible = !management.visible;
                        (context as Element).markNeedsBuild();
                      },
                      child: Text(management.visible ? 'hide' : 'show'));
                }),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('dateTimeField')
                      .cast<BaseFormValueFieldManagement>();
                  return OutlinedButton(
                      onPressed: () {
                        management.readOnly = !management.readOnly;
                        (context as Element).markNeedsBuild();
                      },
                      child:
                          Text(management.readOnly ? 'editable' : 'readOnly'));
                }),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('dateTimeField')
                          .cast<BaseFormValueFieldManagement>()
                          .padding = const EdgeInsets.all(20);
                    },
                    child: Text('update padding')),
              ],
            )
          ],
        ));
  }
}
