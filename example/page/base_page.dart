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

  void updateDecoration(Updater<InputDecoration> updater) {
    FormeDecoratorManagement management =
        this.management as FormeDecoratorManagement;
    FormeInputDecoratorModel decoratorModel =
        management.decoratorModel as FormeInputDecoratorModel;
    InputDecoration decoration =
        updater(decoratorModel.decoration ?? const InputDecoration());
    management.decoratorModel =
        FormeInputDecoratorModel(decoration: decoration);
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
