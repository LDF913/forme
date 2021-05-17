import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'theme_data.dart';

class FormRenderUtils {
  FormRenderUtils._();

  static Widget mergeListTileTheme(
      Widget child, ListTileThemeData? listTileThemeData) {
    return ListTileTheme.merge(
      child: child,
      dense: listTileThemeData?.dense,
      shape: listTileThemeData?.shape,
      style: listTileThemeData?.style,
      selectedColor: listTileThemeData?.selectedColor,
      iconColor: listTileThemeData?.iconColor,
      textColor: listTileThemeData?.textColor,
      contentPadding: listTileThemeData?.contentPadding,
      tileColor: listTileThemeData?.tileColor,
      selectedTileColor: listTileThemeData?.selectedTileColor,
      enableFeedback: listTileThemeData?.enableFeedback,
      horizontalTitleGap: listTileThemeData?.horizontalTitleGap,
      minVerticalPadding: listTileThemeData?.minVerticalPadding,
      minLeadingWidth: listTileThemeData?.minLeadingWidth,
    );
  }

  static Switch adaptiveSwitch(bool value, ValueChanged<bool>? onChanged,
      SwitchRenderData? switchRenderData) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: switchRenderData?.activeColor,
      activeTrackColor: switchRenderData?.activeTrackColor,
      inactiveThumbColor: switchRenderData?.inactiveThumbColor,
      inactiveTrackColor: switchRenderData?.inactiveTrackColor,
      activeThumbImage: switchRenderData?.activeThumbImage,
      inactiveThumbImage: switchRenderData?.inactiveThumbImage,
      materialTapTargetSize: switchRenderData?.materialTapTargetSize,
      thumbColor: switchRenderData?.thumbColor,
      trackColor: switchRenderData?.trackColor,
      dragStartBehavior:
          switchRenderData?.dragStartBehavior ?? DragStartBehavior.start,
      focusColor: switchRenderData?.focusColor,
      hoverColor: switchRenderData?.hoverColor,
      overlayColor: switchRenderData?.overlayColor,
      splashRadius: switchRenderData?.splashRadius,
      onActiveThumbImageError: switchRenderData?.onActiveThumbImageError,
      onInactiveThumbImageError: switchRenderData?.onInactiveThumbImageError,
    );
  }

  static Checkbox checkbox(bool value, ValueChanged<bool?>? onChanged,
      CheckboxRenderData? checkboxRenderData) {
    return Checkbox(
      activeColor: checkboxRenderData?.activeColor,
      fillColor: checkboxRenderData?.fillColor,
      checkColor: checkboxRenderData?.checkColor,
      materialTapTargetSize: checkboxRenderData?.materialTapTargetSize,
      focusColor: checkboxRenderData?.focusColor,
      hoverColor: checkboxRenderData?.hoverColor,
      overlayColor: checkboxRenderData?.overlayColor,
      splashRadius: checkboxRenderData?.splashRadius,
      visualDensity: checkboxRenderData?.visualDensity,
      value: value,
      onChanged: onChanged,
    );
  }

  static Radio<T> radio<T>(T value, T? groupValue, ValueChanged<T?>? onChanged,
      RadioRenderData? radioRenderData) {
    return Radio<T>(
      activeColor: radioRenderData?.activeColor,
      fillColor: radioRenderData?.fillColor,
      materialTapTargetSize: radioRenderData?.materialTapTargetSize,
      focusColor: radioRenderData?.focusColor,
      hoverColor: radioRenderData?.hoverColor,
      overlayColor: radioRenderData?.overlayColor,
      splashRadius: radioRenderData?.splashRadius,
      visualDensity: radioRenderData?.visualDensity,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
