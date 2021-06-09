import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import '../forme_core.dart';
import '../render/forme_render_utils.dart';
import '../forme_state_model.dart';
import 'forme_listenable_builder.dart';

class FormeInputDecoratorBuilder<T> implements FormeDecoratorBuilder<T> {
  final bool Function(T? value)? emptyChecker;
  final InputDecoration? decoration;
  final Widget Function(Widget child)? wrapper;
  const FormeInputDecoratorBuilder(
      {this.emptyChecker, this.decoration, this.wrapper});
  @override
  Widget build(
    ValueListenable<bool> focusListenable,
    ValueListenable<FormeValidateError?> errorTextListenable,
    ValueListenable<T?> valueListenable,
    Widget child,
    FormeModel? model,
  ) {
    return FormeInputDecorator<T>(
      emptyChecker: emptyChecker,
      decoration: decoration,
      focusListenable: focusListenable,
      errorTextListenable: errorTextListenable,
      valueListenable: valueListenable,
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
  final ValueListenable<bool> focusListenable;
  final ValueListenable<FormeValidateError?> errorTextListenable;
  final ValueListenable<T?> valueListenable;
  final InputDecoration? decoration;
  final Widget Function(Widget child)? wrapper;

  FormeInputDecorator({
    required this.focusListenable,
    required this.errorTextListenable,
    required this.valueListenable,
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
    FormeModel? decoratorModel =
        FormeValueFieldController.of(context).decoratorController.currentModel;
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
          valueListenable: focusListenable,
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
        focusListenable,
        errorTextListenable,
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
        return ValueListenableBuilder2(focusListenable, valueListenable,
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
        focusListenable,
        errorTextListenable,
        valueListenable,
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
