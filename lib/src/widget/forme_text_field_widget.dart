import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../field/forme_text_field.dart';

/// used to build a textfield
class FormeTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String? errorText;
  final FormeTextFieldModel? model;

  FormeTextFieldWidget({
    required this.textEditingController,
    required this.focusNode,
    this.errorText,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    InputDecoration? decoration =
        model?.decoration?.copyWith(errorText: errorText);
    TextField textField = TextField(
      focusNode: focusNode,
      controller: textEditingController,
      decoration: decoration,
      obscureText: model?.obscureText ?? false,
      maxLines: model?.maxLines,
      minLines: model?.minLines,
      enabled: model?.enabled ?? true,
      readOnly: model?.readOnly ?? false,
      onTap: model?.onTap,
      onEditingComplete: model?.onEditingComplete,
      onSubmitted: model?.onSubmitted,
      onChanged: model?.onChanged,
      onAppPrivateCommand: model?.appPrivateCommandCallback,
      textInputAction: model?.textInputAction,
      textCapitalization: model?.textCapitalization ?? TextCapitalization.none,
      style: model?.style,
      strutStyle: model?.strutStyle,
      textAlign: model?.textAlign ?? TextAlign.start,
      textAlignVertical: model?.textAlignVertical,
      textDirection: model?.textDirection,
      showCursor: model?.showCursor,
      obscuringCharacter: model?.obscuringCharacter ?? '•',
      autocorrect: model?.autocorrect ?? true,
      smartDashesType: model?.smartDashesType,
      smartQuotesType: model?.smartQuotesType,
      enableSuggestions: model?.enableSuggestions ?? true,
      expands: model?.expands ?? false,
      cursorWidth: model?.cursorWidth ?? 2.0,
      cursorHeight: model?.cursorHeight,
      cursorRadius: model?.cursorRadius,
      cursorColor: model?.cursorColor,
      selectionHeightStyle: model?.selectionHeightStyle ?? BoxHeightStyle.tight,
      selectionWidthStyle: model?.selectionWidthStyle ?? BoxWidthStyle.tight,
      keyboardAppearance: model?.keyboardAppearance,
      scrollPadding: model?.scrollPadding ?? const EdgeInsets.all(20),
      dragStartBehavior: model?.dragStartBehavior ?? DragStartBehavior.start,
      mouseCursor: model?.mouseCursor,
      scrollPhysics: model?.scrollPhysics,
      autofillHints: model?.autofillHints,
      autofocus: model?.autofocus ?? false,
      toolbarOptions: model?.toolbarOptions,
      enableInteractiveSelection: model?.enableInteractiveSelection ?? true,
      buildCounter: model?.buildCounter,
      maxLengthEnforcement: model?.maxLengthEnforcement,
      inputFormatters: model?.inputFormatters,
      keyboardType: model?.keyboardType,
      maxLength: model?.maxLength,
    );

    return textField;
  }
}
