import 'package:flutter/material.dart';

import '../builder.dart';
import '../form_field.dart';
import '../state_model.dart';

enum ButtonType { Text, Elevated, Outlined }

class ButtonFormField extends BaseCommonField {
  ButtonFormField(
      {String? name,
      required Widget child,
      int flex = 0,
      required ValueChanged<BuilderInfo> onPressed,
      ValueChanged<BuilderInfo>? onLongPress,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets? padding,
      ButtonType type = ButtonType.Text,
      TextButtonThemeData? textButtonThemeData,
      ElevatedButtonThemeData? elevatedButtonThemeData,
      OutlinedButtonThemeData? outlinedButtonThemeData,
      Icon? icon})
      : super({
          'icon': StateValue<Icon?>(icon),
          'child': StateValue<Widget>(child),
        },
            name: name,
            padding: padding,
            readOnly: readOnly,
            visible: visible,
            flex: flex, builder: (state) {
          Map<String, dynamic> stateMap = state.currentMap;

          bool readOnly = state.readOnly;
          Icon? icon = stateMap['icon'];
          Widget child = stateMap['child'];

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
                      child: child)
                  : TextButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                    );
              break;
            case ButtonType.Elevated:
              button = icon == null
                  ? ElevatedButton(
                      focusNode: state.focusNode,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      child: child)
                  : ElevatedButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                    );
              break;
            case ButtonType.Outlined:
              button = icon == null
                  ? OutlinedButton(
                      focusNode: state.focusNode,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      child: child)
                  : OutlinedButton.icon(
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
                  data:
                      textButtonThemeData ?? TextButtonTheme.of(state.context),
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
