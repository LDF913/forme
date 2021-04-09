import 'package:flutter/material.dart';

import 'form_theme.dart';

class DropdownController extends ValueNotifier {
  DropdownController({dynamic value}) : super(value);
}

class DropdownItem {
  final bool value;
  final String label;
  final bool readOnly;

  DropdownItem(this.label, {this.value, this.readOnly});
}

class DropdownFormField extends FormField {
  final String controlKey;
  final DropdownController controller;
  final FocusNode focusNode;
  final ValueChanged onChanged;
  final List<DropdownItem> items;
  final bool clearable;
  final DropdownButtonBuilder selectedItemBuilder;
  final FormFieldValidator validator;
  final AutovalidateMode autovalidateMode;
  final EdgeInsets padding;
  final bool readOnly;
  final String labelText;
  final String hintText;
  final TextStyle style;
  final double iconSize;
  final bool loading;

  DropdownFormField(
      this.controlKey, this.controller, this.focusNode, this.items,
      {this.onChanged,
      this.clearable,
      this.labelText,
      this.hintText,
      this.selectedItemBuilder,
      this.validator,
      this.autovalidateMode,
      this.padding,
      this.readOnly = false,
      this.style,
      this.iconSize = 24,
      this.loading = false})
      : super(
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            void onChangedHandler(dynamic value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
              focusNode.requestFocus();
            }

            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            final InputDecoration effectiveDecoration =
                InputDecoration(labelText: labelText, hintText: hintText)
                    .applyDefaults(
              themeData.inputDecorationTheme,
            );
            List<Widget> icons = [];
            if (clearable &&
                !readOnly &&
                controller.value != null &&
                !loading) {
              icons.add(Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Icon(Icons.clear),
                  onTap: () {
                    onChangedHandler(null);
                  },
                ),
              ));
            }
            if (loading)
              icons.add(Padding(
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  padding: EdgeInsets.only(right: 10)));
            icons.add(Icon(
              Icons.arrow_drop_down,
            ));

            bool hasValue = controller.value == null ||
                (controller.value != null &&
                    items.any((element) => element.value == controller.value));

            if (!hasValue) {
              throw 'pls clear dropdown value before you reload items!';
            }

            Widget child = Focus(
                canRequestFocus: false,
                skipTraversal: true,
                child: Builder(
                    builder: (context) => InputDecorator(
                          decoration: effectiveDecoration.copyWith(
                              errorText: field.errorText),
                          isEmpty: controller.value == null,
                          isFocused: Focus.of(context).hasFocus,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                            iconSize: iconSize,
                            style: style,
                            iconDisabledColor: themeData.disabledColor,
                            iconEnabledColor: Focus.of(context).hasFocus
                                ? themeData.primaryColor
                                : themeData.unselectedWidgetColor,
                            selectedItemBuilder: selectedItemBuilder ??
                                (BuildContext context) {
                                  return items.map<Widget>((DropdownItem item) {
                                    return SingleChildScrollView(
                                      child: Text(item.label),
                                    );
                                  }).toList();
                                },
                            items: items
                                .map((e) => DropdownMenuItem(
                                    child: Text(e.label), value: e.value))
                                .toList(),
                            value: controller.value,
                            icon: Row(
                              children: icons,
                              mainAxisSize: MainAxisSize.min,
                            ),
                            onChanged:
                                readOnly || loading ? null : onChangedHandler,
                            isDense: true,
                            isExpanded: true,
                            focusNode: focusNode,
                            autofocus: false,
                          )),
                        )));
            return Padding(
              child: child,
              padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends FormFieldState {
  bool loaded = false;
  @override
  DropdownFormField get widget => super.widget as DropdownFormField;

  @override
  void initState() {
    widget.controller.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChanged);
    super.dispose();
  }

  @override
  void didChange(dynamic value) {
    super.didChange(value);
    if (widget.controller.value != value) widget.controller.value = value;
  }

  @override
  void reset() {
    widget.controller.value = widget.initialValue;
    super.reset();
  }

  void _handleChanged() {
    if (widget.controller.value != value) didChange(widget.controller.value);
  }
}
