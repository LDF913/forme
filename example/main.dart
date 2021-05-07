import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/form_key.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'form_builder.dart';

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
      theme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          checkboxTheme: CheckboxThemeData()
              .copyWith(checkColor: MaterialStateProperty.all(Colors.red)),
          inputDecorationTheme: InputDecorationTheme().copyWith()),
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

  FormManagement formManagement = FormManagement();
  FormManagement formManagement2 = FormManagement();
  late FormFieldManagement username;

  @override
  void initState() {
    super.initState();
    username = formManagement.newFormFieldManagement('username');
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: createForm2(),
            ),
            createButtons2()
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
                onPressed: () {
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
              formManagement.getFocusableInvalidFields().forEach((element) {
                print(element.errorText);
              });
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
            formManagement.formThemeData = (++i) % 2 == 0
                ? FormThemeData(themeData: Theme.of(context))
                : FormThemeData.defaultTheme;
          },
          child: Text('change theme'),
        ),
        Row(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'form2',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ])
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

  Widget createForm2() {
    return FormBuilder(
      formManagement: formManagement2,
      enableLayoutManagement: true,
    )
        .field(field: Label('username'), flex: 2, inline: true)
        .textField(
            hintText: 'username',
            flex: 3,
            autovalidateMode: AutovalidateMode.always,
            clearable: true)
        .nextLine()
        .field(field: Label('password'), flex: 2, inline: true)
        .textField(
            name: 'password',
            hintText: 'password',
            flex: 3,
            obscureText: true,
            passwordVisible: true,
            clearable: true)
        .nextLine()
        .field(field: Label('rememberMe'), flex: 2, inline: true)
        .switchInline(
            name: 'rememberMe',
            flex: 3,
            initialValue: true,
            padding: EdgeInsets.symmetric(vertical: 10))
        .nextLine()
        .divider(padding: EdgeInsets.only(top: 10, bottom: 10))
        .field(field: Label('sex'), flex: 2, inline: true)
        .checkboxGroup(
          items: FormBuilderUtils.toCheckboxGroupItems(['male', 'female'],
              padding: EdgeInsets.symmetric(horizontal: 4)),
          inline: true,
          flex: 3,
        )
        .nextLine()
        .divider(padding: EdgeInsets.only(top: 10))
        .field(field: Label('habbit'), flex: 2, inline: true)
        .switchGroup(
            hasSelectAllSwitch: false,
            name: 'habbit',
            items:
                FormBuilderUtils.toSwitchGroupItems(['sport', 'film', 'sleep']),
            padding: EdgeInsets.only(top: 2, bottom: 2),
            inline: true,
            flex: 3)
        .divider(padding: EdgeInsets.only(top: 10, bottom: 10))
        .nextLine()
        .field(field: Label('age'), flex: 2, inline: true)
        .slider(
          inline: true,
          flex: 3,
          name: 'age',
          max: 100,
          min: 14,
          padding: EdgeInsets.symmetric(horizontal: 4),
          subLabelRender: (value) => Text(value.round().toString()),
        )
        .field(
          field: Button(),
          flex: 1,
          inline: false,
        );
  }

  Widget createButtons2() {
    return Wrap(
      children: [
        TextButton(
            onPressed: () {
              formManagement2.newFormFieldManagementByPosition(0, 0).update({
                'label': '123',
              });
            },
            child: Text('change label at position 0,0')),
        TextButton(
            onPressed: () {
              formManagement2
                  .newFormFieldManagementByPosition(0, 1)
                  .valueFieldManagement
                  .value = 'hello world';
            },
            child: Text('set value at position 0,1')),
        Builder(
          builder: (context) {
            FormRowManagement row = formManagement2.newFormRowManagement(0);
            return TextButton(
                onPressed: () {
                  row.visible = !row.visible;
                  (context as Element).markNeedsBuild();
                },
                child: Text(row.visible ? 'hide first row' : 'show first row'));
          },
        ),
        TextButton(
            onPressed: () {
              formManagement2.newFormRowManagement(0).readOnly = true;
            },
            child: Text('set first row readonly')),
        TextButton(
            onPressed: () {
              FormLayoutManagement formLayoutManagement =
                  formManagement2.newFormLayoutManagement();
              formLayoutManagement.startEdit();
              formLayoutManagement.swapRow(0, 1);
              formLayoutManagement.apply();
            },
            child: Text('swap first row and second row')),
        TextButton(
            onPressed: () {
              FormLayoutManagement formLayoutManagement =
                  formManagement2.newFormLayoutManagement();

              if (!formManagement2.hasField('num0')) {
                formLayoutManagement.startEdit();
                for (int i = 0; i <= 10; i++) {
                  int row = formLayoutManagement.rows - 1;
                  formLayoutManagement.insert(
                      row: row,
                      field: Label("new row"),
                      inline: true,
                      flex: 2,
                      insertRow: true);
                  formLayoutManagement.insert(
                      row: row,
                      inline: true,
                      flex: 3,
                      field: NumberFormField(
                        initialValue: i,
                      ),
                      name: 'num$i');
                }
                formLayoutManagement.apply();
              }
            },
            child: Text('append 10 numberfield rows before apply button')),
        TextButton(
            onPressed: () {
              FormLayoutManagement formLayoutManagement =
                  formManagement2.newFormLayoutManagement();
              formLayoutManagement.startEdit();
              int rows = formLayoutManagement.rows;
              if (rows >= 2) {
                formLayoutManagement.remove(rows - 2);
              }
              if (rows != formLayoutManagement.rows)
                formLayoutManagement.apply();
              else
                formLayoutManagement.cancel();

              formManagement2.newFormFieldManagement('password');
            },
            child: Text('delete last row before apply button')),
      ],
    );
  }

  Widget createForm() {
    return FormBuilder(
      formManagement: formManagement,
    )
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
        .nextLine()
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
            label: 'button',
            name: 'button')
        .nextLine()
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
        .checkboxGroup(
          items: FormBuilderUtils.toCheckboxGroupItems(['male', 'female']),
          name: 'checkbox',
          split: 2,
          label: 'sex',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .checkboxGroup(
          items: FormBuilderUtils.toCheckboxGroupItems(['male', 'female']),
          split: 1,
          label: 'checkboxlisttile',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .divider()
        .radioGroup(
          items: FormBuilderUtils.toRadioGroupItems(['1', '2']),
          name: 'radio',
          onChanged: (value) => print('radio value changed $value'),
          label: 'single choice',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .radioGroup<String>(
          split: 1,
          items: FormBuilderUtils.toRadioGroupItems(['1', '2']),
          onChanged: (value) => print('radio value changed $value'),
          label: 'radiolisttile',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .divider()
        .nextLine()
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
        .nextLine()
        .textField(
            name: 'remark',
            hintText: 'remark',
            maxLines: 5,
            flex: 1,
            clearable: true,
            onChanged: (value) => print('remark value changed $value'),
            maxLength: 500)
        .selector<int>(
            name: 'selector',
            labelText: 'selector',
            multi: true,
            selectItemProvider: (page, params) {
              RangeValues filter = params['filter'];
              print(filter);
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
        .filterChip<String>(
            label: 'Filter Chip',
            name: 'commonField',
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
        .nextLine()
        .field(
            field: Builder(builder: (context) {
              return Row(
                children: [
                  Expanded(
                    child: ClearableTextFormField(),
                    flex: 1,
                  ),
                  Expanded(
                    child: ClearableTextFormField(),
                    flex: 1,
                  ),
                ],
              );
            }),
            name: '123')
        .nextLine()
        .field(
            field: Builder(builder: (context) {
              BuilderInfo info = BuilderInfo.of(context);
              FieldKey fieldKey = info.fieldKey;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'I\'m a stateless field',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    color: info.formThemeData.themeData.primaryColor
                        .withOpacity(0.3),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        createRow('row', '${fieldKey.row}'),
                        createRow('column', '${fieldKey.column}'),
                        createRow('name', '${fieldKey.name ?? ''}'),
                        createRow('flex', '${info.flex}'),
                        createRow('inline', '${info.inline}'),
                        createRow('readOnly', '${info.readOnly}'),
                      ],
                    ),
                  )
                ],
              );
            }),
            flex: 2,
            inline: false);
  }
}

class Label extends BaseCommonField {
  final String label;
  Label(this.label)
      : super(
          {'label': StateValue<String>(label)},
          builder: (state) {
            return Text(
              state.currentMap['label'],
              style: TextStyle(
                  fontSize: 18,
                  color: state.formThemeData.themeData.primaryColor),
            );
          },
        );
}

class Button extends Builder {
  Button()
      : super(
          builder: (context) {
            BuilderInfo info = BuilderInfo.of(context);
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: info.formThemeData.themeData.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      FormManagement management = FormManagement.of(context);
                      Map<String, Widget> widgets =
                          management.data.map((key, value) => MapEntry(
                              key,
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(key),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Text(value.toString()),
                                    flex: 1,
                                  ),
                                ],
                              )));
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                width: double.maxFinite,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.from(widgets.values),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
}
