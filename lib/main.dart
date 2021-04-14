import 'package:flutter/material.dart';
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
  FormControllerDelegate formController;

  @override
  void initState() {
    super.initState();
    formController = FormControllerDelegate();
    formController.onFocusChange('username', (value) {
      print('username focused: $value');
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
              child: Builder(builder: (context) {
                return createForm(context);
              }),
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.visible = !formController.visible;
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(
                        formController.visible ? 'hide form' : 'show form'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.readOnly = !formController.readOnly;
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.readOnly
                        ? 'set form editable'
                        : 'set form readonly'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.setVisible(
                          'username', !formController.isVisible('username'));
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.isVisible('username')
                        ? 'hide username'
                        : 'show username'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.setReadOnly(
                          'username', !formController.isReadOnly('username'));
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.isReadOnly('username')
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
                  formController.validate();
                },
                child: Text('validate')),
            TextButton(
                onPressed: () {
                  formController.validate1('username');
                },
                child: Text('validate username only')),
            TextButton(
                onPressed: () {
                  formController.reset();
                },
                child: Text('reset')),
            TextButton(
                onPressed: () {
                  formController.update('checkbox', {
                    'items': [
                      CheckboxButton('男', readOnly: true),
                      CheckboxButton('女')
                    ]
                  });
                },
                child: Text('set man readonly')),
            TextButton(
                onPressed: () {
                  formController.requestFocus('age');
                },
                child: Text('age focus')),
            TextButton(
                onPressed: () {
                  formController.update('username', {
                    'labelText': DateTime.now().toString(),
                  });
                },
                child: Text('change username\'s label')),
            TextButton(
                onPressed: () {
                  formController.setSelection('age', 1, 1);
                },
                child: Text('set age\'s selection')),
            TextButton(
              onPressed: () {
                print(formController.getData());
              },
              child: Text('get form data'),
            ),
            TextButton(
              onPressed: () {
                formController.setValue('checkbox', null);
                formController.update('checkbox', {
                  'items': [CheckboxButton('I\'m readonly', readOnly: true)],
                });
              },
              child: Text('reload sex checkboxs'),
            ),
            TextButton(
              onPressed: () {
                formController.themeData = FormThemeData();
              },
              child: Text('set new form theme'),
            )
          ]),
        ));
  }

  Widget createForm(BuildContext context) {
    formController.themeData = DefaultThemeData(context);
    FormBuilder builder = FormBuilder(formController)
        .textField('username',
            labelText: 'username',
            clearable: true,
            selectAllOnFocus: true,
            onChanged: (value) => print('username value changed $value'),
            validator: (value) {
              return value.isEmpty ? 'not empty' : null;
            })
        .checkboxInline(
          'rememberMe',
          [CheckboxButton('remember me')],
        )
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
        .button('button', () {
          print('x');
        }, flex: 0, label: '登录')
        .nextLine()
        .numberField(
          'age',
          hintText: 'age',
          clearable: true,
          flex: 3,
          min: 14,
          max: 99,
          onChanged: (value) => print('age value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .radioInline(
          'radioInline',
          FormBuilder.toRadioButtons(['1', '2']),
        )
        .checkboxGroup(
          'checkbox',
          FormBuilder.toCheckboxButtons(['男', '女']),
          split: 2,
          label: 'sex',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .divider('divider')
        .radioGroup(
          'radio',
          [
            RadioButton('1', '1', controlKey: 'radio 1'),
            RadioButton('2', '2'),
          ],
          onChanged: (value) => print('radio value changed $value'),
          label: 'single choice',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .divider('divider')
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
              String filter = params['filter'] ?? '';
              print(filter);
              List items = List<String>.generate(100, (i) => (i + 1).toString())
                  .where((element) => element.contains(filter))
                  .toList();
              return Future.delayed(Duration(seconds: 1), () {
                return SelectItemPage(
                    items.sublist((page - 1) * 20,
                        page * 20 > items.length ? items.length : page * 20),
                    items.length);
              });
            },
            queryFormBuilder: (builder, query) {
              return builder.textField('filter',
                  validator: (value) =>
                      value.isEmpty ? 'pls input something to query !' : null,
                  clearable: true,
                  suffixIcons: [
                    InkWell(
                      onTap: () {
                        query();
                      },
                      child: Icon(Icons.search),
                    )
                  ]).build();
            },
            selectedItemLayoutType: SelectedItemLayoutType.scroll,
            onChanged: (value) => print('selector value changed $value'),
            validator: (value) => value.isEmpty ? 'select something !' : null)
        .switchGroup('switchGroup',
            label: 'switch',
            onChanged: (value) => print('switchGroup value changed $value'),
            validator: (value) => value.isEmpty ? 'select one pls !' : null,
            items: List<String>.generate(3, (index) => index.toString()))
        .slider(
          'slider',
          min: 0,
          max: 100,
          label: 'age slider',
          initialValue: 1,
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
            onChanged: (v) => formController.setValue(
                'sliderInline', v == null ? 0.0 : v.toDouble(), trigger: false))
        .sliderInline('sliderInline',
            min: 0,
            max: 100,
            onChanged: (v) => formController
                .setValue('sliderInlineText', v.round(), trigger: false));
    return builder.build();
  }
}
