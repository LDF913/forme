import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../widget/clear_button.dart';
import '../state_model.dart';
import '../text_selection.dart';
import '../form_field.dart';

class ClearableTextFormField
    extends BaseNonnullValueField<String, TextFieldModel> {
  final bool obscureText;
  ClearableTextFormField({
    String? labelText,
    String? hintText,
    TextInputType? keyboardType,
    bool autofocus = false,
    this.obscureText = false,
    int? maxLines,
    int? minLines,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    NonnullFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    ValueChanged<String>? onFieldSubmitted,
    bool clearable = true,
    bool passwordVisible = false,
    Widget? prefixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextStyle? style,
    String? initialValue,
    ToolbarOptions? toolbarOptions,
    bool selectAllOnFocus = false,
    List<Widget>? suffixIcons,
    VoidCallback? onEditingComplete,
    TextInputAction? textInputAction,
    InputDecorationTheme? inputDecorationTheme,
    NonnullFormFieldSetter<String>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    TextCapitalization? textCapitalization,
    WidgetWrapper? wrapper,
  }) : super(
          model: TextFieldModel(
            labelText: labelText,
            hintText: hintText,
            keyboardType: keyboardType,
            autofocus: autofocus,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            clearable: clearable,
            prefixIcon: prefixIcon,
            toolbarOptions: toolbarOptions,
            selectAllOnFocus: selectAllOnFocus,
            style: style,
            suffixIcons: suffixIcons,
            textInputAction: textInputAction,
            inputDecorationTheme: inputDecorationTheme,
            textCapitalization: textCapitalization,
          ),
          name: name,
          flex: flex,
          visible: visible,
          readOnly: readOnly,
          padding: padding,
          onChanged: onChanged,
          onSaved: onSaved,
          initialValue: initialValue ?? '',
          validator: validator,
          autovalidateMode: autovalidateMode,
          wrapper: wrapper,
          builder: (baseState) {
            bool readOnly = baseState.readOnly;
            _TextFormFieldState state = baseState as _TextFormFieldState;
            ThemeData themeData = Theme.of(state.context);
            FocusNode? focusNode = baseState.focusNode;
            String? labelText = state.model.labelText;
            String? hintText = state.model.hintText;
            TextInputType? keyboardType = state.model.keyboardType;
            bool autofocus = state.model.autofocus!;
            int? maxLines = obscureText ? 1 : state.model.maxLines;
            int? minLines = obscureText ? 1 : state.model.minLines;
            int? maxLength = state.model.maxLength;
            bool clearable = state.model.clearable!;
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
              suffixes
                  .add(ClearButton(state.textEditingController, focusNode, () {
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
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextFormFieldState
    extends BaseNonnullValueFieldState<String, TextFieldModel>
    with TextSelectionManagement {
  bool obscureText = false;

  late final TextEditingController textEditingController;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;

  bool get selectAllOnFocus => model.selectAllOnFocus!;

  void doSelectAll() {
    if (focusNode.hasFocus) {
      selectAll();
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
  }

  @override
  void initFormManagement() {
    super.initFormManagement();
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
  void didUpdateWidget(ClearableTextFormField oldWidget) {
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
  void setSelection(int start, int end) {
    TextSelectionManagement.setSelectionWithTextEditingController(
        start, end, textEditingController);
  }

  @override
  void selectAll() {
    setSelection(0, textEditingController.text.length);
  }
}

class TextFieldModel extends AbstractFieldStateModel {
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

  TextFieldModel({
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
  });

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    TextFieldModel oldModel = old as TextFieldModel;
    return TextFieldModel(
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
