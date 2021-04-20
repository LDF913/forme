import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/slider.dart';
import 'package:flutter_application_1/form/switch_group.dart';
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
              child: Builder(builder: (context) {
                print("build form");
                return createForm(context);
              }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'form2',
                style: TextStyle(fontSize: 30),
              ),
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
                  formManagement.setSelection('age', 1, 1);
                },
                child: Text('set age\'s selection')),
            TextButton(
              onPressed: () {
                print(formManagement.getData());
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
                    : DefaultFormThemeData();
              },
              child: Text('change theme'),
            )
          ]),
        ));
  }

  Widget createForm(BuildContext context) {
    return FormBuilder(formManagement: formManagement)
        .textField('username', labelText: 'username', clearable: true)
        .checkboxGroup('rememberMe', [CheckboxItem('remember me')],
            inline: true)
        .switchInline(
          'switch1',
          onChanged: (value) => print('switch1 value changed $value'),
        )
        .nextLine()
        .textField('password',
            hintText: 'password',
            obscureText: true,
            passwordVisible: true,
            clearable: true,
            toolbarOptions: ToolbarOptions(copy: false, paste: false),
            onChanged: (value) => print('password value changed $value'),
            flex: 1)
        .nextLine()
        .numberField(
          'age',
          hintText: 'age',
          clearable: true,
          flex: 3,
          min: -18,
          max: 99,
          decimal: 0,
          onChanged: (value) => print('age value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .radioGroup('radioInline', FormBuilder.toRadioItems(['1', '2']),
            inline: true)
        .checkboxGroup(
          'checkbox',
          [CheckboxItem('male', controlKey: 'male'), CheckboxItem('female')],
          split: 2,
          label: 'sex',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .divider('divider')
        .radioGroup(
          'radio',
          [
            RadioItem('1', '1', controlKey: 'radio 1'),
            RadioItem('2', '2', controlKey: 'radio 2'),
          ],
          onChanged: (value) => print('radio value changed $value'),
          label: 'single choice',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .divider('divider1')
        .nextLine()
        .datetimeField(
          'startTime',
          useTime: true,
          hintText: 'startTime',
          onChanged: (value) => print('startTime value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .datetimeField(
          'endTime',
          useTime: true,
          hintText: 'endTime',
          onChanged: (value) => print('endTime value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .nextLine()
        .textField('remark',
            hintText: 'remark',
            maxLines: 5,
            flex: 1,
            clearable: true,
            onChanged: (value) => print('remark value changed $value'),
            maxLength: 500)
        .selector('selector',
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
                  .rangeSlider('filter',
                      min: 1,
                      max: 100,
                      inline: true,
                      rangeSubLabelRender: RangeSubLabelRender(
                          (start) => Text(start.round().toString()),
                          (end) => Text(end.round().toString())))
                  .textButton('query', query, label: 'query');
            },
            onSelectDialogShow: (formManagement) {
              //use this formManagement to control query form on search dialog
              formManagement.setValue('filter', RangeValues(20, 50));
              return true; //return true will set params before query
            },
            selectedItemLayoutType: SelectedItemLayoutType.scroll,
            onChanged: (value) => print('selector value changed $value'),
            validator: (value) => value.isEmpty ? 'select something !' : null)
        .switchGroup('switchGroup',
            label: 'switch',
            onChanged: (value) => print('switchGroup value changed $value'),
            validator: (value) => value.isEmpty ? 'select one pls !' : null,
            items: List<SwitchGroupItem>.generate(
                3,
                (index) => SwitchGroupItem(index.toString(),
                    controlKey: 'switch$index')))
        .slider(
          'slider',
          min: 0,
          max: 100,
          label: 'age slider',
          validator: (value) =>
              value < 50 ? 'age slider must bigger than 50' : null,
          subLabelRender: (value) => Text(value.toStringAsFixed(0)),
          onChanged: (value) =>
              print('age slider value changed ' + value.toStringAsFixed(0)),
        )
        .numberField('sliderInlineText',
            min: 0,
            max: 100,
            labelText: 'inline slider',
            flex: 2,
            initialValue: 0,
            onChanged: (v) => formManagement.setValue(
                'sliderInline', v == null ? 0.0 : v.toDouble(),
                trigger: false))
        .slider('sliderInline', min: 0, max: 100, inline: true, onChanged: (v) {
          formManagement.setValue('sliderInlineText', v.round(),
              trigger: false);
        })
        .rangeSlider(
          'rangeSlider',
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
        .commonField('commonField',
            commonField: CommonField(
              {'text': 'click me and change my text'},
              builder: (state, context, readOnly, stateMap, themeData,
                  formThemeData) {
                return TextButton(
                  child: Text(stateMap['text']),
                  onPressed: readOnly
                      ? null
                      : () {
                          formManagement.update('commonField', {
                            'text': Random.secure().nextDouble().toString()
                          });
                        },
                );
              },
            ));
  }
}

class Label extends StatelessWidget {
  final String label;
  const Label(this.label, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18, color: themeData.primaryColor),
    );
  }
}
