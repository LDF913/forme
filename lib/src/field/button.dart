import 'package:flutter/material.dart';

import '../form_field.dart';
import '../state_model.dart';

enum ButtonType { Text, Elevated, Outlined }

class ButtonFormField extends BaseCommonField {
  ButtonFormField(
      {String? name,
      required Widget child,
      int flex = 0,
      required VoidCallback onPressed,
      VoidCallback? onLongPress,
      bool readOnly = false,
      bool visible = true,
      EdgeInsets? padding,
      ButtonStyle? style,
      bool autofocus = false,
      ButtonType type = ButtonType.Text,
      Icon? icon})
      : super({
          'style': StateValue<ButtonStyle?>(style),
          'autofocus': StateValue<bool>(autofocus),
          'type': StateValue<ButtonType>(type),
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
          bool autofocus = stateMap['autofocus'];
          VoidCallback? _onPressed = readOnly ? null : onPressed;
          VoidCallback? _onLongPress = readOnly ? null : onLongPress;
          ButtonType type = stateMap['type'];
          ButtonStyle? style = stateMap['style'];
          Icon? icon = stateMap['icon'];
          Widget child = stateMap['child'];

          switch (type) {
            case ButtonType.Text:
              return icon == null
                  ? TextButton(
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      style: style,
                      child: child)
                  : TextButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      style: style,
                    );
            case ButtonType.Elevated:
              return icon == null
                  ? ElevatedButton(
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      style: style,
                      child: child)
                  : ElevatedButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      style: style,
                    );
            case ButtonType.Outlined:
              return icon == null
                  ? OutlinedButton(
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      style: style,
                      child: child)
                  : OutlinedButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      style: style,
                    );
          }
        });
}
