import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_builder.dart';

class DropdownController extends ValueNotifier {
  DropdownController({dynamic value}) : super(value);
}

class DropdownFormField extends FormField {
  final String controlKey;
  final DropdownController controller;
  final FocusNode focusNode;
  final ValueChanged onChanged;
  final List<DropdownMenuItem> items;
  final bool clearable;
  final DropdownButtonBuilder selectedItemBuilder;
  final FormFieldValidator validator;
  final AutovalidateMode autovalidateMode;

  DropdownFormField(
      this.controlKey, this.controller, this.focusNode, this.items,
      {this.onChanged,
      this.clearable,
      this.selectedItemBuilder,
      this.validator,
      this.autovalidateMode})
      : super(
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final _DropdownFormFieldState state =
                field as _DropdownFormFieldState;

            void onChangedHandler(dynamic value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
              focusNode.requestFocus();
            }

            Widget buildWidget() {
              final InputDecoration effectiveDecoration =
                  InputDecoration().applyDefaults(
                Theme.of(field.context).inputDecorationTheme,
              );
              List<Widget> icons = [];
              if (clearable && !state.readOnly && controller.value != null) {
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
              icons.add(Icon(Icons.arrow_drop_down));

              bool hasValue = controller.value == null ||
                  (controller.value != null &&
                      items
                          .any((element) => element.value == controller.value));

              if (!hasValue) {
                throw 'pls clear dropdown value before you reload items!';
              }
              return Focus(
                canRequestFocus: false,
                skipTraversal: true,
                child: Builder(builder: (BuildContext context) {
                  return InputDecorator(
                    decoration: effectiveDecoration.copyWith(
                        errorText: field.errorText),
                    isEmpty: controller.value == null,
                    isFocused: Focus.of(context).hasFocus,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        selectedItemBuilder: selectedItemBuilder ??
                            (BuildContext context) {
                              return items.map<Widget>((DropdownMenuItem item) {
                                return SingleChildScrollView(
                                  child: item.child,
                                );
                              }).toList();
                            },
                        items: items,
                        value: controller.value,
                        icon: Row(
                          children: icons,
                          mainAxisSize: MainAxisSize.min,
                        ),
                        onChanged: state.readOnly ? null : onChangedHandler,
                        isDense: true,
                        isExpanded: true,
                        focusNode: focusNode,
                        autofocus: false,
                      ),
                    ),
                  );
                }),
              );
            }

            return Consumer<FormController>(
                builder: (context, c, child) {
                  bool currentReadOnly = c.isReadOnly(controlKey);
                  if (state.readOnly != currentReadOnly) {
                    state.readOnly = currentReadOnly;
                    return buildWidget();
                  }
                  return child;
                },
                child: buildWidget());
          },
        );

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends FormFieldState {
  bool readOnly = false;
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
