import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'form/checkbox_group.dart';
import 'form/form_builder.dart';
import 'form/form_theme.dart';
import 'form/radio_group.dart';

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
  FormController formController;

  @override
  void initState() {
    super.initState();
    formController = FormController();
    formController.themeData = FormThemeData.defaultThemeData;
  }

  @override
  void dispose() {
    super.dispose();
    formController.dispose();
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
              padding: EdgeInsets.only(left: 20, right: 20),
              child: createForm(),
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.hide = !formController.hide;
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.hide ? 'show' : 'hide'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.readOnly = !formController.readOnly;
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(
                        formController.readOnly ? 'editable' : 'readonly'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      if (formController.isHide('username')) {
                        formController.hideKeys = [];
                      } else {
                        formController.hideKeys = ['username'];
                      }
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.isHide('username')
                        ? 'show username'
                        : 'hide username'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      if (formController.isReadOnly('username')) {
                        formController.readOnlyKeys = [];
                      } else {
                        formController.readOnlyKeys = ['username'];
                      }
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.isReadOnly('username')
                        ? 'set username editable'
                        : 'set username readonly'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      if (formController.isReadOnly('checkbox')) {
                        formController.readOnlyKeys = [];
                      } else {
                        formController.readOnlyKeys = ['checkbox'];
                      }
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.isReadOnly('checkbox')
                        ? 'set checkbox selectable'
                        : 'set checkbox readonly'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      if (formController.isHide('radio')) {
                        formController.hideKeys = [];
                      } else {
                        formController.hideKeys = ['radio'];
                      }
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.isHide('radio')
                        ? 'show radio'
                        : 'hide radio'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('rebuild page'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.validate();
                    },
                    child: Text('validate'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.reset();
                    },
                    child: Text('reset'));
              },
            ),
            Builder(
              builder: (context) {
                CheckboxGroupController cgc =
                    formController.getController('checkbox');
                return TextButton(
                    onPressed: () {
                      if (cgc.isReadOnly('man'))
                        cgc.readOnlyKeys = [];
                      else
                        cgc.readOnlyKeys = ['man'];
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(cgc.isReadOnly('man')
                        ? 'set man selectable'
                        : 'set man readonly'));
              },
            ),
            Builder(
              builder: (context) {
                RadioGroupController rgc =
                    formController.getController('radio');
                return TextButton(
                    onPressed: () {
                      if (rgc.isReadOnly('radio 1'))
                        rgc.readOnlyKeys = [];
                      else
                        rgc.readOnlyKeys = ['radio 1'];
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(rgc.isReadOnly('radio 1')
                        ? 'set radio 1 selectable'
                        : 'set radio 1 readonly'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      if (formController.isReadOnly('button'))
                        formController.readOnlyKeys = [];
                      else
                        formController.readOnlyKeys = ['button'];
                      (context as Element).markNeedsBuild();
                    },
                    child: Text(formController.isReadOnly('button')
                        ? 'set button pressable'
                        : 'set button readonly'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.requestFocus('age');
                    },
                    child: Text('age focus'));
              },
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () {
                      formController.rebuild('username', {
                        'label': DateTime.now().toString(),
                      });
                    },
                    child: Text('change username\'s label'));
              },
            ),
            TextButton(
              onPressed: () {
                formController.setValue('username', 'username');
                formController.setValue('password', '123456');
                formController.setValue('age', '21');
                formController.setValue('checkbox', [0, 1]);
                formController.setValue('radio', '1');
                formController.setValue('startTime', DateTime(2019, 10, 1));
                formController.setValue('remark', 'hello world');
                print(formController.getData());
              },
              child: Text('set&get form data'),
            ),
            TextButton(
              onPressed: () {
                formController.setValue('dropdown', null);
                formController.rebuild('dropdown', {
                  'items': FormBuilder.toDropdownItems(
                      [Random().nextDouble().toString()])
                });
              },
              child: Text('load dropdownitems'),
            ),
            TextButton(
              onPressed: () {
                formController.setValue('checkbox', null);
                formController.rebuild('checkbox', {
                  'items': FormBuilder.toCheckboxButtons(['男', '女', '未知']),
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

  Widget createForm() {
    FormBuilder builder = FormBuilder(formController)
        .textField(
          'username',
          label: '用户名',
          clearable: true,
          flex: 3,
          validator: (value) => (value ?? '').isEmpty ? '不为空' : null,
        )
        .checkboxs('rememberMe', [CheckboxButton('记住')])
        .nextLine()
        .textField('password',
            hintLabel: '密码',
            obscureText: true,
            passwordVisible: true,
            clearable: true,
            flex: 1)
        .button('button', () {
          print('x');
        }, flex: 0, label: '登录')
        .nextLine()
        .numberField(
          'age',
          hintLabel: '年龄',
          clearable: true,
          flex: 3,
          min: 14,
          max: 99,
          validator: (value) => value == null ? '不为空' : null,
        )
        .checkboxGroup(
          'checkbox',
          [
            CheckboxButton('男', controlKey: 'man'),
            CheckboxButton('女'),
            CheckboxButton('very loooooooooooooong text', ignoreSplit: true),
          ],
          label: '性别',
          validator: (value) => (value ?? []).length == 0 ? '请选择性别' : null,
        )
        .divider('divider')
        .radioGroup(
          'radio',
          [
            RadioButton('1', '1', controlKey: 'radio 1'),
            RadioButton('2', '2'),
          ],
          label: '单选框',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .divider('divider')
        .nextLine()
        .datetimeField(
          'startTime',
          useTime: true,
          hintLabel: '开始日期',
        )
        .datetimeField(
          'endTime',
          useTime: true,
          hintLabel: '结束日期',
        )
        .nextLine()
        .textField('remark',
            hintLabel: '备注',
            maxLines: 5,
            flex: 1,
            clearable: true,
            maxLength: 500)
        .nextLine()
        .dropdown('dropdown',
            validator: (value) => value == null ? 'select something !' : null);
    return builder.build();
  }
}
