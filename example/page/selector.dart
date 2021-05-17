import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

final FormManagement formManagement = FormManagement();

class SelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SelectorFormField'),
        ),
        body: Column(
          children: [
            FormBuilder(
              formManagement: formManagement,
            )
                .oneRowField(SelectorFormField(
                  name: 'selector',
                  labelText: 'selector',
                  multi: false,
                  selectItemProvider: (page, params) {
                    RangeValues filter = params['filter'];
                    List<int> items = List<int>.generate(100, (i) => i + 1)
                        .where((element) =>
                            element >= filter.start.round() &&
                            element <= filter.end.round())
                        .toList();
                    return Future.delayed(Duration(seconds: 1), () {
                      return SelectItemPage<int>(
                          items.sublist(
                              (page - 1) * 20,
                              page * 20 > items.length
                                  ? items.length
                                  : page * 20),
                          items.length);
                    });
                  },
                  queryFormBuilder: (builder, query) {
                    builder
                        .append(RangeSliderFormField(
                            name: 'filter', min: 1, max: 100))
                        .append(ButtonFormField(
                            onPressed: (info) {
                              query();
                            },
                            child: Text('query')));
                  },
                  onSelectDialogShow: (formManagement) {
                    //use this formManagement to control query form on search dialog
                    formManagement
                        .newFormFieldManagement('filter')
                        .valueFieldManagement
                        .value = RangeValues(20, 50);
                    return true; //return true will set params before query
                  },
                  selectedItemLayoutType: SelectedItemLayoutType.scroll,
                  onChanged: (v) =>
                      formManagement.newFormFieldManagement('text').model =
                          ChangeTextModel(
                              text: 'selector value changed, current value $v'),
                ))
                .oneRowField(ChangeText()),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('selector').model =
                          SelectorModel(multi: true);
                    },
                    child: Text('change to mutil selector')),
                OutlinedButton(
                    onPressed: () {
                      formManagement.newFormFieldManagement('selector').model =
                          SelectorModel(labelText: 'filter selector');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formManagement.newFormFieldManagement('selector').model =
                          SelectorModel(
                              selectorThemeData: SelectorThemeData(
                                  listTileThemeData:
                                      ListTileThemeData(textColor: Colors.red),
                                  inputDecorationTheme: InputDecorationTheme(
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(fontSize: 30)),
                                  chipThemeData: ChipTheme.of(context).copyWith(
                                      selectedColor: Colors.green,
                                      backgroundColor: Colors.pink,
                                      deleteIconColor: Colors.green)));
                    },
                    child: Text('update selector render data')),
                OutlinedButton(
                    onPressed: () {
                      formManagement
                          .newFormFieldManagement('selector')
                          .cast<BaseFormValueFieldManagement>()
                          .shake();
                    },
                    child: Text('shake')),
                Builder(builder: (context) {
                  BaseFormValueFieldManagement management = formManagement
                      .newFormFieldManagement('selector')
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
                      .newFormFieldManagement('selector')
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
                          .newFormFieldManagement('selector')
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
