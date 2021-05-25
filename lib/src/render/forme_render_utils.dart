import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../forme_state_model.dart';
import 'forme_render_data.dart';

class FormeRenderUtils {
  FormeRenderUtils._();

  static ChipThemeData? copyChipThemeData(
    ChipThemeData? old, {
    Color? backgroundColor,
    Optional<Color>? deleteIconColor,
    Color? disabledColor,
    Color? selectedColor,
    Color? secondarySelectedColor,
    Optional<Color>? shadowColor,
    Optional<Color>? selectedShadowColor,
    Optional<Color>? checkmarkColor,
    Optional<EdgeInsetsGeometry>? labelPadding,
    EdgeInsetsGeometry? padding,
    Optional<BorderSide>? side,
    Optional<OutlinedBorder>? shape,
    TextStyle? labelStyle,
    TextStyle? secondaryLabelStyle,
    Brightness? brightness,
    Optional<double>? elevation,
    Optional<double>? pressElevation,
  }) {
    if (old == null) return null;
    return ChipThemeData(
      backgroundColor: backgroundColor ?? old.backgroundColor,
      disabledColor: disabledColor ?? old.disabledColor,
      deleteIconColor: Optional.copyWith(deleteIconColor, old.deleteIconColor),
      selectedColor: selectedColor ?? old.selectedColor,
      secondarySelectedColor:
          secondarySelectedColor ?? old.secondarySelectedColor,
      shadowColor: Optional.copyWith(shadowColor, old.shadowColor),
      selectedShadowColor:
          Optional.copyWith(selectedShadowColor, old.selectedShadowColor),
      checkmarkColor: Optional.copyWith(checkmarkColor, old.checkmarkColor),
      labelPadding: Optional.copyWith(labelPadding, old.labelPadding),
      padding: padding ?? old.padding,
      side: Optional.copyWith(side, old.side),
      shape: Optional.copyWith(shape, old.shape),
      labelStyle: labelStyle ?? old.labelStyle,
      secondaryLabelStyle: secondaryLabelStyle ?? old.secondaryLabelStyle,
      brightness: brightness ?? old.brightness,
      elevation: Optional.copyWith(elevation, old.elevation),
      pressElevation: Optional.copyWith(pressElevation, old.pressElevation),
    );
  }

