import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart' as b;
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

  FormManagement? formManagement;
  FormManagement? formManagement2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      formManagement!.getFormFieldManagement('username').focusListener =
          FocusListener(
        rootChanged: (value) {
          print('username focus changed :$value');
        },
      );
    });
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
            createButtons2(),
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
                  formManagement!.visible = !formManagement!.visible;
                  (context as Element).markNeedsBuild();
                },
                child: Text(formManagement == null
                    ? 'hide form'
                    : formManagement!.visible
                        ? 'hide form'
                        : 'show form'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  formManagement!.readOnly = !formManagement!.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(formManagement == null
                    ? 'set form editable'
                    : formManagement!.readOnly
                        ? 'set form editable'
                        : 'set form readonly'));
          },
        ),
        Builder(
          builder: (context) {
            FormFieldManagement username =
                formManagement!.getFormFieldManagement('username');
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
            FormFieldManagement username =
                formManagement!.getFormFieldManagement('username');
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
              formManagement!
                  .getFormFieldManagement('username')
                  .autovalidateMode = AutovalidateMode.always;
            },
            child: Text('validate username always')),
        TextButton(
            onPressed: () {
              formManagement!.getFormFieldManagement('username').remove = true;
            },
            child: Text('remove username completely')),
        TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('rebuild page')),
        TextButton(
            onPressed: () {
              formManagement!.validate();
            },
            child: Text('validate')),
        TextButton(
            onPressed: () {
              formManagement!.getFormFieldManagement('username').validate();
            },
            child: Text('validate username only')),
        TextButton(
            onPressed: () {
              formManagement!.reset();
            },
            child: Text('reset')),
        Builder(
          builder: (context) {
            SubControllerDelegate subController = formManagement!
                .getFormFieldManagement('checkbox')
                .subController;
            return TextButton(
                onPressed: () {
                  bool readOnly = subController.isReadOnly('male');
                  subController.setReadOnly('male', !readOnly);
                  (context as Element).markNeedsBuild();
                },
                child: Text(subController.isReadOnly('male')
                    ? 'set male editable'
                    : 'set male readonly'));
          },
        ),
        Builder(
          builder: (context) {
            SubControllerDelegate subController = formManagement!
                .getFormFieldManagement('switchGroup')
                .subController;
            return TextButton(
                onPressed: () {
                  bool visible = subController.getState('switch1', 'visible');
                  bool readOnly = subController.getState('switch0', 'readOnly');
                  subController.update({
                    'switch0': {'readOnly': !readOnly},
                    'switch1': {'visible': !visible}
                  });
                  (context as Element).markNeedsBuild();
                },
                child: Text((subController.getState('switch1', 'visible')
                        ? 'hide'
                        : 'show') +
                    ' switch 2 & set switch 1 ' +
                    (subController.getState('switch0', 'readOnly')
                        ? 'editable'
                        : 'readOnly')));
          },
        ),
        TextButton(
            onPressed: () {
              formManagement!.getFormFieldManagement('switchGroup').update({
                'items': List<SwitchGroupItem>.generate(
                    5,
                    (index) => SwitchGroupItem((index + 5).toString(),
                        controlKey: 'switch$index',
                        textStyle:
                            TextStyle(color: Theme.of(context).primaryColor)))
              });
            },
            child: Text('set switch items')),
        TextButton(
            onPressed: () {
              formManagement!.getFormFieldManagement('age').focus = true;
            },
            child: Text('age focus')),
        TextButton(
            onPressed: () {
              formManagement!.getFormFieldManagement('username').update({
                'labelText': DateTime.now().toString(),
              });
            },
            child: Text('change username\'s label')),
        TextButton(
            onPressed: () {
              formManagement!
                  .getFormFieldManagement('age')
                  .textSelectionManagement
                  .setSelection(1, 1);
            },
            child: Text('set age\'s selection')),
        TextButton(
          onPressed: () {
            print(formManagement!.data);
          },
          child: Text('get form data'),
        ),
        TextButton(
          onPressed: () {
            formManagement!
                .getFormFieldManagement('button')
                .update({'label': 'new Text'});
          },
          child: Text('set button text'),
        ),
        TextButton(
          onPressed: () {
            formManagement!.formThemeData = (++i) % 2 == 0
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

  Widget createForm2() {
    return FormBuilder(
      initCallback: (formManagement) => this.formManagement2 = formManagement,
    )
        .field(field: Label('username'), flex: 2, inline: true)
        .textField(
            controlKey: 'username',
            hintText: 'username',
            flex: 3,
            clearable: true)
        .nextLine()
        .field(field: Label('password'), flex: 2, inline: true)
        .textField(
            controlKey: 'password',
            hintText: 'password',
            flex: 3,
            obscureText: true,
            passwordVisible: true,
            clearable: true)
        .nextLine()
        .field(field: Label('rememberMe'), flex: 2, inline: true)
        .switchInline(
            controlKey: 'rememberMe',
            flex: 3,
            initialValue: true,
            padding: EdgeInsets.symmetric(vertical: 10))
        .nextLine()
        .divider(padding: EdgeInsets.only(top: 10, bottom: 10))
        .field(field: Label('sex'), flex: 2, inline: true)
        .checkboxGroup(
          FormBuilder.toCheckboxItems(['male', 'female'],
              padding: EdgeInsets.symmetric(horizontal: 4)),
          inline: true,
          flex: 3,
        )
        .nextLine()
        .divider(padding: EdgeInsets.only(top: 10))
        .field(field: Label('habbit'), flex: 2, inline: true)
        .switchGroup(
            hasSelectAllSwitch: false,
            controlKey: 'habbit',
            items: FormBuilder.toSwitchGroupItems(['sport', 'film', 'sleep']),
            padding: EdgeInsets.only(top: 2, bottom: 2),
            inline: true,
            flex: 3)
        .divider(padding: EdgeInsets.only(top: 10, bottom: 10))
        .nextLine()
        .field(field: Label('age'), flex: 2, inline: true)
        .slider(
          inline: true,
          flex: 3,
          controlKey: 'age',
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
              formManagement2!.formLayoutManagement
                  .getFormFieldManagement(0, 0)
                  .update({
                'label': '123',
              });
            },
            child: Text('change label at position 0,0')),
        TextButton(
            onPressed: () {
              formManagement2!.formLayoutManagement
                  .getFormFieldManagement(0, 1)
                  .setValue('hello world');
            },
            child: Text('set value at position 0,1')),
        Builder(
          builder: (context) {
            FormLayoutRowManagement row = formManagement2!.formLayoutManagement
                .getFormLayoutRowManagement(0);
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
              FormLayoutRowManagement row = formManagement2!
                  .formLayoutManagement
                  .getFormLayoutRowManagement(0);
              row.readOnly = true;
            },
            child: Text('set first row readonly')),
        TextButton(
            onPressed: () {
              FormWidgetTreeManagement formWidgetTreeManagement =
                  formManagement2!.formWidgetTreeManagement;
              formWidgetTreeManagement.startEdit();
              formWidgetTreeManagement.swapRow(0, 1);
              formWidgetTreeManagement.apply();
            },
            child: Text('swap first row and second row')),
        TextButton(
            onPressed: () {
              FormWidgetTreeManagement formWidgetTreeManagement =
                  formManagement2!.formWidgetTreeManagement;

              if (!formManagement2!.hasControlKey('num0')) {
                formWidgetTreeManagement.startEdit();
                for (int i = 0; i <= 10; i++) {
                  int row = formWidgetTreeManagement.rows - 1;
                  formWidgetTreeManagement.insert(
                      row: row,
                      field: Label("new row"),
                      inline: true,
                      flex: 2,
                      insertRow: true);
                  formWidgetTreeManagement.insert(
                      row: row,
                      inline: true,
                      flex: 3,
                      field: NumberFormField(
                        initialValue: i,
                      ),
                      controlKey: 'num$i');
                }
                formWidgetTreeManagement.apply();
              }
            },
            child: Text('append 10 numberfield rows before apply button')),
        TextButton(
            onPressed: () {
              FormWidgetTreeManagement formWidgetTreeManagement =
                  formManagement2!.formWidgetTreeManagement;
              formWidgetTreeManagement.startEdit();
              int rows = formWidgetTreeManagement.rows;
              if (rows >= 2) {
                formWidgetTreeManagement.removeAtPosition(rows - 2);
              }
              if (rows != formWidgetTreeManagement.rows)
                formWidgetTreeManagement.apply();
              else
                formWidgetTreeManagement.cancel();
            },
            child: Text('delete last row before apply button')),
      ],
    );
  }

  Widget createForm() {
    return FormBuilder(
      initCallback: (formManagement) {
        this.formManagement = formManagement;
      },
    )
        .textField(
          controlKey: 'username',
          labelText: 'username',
          clearable: true,
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
        )
        .checkboxGroup([CheckboxItem('remember me')],
            controlKey: 'rememberMe', inline: true)
        .switchInline(
          controlKey: 'switch1',
          onChanged: (value) => print('switch1 value changed $value'),
        )
        .nextLine()
        .textField(
            controlKey: 'password',
            hintText: 'password',
            obscureText: true,
            passwordVisible: true,
            clearable: true,
            toolbarOptions: ToolbarOptions(copy: false, paste: false),
            onChanged: (value) => print('password value changed $value'),
            flex: 1)
        .textButton(
            onPressed: () {
              formManagement!
                  .getFormFieldManagement('password')
                  .textSelectionManagement
                  .selectAll();
            },
            label: 'button',
            controlKey: 'button')
        .nextLine()
        .numberField(
          controlKey: 'age',
          hintText: 'age',
          clearable: true,
          flex: 3,
          min: -18,
          max: 99,
          decimal: 0,
          onChanged: (value) => print('age value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .radioGroup(
            items: FormBuilder.toRadioItems(['1', '2']),
            controlKey: 'radioInline',
            inline: true)
        .checkboxGroup(
          [CheckboxItem('male', controlKey: 'male'), CheckboxItem('female')],
          controlKey: 'checkbox',
          split: 2,
          label: 'sex',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .divider()
        .radioGroup(
          items: [
            RadioItem('1', '1', controlKey: 'radio 1'),
            RadioItem('2', '2', controlKey: 'radio 2'),
          ],
          controlKey: 'radio',
          onChanged: (value) => print('radio value changed $value'),
          label: 'single choice',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .divider()
        .nextLine()
        .datetimeField(
          controlKey: 'startTime',
          useTime: true,
          hintText: 'startTime',
          onChanged: (value) => print('startTime value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .datetimeField(
          controlKey: 'endTime',
          useTime: true,
          hintText: 'endTime',
          onChanged: (value) => print('endTime value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .nextLine()
        .textField(
            controlKey: 'remark',
            hintText: 'remark',
            maxLines: 5,
            flex: 1,
            clearable: true,
            onChanged: (value) => print('remark value changed $value'),
            maxLength: 500)
        .selector(
            controlKey: 'selector',
            labelText: 'selector',
            multi: true,
            selectItemProvider: (page, params) {
              RangeValues filter = params['filter'];
              print(filter);
              List items = List<int>.generate(100, (i) => i + 1)
                  .where((element) =>
                      element >= filter.start.round() &&
                      element <= filter.end.round())
                  .toList();
              return Future.delayed(Duration(seconds: 1), () {
                return SelectItemPage(
                    items.sublist((page - 1) * 20,
                        page * 20 > items.length ? items.length : page * 20),
                    items.length);
              });
            },
            queryFormBuilder: (builder, query) {
              builder
                  .rangeSlider(
                      controlKey: 'filter',
                      min: 1,
                      max: 100,
                      inline: true,
                      rangeSubLabelRender: RangeSubLabelRender(
                          (start) => Text(start.round().toString()),
                          (end) => Text(end.round().toString())))
                  .textButton(onPressed: query, label: 'query');
            },
            onSelectDialogShow: (formManagement) {
              //use this formManagement! to control query form on search dialog
              formManagement
                  .getFormFieldManagement('filter')
                  .setValue(RangeValues(20, 50));
              return true; //return true will set params before query
            },
            selectedItemLayoutType: SelectedItemLayoutType.scroll,
            onChanged: (value) => print('selector value changed $value'),
            validator: (value) => value.isEmpty ? 'select something !' : null)
        .switchGroup(
            controlKey: 'switchGroup',
            label: 'switch',
            onChanged: (value) => print('switchGroup value changed $value'),
            validator: (value) => value.isEmpty ? 'select one pls !' : null,
            selectAllPadding: EdgeInsets.only(right: 8),
            items: List<SwitchGroupItem>.generate(
                3,
                (index) => SwitchGroupItem(index.toString(),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    controlKey: 'switch$index')))
        .slider(
          controlKey: 'slider',
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
            controlKey: 'sliderInlineText',
            min: 0,
            max: 100,
            labelText: 'inline slider',
            flex: 2,
            initialValue: 0,
            onChanged: (v) => formManagement!
                .getFormFieldManagement('sliderInline')
                .setValue(v == null ? 0.0 : v.toDouble(), trigger: false))
        .slider(
            controlKey: 'sliderInline',
            min: 0,
            max: 100,
            initialValue: 10,
            inline: true,
            onChanged: (v) {
              formManagement!
                  .getFormFieldManagement('sliderInlineText')
                  .setValue(v.toDouble(), trigger: false);
            })
        .rangeSlider(
          controlKey: 'rangeSlider',
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
        .field(
            controlKey: 'commonField',
            field: CommonField(
              {
                'text': TypedValue<String>('click me and change my text',
                    nullable: false)
              },
              builder: (state, context, readOnly, stateMap, themeData,
                  formThemeData) {
                return TextButton(
                  child: Text(stateMap['text']),
                  onPressed: readOnly
                      ? null
                      : () {
                          FormManagement.of(context);
                          formManagement!
                              .getFormFieldManagement('commonField')
                              .update({'text': '123'});
                        },
                );
              },
            ));
  }
}

class Label extends CommonField {
  final String label;
  Label(this.label)
      : super(
          {'label': TypedValue<String>(label, nullable: false)},
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            return Text(
              stateMap['label'],
              style: TextStyle(fontSize: 18, color: themeData.primaryColor),
            );
          },
        );
}

class Button extends CommonField {
  Button()
      : super(
          {},
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: themeData.primaryColor,
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

class TextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  TextButton({required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: b.TextButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
