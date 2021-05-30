import 'package:flutter/material.dart';

/// this model used to update `FormeDecorator`,it's type is determined by the decorator that you used
/// when you use [FormeInputDecorator] , it's type is [FormeInputDecoratorModel]
///
/// most field which can not decoratored well by [InputDecorator],such as [FormeRate] [FormeSlider] ,
/// it's [FormeFieldManagement] can be cast to [FormeDecoratorManagement], you can set model via [FormeDecoratorManagement.decoratorModel]
@immutable
abstract class FormeDecoratorModel {}

/// an inherited widget used to connect `FormeField` and `FormeDecorator`
///
/// this widget should be provided by `FormeDecorator`
///
/// when `FormeField`'s errorText or focus changed , `FormeField`
/// should call [FormeDecoration]'s onFocusChanged or onErrorChanged
/// to notify `FormeDecorator` rebuild
///
/// see
///   1. [FormeInputDecorator]
///   2. [FormeDecoratorState]
class FormeDecoration extends InheritedWidget {
  final ValueChanged<bool> onFocusChanged;
  final ValueChanged<String?> onErrorChanged;
  final FormeDecoratorModel? decoratorModel;
  final ValueChanged<FormeDecoratorModel?> onModelChanged;

  FormeDecoration({
    required this.onFocusChanged,
    required this.onErrorChanged,
    required Widget child,
    required this.decoratorModel,
    required this.onModelChanged,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant FormeDecoration oldWidget) {
    return decoratorModel != oldWidget.decoratorModel;
  }

  static FormeDecoration? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormeDecoration>();
  }
}

mixin FormeDecorationState<T extends StatefulWidget> on State<T> {
  bool _focus = false;
  String? _errorText;

  @protected
  bool get focus => _focus;
  @protected
  String? get errorText => _errorText;

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

  @protected
  onModelChanged(FormeDecoratorModel? model);
  Widget get child;
  FormeDecoratorModel? get decoratorModel;

  @override
  Widget build(BuildContext context) {
    return FormeDecoration(
      onFocusChanged: _onFocusChanged,
      onErrorChanged: _onErrorChanged,
      child: child,
      decoratorModel: decoratorModel,
      onModelChanged: onModelChanged,
    );
  }
}
