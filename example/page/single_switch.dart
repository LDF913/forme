import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class SingleSwitchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SingleSwitchFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(SingleSwitchFormField(
                  name: 'switch',
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
                      formManagement.newFormFieldManagement('switch').model =
                          SingleSwitchModel(label: Text('new label'));
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('switch').model =
                          SingleSwitchModel(
                              switchRenderData: SwitchRenderData(
                                  activeColor: Colors.red,
                                  inactiveThumbColor: Colors.pink,
                                  activeTrackColor: Colors.yellow));
                    },
                    child: Text('update switch render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('switch')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('switch')
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
                      .newFormFieldManagement('switch')
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
                          .newFormFieldManagement('switch')
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
