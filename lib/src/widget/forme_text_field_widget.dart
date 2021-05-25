import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import '../field/forme_text_field.dart';

/// used to create a textfield that rewraped by [InputDecorator] , avoid trigger on tap when click suffix|prefix buttons
class FormeTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String? errorText;

  /// whether textfield should be readOnly
  final bool readOnly;
  final FormTextFieldWidgetRenderData data;

  FormeTextFieldWidget({
    required this.textEditingController,
    required this.focusNode,
    required this.readOnly,
    this.errorText,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    TextField textField = TextField(
      focusNode: focusNode,
      controller: textEditingController,
      decoration: _UnCopyInputDecoration(
        alignLabelWithHint: data.model?.decoration?.alignLabelWithHint,
        floatingLabelBehavior: data.model?.decoration?.floatingLabelBehavior,
        labelStyle: data.model?.decoration?.labelStyle,
        labelText: data.model?.decoration?.labelText,
      ),
      obscureText: data.model?.obscureText ?? false,
      maxLines: data.model?.maxLines,
      minLines: data.model?.minLines,
      onTap: data.onTap,
      enabled: data.model?.enabled ?? true,
      readOnly: readOnly,
      onChanged: data.onChanged,
      onSubmitted: data.onSubmitted,
      onEditingComplete: data.onEditingComplete,
      onAppPrivateCommand: data.appPrivateCommandCallback,
      textInputAction: data.model?.textInputAction,
      textCapitalization:
          data.model?.textCapitalization ?? TextCapitalization.none,
      style: data.model?.style,
      strutStyle: data.model?.strutStyle,
      textAlign: data.model?.textAlign ?? TextAlign.start,
      textAlignVertical: data.model?.textAlignVertical,
      textDirection: data.model?.textDirection,
      showCursor: data.model?.showCursor,
      obscuringCharacter: data.model?.obscuringCharacter ?? '•',
      autocorrect: data.model?.autocorrect ?? true,
      smartDashesType: data.model?.smartDashesType,
      smartQuotesType: data.model?.smartQuotesType,
      enableSuggestions: data.model?.enableSuggestions ?? true,
      expands: data.model?.expands ?? false,
      cursorWidth: data.model?.cursorWidth ?? 2.0,
      cursorHeight: data.model?.cursorHeight,
      cursorRadius: data.model?.cursorRadius,
      cursorColor: data.model?.cursorColor,
      selectionHeightStyle:
          data.model?.selectionHeightStyle ?? BoxHeightStyle.tight,
      selectionWidthStyle:
          data.model?.selectionWidthStyle ?? BoxWidthStyle.tight,
      keyboardAppearance: data.model?.keyboardAppearance,
      scrollPadding: data.model?.scrollPadding ?? const EdgeInsets.all(20),
      dragStartBehavior:
          data.model?.dragStartBehavior ?? DragStartBehavior.start,
      mouseCursor: data.model?.mouseCursor,
      scrollPhysics: data.model?.scrollPhysics,
      autofillHints: data.model?.autofillHints,
      autofocus: data.model?.autofocus ?? false,
      toolbarOptions: data.model?.toolbarOptions,
      enableInteractiveSelection:
          data.model?.enableInteractiveSelection ?? true,
      buildCounter: data.buildCounter,
      maxLengthEnforcement: data.model?.maxLengthEnforcement,
      inputFormatters: data.formatters,
      keyboardType: data.model?.keyboardType,
      maxLength: data.model?.maxLength,
    );

    return AnimatedBuilder(
      animation:
          Listenable.merge(<Listenable>[focusNode, textEditingController]),
      builder: (BuildContext context, Widget? child) {
        return InputDecorator(
          decoration: FormeRenderUtils.copyInputDecoration(
              _getEffectiveDecoration(context).copyWith(
                contentPadding: EdgeInsets.zero,
                errorText: errorText,
              ),
              labelText: Optional.absent()),
          isFocused: focusNode.hasFocus,
          isEmpty: textEditingController.value.text.isEmpty,
          child: child,
          baseStyle: data.model?.style,
          textAlign: data.model?.textAlign,
          textAlignVertical: data.model?.textAlignVertical,
          isHovering: false,
          expands: data.model?.expands ?? false,
        );
      },
      child: textField,
    );
  }

  InputDecoration _getEffectiveDecoration(BuildContext context) {
    bool _isEnabled = data.model?.decoration?.enabled ?? true;
    int _currentLength = textEditingController.value.text.characters.length;
    bool _hasIntrinsicError = data.model?.maxLength != null &&
        data.model!.maxLength! > 0 &&
        textEditingController.value.text.characters.length >
            data.model!.maxLength!;

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final InputDecoration effectiveDecoration =
        (data.model?.decoration ?? const InputDecoration())
            .applyDefaults(themeData.inputDecorationTheme)
            .copyWith(
              enabled: _isEnabled,
              hintMaxLines:
                  data.model?.decoration?.hintMaxLines ?? data.model?.maxLines,
            );
    if (effectiveDecoration.counter != null ||
        effectiveDecoration.counterText != null) return effectiveDecoration;
    Widget? counter;
    final int currentLength = _currentLength;
    if (effectiveDecoration.counter == null &&
        effectiveDecoration.counterText == null &&
        data.buildCounter != null) {
      final bool isFocused = focusNode.hasFocus;
      final Widget? builtCounter = data.buildCounter!(
        context,
        currentLength: currentLength,
        maxLength: data.model?.maxLength,
        isFocused: isFocused,
      );
      // If buildCounter returns null, don't add a counter widget to the field.
      if (builtCounter != null) {
        counter = Semantics(
          container: true,
          liveRegion: isFocused,
          child: builtCounter,
        );
      }
      return effectiveDecoration.copyWith(counter: counter);
    }

    if (data.model?.maxLength == null)
      return effectiveDecoration; // No counter widget

    String counterText = '$currentLength';
    String semanticCounterText = '';

    // Handle a real maxLength (positive number)
    if (data.model!.maxLength! > 0) {
      // Show the maxLength in the counter
      counterText += '/${data.model?.maxLength}';
      final int remaining = (data.model!.maxLength! - currentLength)
          .clamp(0, data.model!.maxLength!);
      semanticCounterText =
          localizations.remainingTextFieldCharacterCount(remaining);
    }

    if (_hasIntrinsicError) {
      return effectiveDecoration.copyWith(
        errorText: effectiveDecoration.errorText ?? '',
        counterStyle: effectiveDecoration.errorStyle ??
            themeData.textTheme.caption!.copyWith(color: themeData.errorColor),
        counterText: counterText,
        semanticCounterText: semanticCounterText,
      );
    }

    return effectiveDecoration.copyWith(
      counterText: counterText,
      semanticCounterText: semanticCounterText,
    );
  }
}

