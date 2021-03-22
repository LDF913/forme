import 'package:flutter/material.dart';
import 'package:my_flutter/form/button.dart';

import 'form/checkbox_group.dart';
import 'form/form_util.dart';
import 'form/radio_group.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
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
  TextEditingController controller = TextEditingController();
  ButtonController buttonController = ButtonController();

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
      body: Wrap(children: [
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
                  buttonController.child = Icon(Icons.add);
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
        )
      ]),
    );
  }

  CheckboxGroupController cgc = CheckboxGroupController();
  RadioGroupController rgc = RadioGroupController();
  TextEditingController tec = TextEditingController();

  Widget createForm() {
    FormBuilder builder = FormBuilder(formController)
      ..textField(
        '用户名',
        controlKey: 'username',
        clearable: true,
        flex: 3,
        validator: (value) => (value ?? '').isEmpty ? '不为空' : null,
      )
      ..checkboxs([CheckboxButton('记住')], flex: 0)
      ..nextLine()
      ..textField('密码',
          controlKey: '456',
          obscureText: true,
          passwordVisible: true,
          clearable: true,
          flex: 1)
      ..button(() {
        print('x');
      },
          flex: 0,
          controlKey: 'button',
          label: '登录',
          controller: buttonController)
      ..checkboxGroup(
          [CheckboxButton('男', controlKey: 'man'), CheckboxButton('女')],
          label: '性别',
          validator: (value) => (value ?? []).length == 0 ? '请选择性别' : null,
          controlKey: 'checkbox',
          controller: cgc)
      ..radioGroup(
        [
          RadioButton('1', '1', controlKey: 'radio 1'),
          RadioButton('2', '2'),
          RadioButton('3', '3')
        ],
        label: '单选框',
        controlKey: 'radio',
      )
      ..textField('123')
      ..checkboxs([CheckboxButton('1')])
      ..radios([RadioButton('1', '1')]);
    return builder.build();
  }
}
