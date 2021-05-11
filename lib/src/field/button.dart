import 'package:flutter/material.dart';

import '../form_field.dart';
import '../state_model.dart';

enum ButtonType { Text, Elevated, Outlined }

class Button extends BaseCommonField {
  Button(
      {String? name,
      required WidgetBuilder childBuilder,
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
          'gen': StateValue<int>(0),
          'style': StateValue<ButtonStyle?>(style),
          'autofocus': StateValue<bool>(autofocus),
          'type': StateValue<ButtonType>(type),
          'icon': StateValue<Icon?>(icon),
        },
            name: name,
            padding: padding,
            readOnly: readOnly,
            visible: visible,
            flex: flex, builder: (state) {
          Map<String, dynamic> stateMap = state.currentMap;

          VoidCallback? wrap(VoidCallback? click) {
            if (click == null) return null;
            return () {
              click();
              int gen = stateMap['gen'];
              state.model.update({'gen': ++gen});
            };
          }

          bool readOnly = state.readOnly;
          bool autofocus = stateMap['autofocus'];
          Widget child = childBuilder(state.context);
          VoidCallback? _onPressed = readOnly ? null : wrap(onPressed);
          VoidCallback? _onLongPress = readOnly ? null : wrap(onLongPress);
          ButtonType type = stateMap['type'];

          switch (type) {
            case ButtonType.Text:
              return icon == null
                  ? TextButton(
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      child: child)
                  : TextButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                    );
            case ButtonType.Elevated:
              return icon == null
                  ? ElevatedButton(
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      child: child)
                  : ElevatedButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                    );
            case ButtonType.Outlined:
              return icon == null
                  ? OutlinedButton(
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                      onPressed: _onPressed,
                      onLongPress: _onLongPress,
                      child: child)
                  : OutlinedButton.icon(
                      onPressed: _onPressed,
                      icon: icon,
                      label: child,
                      focusNode: state.focusNode,
                      autofocus: autofocus,
                    );
          }
        });
}
