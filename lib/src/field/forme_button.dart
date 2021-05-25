import 'package:flutter/material.dart';

import '../forme_field.dart';
import '../forme_state_model.dart';

/// button type
enum FormeButtonType { Text, Elevated, Outlined }

/// Forme Button
class FormeButton extends CommonField<FormeButtonModel> {
  FormeButton({
    String? name,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool readOnly = false,
    required Widget child,
    FormeButtonModel? model,
    Key? key,
  }) : super(
            key: key,
            model: (model ?? FormeButtonModel())
                .copyWith(child: child, type: FormeButtonType.Text),
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

              return button;
            });
}

class FormeButtonModel extends FormeModel {
  final Widget? child;
  final FormeButtonType? type;
  final Icon? icon;
  final ButtonStyle? style;
  FormeButtonModel({
    this.child,
    this.type,
    this.icon,
    this.style,
  });

  @override
  FormeButtonModel copyWith({
    Widget? child,
    FormeButtonType? type,
    Optional<Icon>? icon,
    Optional<ButtonStyle>? style,
  }) {
    return FormeButtonModel(
      child: child ?? this.child,
      type: type ?? this.type,
      icon: Optional.copyWith(icon, this.icon),
      style: Optional.copyWith(style, this.style),
    );
  }
}
