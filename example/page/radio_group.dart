import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class RadioGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RadioGroupFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(ListTileFormField<String>(
                  items: FormBuilderUtils.toListTileItems(['1', '2', '3']),
                  type: ListTileItemType.Radio,
                  name: 'radioGroup',
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
                          .newFormFieldManagement('radioGroup')
                          .model = ListTileModel<String>(split: 1);
                    },
                    child: Text('update split')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('radioGroup')
                              .model =
                          ListTileModel<String>(
                              items: FormBuilderUtils.toListTileItems(
                                  ['4', '5', '6']));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('radioGroup')
                              .model =
                          ListTileModel<String>(labelText: 'filter radioGroup');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement
                              .newFormFieldManagement('radioGroup')
                              .model =
                          ListTileModel<String>(
                              listTileThemeData: ListTileThemeData(
                                  selectedColor: Colors.pink,
                                  textColor: Colors.deepOrange),
                              radioRenderData:
                                  RadioRenderData(activeColor: Colors.pink));
                    },
                    child: Text('update radioGroup render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('radioGroup')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('radioGroup')
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
                      .newFormFieldManagement('radioGroup')
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
                          .newFormFieldManagement('radioGroup')
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
