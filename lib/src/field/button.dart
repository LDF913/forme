import 'package:flutter/material.dart';

import '../builder.dart';
import '../form_field.dart';
import '../state_model.dart';

enum ButtonType { Text, Elevated, Outlined }

class ButtonFormField extends BaseCommonField<ButtonModel> {
  ButtonFormField({
    String? name,
    int flex = 0,
    required ValueChanged<BuilderInfo> onPressed,
    ValueChanged<BuilderInfo>? onLongPress,
    bool readOnly = false,
    bool visible = true,
    EdgeInsets? padding,
    TextButtonThemeData? textButtonThemeData,
    ElevatedButtonThemeData? elevatedButtonThemeData,
    OutlinedButtonThemeData? outlinedButtonThemeData,
    required Widget child,
    Icon? icon,
    ButtonStyle? style,
    ButtonType type = ButtonType.Text,
    WidgetWrapper? wrapper,
  }) : super(
            model: ButtonModel(
              child: child,
              icon: icon,
              style: style,
              type: type,
            ),
            wrapper: wrapper,
            name: name,
            padding: padding,
            readOnly: readOnly,
            visible: visible,
            flex: flex,
            builder: (state) {
              bool readOnly = state.readOnly;
              Icon? icon = state.model.icon;
              Widget child = state.model.child!;
              ButtonStyle? style = state.model.style;
              ButtonType type = state.model.type!;

              BuilderInfo builderInfo = BuilderInfo.of(state.context);

              VoidCallback? _onPressed = readOnly
                  ? null
                  : () {
                      onPressed(builderInfo);
                    };
              VoidCallback? _onLongPress = onLongPress == null || readOnly
                  ? null
                  : () {
                      onLongPress(builderInfo);
                    };

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
                      data: textButtonThemeData ??
                          TextButtonTheme.of(state.context),
                      child: button);
                case ButtonType.Elevated:
                  return ElevatedButtonTheme(
                      data: elevatedButtonThemeData ??
                          ElevatedButtonTheme.of(state.context),
                      child: button);
                case ButtonType.Outlined:
                  return OutlinedButtonTheme(
                      data: outlinedButtonThemeData ??
                          OutlinedButtonTheme.of(state.context),
                      child: button);
              }
            });
}

class ButtonModel extends AbstractFieldStateModel {
  final Icon? icon;
  final Widget? child;
  final ButtonStyle? style;
  final ButtonType? type;

  ButtonModel({
    this.icon,
    this.child,
    this.style,
    this.type,
  });

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    ButtonModel oldModel = old as ButtonModel;
    return ButtonModel(
        child: child ?? oldModel.child,
        icon: icon ?? oldModel.icon,
        style: style ?? oldModel.style,
        type: type ?? oldModel.type);
  }
}
