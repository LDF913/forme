import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class NumberFieldPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('NumberFieldFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(NumberFormField(
                  name: 'numberField',
                  model: NumberFieldModel(
                    max: 100,
                    allowNegative: false,
                  ),
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
                              .newFormFieldManagement('numberField')
                              .model =
                          NumberFieldModel(labelText: 'filter numberField');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('numberField')
                              .model =
                          NumberFieldModel(
                              prefixIcon: Icon(Icons.zoom_out_map_sharp));
                    },
                    child: Text('add prefix icon')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(suffixIcons: [
                        Icon(Icons.youtube_searched_for),
                        Icon(Icons.video_call)
                      ]);
                    },
                    child: Text('add suffix icon')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
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
                      formKey.currentManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(allowNegative: true);
                    },
                    child: Text('allow negative')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(decimal: 2);
                    },
                    child: Text('allow 2 decimal')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('numberField')
                          .model = NumberFieldModel(max: 19);
                    },
                    child: Text('set max num to 19')),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('numberField');
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
                      .newFormFieldManagement('numberField');
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
                                  BaseLayoutFormFieldManagement>('numberField')
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
