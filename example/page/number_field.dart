import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class NumberFieldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('NumberFieldFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(NumberFormField(
                  name: 'numberField',
                  max: 100,
                  allowNegative: false,
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
                              .newFormFieldManagement('numberField')
                              .model =
                          NumberFieldModel(labelText: 'filter numberField');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('numberField')
                              .model =
                          NumberFieldModel(
                              prefixIcon: Icon(Icons.zoom_out_map_sharp));
                    },
                    child: Text('add prefix icon')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(suffixIcons: [
                        Icon(Icons.youtube_searched_for),
                        Icon(Icons.video_call)
                      ]);
                    },
                    child: Text('add suffix icon')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement
                              .newFormFieldManagement('numberField')
                              .model =
                          NumberFieldModel(
                              style:
                                  TextStyle(fontSize: 20, color: Colors.green),
                              inputDecorationTheme: InputDecorationTheme(
                                  labelStyle: TextStyle(fontSize: 30),
                                  suffixStyle: TextStyle(color: Colors.green)));
                    },
                    child: Text('update numberField render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(allowNegative: true);
                    },
                    child: Text('allow negative')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(decimal: 2);
                    },
                    child: Text('allow 2 decimal')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(max: 19);
                    },
                    child: Text('set max num to 19')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('numberField')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('numberField')
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
                      .newFormFieldManagement('numberField')
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
                          .newFormFieldManagement('numberField')
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
