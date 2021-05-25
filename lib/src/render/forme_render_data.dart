import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../forme_state_model.dart';

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

  FormeCheckboxRenderData copyWith({
    Optional<MouseCursor>? mouseCursor,
    Optional<Color>? activeColor,
    Optional<MaterialStateProperty<Color>>? fillColor,
    Optional<Color>? checkColor,
    Optional<Color>? focusColor,
    Optional<Color>? hoverColor,
    Optional<MaterialStateProperty<Color>>? overlayColor,
    Optional<double>? splashRadius,
    Optional<VisualDensity>? visualDensity,
    Optional<MaterialTapTargetSize>? materialTapTargetSize,
    Optional<Color>? tileColor,
    Optional<Color>? selectedTileColor,
    Optional<ShapeBorder>? shape,
  }) {
    return FormeCheckboxRenderData(
      mouseCursor: Optional.copyWith(mouseCursor, this.mouseCursor),
      activeColor: Optional.copyWith(activeColor, this.activeColor),
      fillColor: Optional.copyWith(fillColor, this.fillColor),
      checkColor: Optional.copyWith(checkColor, this.checkColor),
      focusColor: Optional.copyWith(focusColor, this.focusColor),
      hoverColor: Optional.copyWith(hoverColor, this.hoverColor),
      overlayColor: Optional.copyWith(overlayColor, this.overlayColor),
      splashRadius: Optional.copyWith(splashRadius, this.splashRadius),
      visualDensity: Optional.copyWith(visualDensity, this.visualDensity),
      materialTapTargetSize:
          Optional.copyWith(materialTapTargetSize, this.materialTapTargetSize),
      tileColor: Optional.copyWith(tileColor, this.tileColor),
      selectedTileColor:
          Optional.copyWith(selectedTileColor, this.selectedTileColor),
      shape: Optional.copyWith(shape, this.shape),
    );
  }
}

class FormeListTileRenderData {
  final bool? dense;
  final ShapeBorder? shape;
  final ListTileStyle? style;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;

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

  FormeListTileRenderData copyWith({
    bool? dense,
    Optional<ShapeBorder>? shape,
    Optional<ListTileStyle>? style,
    Optional<Color>? selectedColor,
    Optional<Color>? iconColor,
    Optional<Color>? textColor,
    Optional<EdgeInsetsGeometry>? contentPadding,
    Optional<Color>? tileColor,
    Optional<Color>? selectedTileColor,
    bool? enableFeedback,
    Optional<double>? horizontalTitleGap,
    Optional<double>? minVerticalPadding,
    Optional<double>? minLeadingWidth,
  }) {
    return FormeListTileRenderData(
      dense: dense ?? dense,
      shape: Optional.copyWith(shape, this.shape),
      style: Optional.copyWith(style, this.style),
      selectedColor: Optional.copyWith(selectedColor, this.selectedColor),
      iconColor: Optional.copyWith(iconColor, this.iconColor),
      textColor: Optional.copyWith(textColor, this.textColor),
      contentPadding: Optional.copyWith(contentPadding, this.contentPadding),
      tileColor: Optional.copyWith(tileColor, this.tileColor),
      selectedTileColor:
          Optional.copyWith(selectedTileColor, this.selectedTileColor),
      enableFeedback: enableFeedback ?? enableFeedback,
      horizontalTitleGap:
          Optional.copyWith(horizontalTitleGap, this.horizontalTitleGap),
      minVerticalPadding:
          Optional.copyWith(minVerticalPadding, this.minVerticalPadding),
      minLeadingWidth: Optional.copyWith(minLeadingWidth, this.minLeadingWidth),
    );
  }
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
  final DragStartBehavior? dragStartBehavior;
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
    this.dragStartBehavior,
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

