import 'package:flutter/material.dart';

/// used to wrap form field which not support inputdecoration
class DecorationField extends StatelessWidget {
  final String? labelText;
  final Widget child;
  final String? errorText;
  final FocusNode? focusNode;
  final Widget? icon;
  final bool readOnly;
  final TextStyle? labelStyle;

  const DecorationField(
      {Key? key,
      this.labelText,
      required this.child,
      this.errorText,
      this.focusNode,
      this.readOnly = false,
      this.icon,
      this.labelStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget builder = Builder(builder: (context) {
      bool hasFocus = Focus.of(context).hasFocus;
      ThemeData themeData = Theme.of(context);
      List<Widget> rows = [];
      if (labelText != null || icon != null) {
        List<Widget> children = [];
        if (labelText != null) {
          children.add(
              Text(labelText!, style: _getLabelStyle(themeData, hasFocus)));
        }

        if (icon != null) {
          Color? color = hasFocus
              ? themeData.primaryColor
              : readOnly
                  ? themeData.disabledColor
                  : _getDefaultIconColor(themeData);
          children.add(Spacer());
          children.add(IconTheme(
            data: IconThemeData(color: color),
            child: icon!,
          ));
        }
        rows.add(Row(
          children: children,
        ));
      }

      rows.add(child);

      if (errorText != null) {
        rows.add(Text(errorText!,
            overflow: TextOverflow.ellipsis, style: _getErrorStyle(themeData)));
      }

      return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rows),
      );
    });

    return Focus(
        focusNode: focusNode,
        canRequestFocus: focusNode == null ? false : focusNode!.canRequestFocus,
        skipTraversal: true,
        child: builder);
  }

  TextStyle? _getLabelStyle(ThemeData themeData, bool hasFocus) {
    return themeData.textTheme.subtitle1?.copyWith(
        color: hasFocus ? themeData.primaryColor : themeData.hintColor);
  }

  Color? _getDefaultIconColor(ThemeData themeData) {
    switch (themeData.brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
    }
  }

  TextStyle? _getErrorStyle(ThemeData themeData) {
    InputDecorationTheme inputDecorationTheme = themeData.inputDecorationTheme;
    final Color color = themeData.errorColor;
    return themeData.textTheme.caption
        ?.copyWith(color: color)
        .merge(inputDecorationTheme.errorStyle);
  }
}
