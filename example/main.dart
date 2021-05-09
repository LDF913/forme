import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'form_builder.dart';
import 'src/form_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int i = 1;
  int j = 1;

  FormManagement formManagement = FormManagement();
  late FormFieldManagement username;
  late FormPositionManagement positionManagement;
  late FormLayoutManagement formLayoutManagement;

  @override
  void initState() {
    super.initState();
    username = formManagement.newFormFieldManagement('username');
    positionManagement = formManagement.newFormPositionManagement(0);
    formLayoutManagement = formManagement.newFormLayoutManagement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'form1',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: createForm(),
            ),
            createButtons(),
          ]),
        ));
  }

  Widget createButtons() {
    Wrap buttons = Wrap(
      children: [
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  formManagement.visible = !formManagement.visible;
                  (context as Element).markNeedsBuild();
                },
                child:
                    Text(formManagement.visible ? 'hide form' : 'show form'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  formManagement.readOnly = !formManagement.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(formManagement.readOnly
                    ? 'set form editable'
                    : 'set form readonly'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () async {
                  username.visible = !username.visible;
                  (context as Element).markNeedsBuild();
                },
                child:
                    Text(username.visible ? 'hide username' : 'show username'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  username.readOnly = !username.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(username.readOnly
                    ? 'set username editable'
                    : 'set username readonly'));
          },
        ),
        TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('rebuild page')),
        TextButton(
            onPressed: () {
              formManagement.validate();
            },
            child: Text('validate')),
        TextButton(
            onPressed: () {
              username.valueFieldManagement.validate();
            },
            child: Text('validate username only')),
        TextButton(
            onPressed: () {
              formManagement.reset();
            },
            child: Text('reset')),
        TextButton(
            onPressed: () {
              formManagement.newFormFieldManagement('age').focus = true;
            },
            child: Text('age focus')),
        Builder(builder: (context) {
          return TextButton(
              onPressed: () {
                username.update({
                  'labelText': DateTime.now().toString(),
                });
              },
              child: Text('change username\'s label'));
        }),
        TextButton(
            onPressed: () {
              formManagement
                  .newFormFieldManagement('age')
                  .textSelectionManagement
                  .setSelection(1, 1);
            },
            child: Text('set age\'s selection')),
        TextButton(
          onPressed: () {
            print(formManagement.data);
          },
          child: Text('get form data'),
        ),
        TextButton(
          onPressed: () {
            formManagement
                .newFormFieldManagement('button')
                .update({'label': 'new Text'});
          },
          child: Text('set button text'),
        ),
        TextButton(
          onPressed: () {
            formManagement.formThemeData =
                (++i) % 2 == 0 ? Theme.of(context) : ThemeUtil.defaultTheme();
          },
          child: Text('change theme'),
        ),
        TextButton(
          onPressed: () {
            formManagement.newFormFieldManagement('checkbox2').update1('items',
                FormBuilderUtils.toCheckboxGroupItems(['male1', 'female1']));
          },
          child: Text('change checkboxlisttile\'s items'),
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  positionManagement.visible = !positionManagement.visible;
                  (context as Element).markNeedsBuild();
                },
                child: Text(positionManagement.visible
                    ? 'hide first row'
                    : 'show first row'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  positionManagement.readOnly = !positionManagement.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(positionManagement.readOnly
                    ? 'set first row editable'
                    : 'set first row readOnly'));
          },
        ),
        TextButton(
            onPressed: () {
              formManagement.setData({
                'username': 'user name',
                'password': 'password',
                'checkbox': [0],
                'age': 38,
                'radio': '1',
                'startTime': DateTime.now(),
                'switchGroup': [0, 1],
                'sliderInline': 50,
                'filterChip': ['java', 'C#', 'flutter'],
                'rangeSlider': RangeValues(10, 100)
              });
            },
            child: Text('set form data')),
        TextButton(
            onPressed: () {
              formLayoutManagement.startEdit();
              formLayoutManagement.swapRow(0, 1);
              formLayoutManagement.apply();
            },
            child: Text('swap first and second row')),
        TextButton(
            onPressed: () {
              formLayoutManagement.startEdit();
              formLayoutManagement.remove(2);
              formLayoutManagement.apply();
            },
            child: Text('remove age')),
      ],
    );
    return buttons;
  }

  static Row createRow(String key, String value) {
    return Row(
      children: [
        Expanded(child: Text(key)),
        Spacer(),
        Expanded(child: Text(value))
      ],
    );
  }

  Widget createForm() {
    return FormBuilder(
      formManagement: formManagement,
      enableLayoutManagement: true,
    )
        //    .customize(crossAxisAlignment: CrossAxisAlignment.start)
        .textField(
          name: 'username',
          labelText: 'username',
          clearable: true,
          selectAllOnFocus: true,
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
        )
        .switchInline(
          name: 'switch1',
          onChanged: (value) => print('switch1 value changed $value'),
        )
        .newRow()
        .field(field: Builder(builder: (context) {
          return TextButton(
              onPressed: () {
                j++;
                int row = BuilderInfo.of(context).position.row;
                formLayoutManagement.startEdit();
                formLayoutManagement.insert(
                    field: Label("new row"), newRow: true, row: row);
                formLayoutManagement.insert(
                    field: NumberFormField(
                      initialValue: j,
                      name: 'num$j',
                      flex: 2,
                    ),
                    row: row);
                formLayoutManagement.insert(
                    field: Builder(builder: (context) {
                      int row = BuilderInfo.of(context).position.row;
                      return TextButton.icon(
                          onPressed: () {
                            formLayoutManagement.startEdit();
                            formLayoutManagement.remove(row);
                            formLayoutManagement.apply();
                          },
                          icon: Icon(Icons.delete),
                          label: Text('delete'));
                    }),
                    row: row);
                formLayoutManagement.apply();
              },
              child: Text('append a new row before this button'));
        }))
        .newRow()
        .textField(
            name: 'password',
            hintText: 'password',
            obscureText: true,
            passwordVisible: true,
            clearable: true,
            toolbarOptions: ToolbarOptions(copy: false, paste: false),
            onChanged: (value) => print('password value changed $value'),
            flex: 1)
        .textButton(
            onPressed: () {
              formManagement
                  .newFormFieldManagement('password')
                  .textSelectionManagement
                  .selectAll();
            },
            label: 'select all',
            name: 'button')
        .newRow()
        .numberField(
          name: 'age',
          hintText: 'age',
          clearable: true,
          flex: 3,
          min: 18,
          max: 99,
          decimal: 0,
          onChanged: (value) => print('age value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .newRow()
        .checkboxGroup(
          items: FormBuilderUtils.toCheckboxGroupItems(['male', 'female']),
          name: 'checkbox',
          split: 2,
          label: 'sex',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .newRow()
        .checkboxGroup(
          name: 'checkbox2',
          items: FormBuilderUtils.toCheckboxGroupItems(['male', 'female']),
          split: 1,
          label: 'checkboxlisttile',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .newRow()
        .radioGroup(
          items: FormBuilderUtils.toRadioGroupItems(['1', '2']),
          name: 'radio',
          onChanged: (value) => print('radio value changed $value'),
          label: 'single choice',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .newRow()
        .radioGroup<String>(
          split: 1,
          items: FormBuilderUtils.toRadioGroupItems(['1', '2']),
          onChanged: (value) => print('radio value changed $value'),
          label: 'radiolisttile',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .newRow()
        .datetimeField(
          name: 'startTime',
          useTime: true,
          hintText: 'startTime',
          onChanged: (value) => print('startTime value changed $value'),
          validator: (value) => value == null ? 'not empty1' : null,
        )
        .datetimeField(
          name: 'endTime',
          useTime: true,
          hintText: 'endTime',
          onChanged: (value) => print('endTime value changed $value'),
          validator: (value) => value == null ? 'not empty2' : null,
        )
        .newRow()
        .textField(
            name: 'remark',
            hintText: 'remark',
            maxLines: 5,
            flex: 1,
            clearable: true,
            onChanged: (value) => print('remark value changed $value'),
            maxLength: 500)
        .newRow()
        .selector<int>(
            name: 'selector',
            labelText: 'selector',
            multi: true,
            selectItemProvider: (page, params) {
              RangeValues filter = params['filter'];
              List<int> items = List<int>.generate(100, (i) => i + 1)
                  .where((element) =>
                      element >= filter.start.round() &&
                      element <= filter.end.round())
                  .toList();
              return Future.delayed(Duration(seconds: 1), () {
                return SelectItemPage<int>(
                    items.sublist((page - 1) * 20,
                        page * 20 > items.length ? items.length : page * 20),
                    items.length);
              });
            },
            queryFormBuilder: (builder, query) {
              builder
                  .rangeSlider(
                      name: 'filter',
                      min: 1,
                      max: 100,
                      inline: true,
                      rangeSubLabelRender: RangeSubLabelRender(
                          (start) => Text(start.round().toString()),
                          (end) => Text(end.round().toString())))
                  .textButton(onPressed: query, label: 'query');
            },
            onSelectDialogShow: (formManagement) {
              //use this formManagement to control query form on search dialog
              formManagement
                  .newFormFieldManagement('filter')
                  .valueFieldManagement
                  .setValue(RangeValues(20, 50));
              return true; //return true will set params before query
            },
            selectedItemLayoutType: SelectedItemLayoutType.scroll,
            onChanged: (value) => print('selector value changed $value'),
            validator: (value) => value.isEmpty ? 'select something !' : null)
        .newRow()
        .switchGroup(
            name: 'switchGroup',
            label: 'switch',
            onChanged: (value) => print('switchGroup value changed $value'),
            validator: (value) => value.isEmpty ? 'select one pls !' : null,
            selectAllPadding: EdgeInsets.only(right: 8),
            items: List<SwitchGroupItem>.generate(
                3,
                (index) => SwitchGroupItem(index.toString(),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8))))
        .newRow()
        .slider(
          name: 'slider',
          min: 0,
          max: 100,
          label: 'age slider',
          validator: (value) =>
              value < 50 ? 'age slider must bigger than 50' : null,
          subLabelRender: (value) => Text(value.toStringAsFixed(0)),
          onChanged: (value) =>
              print('age slider value changed ' + value.toStringAsFixed(0)),
        )
        .newRow()
        .numberField(
            name: 'sliderInlineText',
            min: 0,
            max: 100,
            labelText: 'inline slider',
            flex: 2,
            onChanged: (v) => formManagement
                .newFormFieldManagement('sliderInline')
                .valueFieldManagement
                .setValue(v == null ? 0.0 : v.toDouble(), trigger: false))
        .slider(
            name: 'sliderInline',
            min: 0,
            max: 100,
            inline: true,
            onChanged: (v) {
              formManagement
                  .newFormFieldManagement('sliderInlineText')
                  .valueFieldManagement
                  .setValue(v.toDouble().toInt(), trigger: false);
            })
        .newRow()
        .rangeSlider(
          name: 'rangeSlider',
          min: 0,
          max: 100,
          label: 'range slider',
          rangeSubLabelRender: RangeSubLabelRender((start) {
            return Text(start.toStringAsFixed(0));
          }, (end) {
            return Text(end.toStringAsFixed(0));
          }),
          onChanged: (value) =>
              print('range slider value changed ' + value.toString()),
        )
        .newRow()
        .filterChip<String>(
            label: 'Filter Chip',
            name: 'filterChip',
            count: 3,
            exceedCallback: () => print('max 3 items can be selected'),
            onChanged: (value) => print('Filter Chip Changed: $value'),
            validator: (t) =>
                t.length < 3 ? 'at least three items  must be selected ' : null,
            items: FormBuilderUtils.toFilterChipItems([
              'java',
              'android',
              'flutter',
              'html',
              'css',
              'javascript',
              'C#',
              'swift',
              'object-c'
            ]))
        .newRow()
        .field(field: Builder(builder: (context) {
          BuilderInfo info = BuilderInfo.of(context);
          Position position = info.position;
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I\'m a stateless field',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  color: info.formThemeData.primaryColor.withOpacity(0.3),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      createRow('row', '${position.row}'),
                      createRow('column', '${position.column}'),
                      createRow('inline', '${info.inline}'),
                    ],
                  ),
                )
              ],
            ),
            flex: 1,
          );
        }))
        .newRow()
        .field(
            field: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'a custom field with two value fields',
            style: TextStyle(fontSize: 20),
          ),
        ))
        .newRow()
        .field(field: Builder(builder: (context) {
          return Expanded(
              child: Row(
            children: [
              ClearableTextFormField(
                name: 'value1',
                hintText: 'value1',
              ),
              ClearableTextFormField(
                name: 'value2',
                hintText: 'value2',
              ),
            ],
          ));
        }))
        .newRow()
        .field(
            field: Label(
          'username',
          flex: 1,
        ))
        .textField(hintText: 'username', flex: 2)
        .newRow()
        .field(
            field: Label(
          'password',
          flex: 1,
        ))
        .textField(hintText: 'password', flex: 2, obscureText: true)
        .newRow()
        .field(
            field: Label(
          'sex',
          flex: 1,
        ))
        .radioGroup<String>(
            flex: 2,
            items: FormBuilderUtils.toRadioGroupItems(['male', 'female'],
                padding: EdgeInsets.zero))
        .newRow()
        .field(
            field: Label(
          'habbit',
          flex: 1,
        ))
        .switchGroup(
            flex: 2,
            hasSelectAllSwitch: false,
            items: FormBuilderUtils.toSwitchGroupItems(
                ['basketball', 'football', 'pingpong']))
        .newRow()
        .field(
            field: Label(
          'age',
          flex: 1,
        ))
        .slider(
          min: 18,
          max: 99,
          flex: 2,
          subLabelRender: (value) => Text(value.round().toString()),
        )
        .newRow()
        .field(
            field: Label(
          'skill',
          flex: 1,
        ))
        .filterChip<String>(
            flex: 2,
            items: FormBuilderUtils.toFilterChipItems(
                ['java', 'c#', 'object-c', 'html5', 'css', 'android', 'iOS'],
                padding: EdgeInsets.all(5)));
  }
}

class Label extends BaseCommonField {
  final String label;
  Label(this.label, {int flex = 1})
      : super(
          {'label': StateValue<String>(label)},
          flex: flex,
          builder: (state) {
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.formThemeData;
            return Text(
              stateMap['label'],
              style: TextStyle(fontSize: 18, color: themeData.primaryColor),
            );
          },
        );
}
