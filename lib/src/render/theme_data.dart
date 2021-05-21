import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CheckboxRenderData {
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

  const CheckboxRenderData({
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

class ListTileThemeData {
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

  ListTileThemeData({
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

class SwitchRenderData {
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

  const SwitchRenderData({
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

class RadioRenderData {
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

  const RadioRenderData({
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

class FilterChipRenderData {
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

  const FilterChipRenderData({
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

class WrapRenderData {
  final Axis? direction;
  final WrapAlignment? alignment;
  final double? space;
  final WrapAlignment? runAlignment;
  final double? runSpacing;
  final double? spacing;
  final WrapCrossAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;

  const WrapRenderData({
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

class SingleChildScrollViewRenderData {
  final bool? reverse;
  final EdgeInsets? padding;
  final Axis? scrollDirection;

  const SingleChildScrollViewRenderData({
    this.reverse,
    this.padding,
    this.scrollDirection,
  });
}
