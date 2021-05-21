import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

class ButtonPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ButtonFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .customize(mainAxisAlignment: MainAxisAlignment.center)
                .append(ButtonFormField(
                  name: 'button',
                  child: Text('Button'),
                  onPressed: () => {},
                ))
                .build(),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('button')
                              .model =
                          ButtonModel(
                              child: Text('new content'),
                              icon: Icon(Icons.accessible_forward_rounded),
                              style: ButtonStyle(alignment: Alignment.center));
                    },
                    child: Text('update button content')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('button')
                          .model = ButtonModel(type: ButtonType.Outlined);
                    },
                    child: Text('update button type')),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('button');
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
                      .newFormFieldManagement('button');
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
                                  BaseLayoutFormFieldManagement>('button')
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
