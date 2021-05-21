import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class SliderPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SliderFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(SliderFormField(
                  name: 'slider',
                  model: SliderModel(
                    min: 0,
                    max: 100,
                  ),
                  onChanged: (v) {
                    formKey.currentManagement
                            .newFormFieldManagement('text')
                            .model =
                        ChangeTextModel(
                            text:
                                'value changed, current value is ${v.round().toString()}');
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
                          .newFormFieldManagement('slider')
                          .model = SliderModel(labelText: 'filter slider');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('slider')
                              .model =
                          SliderModel(
                              activeColor: Colors.red,
                              inactiveColor: Colors.green);
                    },
                    child: Text('update slider render data')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('slider')
                          .model = SliderModel(divisions: 10);
                    },
                    child: Text('update divisions')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('slider')
                          .model = SliderModel(min: 40, max: 90);
                    },
                    child: Text('update min & max')),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('slider');
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
                      .newFormFieldManagement('slider');
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
                                  BaseLayoutFormFieldManagement>('slider')
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
