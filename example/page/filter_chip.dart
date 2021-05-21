import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'change_text.dart';
import 'package:form_builder/form_builder.dart';

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
                    model: FilterChipModel<String>(
                      items: FormBuilderUtils.toFilterChipItems(
                          ['flutter', 'android', 'iOS']),
                    ),
                    onChanged: (v) async {
                      formKey.currentManagement
                              .newFormFieldManagement('text')
                              .model =
                          ChangeTextModel(
                              text: 'value changed, current value is $v');
                    }))
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
                  BaseLayoutFormFieldManagement management =
                      formKey.currentManagement.newFormFieldManagement('chip');
                  bool visible = management.layoutParam?.visible ?? true;
                  return OutlinedButton(
                      onPressed: () {
                        management.layoutParam = LayoutParam(visible: !visible);
                        (context as Element).markNeedsBuild();
                      },
                      child: Text(visible ? 'hide' : 'show'));
                }),
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management =
                      formKey.currentManagement.newFormFieldManagement('chip');
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
                                  BaseLayoutFormFieldManagement>('chip')
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
