import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

final FormManagement formManagement = FormManagement();

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ButtonFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            ).append(ButtonFormField(
              name: 'button',
              child: Text('Button'),
              onPressed: (info) => {},
            )),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('button').model =
                          ButtonModel(
                              child: Text('new content'),
                              icon: Icon(Icons.accessible_forward_rounded),
                              style: ButtonStyle(alignment: Alignment.center));
                    },
                    child: Text('update button content')),
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('button').model =
                          ButtonModel(type: ButtonType.Outlined);
                    },
                    child: Text('update button type')),
                Builder(builder: (context) {
                  BaseFormFieldManagement management = formManagement
                      .newFormFieldManagement('button')
                      .cast<BaseFormFieldManagement>();
                  return OutlinedButton(
                      onPressed: () {
                        management.visible = !management.visible;
                        (context as Element).markNeedsBuild();
                      },
                      child: Text(management.visible ? 'hide' : 'show'));
                }),
                Builder(builder: (context) {
                  BaseFormFieldManagement management = formManagement
                      .newFormFieldManagement('button')
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
                      formManagement
                          .newFormFieldManagement('button')
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
