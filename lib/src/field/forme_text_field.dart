import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../forme_utils.dart';
import '../widget/forme_clear_button.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';

class FormeTextField extends NonnullValueField<String, FormeTextFieldModel> {
  final bool obscureText;
  FormeTextField({
    this.obscureText = false,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    NonnullFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    ValueChanged<String>? onFieldSubmitted,
    bool passwordVisible = false,
    List<TextInputFormatter>? inputFormatters,
    String? initialValue,
    VoidCallback? onEditingComplete,
    NonnullFormFieldSetter<String>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    FormeTextFieldModel? model,
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
            ThemeData themeData = Theme.of(state.context);
            FocusNode? focusNode = baseState.focusNode;
            String? labelText = state.model.labelText;
            String? hintText = state.model.hintText;
            TextInputType? keyboardType = state.model.keyboardType;
            bool autofocus = state.model.autofocus ?? false;
            int? maxLines = obscureText ? 1 : state.model.maxLines;
            int? minLines = obscureText ? 1 : state.model.minLines;
            int? maxLength = state.model.maxLength;
            bool clearable = state.model.clearable ?? true;
            Widget? prefixIcon = state.model.prefixIcon;
            TextStyle? style = state.model.style;
            ToolbarOptions? toolbarOptions = state.model.toolbarOptions;
            List<Widget>? suffixIcons = state.model.suffixIcons;
            TextInputAction? textInputAction = state.model.textInputAction;
            InputDecorationTheme inputDecorationTheme =
                state.model.inputDecorationTheme ??
                    themeData.inputDecorationTheme;
            TextCapitalization textCapitalization =
                state.model.textCapitalization ?? TextCapitalization.none;

            List<Widget> suffixes = [];
            if (clearable && !readOnly && state.value.length > 0) {
              suffixes.add(
                  FormeClearButton(state.textEditingController, focusNode, () {
                state.didChange('');
              }));
            }

            if (passwordVisible) {
              suffixes.add(InkWell(
                child: IconButton(
                  icon: Icon(state.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: readOnly
                      ? null
                      : () {
                          state.toggleObsureText();
                        },
                ),
              ));
            }

            if (suffixIcons != null && suffixIcons.isNotEmpty) {
              suffixes.addAll(suffixIcons);
            }

            Widget? suffixIcon = suffixes.isEmpty
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min, // added line
                    children: suffixes,
                  );

            final InputDecoration effectiveDecoration = InputDecoration(
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    labelText: labelText,
                    hintText: hintText)
                .applyDefaults(inputDecorationTheme);

            TextField textField = TextField(
              style: style,
              textAlignVertical: TextAlignVertical.center,
              controller: state.textEditingController,
              focusNode: focusNode,
              textInputAction: textInputAction,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              keyboardType: keyboardType,
              autofocus: autofocus,
              obscureText: state.obscureText,
              toolbarOptions: toolbarOptions,
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              onChanged: (value) => state.didChange(value),
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              enabled: true,
              readOnly: readOnly,
              inputFormatters: inputFormatters,
              textCapitalization: textCapitalization,
            );

            return textField;
          },
        );

  @override
  _TextFormeFieldState createState() => _TextFormeFieldState();
}

class _TextFormeFieldState
    extends NonnullValueFieldState<String, FormeTextFieldModel> {
  bool obscureText = false;

  late final TextEditingController textEditingController;

  @override
  FormeTextField get widget => super.widget as FormeTextField;

  bool get selectAllOnFocus => model.selectAllOnFocus ?? false;

  void doSelectAll() {
    if (focusNode.hasFocus) {
      textEditingController.selection =
          FormeUtils.selection(0, textEditingController.text.length);
    }
  }

  @override
  void doChangeValue(String? value, {bool trigger = true}) {
    super.doChangeValue(value, trigger: trigger);
    if (textEditingController.text != this.value)
      textEditingController.text = this.value;
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
    textEditingController = TextEditingController(text: widget.initialValue);
    if (selectAllOnFocus) {
      focusNode.addListener(doSelectAll);
    }
  }

  @override
  void dispose() {
    if (selectAllOnFocus) {
      focusNode.removeListener(doSelectAll);
    }
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FormeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode.removeListener(doSelectAll);
    if (selectAllOnFocus) {
      focusNode.addListener(doSelectAll);
    }
  }

  void toggleObsureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void reset() {
    super.reset();
    if (textEditingController.text != widget.initialValue)
      textEditingController.text = widget.initialValue;
  }

  @override
  void beforeMerge(FormeTextFieldModel old, FormeTextFieldModel current) {
    if (current.selection != null)
      textEditingController.selection = current.selection!;
  }
}

class FormeTextFieldModel extends AbstractFormeModel {
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool? clearable;
  final Widget? prefixIcon;
  final TextStyle? style;
  final ToolbarOptions? toolbarOptions;
  final bool? selectAllOnFocus;
  final List<Widget>? suffixIcons;
  final TextInputAction? textInputAction;
  final InputDecorationTheme? inputDecorationTheme;
  final TextCapitalization? textCapitalization;
  final TextSelection? selection;

  FormeTextFieldModel({
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.autofocus,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.clearable,
    this.prefixIcon,
    this.style,
    this.toolbarOptions,
    this.selectAllOnFocus,
    this.suffixIcons,
    this.textInputAction,
    this.inputDecorationTheme,
    this.textCapitalization,
    this.selection,
  });

  @override
  AbstractFormeModel merge(AbstractFormeModel old) {
    FormeTextFieldModel oldModel = old as FormeTextFieldModel;
    return FormeTextFieldModel(
      labelText: labelText ?? oldModel.labelText,
      hintText: hintText ?? oldModel.hintText,
      keyboardType: keyboardType ?? oldModel.keyboardType,
      autofocus: autofocus ?? oldModel.autofocus,
      maxLines: maxLines ?? oldModel.maxLines,
      minLines: minLines ?? oldModel.minLines,
      maxLength: maxLength ?? oldModel.maxLength,
      clearable: clearable ?? oldModel.clearable,
      prefixIcon: prefixIcon ?? oldModel.prefixIcon,
      toolbarOptions: toolbarOptions ?? oldModel.toolbarOptions,
      selectAllOnFocus: selectAllOnFocus ?? oldModel.selectAllOnFocus,
      style: style ?? oldModel.style,
      suffixIcons: suffixIcons ?? oldModel.suffixIcons,
      textInputAction: textInputAction ?? oldModel.textInputAction,
      inputDecorationTheme:
          inputDecorationTheme ?? oldModel.inputDecorationTheme,
      textCapitalization: textCapitalization ?? oldModel.textCapitalization,
    );
  }
}
