import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

import 'change_text.dart';

class FilterChipPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FilterChipFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .key(formKey)
                .layoutBuilder()
                .oneRowField(FilterChipFormField<String>(
                    name: 'chip',
                    onChanged: (v) async {
                      formKey.currentManagement
                              .newFormFieldManagement('text')
                              .model =
                          ChangeTextModel(
                              text: 'value changed, current value is $v');
                    },
                    items: FormBuilderUtils.toFilterChipItems(
                        ['flutter', 'android', 'iOS'])))
                .append(ChangeText())
                .build(),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('chip')
                              .model =
                          FilterChipModel(
                              items: FormBuilderUtils.toFilterChipItems(
                                  ['flutter', 'android', 'iOS', 'linux']));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                              .newFormFieldManagement('chip')
                              .model =
                          FilterChipModel<String>(labelText: 'filter chip');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('chip')
                              .model =
                          FilterChipModel<String>(
                              filterChipRenderData: FilterChipRenderData(
                                  selectedColor: Colors.yellow,
                                  backgroundColor:
                                      Colors.pink.withOpacity(0.3)));
                    },
                    child: Text('update chip render data')),
                Builder(builder: (context) {
                  BaseFormFieldManagement management = formKey.currentManagement
                      .newFormFieldManagement('chip')
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
                      .newFormFieldManagement('chip')
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
                          .newFormFieldManagement('chip')
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
