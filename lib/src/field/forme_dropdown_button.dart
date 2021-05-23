import 'package:flutter/material.dart';

import '../forme_field.dart';
import '../forme_state_model.dart';

class FormeDropdownButton<T>
    extends ValueField<T, FormeDropdownButtonModel<T>> {
  FormeDropdownButton({
    required List<DropdownMenuItem<T>> items,
    ValueChanged<T?>? onChanged,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    FormFieldSetter<T>? onSaved,
    String? name,
    bool readOnly = false,
    FormeDropdownButtonModel<T>? model,
    VoidCallback? onTap,
    DropdownButtonBuilder? selectedItemBuilder,
    bool autofocus = false,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeDropdownButtonModel<T>())
              .merge(FormeDropdownButtonModel<T>(items: items)),
          readOnly: readOnly,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            double iconSize = state.model.iconSize ?? 24;
            InputDecoration inputDecoration = state.model.decoration ??
                InputDecoration(
                  focusColor: state.model.focusColor,
                  labelText: state.model.labelText,
                  helperText: state.model.helperText,
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_drop_down,
                        size: iconSize,
                      ),
                      if (!readOnly)
                        InkWell(
                          child: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: readOnly
                                  ? null
                                  : () {
                                      state.didChange(null);
                                      state.requestFocus();
                                    }),
                        )
                    ],
                  ),
                );
            DropdownButtonFormField<T> dropdownButton =
                DropdownButtonFormField<T>(
              focusNode: state.focusNode,
              autofocus: autofocus,
              selectedItemBuilder: selectedItemBuilder,
              value: state.value,
              items: state.model.items!,
              onTap: onTap,
              hint: state.model.hint,
              disabledHint: state.model.disabledHint,
              elevation: state.model.elevation ?? 8,
              style: state.model.style,
              icon: SizedBox.shrink(),
              isDense: state.model.isDense ?? true,
              isExpanded: state.model.isExpanded ?? true,
              itemHeight: state.model.itemHeight ?? kMinInteractiveDimension,
              focusColor: state.model.focusColor,
              dropdownColor: state.model.dropdownColor,
              decoration: inputDecoration.copyWith(errorText: state.errorText),
              onChanged: readOnly
                  ? null
                  : (value) {
                      state.didChange(value);
                      state.requestFocus();
                    },
            );

            return Row(
              children: [
                Expanded(
                  child: dropdownButton,
                )
              ],
            );
          },
        );
}

class FormeDropdownButtonModel<T> extends AbstractFormeModel {
  final String? labelText;
  final String? helperText;
  final List<DropdownMenuItem<T>>? items;
  final Widget? hint;
  final Widget? disabledHint;
  final int? elevation;
  final TextStyle? style;
  final bool? isDense;
  final bool? isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final Color? dropdownColor;
  final double? iconSize;
  final InputDecoration? decoration;

  FormeDropdownButtonModel({
    this.helperText,
    this.labelText,
    this.items,
    this.hint,
    this.disabledHint,
    this.elevation,
    this.style,
    this.isDense,
    this.isExpanded,
    this.itemHeight,
    this.focusColor,
    this.dropdownColor,
    this.decoration,
    this.iconSize,
  });

  @override
  FormeDropdownButtonModel<T> merge(AbstractFormeModel old) {
    FormeDropdownButtonModel<T> oldModel = old as FormeDropdownButtonModel<T>;
    return FormeDropdownButtonModel<T>(
      labelText: labelText ?? oldModel.labelText,
      helperText: helperText ?? oldModel.helperText,
      items: items ?? oldModel.items,
      hint: hint ?? oldModel.hint,
      disabledHint: disabledHint ?? oldModel.disabledHint,
      elevation: elevation ?? oldModel.elevation,
      style: style ?? oldModel.style,
      isDense: isDense ?? oldModel.isDense,
      iconSize: iconSize ?? oldModel.iconSize,
      isExpanded: isExpanded ?? oldModel.isExpanded,
      itemHeight: itemHeight ?? oldModel.itemHeight,
      focusColor: focusColor ?? oldModel.focusColor,
      dropdownColor: dropdownColor ?? oldModel.dropdownColor,
      decoration: decoration ?? oldModel.decoration,
    );
  }
}