  static SliderThemeData? copySliderThemeData(
    SliderThemeData? old, {
    Optional<double>? trackHeight,
    Optional<Color>? activeTrackColor,
    Optional<Color>? inactiveTrackColor,
    Optional<Color>? disabledActiveTrackColor,
    Optional<Color>? disabledInactiveTrackColor,
    Optional<Color>? activeTickMarkColor,
    Optional<Color>? inactiveTickMarkColor,
    Optional<Color>? disabledActiveTickMarkColor,
    Optional<Color>? disabledInactiveTickMarkColor,
    Optional<Color>? thumbColor,
    Optional<Color>? overlappingShapeStrokeColor,
    Optional<Color>? disabledThumbColor,
    Optional<Color>? overlayColor,
    Optional<Color>? valueIndicatorColor,
    Optional<SliderComponentShape>? overlayShape,
    Optional<SliderTickMarkShape>? tickMarkShape,
    Optional<SliderComponentShape>? thumbShape,
    Optional<SliderTrackShape>? trackShape,
    Optional<SliderComponentShape>? valueIndicatorShape,
    Optional<RangeSliderTickMarkShape>? rangeTickMarkShape,
    Optional<RangeSliderThumbShape>? rangeThumbShape,
    Optional<RangeSliderTrackShape>? rangeTrackShape,
    Optional<RangeSliderValueIndicatorShape>? rangeValueIndicatorShape,
    Optional<ShowValueIndicator>? showValueIndicator,
    Optional<TextStyle>? valueIndicatorTextStyle,
    Optional<double>? minThumbSeparation,
    Optional<RangeThumbSelector>? thumbSelector,
  }) {
    if (old == null) return null;
    return SliderThemeData(
      trackHeight: Optional.copyWith(trackHeight, old.trackHeight),
      activeTrackColor:
          Optional.copyWith(activeTrackColor, old.activeTrackColor),
      inactiveTrackColor:
          Optional.copyWith(inactiveTrackColor, old.inactiveTrackColor),
      disabledActiveTrackColor: Optional.copyWith(
          disabledActiveTrackColor, old.disabledActiveTrackColor),
      disabledInactiveTrackColor: Optional.copyWith(
          disabledInactiveTrackColor, old.disabledInactiveTrackColor),
      activeTickMarkColor:
          Optional.copyWith(activeTickMarkColor, old.activeTickMarkColor),
      inactiveTickMarkColor:
          Optional.copyWith(inactiveTickMarkColor, old.inactiveTickMarkColor),
      disabledActiveTickMarkColor: Optional.copyWith(
          disabledActiveTickMarkColor, old.disabledActiveTickMarkColor),
      disabledInactiveTickMarkColor: Optional.copyWith(
          disabledInactiveTickMarkColor, old.disabledInactiveTickMarkColor),
      thumbColor: Optional.copyWith(thumbColor, old.thumbColor),
      overlappingShapeStrokeColor: Optional.copyWith(
          overlappingShapeStrokeColor, old.overlappingShapeStrokeColor),
      disabledThumbColor:
          Optional.copyWith(disabledThumbColor, old.disabledThumbColor),
      overlayColor: Optional.copyWith(overlayColor, old.overlayColor),
      valueIndicatorColor:
          Optional.copyWith(valueIndicatorColor, old.valueIndicatorColor),
      overlayShape: Optional.copyWith(overlayShape, old.overlayShape),
      tickMarkShape: Optional.copyWith(tickMarkShape, old.tickMarkShape),
      thumbShape: Optional.copyWith(thumbShape, old.thumbShape),
      trackShape: Optional.copyWith(trackShape, old.trackShape),
      valueIndicatorShape:
          Optional.copyWith(valueIndicatorShape, old.valueIndicatorShape),
      rangeTickMarkShape:
          Optional.copyWith(rangeTickMarkShape, old.rangeTickMarkShape),
      rangeThumbShape: Optional.copyWith(rangeThumbShape, old.rangeThumbShape),
      rangeTrackShape: Optional.copyWith(rangeTrackShape, old.rangeTrackShape),
      rangeValueIndicatorShape: Optional.copyWith(
          rangeValueIndicatorShape, old.rangeValueIndicatorShape),
      showValueIndicator:
          Optional.copyWith(showValueIndicator, old.showValueIndicator),
      valueIndicatorTextStyle: Optional.copyWith(
          valueIndicatorTextStyle, old.valueIndicatorTextStyle),
      minThumbSeparation:
          Optional.copyWith(minThumbSeparation, old.minThumbSeparation),
      thumbSelector: Optional.copyWith(thumbSelector, old.thumbSelector),
    );
  }

