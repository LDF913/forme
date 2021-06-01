import 'package:flutter/material.dart';
import '../forme_field.dart';
import '../render/forme_render_utils.dart';
import '../forme_state_model.dart';

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

/// wrap your field in a [InputDecorator]
///
/// **worked well if you no need to support prefixIcon & suffixIcon & prefix & sufix**
class FormeInputDecorator extends StatefulWidget {
  final InputDecoration? decoration;
  final Widget child;
  const FormeInputDecorator({Key? key, this.decoration, required this.child})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormeInputDecoratorState();
}

class _FormeInputDecoratorState extends State<FormeInputDecorator> {
  bool _focus = false;
  String? _errorText;

  late FormeInputDecoratorModel model;

  _onFocusChanged(bool focus) {
    setState(() {
      this._focus = focus;
    });
  }

  _onErrorChanged(String? errorText) {
    setState(() {
      this._errorText = errorText;
    });
  }

  _updateModel(FormeModel model) {
    FormeInputDecoratorModel decoratorModel = model as FormeInputDecoratorModel;
    if (this.model != decoratorModel)
      setState(() {
        this.model =
            decoratorModel.copyWith(this.model) as FormeInputDecoratorModel;
      });
  }

  _setModel(FormeModel model) {
    FormeInputDecoratorModel decoratorModel = model as FormeInputDecoratorModel;
    if (this.model != decoratorModel)
      setState(() {
        this.model = decoratorModel;
      });
  }

  @override
  void initState() {
    super.initState();
    model = FormeInputDecoratorModel(decoration: widget.decoration);
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      isEmpty: true,
      isFocused: _focus,
      decoration: (model.decoration ?? const InputDecoration())
          .copyWith(errorText: _errorText),
      child: FormeDecoration(
        onFocusChanged: _onFocusChanged,
        onErrorChanged: _onErrorChanged,
        child: widget.child,
        management: FormeDecoratorModelManagement(
          model: model,
          updateModel: _updateModel,
          setModel: _setModel,
        ),
      ),
    );
  }
}
