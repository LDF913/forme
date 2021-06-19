import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:forme/forme.dart';

class FormeTextField extends ValueField<String, FormeTextFieldModel> {
  FormeTextField({
    FormeValueChanged<String, FormeTextFieldModel>? onValueChanged,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    FormFieldSetter<String>? onSaved,
    String? initialValue,
    required String name,
    bool readOnly = false,
    FormeTextFieldModel? model,
    FormeErrorChanged<FormeValueFieldController<String, FormeTextFieldModel>>?
        onErrorChanged,
    FormeFocusChanged<FormeValueFieldController<String, FormeTextFieldModel>>?
        onFocusChanged,
    FormeFieldInitialed<FormeValueFieldController<String, FormeTextFieldModel>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<String>? decoratorBuilder,
    InputDecoration? decoration,
    int? maxLines = 1,
  }) : super(
          onInitialed: onInitialed,
          nullValueReplacement: '',
          decoratorBuilder: decoratorBuilder,
          key: key,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          model: (model ?? FormeTextFieldModel()).copyWith(
              FormeTextFieldModel(decoration: decoration, maxLines: maxLines)),
          name: name,
          readOnly: readOnly,
          onValueChanged: onValueChanged,
          onSaved: onSaved,
          initialValue: initialValue,
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
              model: FormeTextFieldModel(
                      onChanged: onChanged,
                      onTap: readOnly ? () {} : state.model.onTap,
                      readOnly: readOnly)
                  .copyWith(state.model),
            );
          },
        );

  @override
  _TextFormeFieldState createState() => _TextFormeFieldState();
}

class _TextFormeFieldState
    extends ValueFieldState<String, FormeTextFieldModel> {
  late final TextEditingController textEditingController;

  @override
  FormeTextField get widget => super.widget as FormeTextField;

  bool get selectAllOnFocus => model.selectAllOnFocus ?? false;

  @override
  void onFocusChanged(bool hasFocus) {
    if (hasFocus && selectAllOnFocus) {
      textEditingController.selection =
          FormeUtils.selection(0, textEditingController.text.length);
    }
  }

  @override
  void afterInitiation() {
    super.afterInitiation();
    textEditingController = TextEditingController(text: initialValue);
  }

  @override
  void onValueChanged(String? value) {
    if (textEditingController.text != value)
      textEditingController.text = value!;
  }

  @override
  void dispose() {
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
