import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../widget/forme_text_field_widget.dart';

import '../forme_utils.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';
import '../forme_core.dart';

class FormeTextField extends NonnullValueField<String, FormeTextFieldModel> {
  FormeTextField({
    GestureTapCallback? onTap,
    NonnullFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    NonnullFormFieldSetter<String>? onSaved,
    String? initialValue,
    VoidCallback? onEditingComplete,
    String? name,
    bool readOnly = false,
    FormeTextFieldModel? model,
    List<TextInputFormatter>? inputFormatters,
    AppPrivateCommandCallback? appPrivateCommandCallback,
    InputCounterWidgetBuilder? buildCounter,
    Key? key,
  }) : super(
          key: key,
          model: model ?? FormeTextFieldModel(),
          name: name,
          readOnly: readOnly,
          onChanged: onChanged,
          onSaved: onSaved,
          initialValue: initialValue ?? '',
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (baseState) {
            bool readOnly = baseState.readOnly;
            _TextFormeFieldState state = baseState as _TextFormeFieldState;
            FocusNode? focusNode = baseState.focusNode;

            return FormeTextFieldWidget(
              textEditingController: state.textEditingController,
              focusNode: focusNode,
              readOnly: readOnly,
              errorText: state.errorText,
              data: FormTextFieldWidgetRenderData(
                appPrivateCommandCallback: appPrivateCommandCallback,
                buildCounter: buildCounter,
                formatters: inputFormatters,
                onTap: readOnly ? null : onTap,
                onChanged: onChanged,
                onEditingComplete: readOnly ? null : onEditingComplete,
                onSubmitted: readOnly ? null : onSubmitted,
                model: state.model,
              ),
            );
          },
        );

  @override
  _TextFormeFieldState createState() => _TextFormeFieldState();
}

