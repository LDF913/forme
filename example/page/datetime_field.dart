import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class DateTimeFieldPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DateTimeFieldFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(DateTimeFormField(
                  model: DateTimeFieldModel(),
                  name: 'dateTimeField',
                  onChanged: (v) {
                    formKey.currentManagement
                            .newFormFieldManagement('text')
                            .model =
                        ChangeTextModel(
                            text:
                                'value changed, current value is ${v.toString()}');
                  },
                ))
                .oneRowField(ChangeText())
                .build(),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('dateTimeField')
                              .model =
                          DateTimeFieldModel(labelText: 'filter dateTimeField');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
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
                      formKey.currentManagement
                              .newFormFieldManagement('dateTimeField')
                              .model =
                          DateTimeFieldModel(
                              firstDate: DateTime.now().add(Duration(days: 1)));
                    },
                    child: Text('set first day to tomorrow')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('dateTimeField')
                              .model =
                          DateTimeFieldModel(type: DateTimeType.DateTime);
                    },
                    child: Text('allow datetime')),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('dateTimeField');
                  bool visible = management.layoutParam?.visible ?? true;
                  return OutlinedButton(
                      onPressed: () {
                        management.layoutParam = LayoutParam(visible: !visible);
                        (context as Element).markNeedsBuild();
                      },
                      child: Text(visible ? 'hide' : 'show'));
                }),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('dateTimeField');
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
                      formKey.currentManagement
                              .newFormFieldManagement<
                                  BaseLayoutFormFieldManagement>('dateTimeField')
                              .layoutParam =
                          LayoutParam(padding: EdgeInsets.all(20));
                    },
                    child: Text('update padding')),
              ],
            )
          ],
        ));
  }
}
