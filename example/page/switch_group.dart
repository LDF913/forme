import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class SwitchGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SwitchGroupFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(ListTileFormField<String>(
                  items: FormBuilderUtils.toListTileItems(['1', '2', '3']),
                  type: ListTileItemType.Switch,
                  split: 3,
                  name: 'switchGroup',
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
                          .newFormFieldManagement('switchGroup')
                          .model = ListTileModel<String>(split: 1);
                    },
                    child: Text('update split')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('switchGroup')
                              .model =
                          ListTileModel<String>(
                              items: FormBuilderUtils.toListTileItems(
                                  ['4', '5', '6']));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                              .newFormFieldManagement('switchGroup')
                              .model =
                          ListTileModel<String>(
                              labelText: 'filter switchGroup');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement
                              .newFormFieldManagement('switchGroup')
                              .model =
                          ListTileModel<String>(
                              listTileThemeData: ListTileThemeData(
                                  selectedColor: Colors.pink,
                                  textColor: Colors.deepOrange),
                              switchRenderData:
                                  SwitchRenderData(activeColor: Colors.pink));
                    },
                    child: Text('update switchGroup render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('switchGroup')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('switchGroup')
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
                      .newFormFieldManagement('switchGroup')
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
                          .newFormFieldManagement('switchGroup')
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
