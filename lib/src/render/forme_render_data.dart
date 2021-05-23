import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FormeCheckboxRenderData {
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final Color? tileColor;
  final Color? selectedTileColor;
  final ShapeBorder? shape;

  const FormeCheckboxRenderData({
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.materialTapTargetSize,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.visualDensity,
    this.tileColor,
    this.selectedTileColor,
    this.shape,
  });
}

class FormeListTileRenderData {
  bool? dense;
  ShapeBorder? shape;
  ListTileStyle? style;
  Color? selectedColor;
  Color? iconColor;
  Color? textColor;
  EdgeInsetsGeometry? contentPadding;
  Color? tileColor;
  Color? selectedTileColor;
  bool? enableFeedback;
  double? horizontalTitleGap;
  double? minVerticalPadding;
  double? minLeadingWidth;

  FormeListTileRenderData({
    this.dense,
    this.shape,
    this.style,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.contentPadding,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
  });
}

class FormeSwitchRenderData {
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? imageProvider;
  final ImageProvider? activeThumbImage;
  final ImageProvider? inactiveThumbImage;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final DragStartBehavior dragStartBehavior;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final ImageErrorListener? onActiveThumbImageError;
  final ImageErrorListener? onInactiveThumbImageError;
  final Color? tileColor;
  final ShapeBorder? shape;
  final Color? selectedTileColor;

  const FormeSwitchRenderData({
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.imageProvider,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.thumbColor,
    this.trackColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.onActiveThumbImageError,
    this.onInactiveThumbImageError,
    this.tileColor,
    this.shape,
    this.selectedTileColor,
  });
}

class FormeRadioRenderData {
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final Color? tileColor;
  final Color? selectedTileColor;
  final ShapeBorder? shape;

  const FormeRadioRenderData({
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.materialTapTargetSize,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.visualDensity,
    this.tileColor,
    this.selectedTileColor,
    this.shape,
  });
}

class FormeFilterChipRenderData {
  final TextStyle? labelStyle;
  final EdgeInsets? labelPadding;
  final double? pressElevation;
  final Color? disabledColor;
  final Color? selectedColor;
  final String? tooltip;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final Color? shadowColor;
  final Color? selectedShadowColor;
  final bool? showCheckmark;
  final Color? checkmarkColor;
  final CircleBorder? avatarBorder;

  const FormeFilterChipRenderData({
    this.labelPadding,
    this.labelStyle,
    this.avatarBorder,
    this.backgroundColor,
    this.checkmarkColor,
    this.showCheckmark,
    this.shadowColor,
    this.disabledColor,
    this.selectedColor,
    this.selectedShadowColor,
    this.visualDensity,
    this.elevation,
    this.pressElevation,
    this.materialTapTargetSize,
    this.padding,
    this.shape,
    this.side,
    this.tooltip,
  });
}

class FormeWrapRenderData {
  final Axis? direction;
  final WrapAlignment? alignment;
  final double? space;
  final WrapAlignment? runAlignment;
  final double? runSpacing;
  final double? spacing;
  final WrapCrossAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;

  const FormeWrapRenderData({
    this.direction,
    this.alignment,
    this.space,
    this.runAlignment,
    this.runSpacing,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.spacing,
  });
}

class FormeDecorationRenderData {
  const FormeDecorationRenderData({
    this.errorStyle,
    this.helperStyle,
    this.labelStyle,
    this.helperMaxLines,
    this.errorMaxLines,
    this.bottomPadding,
    this.headPadding,
  });

  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final TextStyle? labelStyle;
  final int? helperMaxLines;
  final int? errorMaxLines;

  /// errorText & helperText padding
  final EdgeInsets? bottomPadding;

  /// label & icon padding
  final EdgeInsets? headPadding;
}
