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
    formController.onFocusChange('username', (value) {
      print('username focused: $value');
    });
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: createForm(),
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
                print(formController.getData());
              },
              child: Text('get form data'),
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                formController.update('selector', {'loading': true});

                Future.delayed(Duration(seconds: 2), () {
                  formController.setValue('selector', null);
                  formController.update('selector', {
                    'items': FormBuilder.toSelectorItems(
                        [Random().nextDouble().toString()])
                  });
                });
              },
              child: Text('load selectoritems'),
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

  Widget createForm() {
    FormBuilder builder = FormBuilder(formController)
        .textField('username', labelText: '用户名', clearable: true, flex: 3,
            validator: (value) {
          return (value ?? '').isEmpty ? '不为空' : null;
        })
        .checkboxs('rememberMe', [CheckboxButton('记住')])
        .switch1('123')
        .nextLine()
        .textField('password',
            hintText: '密码',
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
          hintText: '年龄',
          clearable: true,
          flex: 3,
          min: 14,
          max: 99,
          onChanged: (value) {
            print(value);
          },
          validator: (value) => value == null ? '不为空' : null,
        )
        .checkboxGroup(
          'checkbox',
          [
            CheckboxButton('男'),
            CheckboxButton('女'),
          ],
          split: 2,
          label: '性别',
          onChanged: (value) => print(value),
          validator: (value) => (value ?? []).isEmpty ? '请选择性别' : null,
        )
        .divider('divider')
        .radioGroup(
          'radio',
          [
            RadioButton('1', '1', controlKey: 'radio 1'),
            RadioButton('2', '2'),
          ],
          onChanged: (value) => print(value),
          label: '单选框',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .divider('divider')
        .nextLine()
        .datetimeField(
          'startTime',
          useTime: true,
          hintText: '开始日期',
        )
        .datetimeField(
          'endTime',
          useTime: true,
          hintText: '结束日期',
        )
        .nextLine()
        .textField('remark',
            hintText: '备注',
            maxLines: 5,
            flex: 1,
            clearable: true,
            maxLength: 500)
        .nextLine()
        .selector('selector',
            labelText: '选择器',
            multi: true,
            items: FormBuilder.toSelectorItems(
                new List<int>.generate(100, (i) => i + 1)
                    .map((e) => e.toString())
                    .toList()),
            onChanged: (value) => print(value),
            validator: (value) =>
                (value ?? []).isEmpty ? 'select something !' : null)
        .nextLine()
        .switchGroup('switch',
            label: 'switch',
            validator: (value) =>
                (value == null || value.isEmpty) ? 'select one pls !' : null,
            items: List<String>.generate(3, (index) => index.toString()));
    return builder.build();
  }
}
