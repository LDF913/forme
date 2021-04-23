import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/slider.dart';
import 'package:flutter_application_1/form/switch_group.dart';
import 'package:flutter_application_1/form/text_field.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'form/checkbox_group.dart';
import 'form/form_builder.dart';
import 'form/form_theme.dart';
import 'form/radio_group.dart';
import 'form/selector.dart';

void main() => runApp(MyApp());

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
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int i = 1;

  FormManagement formManagement;

  @override
  void initState() {
    super.initState();
    formManagement = FormManagement(initCallback: () {
      formManagement.onFocusChange('username',
          FocusChanged(rootChanged: (value) {
        print('username focused: $value');
      }));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Wrap(children: [
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
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formManagement.visible = !formManagement.visible;
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(
                        formManagement.visible ? 'hide form' : 'show form'));
              },
            ),
            TextButton(
                onPressed: () {
                  formManagement.formLayoutManagement
                      .setVisibleAtPosition(0, false);
                },
                child: Text('hide first row')),
            TextButton(
                onPressed: () {
                  formManagement.formLayoutManagement
                      .setReadOnlyAtPosition(0, true);
                },
                child: Text('set first row readonly')),
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
                      formManagement.setVisible(
                          'username', !formManagement.isVisible('username'));
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formManagement.isVisible('username')
                        ? 'hide username'
                        : 'show username'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formManagement.setReadOnly(
                          'username', !formManagement.isReadOnly('username'));
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formManagement.isReadOnly('username')
                        ? 'set username editable'
                        : 'set username readonly'));
              },
            ),
            TextButton(
                onPressed: () {
                  formManagement.setAutovalidateMode(
                      'username', AutovalidateMode.always);
                },
                child: Text('validate username always')),
            TextButton(
                onPressed: () {
                  formManagement.remove('username');
                },
                child: Text('remove username completely')),
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
                  formManagement.validate1('username');
                },
                child: Text('validate username only')),
            TextButton(
                onPressed: () {
                  formManagement.reset();
                },
                child: Text('reset')),
            Builder(
              builder: (context) {
                SubControllerDelegate subController =
                    formManagement.getSubController('checkbox');
                return subController == null
                    ? SizedBox()
                    : TextButton(
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
                SubControllerDelegate subController =
                    formManagement.getSubController('switchGroup');
                return subController == null
                    ? SizedBox()
                    : TextButton(
                        onPressed: () {
                          bool visible =
                              subController.getState('switch1', 'visible');
                          bool readOnly =
                              subController.getState('switch0', 'readOnly');
                          subController.update({
                            'switch0': {'readOnly': !readOnly},
                            'switch1': {'visible': !visible}
                          });
                          (context as Element).markNeedsBuild();
                        },
                        child: Text(
                            (subController.getState('switch1', 'visible')
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
                  formManagement.update('switchGroup', {
                    'items': List<SwitchGroupItem>.generate(
                        5,
                        (index) => SwitchGroupItem((index + 5).toString(),
                            controlKey: 'switch$index',
                            textStyle: TextStyle(
                                color: Theme.of(context).primaryColor)))
                  });
                },
                child: Text('set switch items')),
            TextButton(
                onPressed: () {
                  formManagement.requestFocus('age');
                },
                child: Text('age focus')),
            TextButton(
                onPressed: () {
                  formManagement.update('username', {
                    'labelText': DateTime.now().toString(),
                  });
                },
                child: Text('change username\'s label')),
            TextButton(
                onPressed: () {
                  formManagement
                      .getTextSelectionManagement('age')
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
                formManagement.update('button', {'label': 'new Text'});
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
            ]),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: createForm2(),
            ),
          ]),
        ));
  }

  Widget createForm2() {
    return FormBuilder()
        .widget(field: Label('username'), flex: 2, inline: true)
        .textField(
            controlKey: 'username',
            hintText: 'username',
            flex: 3,
            clearable: true)
        .nextLine()
        .widget(field: Label('password'), flex: 2, inline: true)
        .textField(
            controlKey: 'password',
            hintText: 'password',
            flex: 3,
            obscureText: true,
            passwordVisible: true,
            clearable: true)
        .nextLine()
        .widget(field: Label('rememberMe'), flex: 2, inline: true)
        .switchInline(
            controlKey: 'rememberMe',
            flex: 3,
            initialValue: true,
            padding: EdgeInsets.symmetric(vertical: 10))
        .nextLine()
        .divider(padding: EdgeInsets.only(top: 10, bottom: 10))
        .widget(field: Label('sex'), flex: 2, inline: true)
        .checkboxGroup(
            FormBuilder.toCheckboxItems(['male', 'female'],
                padding: EdgeInsets.symmetric(horizontal: 4)),
            inline: true,
            flex: 3,
            controlKey: 'sex')
        .nextLine()
        .divider(padding: EdgeInsets.only(top: 10))
        .widget(field: Label('habbit'), flex: 2, inline: true)
        .switchGroup(
            hasSelectAllSwitch: false,
            controlKey: 'habbit',
            items: FormBuilder.toSwitchGroupItems(['sport', 'film', 'sleep']),
            padding: EdgeInsets.only(top: 2, bottom: 2),
            inline: true,
            flex: 3)
        .divider(padding: EdgeInsets.only(top: 10, bottom: 10))
        .nextLine()
        .widget(field: Label('age'), flex: 2, inline: true)
        .slider(
          inline: true,
          flex: 3,
          controlKey: 'age',
          max: 100,
          min: 14,
          padding: EdgeInsets.symmetric(horizontal: 4),
          subLabelRender: (value) => Text(value.round().toString()),
        )
        .widget(
          field: Button(),
          flex: 1,
          inline: false,
        );
  }

  Widget createForm() {
    return FormBuilder(formManagement: formManagement)
        .textField(
            controlKey: 'password',
            hintText: 'password',
            obscureText: true,
            passwordVisible: true,
            clearable: true,
            toolbarOptions: ToolbarOptions(copy: false, paste: false),
            onChanged: (value) => print('password value changed $value'),
            flex: 1)
        .textButton((management) {
          management.getTextSelectionManagement('password').selectAll();
        }, label: 'button')
        .nextLine()
        .textField(
            controlKey: 'username', labelText: 'username', clearable: true)
        .checkboxGroup([CheckboxItem('remember me')],
            controlKey: 'rememberMe', inline: true)
        .switchInline(
          controlKey: 'switch1',
          onChanged: (value) => print('switch1 value changed $value'),
        )
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
        .radioGroup(FormBuilder.toRadioItems(['1', '2']),
            controlKey: 'radioInline', inline: true)
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
          [
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
                  .textButton((formManagement) {
                query();
              }, label: 'query');
            },
            onSelectDialogShow: (formManagement) {
              //use this formManagement to control query form on search dialog
              formManagement.setValue('filter', RangeValues(20, 50));
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
            onChanged: (v) => formManagement.setValue(
                'sliderInline', v == null ? 0.0 : v.toDouble(),
                trigger: false))
        .slider(
            controlKey: 'sliderInline',
            min: 0,
            max: 100,
            initialValue: 10,
            inline: true,
            onChanged: (v) {
              formManagement.setValue('sliderInlineText', v.round(),
                  trigger: false);
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
        .widget(
            controlKey: 'commonField',
            field: CommonField(
              {'text': 'click me and change my text'},
              builder: (state, context, readOnly, stateMap, themeData,
                  formThemeData) {
                return TextButton(
                  child: Text(stateMap['text']),
                  onPressed: readOnly
                      ? null
                      : () {
                          FormManagement.of(context);
                          formManagement.update('commonField', {
                            'text': Random.secure().nextDouble().toString()
                          });
                        },
                );
              },
            ));
  }
}

class Label extends CommonField {
  final String label;
  Label(this.label, {Key key})
      : super(
          {'label': label},
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            return Text(
              stateMap['label'],
              style: TextStyle(fontSize: 18, color: themeData.primaryColor),
            );
          },
        );
}

// from
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
                      if (!management.hasControlKey('num0')) {
                        FormLayoutEditor editor =
                            management.formLayoutManagement.formLayoutEditor;
                        editor.startEdit();
                        editor.removeAtPosition(0);
                        for (int i = 0; i <= 10; i++) {
                          int row = editor.rows - 1;
                          editor.insert(
                              row: row,
                              field: Label("new row"),
                              inline: true,
                              flex: 2,
                              insertRow: true);
                          editor.insert(
                              row: row,
                              inline: true,
                              flex: 3,
                              field: NumberFormField(
                                initialValue: i,
                              ),
                              controlKey: 'num$i');
                        }
                        editor.apply();
                        management.setValue('num0',
                            123); //this will not work,because nums will be added to form at next frame

                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          management.setValue('num0', 123);
                        });
                      }

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
