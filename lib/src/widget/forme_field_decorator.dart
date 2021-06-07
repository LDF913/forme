import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../render/forme_render_utils.dart';
import '../forme_core.dart';
import '../forme_state_model.dart';
import 'forme_listenable_builder.dart';

typedef FormeDecoratorBuilder<T, E extends FormeModel> = Widget Function(
  BuildContext context,
  ValueListenable<bool> focusListenable,
  ValueListenable<T?> valueListenable,
  ValueListenable<Optional<String>?> errorTextListenable,
  E model,
);

class FormeDecorator<T, E extends FormeModel> extends StatefulWidget {
  final String name;
  final E model;
  final FormeDecoratorBuilder<T, E> builder;
  FormeDecorator({
    Key? key,
    required this.name,
    required this.model,
    required this.builder,
  }) : super(key: key);

  @override
  FormeDecoratorState<T, E> createState() => FormeDecoratorState();
}

class FormeDecoratorState<T, E extends FormeModel>
    extends State<FormeDecorator<T, E>> {
  E? _model;
  late FormeFieldListenable<T> _notifier;

  E get model => _model ?? widget.model;

  late final ValueNotifier<E> _modelNotifier;

  @override
  void initState() {
    super.initState();
    _modelNotifier = ValueNotifier(model);
    _modelNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notifier = FormeKey.of(context).fieldListenable<T>(widget.name);
  }

  @override
  void dispose() {
    _modelNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.builder(
        context,
        _notifier.focusListenable,
        _notifier.valueListenable,
        _notifier.errorTextListenable,
        _modelNotifier.value);
    return FormeDecoratorController<E>(
      _modelNotifier,
      child: child,
    );
  }
}

/// used to update decorator model
class FormeDecoratorController<E extends FormeModel> extends InheritedWidget {
  final ValueNotifier<E> _valueListenable;

  set model(E model) => _valueListenable.value = model;
  E get model => _valueListenable.value;

  void update(E model) =>
      _valueListenable.value = model.copyWith(_valueListenable.value) as E;

  FormeDecoratorController(
    this._valueListenable, {
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

typedef EmptyChecker<T> = bool Function(T? value);

/// wrap your field in a [InputDecorator]
///
/// **worked well if you no need to support prefixIcon & suffixIcon & prefix & sufix**
class FormeInputDecorator<T>
    extends FormeDecorator<T, FormeInputDecoratorModel> {
  FormeInputDecorator({
    Key? key,
    InputDecoration? decoration,
    required Widget child,
    required String name,
    EmptyChecker<T>? emptyChecker,
  }) : super(
            key: key,
            name: name,
            model: FormeInputDecoratorModel(
                decoration: decoration ?? const InputDecoration()),
            builder: (context, focusListenable, valueListenable,
                errorTextListenable, model) {
              if (emptyChecker == null) {
                if (FormeKey.of(context).quietlyValidate) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: focusListenable,
                    builder: (context, focus, _child) {
                      return InputDecorator(
                        isEmpty: false,
                        isFocused: focus,
                        decoration:
                            (model.decoration ?? const InputDecoration()),
                        child: child,
                      );
                    },
                  );
                }
                return ValueListenableBuilder2(
                  focusListenable,
                  errorTextListenable,
                  builder: (context, bool focus, Optional<String>? errorText,
                      _child) {
                    return InputDecorator(
                      isEmpty: false,
                      isFocused: focus,
                      decoration: (model.decoration ?? const InputDecoration())
                          .copyWith(errorText: errorText?.value),
                      child: child,
                    );
                  },
                );
              } else {
                if (FormeKey.of(context).quietlyValidate) {
                  return ValueListenableBuilder2(
                      focusListenable, valueListenable,
                      builder: (context, bool focus, T? value, child) {
                    return InputDecorator(
                      isEmpty: emptyChecker(value),
                      isFocused: focus,
                      decoration: (model.decoration ?? const InputDecoration()),
                      child: child,
                    );
                  });
                }
                return ValueListenableBuilder3(
                  focusListenable,
                  errorTextListenable,
                  valueListenable,
                  builder: (context, bool focus, Optional<String>? errorText,
                      T? value, _child) {
                    return InputDecorator(
                      isEmpty: emptyChecker(value),
                      isFocused: focus,
                      decoration: (model.decoration ?? const InputDecoration())
                          .copyWith(errorText: errorText?.value),
                      child: child,
                    );
                  },
                );
              }
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
