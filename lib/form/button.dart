import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/form_theme.dart';

import 'form_builder.dart';

class Button extends CommonField {
  Button(String controlKey, VoidCallback onPressed,
      {Key key,
      VoidCallback onLongPress,
      String label,
      Widget child,
      EdgeInsets padding,
      bool readOnly})
      : super({
          'label': label,
          'child': child,
          'padding': padding,
        }, key: key, readOnly: readOnly, padding: padding, builder: (field) {
          ValueFieldState state = field as ValueFieldState;
          FormThemeData themeData = FormThemeData.of(state.context);
          bool readOnly = state.readOnly;
          Widget child =
              state.getState('child') ?? Text(state.getState('label'));
          EdgeInsets padding = state.padding;
          return Padding(
            child: TextButton(
                onPressed: readOnly ? null : onPressed,
                onLongPress: readOnly ? null : onLongPress,
                child: child),
            padding: padding ?? themeData.padding ?? EdgeInsets.zero,
          );
        });
}
