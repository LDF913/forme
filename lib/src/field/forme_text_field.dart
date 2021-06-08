import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../render/forme_render_utils.dart';
import '../../forme.dart';
import '../widget/forme_text_field_widget.dart';

import '../forme_utils.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';
import '../forme_core.dart';

class FormeTextField extends NonnullValueField<String, FormeTextFieldModel> {
  FormeTextField({
    NonnullFormeFieldValueChanged<String, FormeTextFieldModel>? onChanged,
    NonnullFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    NonnullFormFieldSetter<String>? onSaved,
    String? initialValue,
    required String name,
    bool readOnly = false,
    FormeTextFieldModel? model,
    ValidateErrorListener<
            FormeValueFieldController<String, FormeTextFieldModel>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<String, FormeTextFieldModel>>?
        focusListener,
    Key? key,
  }) : super(
          key: key,
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
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
            FocusNode focusNode = baseState.focusNode;

            onChanged(String v) {
              state.didChange(v);
            }

            return FormeTextFieldWidget(
              textEditingController: state.textEditingController,
              focusNode: focusNode,
              errorText: state.errorText,
              model: state.model.copyWith(FormeTextFieldModel(
                  onChanged: onChanged,
                  onTap: readOnly ? () {} : state.model.onTap,
                  readOnly: readOnly)),
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
  void afterInitiation() {
    super.afterInitiation();
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
  FormeTextFieldModel beforeUpdateModel(
      FormeTextFieldModel old, FormeTextFieldModel current) {
    if (current.selection != null) {
      textEditingController.selection = current.selection!;
    }
    return current;
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
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final AppPrivateCommandCallback? appPrivateCommandCallback;
  final InputCounterWidgetBuilder? buildCounter;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? readOnly;

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
    this.onEditingComplete,
    this.inputFormatters,
    this.appPrivateCommandCallback,
    this.buildCounter,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.readOnly,
  });

  static FormeTextFieldModel? copy(
      FormeTextFieldModel? old, FormeTextFieldModel? current) {
    if (current == null) return old;
    if (old == null) return current;
    return current.copyWith(old);
  }

  @override
  FormeTextFieldModel copyWith(FormeModel oldModel) {
    FormeTextFieldModel old = oldModel as FormeTextFieldModel;
    return FormeTextFieldModel(
      selectAllOnFocus: selectAllOnFocus ?? old.selectAllOnFocus,
      selection: selection,
      decoration:
          FormeRenderUtils.copyInputDecoration(old.decoration, decoration),
      keyboardType: keyboardType ?? old.keyboardType,
      autofocus: autofocus ?? old.autofocus,
      maxLines: maxLines ?? old.maxLines,
      minLines: minLines ?? old.minLines,
      maxLength: maxLength ?? old.maxLength,
      style: style ?? old.style,
      toolbarOptions: toolbarOptions ?? old.toolbarOptions,
      textInputAction: textInputAction ?? old.textInputAction,
      textCapitalization: textCapitalization ?? old.textCapitalization,
      obscureText: obscureText ?? old.obscureText,
      strutStyle: strutStyle ?? old.strutStyle,
      textAlign: textAlign ?? old.textAlign,
      textAlignVertical: textAlignVertical ?? old.textAlignVertical,
      textDirection: textDirection ?? old.textDirection,
      showCursor: showCursor ?? old.showCursor,
      obscuringCharacter: obscuringCharacter ?? old.obscuringCharacter,
      autocorrect: autocorrect ?? old.autocorrect,
      smartDashesType: smartDashesType ?? old.smartDashesType,
      smartQuotesType: smartQuotesType ?? old.smartQuotesType,
      enableSuggestions: enableSuggestions ?? old.enableSuggestions,
      expands: expands ?? old.expands,
      maxLengthEnforcement: maxLengthEnforcement ?? old.maxLengthEnforcement,
      cursorWidth: cursorWidth ?? old.cursorWidth,
      cursorHeight: cursorHeight ?? old.cursorHeight,
      cursorRadius: cursorRadius ?? old.cursorRadius,
      cursorColor: cursorColor ?? old.cursorColor,
      selectionHeightStyle: selectionHeightStyle ?? old.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? old.selectionWidthStyle,
      keyboardAppearance: keyboardAppearance ?? old.keyboardAppearance,
      scrollPadding: scrollPadding ?? old.scrollPadding,
      dragStartBehavior: dragStartBehavior ?? old.dragStartBehavior,
      mouseCursor: mouseCursor ?? old.mouseCursor,
      scrollPhysics: scrollPhysics ?? old.scrollPhysics,
      autofillHints: autofillHints ?? old.autofillHints,
      enableInteractiveSelection:
          enableInteractiveSelection ?? old.enableInteractiveSelection,
      enabled: enabled ?? old.enabled,
      onEditingComplete: onEditingComplete ?? old.onEditingComplete,
      inputFormatters: inputFormatters ?? old.inputFormatters,
      appPrivateCommandCallback:
          appPrivateCommandCallback ?? old.appPrivateCommandCallback,
      buildCounter: buildCounter ?? old.buildCounter,
      onTap: onTap ?? old.onTap,
      onChanged: onChanged ?? old.onChanged,
      onSubmitted: onSubmitted ?? old.onSubmitted,
      readOnly: readOnly ?? old.readOnly,
    );
  }
}
