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
                formController.theme.set(
                    themeData: Theme.of(context)
                        .copyWith(primaryColor: HexColor('#54D3C2')));
              },
              child: Text('set new form theme'),
            )
          ]),
        ));
  }

  Widget createForm() {
    RadioGroupTheme radioGroupTheme = RadioGroupTheme(labelSpace: 10);
    formController.theme.set(
        themeData: buildLightTheme(context),
        labelPadding: const EdgeInsets.only(top: 8, bottom: 8),
        radioGroupTheme: radioGroupTheme,
        checkboxGroupTheme: radioGroupTheme);
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
            CheckboxButton('女'),
            CheckboxButton('女'),
            CheckboxButton('very loooooooooooooong text', ignoreSplit: true),
          ],
          label: '性别',
          validator: (value) => (value ?? []).length == 0 ? '请选择性别' : null,
        )
        .radioGroup(
          'radio',
          [
            RadioButton('1', '1', controlKey: 'radio 1'),
            RadioButton('2', '2'),
          ],
          label: '单选框',
          validator: (value) => value == null ? 'select one !' : null,
        )
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

  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      headline1: base.headline1.copyWith(fontFamily: fontName),
      headline2: base.headline2.copyWith(fontFamily: fontName),
      headline3: base.headline3.copyWith(fontFamily: fontName),
      headline4: base.headline4.copyWith(fontFamily: fontName),
      headline5: base.headline5.copyWith(fontFamily: fontName),
      headline6: base.headline6.copyWith(fontFamily: fontName),
      button: base.button.copyWith(fontFamily: fontName),
      caption: base.caption.copyWith(fontFamily: fontName),
      bodyText1: base.bodyText1.copyWith(fontFamily: fontName),
      bodyText2: base.bodyText2.copyWith(fontFamily: fontName),
      subtitle1: base.subtitle1.copyWith(fontFamily: fontName),
      subtitle2: base.subtitle2.copyWith(fontFamily: fontName),
      overline: base.overline.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData buildLightTheme(context) {
    final Color primaryColor = HexColor('#54D3C2');
    final Color secondaryColor = HexColor('#54D3C2');
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
          )),
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      unselectedWidgetColor: Colors.grey.withOpacity(0.6),
      backgroundColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }
}
