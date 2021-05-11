import 'package:flutter/material.dart';

class ThemeUtil {
  ThemeUtil._();

  ///used for checkboxgroup|radiogroup
  static Widget wrapTitle(Widget title, bool dense, bool enabled, bool selected,
      ThemeData theme, ListTileTheme? tileTheme) {
    return AnimatedDefaultTextStyle(
      style: _titleTextStyle(dense, enabled, selected, theme, tileTheme),
      duration: kThemeChangeDuration,
      child: title,
    );
  }

  /// copied from [ListTile._titleTextStyle]
  static TextStyle _titleTextStyle(bool dense, bool enabled, bool selected,
      ThemeData theme, ListTileTheme? tileTheme) {
    final TextStyle style;
    if (tileTheme != null) {
      switch (tileTheme.style) {
        case ListTileStyle.drawer:
          style = theme.textTheme.bodyText1!;
          break;
        case ListTileStyle.list:
          style = theme.textTheme.subtitle1!;
          break;
      }
    } else {
      style = theme.textTheme.subtitle1!;
    }
    final Color? color =
        _textColor(enabled, selected, theme, tileTheme, style.color);
    return dense
        ? style.copyWith(fontSize: 13.0, color: color)
        : style.copyWith(color: color);
  }

  static Color? _textColor(bool enabled, bool selected, ThemeData theme,
      ListTileTheme? tileTheme, Color? defaultColor) {
    if (!enabled) return theme.disabledColor;

    if (selected && tileTheme?.selectedColor != null)
      return tileTheme!.selectedColor;

    if (!selected && tileTheme?.textColor != null) return tileTheme!.textColor;

    if (selected) {
      switch (theme.brightness) {
        case Brightness.light:
          return theme.primaryColor;
        case Brightness.dark:
          return theme.accentColor;
      }
    }
    return defaultColor;
  }
}