  FormeSwitchRenderData copyWith({
    Optional<Color>? activeColor,
    Optional<Color>? activeTrackColor,
    Optional<Color>? inactiveThumbColor,
    Optional<Color>? inactiveTrackColor,
    Optional<ImageProvider>? imageProvider,
    Optional<ImageProvider>? activeThumbImage,
    Optional<ImageProvider>? inactiveThumbImage,
    Optional<MaterialStateProperty<Color>>? thumbColor,
    Optional<MaterialStateProperty<Color>>? trackColor,
    Optional<DragStartBehavior>? dragStartBehavior,
    Optional<MaterialTapTargetSize>? materialTapTargetSize,
    Optional<MouseCursor>? mouseCursor,
    Optional<Color>? focusColor,
    Optional<Color>? hoverColor,
    Optional<MaterialStateProperty<Color>>? overlayColor,
    Optional<double>? splashRadius,
    Optional<ImageErrorListener>? onActiveThumbImageError,
    Optional<ImageErrorListener>? onInactiveThumbImageError,
    Optional<Color>? tileColor,
    Optional<ShapeBorder>? shape,
    Optional<Color>? selectedTileColor,
  }) {
    return FormeSwitchRenderData(
      activeColor: Optional.copyWith(activeColor, this.activeColor),
      activeTrackColor:
          Optional.copyWith(activeTrackColor, this.activeTrackColor),
      inactiveThumbColor:
          Optional.copyWith(inactiveThumbColor, this.inactiveThumbColor),
      inactiveTrackColor:
          Optional.copyWith(inactiveTrackColor, this.inactiveTrackColor),
      imageProvider: Optional.copyWith(imageProvider, this.imageProvider),
      activeThumbImage:
          Optional.copyWith(activeThumbImage, this.activeThumbImage),
      inactiveThumbImage:
          Optional.copyWith(inactiveThumbImage, this.inactiveThumbImage),
      thumbColor: Optional.copyWith(thumbColor, this.thumbColor),
      trackColor: Optional.copyWith(trackColor, this.trackColor),
      dragStartBehavior:
          Optional.copyWith(dragStartBehavior, this.dragStartBehavior),
      materialTapTargetSize:
          Optional.copyWith(materialTapTargetSize, this.materialTapTargetSize),
      mouseCursor: Optional.copyWith(mouseCursor, this.mouseCursor),
      focusColor: Optional.copyWith(focusColor, this.focusColor),
      hoverColor: Optional.copyWith(hoverColor, this.hoverColor),
      overlayColor: Optional.copyWith(overlayColor, this.overlayColor),
      splashRadius: Optional.copyWith(splashRadius, this.splashRadius),
      onActiveThumbImageError: Optional.copyWith(
          onActiveThumbImageError, this.onActiveThumbImageError),
      onInactiveThumbImageError: Optional.copyWith(
          onInactiveThumbImageError, this.onInactiveThumbImageError),
      tileColor: Optional.copyWith(tileColor, this.tileColor),
      shape: Optional.copyWith(shape, this.shape),
      selectedTileColor:
          Optional.copyWith(selectedTileColor, this.selectedTileColor),
    );
  }
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
  FormeRadioRenderData copyWith({
    Optional<MouseCursor>? mouseCursor,
    Optional<Color>? activeColor,
    Optional<MaterialStateProperty<Color>>? fillColor,
    Optional<Color>? focusColor,
    Optional<Color>? hoverColor,
    Optional<MaterialStateProperty<Color>>? overlayColor,
    Optional<double>? splashRadius,
    Optional<VisualDensity>? visualDensity,
    Optional<MaterialTapTargetSize>? materialTapTargetSize,
    Optional<Color>? tileColor,
    Optional<Color>? selectedTileColor,
    Optional<ShapeBorder>? shape,
  }) {
    return FormeRadioRenderData(
      mouseCursor: Optional.copyWith(mouseCursor, this.mouseCursor),
      activeColor: Optional.copyWith(activeColor, this.activeColor),
      fillColor: Optional.copyWith(fillColor, this.fillColor),
      focusColor: Optional.copyWith(focusColor, this.focusColor),
      hoverColor: Optional.copyWith(hoverColor, this.hoverColor),
      overlayColor: Optional.copyWith(overlayColor, this.overlayColor),
      splashRadius: Optional.copyWith(splashRadius, this.splashRadius),
      visualDensity: Optional.copyWith(visualDensity, this.visualDensity),
      materialTapTargetSize:
          Optional.copyWith(materialTapTargetSize, this.materialTapTargetSize),
      tileColor: Optional.copyWith(tileColor, this.tileColor),
      selectedTileColor:
          Optional.copyWith(selectedTileColor, this.selectedTileColor),
      shape: Optional.copyWith(shape, this.shape),
    );
  }
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
  FormeWrapRenderData copyWith({
    Optional<Axis>? direction,
    Optional<WrapAlignment>? alignment,
    Optional<double>? space,
    Optional<WrapAlignment>? runAlignment,
    Optional<double>? runSpacing,
    Optional<double>? spacing,
    Optional<WrapCrossAlignment>? crossAxisAlignment,
    Optional<TextDirection>? textDirection,
    Optional<VerticalDirection>? verticalDirection,
  }) {
    return FormeWrapRenderData(
      direction: Optional.copyWith(direction, this.direction),
      alignment: Optional.copyWith(alignment, this.alignment),
      space: Optional.copyWith(space, this.space),
      runAlignment: Optional.copyWith(runAlignment, this.runAlignment),
      runSpacing: Optional.copyWith(runSpacing, this.runSpacing),
      spacing: Optional.copyWith(spacing, this.spacing),
      crossAxisAlignment:
          Optional.copyWith(crossAxisAlignment, this.crossAxisAlignment),
      textDirection: Optional.copyWith(textDirection, this.textDirection),
      verticalDirection:
          Optional.copyWith(verticalDirection, this.verticalDirection),
    );
  }
}

