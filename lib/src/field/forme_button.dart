import 'package:flutter/material.dart';

import '../forme_field.dart';
import '../forme_state_model.dart';

enum FormeButtonType { Text, Elevated, Outlined }

class FormeButton extends CommonField<FormeButtonModel> {
  FormeButton({
    String? name,
    int flex = 0,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    required Widget child,
    FormeButtonType type = FormeButtonType.Text,
    FormeButtonModel? model,
    Key? key,
  }) : super(
            key: key,
            model: (model ?? FormeButtonModel())
                .merge(FormeButtonModel(child: child, type: type)),
            name: name,
            readOnly: readOnly,
            builder: (state) {
              bool readOnly = state.readOnly;
              Icon? icon = state.model.icon;
              Widget child = state.model.child!;
              ButtonStyle? style = state.model.style;
              FormeButtonType type = state.model.type!;

              VoidCallback? _onPressed = readOnly ? null : onPressed;
              VoidCallback? _onLongPress = readOnly ? null : onLongPress;

              Widget button;

              switch (type) {
                case FormeButtonType.Text:
                  button = icon == null
                      ? TextButton(
                          focusNode: state.focusNode,
                          onPressed: _onPressed,
                          onLongPress: _onLongPress,
                          style: style,
                          child: child)
                      : TextButton.icon(
                          onPressed: _onPressed,
                          icon: icon,
                          label: child,
                          style: style,
                          focusNode: state.focusNode,
                        );
                  break;
                case FormeButtonType.Elevated:
                  button = icon == null
                      ? ElevatedButton(
                          style: style,
                          focusNode: state.focusNode,
                          onPressed: _onPressed,
                          onLongPress: _onLongPress,
                          child: child)
                      : ElevatedButton.icon(
                          style: style,
                          onPressed: _onPressed,
                          icon: icon,
                          label: child,
                          focusNode: state.focusNode,
                        );
                  break;
                case FormeButtonType.Outlined:
                  button = icon == null
                      ? OutlinedButton(
                          style: style,
                          focusNode: state.focusNode,
                          onPressed: _onPressed,
                          onLongPress: _onLongPress,
                          child: child)
                      : OutlinedButton.icon(
                          style: style,
                          onPressed: _onPressed,
                          icon: icon,
                          label: child,
                          focusNode: state.focusNode,
                        );
                  break;
              }

              switch (type) {
                case FormeButtonType.Text:
                  return TextButtonTheme(
                      data: state.model.textButtonThemeData ??
                          TextButtonTheme.of(state.context),
                      child: button);
                case FormeButtonType.Elevated:
                  return ElevatedButtonTheme(
                      data: state.model.elevatedButtonThemeData ??
                          ElevatedButtonTheme.of(state.context),
                      child: button);
                case FormeButtonType.Outlined:
                  return OutlinedButtonTheme(
                      data: state.model.outlinedButtonThemeData ??
                          OutlinedButtonTheme.of(state.context),
                      child: button);
              }
            });
}

class FormeButtonModel extends AbstractFormeModel {
  final Widget? child;
  final FormeButtonType? type;
  final Icon? icon;
  final ButtonStyle? style;
  final TextButtonThemeData? textButtonThemeData;
  final ElevatedButtonThemeData? elevatedButtonThemeData;
  final OutlinedButtonThemeData? outlinedButtonThemeData;
  FormeButtonModel({
    this.child,
    this.type,
    this.icon,
    this.style,
    this.textButtonThemeData,
    this.elevatedButtonThemeData,
    this.outlinedButtonThemeData,
  });

  @override
  FormeButtonModel merge(AbstractFormeModel old) {
    FormeButtonModel oldModel = old as FormeButtonModel;
    return FormeButtonModel(
      child: child ?? oldModel.child,
      type: type ?? oldModel.type,
      icon: icon ?? oldModel.icon,
      style: style ?? oldModel.style,
      textButtonThemeData: textButtonThemeData ?? oldModel.textButtonThemeData,
      elevatedButtonThemeData:
          elevatedButtonThemeData ?? oldModel.elevatedButtonThemeData,
      outlinedButtonThemeData:
          outlinedButtonThemeData ?? oldModel.outlinedButtonThemeData,
    );
  }
}
