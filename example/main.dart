import 'package:flutter/material.dart';

import 'page/button.dart';
import 'page/checkbox_group.dart';
import 'page/datetime_field.dart';
import 'page/filter_chip.dart';
import 'page/main.dart';
import 'page/number_field.dart';
import 'page/radio_group.dart';
import 'page/range_slider.dart';
import 'page/rate.dart';
import 'page/selector.dart';
import 'page/single_checkbox.dart';
import 'page/single_switch.dart';
import 'page/slider.dart';
import 'page/switch_group.dart';
import 'page/text_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Builder',
      home: MyHomePage(title: 'Flutter Form Builder'),
      routes: {
        '/filterChip': (context) => FilterChipPage(),
        '/rate': (context) => RatePage(),
        '/button': (context) => ButtonPage(),
        '/single_switch': (context) => SingleSwitchPage(),
        '/single_checkbox': (context) => SingleCheckboxPage(),
        '/slider': (context) => SliderPage(),
        '/rangeSlider': (context) => RangeSliderPage(),
        '/radio_group': (context) => RadioGroupPage(),
        '/checkbox_group': (context) => CheckboxGroupPage(),
        '/switch_group': (context) => SwitchGroupPage(),
        '/selector': (context) => SelectorPage(),
        '/number': (context) => NumberFieldPage(),
        '/datetime': (context) => DateTimeFieldPage(),
        '/text': (context) => TextFieldPage(),
        '/demo': (context) => DemoPage(),
      },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/filterChip');
                },
                child: Text('FilterChipFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rate');
                },
                child: Text('RateFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/button');
                },
                child: Text('ButtonFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/single_switch');
                },
                child: Text('SingleSwitchFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/single_checkbox');
                },
                child: Text('SingleCheckboxFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/slider');
                },
                child: Text('SliderFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rangeSlider');
                },
                child: Text('RangeSliderFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/radio_group');
                },
                child: Text('RadioGroupFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkbox_group');
                },
                child: Text('CheckboxGroupFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/switch_group');
                },
                child: Text('SwitchFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/selector');
                },
                child: Text('SelectorFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/number');
                },
                child: Text('NumberFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/datetime');
                },
                child: Text('DateTimeFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/text');
                },
                child: Text('TextFormField')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/demo');
                },
                child: Text('demo page')),
          ],
        ));
  }
}
