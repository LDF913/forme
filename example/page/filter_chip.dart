import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class FilterChipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FilterChipFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(FilterChipFormField<String>(
                    name: 'chip',
                    onChanged: (v) async {
                      formManagement.newFormFieldManagement('text').model =
                          ChangeTextModel(
                              text: 'value changed, current value is $v');
                    },
                    items: FormBuilderUtils.toFilterChipItems(
                        ['flutter', 'android', 'iOS'])))
                .append(ChangeText()),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('chip').model =
                          FilterChipModel(
                              items: FormBuilderUtils.toFilterChipItems(
                                  ['flutter', 'android', 'iOS', 'linux']));
                    },
                    child: Text('update items')),
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('chip').model =
                          FilterChipModel<String>(labelText: 'filter chip');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('chip').model =
                          FilterChipModel<String>(
                              filterChipRenderData: FilterChipRenderData(
                                  selectedColor: Colors.yellow,
                                  backgroundColor:
                                      Colors.pink.withOpacity(0.3)));
                    },
                    child: Text('update chip render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('chip')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('chip')
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
                      .newFormFieldManagement('chip')
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
                          .newFormFieldManagement('chip')
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
