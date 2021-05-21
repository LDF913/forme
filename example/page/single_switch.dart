import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class SingleSwitchPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SingleSwitchFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .customize(mainAxisAlignment: MainAxisAlignment.center)
                .oneRowField(SingleSwitchFormField(
                  model: SingleSwitchModel(),
                  name: 'switch',
                  onChanged: (v) {
                    formKey.currentManagement
                            .newFormFieldManagement('text')
                            .model =
                        ChangeTextModel(
                            text: 'value changed, current value is $v');
                  },
                ))
                .oneRowField(ChangeText(
                  layoutParam: LayoutParam(
                      wrapper: (child) => Center(
                            child: child,
                          )),
                ))
                .build(),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('switch')
                          .model = SingleSwitchModel(label: Text('new label'));
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('switch')
                              .model =
                          SingleSwitchModel(
                              switchRenderData: SwitchRenderData(
                                  activeColor: Colors.red,
                                  inactiveThumbColor: Colors.pink,
                                  activeTrackColor: Colors.yellow));
                    },
                    child: Text('update switch render data')),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('switch');
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
                      .newFormFieldManagement('switch');
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
                                  BaseLayoutFormFieldManagement>('switch')
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
