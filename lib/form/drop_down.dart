import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_builder.dart';

class DropDownController extends ValueNotifier {
  DropDownController({dynamic value}) : super(value);
}

class DropDownFormField extends FormField {
  final String controlKey;
  final DropDownController controller;
  final FocusNode focusNode;
  final ValueChanged onChanged;
  final Future<List<DropdownMenuItem>> dataProvider;

  DropDownFormField(
      this.controlKey, this.controller, this.focusNode, this.dataProvider,
      {this.onChanged})
      : super(
          builder: (field) {
            final _DropDownFormFieldState state =
                field as _DropDownFormFieldState;

            void onChangedHandler(dynamic value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            Widget buildWidget() {
              return DropdownButton(
                isExpanded: true,
                focusNode: focusNode,
                value: controller.value,
                items: state.items,
                onChanged: state.readOnly ? null : onChangedHandler,
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
  _DropDownFormFieldState createState() => _DropDownFormFieldState();
}

class _DropDownFormFieldState extends FormFieldState {
  bool readOnly = false;
  bool loaded = false;
  List<DropdownMenuItem> items = [];
  @override
  DropDownFormField get widget => super.widget as DropDownFormField;

  @override
  void initState() {
    widget.controller.addListener(_handleChanged);

    widget.dataProvider.then((value) {
      setState(() {
        items = value == null ? [] : List.from(value);
        loaded = true;
      });
    });
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