class _TextFormeFieldState
    extends NonnullValueFieldState<String, FormeTextFieldModel> {
  late final TextEditingController textEditingController;

  @override
  FormeTextField get widget => super.widget as FormeTextField;

  bool get selectAllOnFocus => model.selectAllOnFocus ?? false;

  void focusChange() {
    setState(() {
      if (focusNode.hasFocus && selectAllOnFocus) {
        textEditingController.selection =
            FormeUtils.selection(0, textEditingController.text.length);
      }
    });
  }

  @override
  void afterSetInitialValue() {
    textEditingController = TextEditingController(text: initialValue);
    focusNode.addListener(focusChange);
  }

  @override
  void afterNonnullValueChanged(String oldValue, String current) {
    if (textEditingController.text != current)
      textEditingController.text = current;
  }

  @override
  void dispose() {
    focusNode.removeListener(focusChange);
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void beforeUpdateModel(FormeTextFieldModel old, FormeTextFieldModel current) {
    if (current.selection != null)
      textEditingController.selection = current.selection!;
  }
}

class FormeTextFieldModel extends FormeModel {
  final bool? selectAllOnFocus;
  final TextSelection? selection;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextStyle? style;
  final ToolbarOptions? toolbarOptions;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final bool? obscureText;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool? showCursor;
  final String? obscuringCharacter;
  final bool? autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool? enableSuggestions;
  final bool? expands;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final BoxHeightStyle? selectionHeightStyle;
  final BoxWidthStyle? selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final DragStartBehavior? dragStartBehavior;
  final MouseCursor? mouseCursor;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final bool? enableInteractiveSelection;
  final bool? enabled;

  FormeTextFieldModel({
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textAlignVertical,
    this.textDirection,
    this.showCursor,
    this.obscuringCharacter,
    this.obscureText,
    this.autocorrect,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions,
    this.maxLines,
    this.minLines,
    this.expands,
    this.maxLength,
    this.maxLengthEnforcement,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.keyboardAppearance,
    this.scrollPadding,
    this.dragStartBehavior,
    this.mouseCursor,
    this.scrollPhysics,
    this.autofillHints,
    this.decoration,
    this.autofocus,
    this.toolbarOptions,
    this.selectAllOnFocus,
    this.selection,
    this.enableInteractiveSelection,
    this.enabled,
  });

  @override
  FormeTextFieldModel copyWith({
    bool? selectAllOnFocus,
    Optional<TextSelection>? selection,
    Optional<InputDecoration>? decoration,
    Optional<TextInputType>? keyboardType,
    bool? autofocus,
    Optional<int>? maxLines,
    Optional<int>? minLines,
    Optional<int>? maxLength,
    Optional<TextStyle>? style,
    Optional<ToolbarOptions>? toolbarOptions,
    Optional<TextInputAction>? textInputAction,
    Optional<TextCapitalization>? textCapitalization,
    bool? obscureText,
    Optional<StrutStyle>? strutStyle,
    Optional<TextAlign>? textAlign,
    Optional<TextAlignVertical>? textAlignVertical,
    Optional<TextDirection>? textDirection,
    bool? showCursor,
    Optional<String>? obscuringCharacter,
    bool? autocorrect,
    Optional<SmartDashesType>? smartDashesType,
    Optional<SmartQuotesType>? smartQuotesType,
    bool? enableSuggestions,
    bool? expands,
    Optional<MaxLengthEnforcement>? maxLengthEnforcement,
    Optional<double>? cursorWidth,
    Optional<double>? cursorHeight,
    Optional<Radius>? cursorRadius,
    Optional<Color>? cursorColor,
    Optional<BoxHeightStyle>? selectionHeightStyle,
    Optional<BoxWidthStyle>? selectionWidthStyle,
    Optional<Brightness>? keyboardAppearance,
    Optional<EdgeInsets>? scrollPadding,
    Optional<DragStartBehavior>? dragStartBehavior,
    Optional<MouseCursor>? mouseCursor,
    Optional<ScrollPhysics>? scrollPhysics,
    Optional<Iterable<String>>? autofillHints,
    bool? enableInteractiveSelection,
    bool? enabled,
  }) {
    return FormeTextFieldModel(
      selectAllOnFocus: selectAllOnFocus ?? selectAllOnFocus,
      selection: Optional.copyWith(selection, this.selection),
      decoration: Optional.copyWith(decoration, this.decoration),
      keyboardType: Optional.copyWith(keyboardType, this.keyboardType),
      autofocus: autofocus ?? autofocus,
      maxLines: Optional.copyWith(maxLines, this.maxLines),
      minLines: Optional.copyWith(minLines, this.minLines),
      maxLength: Optional.copyWith(maxLength, this.maxLength),
      style: Optional.copyWith(style, this.style),
      toolbarOptions: Optional.copyWith(toolbarOptions, this.toolbarOptions),
      textInputAction: Optional.copyWith(textInputAction, this.textInputAction),
      textCapitalization:
          Optional.copyWith(textCapitalization, this.textCapitalization),
      obscureText: obscureText ?? obscureText,
      strutStyle: Optional.copyWith(strutStyle, this.strutStyle),
      textAlign: Optional.copyWith(textAlign, this.textAlign),
      textAlignVertical:
          Optional.copyWith(textAlignVertical, this.textAlignVertical),
      textDirection: Optional.copyWith(textDirection, this.textDirection),
      showCursor: showCursor ?? showCursor,
      obscuringCharacter:
          Optional.copyWith(obscuringCharacter, this.obscuringCharacter),
      autocorrect: autocorrect ?? autocorrect,
      smartDashesType: Optional.copyWith(smartDashesType, this.smartDashesType),
      smartQuotesType: Optional.copyWith(smartQuotesType, this.smartQuotesType),
      enableSuggestions: enableSuggestions ?? enableSuggestions,
      expands: expands ?? expands,
      maxLengthEnforcement:
          Optional.copyWith(maxLengthEnforcement, this.maxLengthEnforcement),
      cursorWidth: Optional.copyWith(cursorWidth, this.cursorWidth),
      cursorHeight: Optional.copyWith(cursorHeight, this.cursorHeight),
      cursorRadius: Optional.copyWith(cursorRadius, this.cursorRadius),
      cursorColor: Optional.copyWith(cursorColor, this.cursorColor),
      selectionHeightStyle:
          Optional.copyWith(selectionHeightStyle, this.selectionHeightStyle),
      selectionWidthStyle:
          Optional.copyWith(selectionWidthStyle, this.selectionWidthStyle),
      keyboardAppearance:
          Optional.copyWith(keyboardAppearance, this.keyboardAppearance),
      scrollPadding: Optional.copyWith(scrollPadding, this.scrollPadding),
      dragStartBehavior:
          Optional.copyWith(dragStartBehavior, this.dragStartBehavior),
      mouseCursor: Optional.copyWith(mouseCursor, this.mouseCursor),
      scrollPhysics: Optional.copyWith(scrollPhysics, this.scrollPhysics),
      autofillHints: Optional.copyWith(autofillHints, this.autofillHints),
      enableInteractiveSelection:
          enableInteractiveSelection ?? enableInteractiveSelection,
      enabled: enabled ?? enabled,
    );
  }
}