class FormeChipRenderData {
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

  const FormeChipRenderData({
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

  FormeChipRenderData copyWith({
    Optional<TextStyle>? labelStyle,
    Optional<EdgeInsets>? labelPadding,
    Optional<double>? pressElevation,
    Optional<Color>? disabledColor,
    Optional<Color>? selectedColor,
    Optional<String>? tooltip,
    Optional<BorderSide>? side,
    Optional<OutlinedBorder>? shape,
    Optional<Color>? backgroundColor,
    Optional<EdgeInsets>? padding,
    Optional<VisualDensity>? visualDensity,
    Optional<MaterialTapTargetSize>? materialTapTargetSize,
    Optional<double>? elevation,
    Optional<Color>? shadowColor,
    Optional<Color>? selectedShadowColor,
    bool? showCheckmark,
    Optional<Color>? checkmarkColor,
    Optional<CircleBorder>? avatarBorder,
  }) {
    return FormeChipRenderData(
      labelStyle: Optional.copyWith(labelStyle, this.labelStyle),
      labelPadding: Optional.copyWith(labelPadding, this.labelPadding),
      pressElevation: Optional.copyWith(pressElevation, this.pressElevation),
      disabledColor: Optional.copyWith(disabledColor, this.disabledColor),
      selectedColor: Optional.copyWith(selectedColor, this.selectedColor),
      tooltip: Optional.copyWith(tooltip, this.tooltip),
      side: Optional.copyWith(side, this.side),
      shape: Optional.copyWith(shape, this.shape),
      backgroundColor: Optional.copyWith(backgroundColor, this.backgroundColor),
      padding: Optional.copyWith(padding, this.padding),
      visualDensity: Optional.copyWith(visualDensity, this.visualDensity),
      materialTapTargetSize:
          Optional.copyWith(materialTapTargetSize, this.materialTapTargetSize),
      elevation: Optional.copyWith(elevation, this.elevation),
      shadowColor: Optional.copyWith(shadowColor, this.shadowColor),
      selectedShadowColor:
          Optional.copyWith(selectedShadowColor, this.selectedShadowColor),
      showCheckmark: showCheckmark ?? showCheckmark,
      checkmarkColor: Optional.copyWith(checkmarkColor, this.checkmarkColor),
      avatarBorder: Optional.copyWith(avatarBorder, this.avatarBorder),
    );
  }
}
