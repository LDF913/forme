import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forme_render_data.dart';

class FormeRenderUtils {
  FormeRenderUtils._();

  static Wrap wrap(
      FormeWrapRenderData? formeWrapRenderData, List<Widget> children) {
    return Wrap(
      spacing: formeWrapRenderData?.spacing ?? 0.0,
      runSpacing: formeWrapRenderData?.runSpacing ?? 0.0,
      textDirection: formeWrapRenderData?.textDirection,
      crossAxisAlignment:
          formeWrapRenderData?.crossAxisAlignment ?? WrapCrossAlignment.start,
      verticalDirection:
          formeWrapRenderData?.verticalDirection ?? VerticalDirection.down,
      alignment: formeWrapRenderData?.alignment ?? WrapAlignment.start,
      direction: formeWrapRenderData?.direction ?? Axis.horizontal,
      runAlignment: formeWrapRenderData?.runAlignment ?? WrapAlignment.start,
      children: children,
    );
  }

  static Widget mergeListTileTheme(
      Widget child, FormeListTileRenderData? formeListTileRenderData) {
    return ListTileTheme.merge(
      child: child,
      dense: formeListTileRenderData?.dense,
      shape: formeListTileRenderData?.shape,
      style: formeListTileRenderData?.style,
      selectedColor: formeListTileRenderData?.selectedColor,
      iconColor: formeListTileRenderData?.iconColor,
      textColor: formeListTileRenderData?.textColor,
      contentPadding: formeListTileRenderData?.contentPadding,
      tileColor: formeListTileRenderData?.tileColor,
      selectedTileColor: formeListTileRenderData?.selectedTileColor,
      enableFeedback: formeListTileRenderData?.enableFeedback,
      horizontalTitleGap: formeListTileRenderData?.horizontalTitleGap,
      minVerticalPadding: formeListTileRenderData?.minVerticalPadding,
      minLeadingWidth: formeListTileRenderData?.minLeadingWidth,
    );
  }

  static Switch adaptiveSwitch(bool value, ValueChanged<bool>? onChanged,
      FormeSwitchRenderData? formeSwitchRenderData) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: formeSwitchRenderData?.activeColor,
      activeTrackColor: formeSwitchRenderData?.activeTrackColor,
      inactiveThumbColor: formeSwitchRenderData?.inactiveThumbColor,
      inactiveTrackColor: formeSwitchRenderData?.inactiveTrackColor,
      activeThumbImage: formeSwitchRenderData?.activeThumbImage,
      inactiveThumbImage: formeSwitchRenderData?.inactiveThumbImage,
      materialTapTargetSize: formeSwitchRenderData?.materialTapTargetSize,
      thumbColor: formeSwitchRenderData?.thumbColor,
      trackColor: formeSwitchRenderData?.trackColor,
      dragStartBehavior:
          formeSwitchRenderData?.dragStartBehavior ?? DragStartBehavior.start,
      focusColor: formeSwitchRenderData?.focusColor,
      hoverColor: formeSwitchRenderData?.hoverColor,
      overlayColor: formeSwitchRenderData?.overlayColor,
      splashRadius: formeSwitchRenderData?.splashRadius,
      onActiveThumbImageError: formeSwitchRenderData?.onActiveThumbImageError,
      onInactiveThumbImageError:
          formeSwitchRenderData?.onInactiveThumbImageError,
    );
  }

  static Checkbox checkbox(bool value, ValueChanged<bool?>? onChanged,
      FormeCheckboxRenderData? formeCheckboxRenderData) {
    return Checkbox(
      activeColor: formeCheckboxRenderData?.activeColor,
      fillColor: formeCheckboxRenderData?.fillColor,
      checkColor: formeCheckboxRenderData?.checkColor,
      materialTapTargetSize: formeCheckboxRenderData?.materialTapTargetSize,
      focusColor: formeCheckboxRenderData?.focusColor,
      hoverColor: formeCheckboxRenderData?.hoverColor,
      overlayColor: formeCheckboxRenderData?.overlayColor,
      splashRadius: formeCheckboxRenderData?.splashRadius,
      visualDensity: formeCheckboxRenderData?.visualDensity,
      value: value,
      onChanged: onChanged,
    );
  }

  static Radio<T> radio<T>(T value, T? groupValue, ValueChanged<T?>? onChanged,
      FormeRadioRenderData? formeRadioRenderData) {
    return Radio<T>(
      activeColor: formeRadioRenderData?.activeColor,
      fillColor: formeRadioRenderData?.fillColor,
      materialTapTargetSize: formeRadioRenderData?.materialTapTargetSize,
      focusColor: formeRadioRenderData?.focusColor,
      hoverColor: formeRadioRenderData?.hoverColor,
      overlayColor: formeRadioRenderData?.overlayColor,
      splashRadius: formeRadioRenderData?.splashRadius,
      visualDensity: formeRadioRenderData?.visualDensity,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