  static InputDecoration copyInputDecoration(
    InputDecoration? old, {
    Optional<Widget>? icon,
    Optional<String>? labelText,
    Optional<TextStyle>? labelStyle,
    Optional<String>? helperText,
    Optional<TextStyle>? helperStyle,
    Optional<int>? helperMaxLines,
    Optional<String>? hintText,
    Optional<TextStyle>? hintStyle,
    Optional<TextDirection>? hintTextDirection,
    Optional<int>? hintMaxLines,
    Optional<String>? errorText,
    Optional<TextStyle>? errorStyle,
    Optional<int>? errorMaxLines,
    bool? hasFloatingPlaceholder,
    Optional<FloatingLabelBehavior>? floatingLabelBehavior,
    bool? isCollapsed,
    bool? isDense,
    Optional<EdgeInsetsGeometry>? contentPadding,
    Optional<Widget>? prefixIcon,
    Optional<Widget>? prefix,
    Optional<String>? prefixText,
    Optional<BoxConstraints>? prefixIconConstraints,
    Optional<TextStyle>? prefixStyle,
    Optional<Widget>? suffixIcon,
    Optional<Widget>? suffix,
    Optional<String>? suffixText,
    Optional<TextStyle>? suffixStyle,
    Optional<BoxConstraints>? suffixIconConstraints,
    Optional<Widget>? counter,
    Optional<String>? counterText,
    Optional<TextStyle>? counterStyle,
    bool? filled,
    Optional<Color>? fillColor,
    Optional<Color>? focusColor,
    Optional<Color>? hoverColor,
    Optional<InputBorder>? errorBorder,
    Optional<InputBorder>? focusedBorder,
    Optional<InputBorder>? focusedErrorBorder,
    Optional<InputBorder>? disabledBorder,
    Optional<InputBorder>? enabledBorder,
    Optional<InputBorder>? border,
    bool? enabled,
    Optional<String>? semanticCounterText,
    bool? alignLabelWithHint,
  }) {
    return InputDecoration(
      icon: Optional.copyWith(icon, old?.icon),
      labelText: Optional.copyWith(labelText, old?.labelText),
      labelStyle: Optional.copyWith(labelStyle, old?.labelStyle),
      helperText: Optional.copyWith(helperText, old?.helperText),
      helperStyle: Optional.copyWith(helperStyle, old?.helperStyle),
      helperMaxLines: Optional.copyWith(helperMaxLines, old?.helperMaxLines),
      hintText: Optional.copyWith(hintText, old?.hintText),
      hintStyle: Optional.copyWith(hintStyle, old?.hintStyle),
      hintTextDirection:
          Optional.copyWith(hintTextDirection, old?.hintTextDirection),
      hintMaxLines: Optional.copyWith(hintMaxLines, old?.hintMaxLines),
      errorText: Optional.copyWith(errorText, old?.errorText),
      errorStyle: Optional.copyWith(errorStyle, old?.errorStyle),
      errorMaxLines: Optional.copyWith(errorMaxLines, old?.errorMaxLines),
      floatingLabelBehavior:
          Optional.copyWith(floatingLabelBehavior, old?.floatingLabelBehavior),
      isCollapsed: isCollapsed ?? old?.isCollapsed ?? false,
      isDense: isDense ?? isDense,
      contentPadding: Optional.copyWith(contentPadding, old?.contentPadding),
      prefixIcon: Optional.copyWith(prefixIcon, old?.prefixIcon),
      prefix: Optional.copyWith(prefix, old?.prefix),
      prefixText: Optional.copyWith(prefixText, old?.prefixText),
      prefixIconConstraints:
          Optional.copyWith(prefixIconConstraints, old?.prefixIconConstraints),
      prefixStyle: Optional.copyWith(prefixStyle, old?.prefixStyle),
      suffixIcon: Optional.copyWith(suffixIcon, old?.suffixIcon),
      suffix: Optional.copyWith(suffix, old?.suffix),
      suffixText: Optional.copyWith(suffixText, old?.suffixText),
      suffixStyle: Optional.copyWith(suffixStyle, old?.suffixStyle),
      suffixIconConstraints:
          Optional.copyWith(suffixIconConstraints, old?.suffixIconConstraints),
      counter: Optional.copyWith(counter, old?.counter),
      counterText: Optional.copyWith(counterText, old?.counterText),
      counterStyle: Optional.copyWith(counterStyle, old?.counterStyle),
      filled: filled ?? filled,
      fillColor: Optional.copyWith(fillColor, old?.fillColor),
      focusColor: Optional.copyWith(focusColor, old?.focusColor),
      hoverColor: Optional.copyWith(hoverColor, old?.hoverColor),
      errorBorder: Optional.copyWith(errorBorder, old?.errorBorder),
      focusedBorder: Optional.copyWith(focusedBorder, old?.focusedBorder),
      focusedErrorBorder:
          Optional.copyWith(focusedErrorBorder, old?.focusedErrorBorder),
      disabledBorder: Optional.copyWith(disabledBorder, old?.disabledBorder),
      enabledBorder: Optional.copyWith(enabledBorder, old?.enabledBorder),
      border: Optional.copyWith(border, old?.border),
      enabled: enabled ?? old?.enabled ?? true,
      semanticCounterText:
          Optional.copyWith(semanticCounterText, old?.semanticCounterText),
      alignLabelWithHint: alignLabelWithHint ?? alignLabelWithHint,
    );
  }

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