class FormTextFieldWidgetRenderData {
  final FormeTextFieldModel? model;
  final AppPrivateCommandCallback? appPrivateCommandCallback;
  final InputCounterWidgetBuilder? buildCounter;
  final List<TextInputFormatter>? formatters;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  const FormTextFieldWidgetRenderData({
    this.model,
    this.appPrivateCommandCallback,
    this.buildCounter,
    this.formatters,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
  });
}

class _UnCopyInputDecoration extends InputDecoration {
  _UnCopyInputDecoration({
    bool? alignLabelWithHint,
    FloatingLabelBehavior? floatingLabelBehavior,
    TextStyle? labelStyle,
    String? labelText,
  }) : super(
          floatingLabelBehavior: floatingLabelBehavior,
          alignLabelWithHint: alignLabelWithHint,
          labelStyle: labelStyle,
          labelText: labelText,
          border: InputBorder.none,
          isDense: false,
        );

  @override
  InputDecoration copyWith({
    Widget? icon,
    String? labelText,
    TextStyle? labelStyle,
    String? helperText,
    TextStyle? helperStyle,
    int? helperMaxLines,
    String? hintText,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    int? hintMaxLines,
    String? errorText,
    TextStyle? errorStyle,
    int? errorMaxLines,
    bool? hasFloatingPlaceholder,
    FloatingLabelBehavior? floatingLabelBehavior,
    bool? isCollapsed,
    bool? isDense,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    Widget? prefix,
    String? prefixText,
    BoxConstraints? prefixIconConstraints,
    TextStyle? prefixStyle,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    TextStyle? suffixStyle,
    BoxConstraints? suffixIconConstraints,
    Widget? counter,
    String? counterText,
    TextStyle? counterStyle,
    bool? filled,
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    InputBorder? errorBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? border,
    bool? enabled,
    String? semanticCounterText,
    bool? alignLabelWithHint,
  }) {
    return this;
  }
}
