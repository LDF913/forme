import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../widget/clear_button.dart';
import '../state_model.dart';
import '../text_selection.dart';
import '../form_field.dart';

class ClearableTextFormField extends BaseNonnullValueField<String> {
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
  }) : super(
          {
            'labelText': StateValue<String?>(labelText),
            'hintText': StateValue<String?>(hintText),
            'keyboardType': StateValue<TextInputType?>(keyboardType),
            'autofocus': StateValue<bool>(autofocus),
            'maxLines': StateValue<int?>(maxLines),
            'minLines': StateValue<int?>(minLines),
            'maxLength': StateValue<int?>(maxLength),
            'clearable': StateValue<bool>(clearable),
            'prefixIcon': StateValue<Widget?>(prefixIcon),
            'inputFormatters':
                StateValue<List<TextInputFormatter>?>(inputFormatters),
            'style': StateValue<TextStyle?>(style),
            'toolbarOptions': StateValue<ToolbarOptions?>(toolbarOptions),
            'selectAllOnFocus': StateValue<bool>(selectAllOnFocus),
            'suffixIcons': StateValue<List<Widget>?>(suffixIcons),
            'textInputAction': StateValue<TextInputAction?>(textInputAction),
            'inputDecorationTheme':
                StateValue<InputDecorationTheme?>(inputDecorationTheme),
            'textCapitalization':
                StateValue<TextCapitalization?>(textCapitalization),
          },
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
          builder: (baseState) {
            bool readOnly = baseState.readOnly;
            _TextFormFieldState state = baseState as _TextFormFieldState;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = Theme.of(state.context);
            FocusNode? focusNode = baseState.focusNode;
            String? labelText = stateMap['labelText'];
            String? hintText = stateMap['hintText'];
            TextInputType? keyboardType = stateMap['keyboardType'];
            bool autofocus = stateMap['autofocus'];
            int? maxLines = obscureText ? 1 : stateMap['maxLines'];
            int? minLines = obscureText ? 1 : stateMap['minLines'];
            int? maxLength = stateMap['maxLength'];
            bool clearable = stateMap['clearable'];
            Widget? prefixIcon = stateMap['prefixIcon'];
            List<TextInputFormatter>? inputFormatters =
                stateMap['inputFormatters'];
            TextStyle? style = stateMap['style'];
            ToolbarOptions? toolbarOptions = stateMap['toolbarOptions'];
            List<Widget>? suffixIcons = stateMap['suffixIcons'];
            TextInputAction? textInputAction = stateMap['textInputAction'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    themeData.inputDecorationTheme;
            TextCapitalization textCapitalization =
                stateMap['textCapitalization'] ?? TextCapitalization.none;

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

class _TextFormFieldState extends BaseNonnullValueFieldState<String>
    with TextSelectionManagement {
  bool obscureText = false;

  late final TextEditingController textEditingController;

  @override
  ClearableTextFormField get widget => super.widget as ClearableTextFormField;

  bool get selectAllOnFocus => getState('selectAllOnFocus');

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
