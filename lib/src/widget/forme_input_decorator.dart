import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeInputDecoratorBuilder<T> implements FormeDecoratorBuilder<T> {
  final bool Function(T? value)? emptyChecker;
  final InputDecoration? decoration;
  final Widget Function(Widget child)? wrapper;
  const FormeInputDecoratorBuilder(
      {this.emptyChecker, this.decoration, this.wrapper});
  @override
  Widget build(
    FormeValueFieldController<T, FormeModel> controller,
    Widget child,
  ) {
    return FormeInputDecorator<T>(
      emptyChecker: emptyChecker,
      decoration: decoration,
      controller: controller,
      child: child,
      wrapper: wrapper,
    );
  }
}

/// wrap your field in a [InputDecorator]
///
/// **worked well if you no need to support prefixIcon & suffixIcon & prefix & sufix**
class FormeInputDecorator<T> extends StatelessWidget {
  final Widget child;
  final bool Function(T? value)? emptyChecker;
  final InputDecoration? decoration;
  final Widget Function(Widget child)? wrapper;
  final FormeValueFieldController<T, FormeModel> controller;

  FormeInputDecorator({
    required this.controller,
    Key? key,
    required this.child,
    this.decoration,
    this.emptyChecker,
    this.wrapper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = wrapper == null ? this.child : wrapper!(this.child);
    FormeInputDecoratorModel model;
    FormeModel? decoratorModel = controller.decoratorController.currentModel;
    if (decoratorModel == null || decoratorModel is! FormeInputDecoratorModel) {
      model = const FormeInputDecoratorModel();
    } else {
      model = decoratorModel;
    }
    model = model.copyWith(FormeInputDecoratorModel(decoration: decoration));

    InputDecoration _decoration = model.decoration ?? const InputDecoration();

    if (emptyChecker == null) {
      if (FormeKey.of(context).quietlyValidate) {
        return ValueListenableBuilder<bool>(
          valueListenable: controller.focusListenable,
          builder: (context, focus, _child) {
            return InputDecorator(
              isEmpty: false,
              isFocused: focus,
              decoration: _decoration,
              child: child,
            );
          },
        );
      }
      return ValueListenableBuilder2(
        controller.focusListenable,
        controller.errorTextListenable,
        builder: (context, bool focus, FormeValidateError? error, _child) {
          return InputDecorator(
            isEmpty: false,
            isFocused: focus,
            decoration: _decoration.copyWith(errorText: error?.text),
            child: child,
          );
        },
      );
    } else {
      if (FormeKey.of(context).quietlyValidate) {
        return ValueListenableBuilder2(
            controller.focusListenable, controller.valueListenable,
            builder: (context, bool focus, T? value, child) {
          return InputDecorator(
            isEmpty: emptyChecker!(value),
            isFocused: focus,
            decoration: _decoration,
            child: child,
          );
        });
      }
      return ValueListenableBuilder3(
        controller.focusListenable,
        controller.errorTextListenable,
        controller.valueListenable,
        builder:
            (context, bool focus, FormeValidateError? error, T? value, _child) {
          return InputDecorator(
            isEmpty: emptyChecker!(value),
            isFocused: focus,
            decoration: _decoration.copyWith(errorText: error?.text),
            child: child,
          );
        },
      );
    }
  }
}

class FormeInputDecoratorModel extends FormeModel {
  final InputDecoration? decoration;

  const FormeInputDecoratorModel({this.decoration});

  @override
  FormeInputDecoratorModel copyWith(FormeModel oldModel) {
    FormeInputDecoratorModel old = oldModel as FormeInputDecoratorModel;
    return FormeInputDecoratorModel(
      decoration:
          FormeRenderUtils.copyInputDecoration(old.decoration, decoration),
    );
  }
}
