import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class TextFieldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('TextFieldFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(ClearableTextFormField(
                  name: 'textField',
                  onChanged: (v) {
                    formManagement.newFormFieldManagement('text').model =
                        ChangeTextModel(
                            text:
                                'value changed, current value is ${v.toString()}');
                  },
                ))
                .oneRowField(ChangeText()),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(labelText: 'filter textField');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(
                              prefixIcon: Icon(Icons.zoom_out_map_sharp));
                    },
                    child: Text('add prefix icon')),
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(suffixIcons: [
                        Icon(Icons.youtube_searched_for),
                        Icon(Icons.video_call)
                      ]);
                    },
                    child: Text('add suffix icon')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('textField').model =
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
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(maxLines: 2);
                    },
                    child: Text('update maxline to 2')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(minLines: 1);
                    },
                    child: Text('update minLines to 1')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(toolbarOptions: ToolbarOptions());
                    },
                    child: Text('update toolbarOptions')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(maxLength: 10);
                    },
                    child: Text('update maxLength to 10')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('textField').model =
                          TextFieldModel(
                              textInputAction: TextInputAction.search);
                    },
                    child: Text('update inputAction to search')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('textField')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('textField')
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
                      .newFormFieldManagement('textField')
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
                          .newFormFieldManagement('textField')
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
