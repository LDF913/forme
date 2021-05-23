import 'package:flutter/material.dart';
import 'page/demo2.dart';

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
        '/demo2': (context) => Demo2Page(),
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
                  Navigator.pushNamed(context, '/demo2');
                },
                child: Text('demo2 page')),
          ],
        ));
  }
}
