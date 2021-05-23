import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_state_model.dart';

enum ButtonType { Text, Elevated, Outlined }

class ButtonFormField extends CommonField<ButtonModel> {
  ButtonFormField({
    String? name,
    int flex = 0,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    required Widget child,
    ButtonType type = ButtonType.Text,
    ButtonModel? model,
  }) : super(
            model: (model ?? ButtonModel())
                .merge(ButtonModel(child: child, type: type)),
            name: name,
            readOnly: readOnly,
            builder: (state) {
              bool readOnly = state.readOnly;
              Icon? icon = state.model.icon;
              Widget child = state.model.child!;
              ButtonStyle? style = state.model.style;
              ButtonType type = state.model.type!;

              VoidCallback? _onPressed = readOnly ? null : onPressed;
              VoidCallback? _onLongPress = readOnly ? null : onLongPress;

              Widget button;

              switch (type) {
                case ButtonType.Text:
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
                case ButtonType.Elevated:
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
                case ButtonType.Outlined:
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
                case ButtonType.Text:
                  return TextButtonTheme(
                      data: state.model.textButtonThemeData ??
                          TextButtonTheme.of(state.context),
                      child: button);
                case ButtonType.Elevated:
                  return ElevatedButtonTheme(
                      data: state.model.elevatedButtonThemeData ??
                          ElevatedButtonTheme.of(state.context),
                      child: button);
                case ButtonType.Outlined:
                  return OutlinedButtonTheme(
                      data: state.model.outlinedButtonThemeData ??
                          OutlinedButtonTheme.of(state.context),
                      child: button);
              }
            });
}

class ButtonModel extends AbstractFieldStateModel {
  final Widget? child;
  final ButtonType? type;
  final Icon? icon;
  final ButtonStyle? style;
  final TextButtonThemeData? textButtonThemeData;
  final ElevatedButtonThemeData? elevatedButtonThemeData;
  final OutlinedButtonThemeData? outlinedButtonThemeData;
  ButtonModel({
    this.child,
    this.type,
    this.icon,
    this.style,
    this.textButtonThemeData,
    this.elevatedButtonThemeData,
    this.outlinedButtonThemeData,
  });

  @override
  ButtonModel merge(AbstractFieldStateModel old) {
    ButtonModel oldModel = old as ButtonModel;
    return ButtonModel(
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
