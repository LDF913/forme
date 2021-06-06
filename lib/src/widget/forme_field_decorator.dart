import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../render/forme_render_utils.dart';
import '../forme_core.dart';
import '../forme_state_model.dart';

typedef FormeDecoratorBuilder<T> = Widget Function(
  BuildContext context,
  ValueListenable<bool> focusListenable,
  ValueListenable<dynamic> valueListenable,
  ValueListenable<Optional<String>?> errorTextListenable,
  T model,
);

class FormeDecorator<T extends FormeModel> extends StatefulWidget {
  final String name;
  final T model;
  final FormeDecoratorBuilder<T> builder;
  FormeDecorator({
    Key? key,
    required this.name,
    required this.model,
    required this.builder,
  }) : super(key: key);

  @override
  FormeDecoratorState<T> createState() => FormeDecoratorState();
}

class FormeDecoratorState<T extends FormeModel>
    extends State<FormeDecorator<T>> {
  T? _model;
  late FormefieldListenable _notifier;

  T get model => _model ?? widget.model;

  late final ValueNotifier<T> modelNotifier;

  @override
  void initState() {
    super.initState();
    modelNotifier = ValueNotifier(model);
    modelNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notifier = FormeKey.of(context).fieldListenable(widget.name);
  }

  @override
  void dispose() {
    modelNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.builder(
        context,
        _notifier.focusListenable,
        _notifier.valueNotifier,
        _notifier.errorTextListenable,
        modelNotifier.value);
    return FormeDecoratorController<T>(
      modelNotifier,
      child: child,
    );
  }
}

/// used to update decorator model
class FormeDecoratorController<T extends FormeModel> extends InheritedWidget {
  final ValueNotifier<T> _valueNotifier;

  set model(T model) => _valueNotifier.value = model;
  T get model => _valueNotifier.value;

  void update(T model) =>
      _valueNotifier.value = model.copyWith(_valueNotifier.value) as T;

  FormeDecoratorController(
    this._valueNotifier, {
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant FormeDecoratorController oldWidget) {
    return model != oldWidget.model;
  }

  static FormeDecoratorController<T>? of<T extends FormeModel>(
      BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FormeDecoratorController<T>>();
  }
}

/// wrap your field in a [InputDecorator]
///
/// **worked well if you no need to support prefixIcon & suffixIcon & prefix & sufix**
class FormeInputDecorator extends FormeDecorator<FormeInputDecoratorModel> {
  FormeInputDecorator({
    Key? key,
    InputDecoration? decoration,
    required Widget child,
    required String name,
    bool isEmpty = false,
  }) : super(
            key: key,
            name: name,
            model: FormeInputDecoratorModel(
                decoration: decoration ?? const InputDecoration()),
            builder: (context, a, b, c, model) {
              if (FormeKey.of(context).quietlyValidate) {
                return ValueListenableBuilder<bool>(
                    valueListenable: a,
                    builder: (context, focus, _child) {
                      return InputDecorator(
                        isEmpty: false,
                        isFocused: focus,
                        decoration:
                            (model.decoration ?? const InputDecoration()),
                        child: child,
                      );
                    });
              }
              return _ValueListenableBuilder2<bool, Optional<String>?>(
                a,
                c,
                builder:
                    (context, bool focus, Optional<String>? errorText, _child) {
                  return InputDecorator(
                    isEmpty: isEmpty,
                    isFocused: focus,
                    decoration: (model.decoration ?? const InputDecoration())
                        .copyWith(errorText: errorText?.value),
                    child: child,
                  );
                },
              );
            });
}

class FormeInputDecoratorModel extends FormeModel {
  final InputDecoration? decoration;

  FormeInputDecoratorModel({this.decoration});

  @override
  FormeModel copyWith(FormeModel oldModel) {
    FormeInputDecoratorModel old = oldModel as FormeInputDecoratorModel;
    return FormeInputDecoratorModel(
      decoration:
          FormeRenderUtils.copyInputDecoration(old.decoration, decoration),
    );
  }
}

class _ValueListenableBuilder2<A, B> extends StatelessWidget {
  _ValueListenableBuilder2(
    this.first,
    this.second, {
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}
