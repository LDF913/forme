import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form_builder.dart';

class Button extends CommonField {
  Button(String controlKey, VoidCallback onPressed,
      {Key key,
      VoidCallback onLongPress,
      String label,
      Widget child,
      bool readOnly})
      : super({
          'label': label,
          'child': child,
        }, key: key, readOnly: readOnly, builder: (field) {
          CommonFieldState state = field as CommonFieldState;
          bool readOnly = state.readOnly;
          Widget child =
              state.getState('child') ?? Text(state.getState('label'));
          return TextButton(
              onPressed: readOnly ? null : onPressed,
              onLongPress: readOnly ? null : onLongPress,
              child: child);
        });
}
