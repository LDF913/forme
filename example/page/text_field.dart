import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class TextFieldPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('TextFieldFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(ClearableTextFormField(
                  name: 'textField',
                  onChanged: (v) {
                    formKey.currentManagement
                            .newFormFieldManagement('text')
                            .model =
                        ChangeTextModel(
                            text:
                                'value changed, current value is ${v.toString()}');
                  },
                  model: TextFieldModel(),
                ))
                .oneRowField(ChangeText())
                .build(),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('textField')
                              .model =
                          TextFieldModel(labelText: 'filter textField');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('textField')
                              .model =
                          TextFieldModel(
                              prefixIcon: Icon(Icons.zoom_out_map_sharp));
                    },
                    child: Text('add prefix icon')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('textField')
                          .model = TextFieldModel(suffixIcons: [
                        Icon(Icons.youtube_searched_for),
                        Icon(Icons.video_call)
                      ]);
                    },
                    child: Text('add suffix icon')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('textField')
                              .model =
                          TextFieldModel(
                              style:
                                  TextStyle(fontSize: 20, color: Colors.green),
                              inputDecorationTheme: InputDecorationTheme(
                                  labelStyle: TextStyle(fontSize: 30),
                                  suffixStyle: TextStyle(color: Colors.green)));
                    },
                    child: Text('update textField render data')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                          .newFormFieldManagement('textField')
                          .model = TextFieldModel(maxLines: 2);
                    },
                    child: Text('update maxline to 2')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                          .newFormFieldManagement('textField')
                          .model = TextFieldModel(minLines: 1);
                    },
                    child: Text('update minLines to 1')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('textField')
                              .model =
                          TextFieldModel(toolbarOptions: ToolbarOptions());
                    },
                    child: Text('update toolbarOptions')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                          .newFormFieldManagement('textField')
                          .model = TextFieldModel(maxLength: 10);
                    },
                    child: Text('update maxLength to 10')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('textField')
                              .model =
                          TextFieldModel(
                              textInputAction: TextInputAction.search);
                    },
                    child: Text('update inputAction to search')),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('textField');
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
                      .newFormFieldManagement('textField');
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
                                  BaseLayoutFormFieldManagement>('textField')
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
