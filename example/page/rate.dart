import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class RatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RateFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(RateFormField(
                  name: 'rate',
                  onChanged: (v) {
                    formManagement.newFormFieldManagement('text').model =
                        ChangeTextModel(
                            text: 'value changed, current value is $v');
                  },
                ))
                .oneRowField(ChangeText()),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('rate').model =
                          RateModel(labelText: 'filter rate');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('rate').model =
                          RateModel(
                              rateThemeData: RateThemeData(
                                  icon: Icons.access_alarm_rounded,
                                  seletedColor: Colors.red));
                    },
                    child: Text('update rate render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('rate')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('rate')
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
                      .newFormFieldManagement('rate')
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
                          .newFormFieldManagement('rate')
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
