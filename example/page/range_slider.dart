import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class RangeSliderPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RangeSliderFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(RangeSliderFormField(
                  name: 'rangeSlider',
                  max: 100,
                  min: 1,
                  onChanged: (v) {
                    formKey.currentManagement
                            .newFormFieldManagement('text')
                            .model =
                        ChangeTextModel(
                            text:
                                'value changed, current value is ${v.start.round().toString()} - ${v.end.round().toString()}');
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
                          .newFormFieldManagement('rangeSlider')
                          .model = SliderModel(labelText: 'filter rangeSlider');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('rangeSlider')
                              .model =
                          SliderModel(
                              activeColor: Colors.red,
                              inactiveColor: Colors.green);
                    },
                    child: Text('update rangeSlider render data')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('rangeSlider')
                          .model = SliderModel(divisions: 10);
                    },
                    child: Text('update divisions')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('rangeSlider')
                          .model = SliderModel(min: 40, max: 90);
                    },
                    child: Text('update min & max')),
                Builder(builder: (context) {
                  BaseFormFieldManagement management = formKey.currentManagement
                      .newFormFieldManagement('rangeSlider')
                      .cast<BaseFormFieldManagement>();
                  return OutlinedButton(
                      onPressed: () {
                        management.visible = !management.visible;
                        (context as Element).markNeedsBuild();
                      },
                      child: Text(management.visible ? 'hide' : 'show'));
                }),
                Builder(builder: (context) {
                  BaseFormFieldManagement management = formKey.currentManagement
                      .newFormFieldManagement('rangeSlider')
                      .cast<BaseFormFieldManagement>();
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
                          .newFormFieldManagement('rangeSlider')
                          .cast<BaseFormFieldManagement>()
                          .padding = const EdgeInsets.all(20);
                    },
                    child: Text('update padding')),
              ],
            )
          ],
        ));
  }
}
