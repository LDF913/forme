import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class CheckboxGroupPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CheckboxGroupFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(ListTileFormField<String>(
                  type: ListTileItemType.Checkbox,
                  name: 'checkboxGroup',
                  onChanged: (v) {
                    formKey.currentManagement
                            .newFormFieldManagement('text')
                            .model =
                        ChangeTextModel(
                            text: 'value changed, current value is $v');
                  },
                  model: ListTileModel(
                    items: FormBuilderUtils.toListTileItems(['1', '2', '3']),
                    split: 3,
                  ),
                ))
                .oneRowField(ChangeText())
                .build(),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('checkboxGroup')
                          .model = ListTileModel<String>(split: 1);
                    },
                    child: Text('update split')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('checkboxGroup')
                              .model =
                          ListTileModel<String>(
                              items: FormBuilderUtils.toListTileItems(
                                  ['4', '5', '6']));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('checkboxGroup')
                              .model =
                          ListTileModel<String>(
                              labelText: 'filter checkboxGroup');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
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
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement<BaseLayoutFormFieldManagement>(
                          'checkboxGroup');
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
                      .newFormFieldManagement('checkboxGroup');
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
                                  BaseLayoutFormFieldManagement>('checkboxGroup')
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
