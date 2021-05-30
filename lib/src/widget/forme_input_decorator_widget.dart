import 'package:flutter/material.dart';

import 'forme_decoration_widget.dart';

class FormeInputDecoratorModel extends FormeDecoratorModel {
  final InputDecoration? decoration;

  FormeInputDecoratorModel({this.decoration});
}

/// wrap your field in a [InputDecorator]
///
/// **NOT SUPPORT prefixIcon & suffixIcon & prefix & sufix**
class FormeInputDecorator extends StatefulWidget {
  final InputDecoration? decoration;
  final Widget child;
  const FormeInputDecorator({Key? key, this.decoration, required this.child})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormeInputDecoratorState();
}

class _FormeInputDecoratorState extends State<FormeInputDecorator>
    with FormeDecorationState {
  late FormeInputDecoratorModel model;

  @override
  void initState() {
    super.initState();
    model = FormeInputDecoratorModel(decoration: widget.decoration);
  }

  @override
  FormeDecoratorModel? get decoratorModel => model;

  @override
  Widget get child {
    return InputDecorator(
      isEmpty: false,
      isFocused: focus,
      decoration: (model.decoration ?? const InputDecoration())
          .copyWith(errorText: errorText),
      child: widget.child,
    );
  }

  @override
  onModelChanged(FormeDecoratorModel? model) {
    if (model == null) {
      setState(() {
        this.model = FormeInputDecoratorModel(decoration: widget.decoration);
      });
      return;
    }
    if (model is! FormeInputDecoratorModel)
      throw 'model need be FormeInputDecoratorModel current model is ${model.runtimeType}';
    setState(() {
      this.model = model;
    });
  }
}
