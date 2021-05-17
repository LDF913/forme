import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class CheckboxGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CheckboxGroupFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(ListTileFormField<String>(
                  items: FormBuilderUtils.toListTileItems(['1', '2', '3']),
                  type: ListTileItemType.Checkbox,
                  split: 3,
                  name: 'checkboxGroup',
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
                      formManagement
                          .newFormFieldManagement('checkboxGroup')
                          .model = ListTileModel<String>(split: 1);
                    },
                    child: Text('update split')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('checkboxGroup')
                              .model =
                          ListTileModel<String>(
                              items: FormBuilderUtils.toListTileItems(
                                  ['4', '5', '6']));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('checkboxGroup')
                              .model =
                          ListTileModel<String>(
                              labelText: 'filter checkboxGroup');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement
                              .newFormFieldManagement('checkboxGroup')
                              .model =
                          ListTileModel<String>(
                              listTileThemeData: ListTileThemeData(
                                  selectedColor: Colors.pink,
                                  textColor: Colors.deepOrange),
                              checkboxRenderData:
                                  CheckboxRenderData(activeColor: Colors.pink));
                    },
                    child: Text('update checkboxGroup render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('checkboxGroup')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('checkboxGroup')
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
                      .newFormFieldManagement('checkboxGroup')
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
                          .newFormFieldManagement('checkboxGroup')
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
