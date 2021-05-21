import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/src/field/cupertino_picker.dart';
import 'change_text.dart';
import 'package:form_builder/form_builder.dart';

class CupertinoPickerPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>.generate(
        100,
        (index) => Center(
              child: Text(index.toString()),
            ));
    return Scaffold(
        appBar: AppBar(
          title: Text('CupertinoPickerFormField'),
        ),
        body: Column(
          children: [
            FormBuilder().key(formKey).build(
                    child: Column(
                  children: [
                    Container(
                      child: CupertinoPickerFormField(
                        name: 'picker',
                        initialValue: 0,
                        onChanged: (v) async {
                          formKey.currentManagement
                                  .newFormFieldManagement('text')
                                  .model =
                              ChangeTextModel(
                                  text: 'value changed, current value is $v');
                        },
                        model: CupertinoPickerModel(
                          itemExtent: 30,
                          children: children,
                        ),
                      ),
                    ),
                    ChangeText()
                  ],
                )),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('picker')
                              .model =
                          CupertinoPickerModel(
                              children: List<Widget>.generate(
                                  10, (index) => Text(index.toString())));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {}, child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('picker')
                              .model =
                          CupertinoPickerModel(
                              useMagnifier: true,
                              magnification: 1.5,
                              itemExtent: 50,
                              looping: true,
                              selectionOverlay: Text('I\'m overlay'));
                    },
                    child: Text('update picker model')),
                Builder(builder: (context) {
                  FormFieldManagement management = formKey.currentManagement
                      .newFormFieldManagement('picker');
                  return OutlinedButton(
                      onPressed: () {
                        management.readOnly = !management.readOnly;
                        (context as Element).markNeedsBuild();
                      },
                      child:
                          Text(management.readOnly ? 'editable' : 'readOnly'));
                }),
              ],
            )
          ],
        ));
  }
}
