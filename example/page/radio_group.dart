import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class RadioGroupPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RadioGroupFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(ListTileFormField<String>(
                  model: ListTileModel(
                    items: FormBuilderUtils.toListTileItems(['1', '2', '3'],
                        controlAffinity: ListTileControlAffinity.trailing),
                  ),
                  type: ListTileItemType.Radio,
                  name: 'radioGroup',
                  onChanged: (v) {
                    formKey.currentManagement
                            .newFormFieldManagement('text')
                            .model =
                        ChangeTextModel(
                            text: 'value changed, current value is $v');
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
                          .newFormFieldManagement('radioGroup')
                          .model = ListTileModel<String>(split: 1);
                    },
                    child: Text('update split')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('radioGroup')
                              .model =
                          ListTileModel<String>(
                              items: FormBuilderUtils.toListTileItems(
                                  ['4', '5', '6']));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('radioGroup')
                              .model =
                          ListTileModel<String>(labelText: 'filter radioGroup');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
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
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('radioGroup');
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
                      .newFormFieldManagement('radioGroup');
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
                                  BaseLayoutFormFieldManagement>('radioGroup')
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
