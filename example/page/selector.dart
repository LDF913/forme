import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'change_text.dart';

class SelectorPage extends StatelessWidget {
  final FormKey formKey = FormKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SelectorFormField'),
        ),
        body: Column(
          children: [
            FormBuilder()
                .key(formKey)
                .layoutBuilder()
                .oneRowField(SelectorFormField(
                  name: 'selector',
                  model: SelectorModel(
                    labelText: 'selector',
                    multi: false,
                    selectedItemLayoutType: SelectedItemLayoutType.scroll,
                  ),
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
                    return builder
                        .layoutBuilder()
                        .append(RangeSliderFormField(
                          name: 'filter',
                          model: SliderModel(min: 1, max: 100),
                        ))
                        .append(ButtonFormField(
                            onPressed: query, child: Text('query')))
                        .build();
                  },
                  onSelectDialogShow: (FormManagement currentManagement) {
                    //use this formKey.currentManagement to control query form on search dialog
                    currentManagement
                        .newFormFieldManagement('filter')
                        .valueFieldManagement
                        .value = RangeValues(20, 50);
                    return true; //return true will set params before query
                  },
                  onChanged: (v) => formKey.currentManagement
                          .newFormFieldManagement('text')
                          .model =
                      ChangeTextModel(
                          text: 'selector value changed, current value $v'),
                ))
                .oneRowField(ChangeText())
                .build(),
            Wrap(
              spacing: 20,
              children: [
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('selector')
                          .model = SelectorModel(multi: true);
                    },
                    child: Text('change to mutil selector')),
                OutlinedButton(
                    onPressed: () {
                      formKey.currentManagement
                          .newFormFieldManagement('selector')
                          .model = SelectorModel(labelText: 'filter selector');
                    },
                    child: Text('update label text')),
                OutlinedButton(
                    onPressed: () async {
                      formKey.currentManagement
                              .newFormFieldManagement('selector')
                              .model =
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
                Builder(builder: (context) {
                  BaseLayoutFormFieldManagement management = formKey
                      .currentManagement
                      .newFormFieldManagement('selector');
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
                      .newFormFieldManagement('selector');
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
                                  BaseLayoutFormFieldManagement>('selector')
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
