import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

typedef Updater<T> = T Function(T t);

abstract class BasePage<T, E extends FormeModel> extends StatelessWidget {
  final String name = 'field';
  final FormeKey formKey = FormeKey();

  FormeValueFieldManagement<T, E> get management => formKey.valueField(name);

  String get title;

  Widget get body;

  Widget createButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextButton(onPressed: onPressed, child: Text(text)),
    );
  }

  void showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    ));
  }

  void updateLabel() {
    management.updateDecoratorModel(FormeInputDecoratorModel(
        decoration: InputDecoration(labelText: 'New Label Text')));
  }

  void updateLabelStyle() {
    management.updateDecoratorModel(FormeInputDecoratorModel(
        decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent))));
  }

  void updateHelperStyle() {
    management.updateDecoratorModel(FormeInputDecoratorModel(
        decoration: InputDecoration(helperText: 'helper text')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Forme(
          child: body,
          key: formKey,
        ),
      ),
    );
  }
}
