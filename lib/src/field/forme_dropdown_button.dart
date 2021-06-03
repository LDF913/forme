import 'package:flutter/material.dart';
import '../render/forme_render_utils.dart';
import '../forme_core.dart';

import '../forme_field.dart';
import '../forme_controller.dart';
import '../forme_state_model.dart';

class FormeDropdownButton<T>
    extends ValueField<T, FormeDropdownButtonModel<T>> {
  FormeDropdownButton({
    required List<DropdownMenuItem<T>> items,
    FormeFieldValueChanged<T, FormeDropdownButtonModel<T>>? onChanged,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    FormFieldSetter<T>? onSaved,
    String? name,
    bool readOnly = false,
    FormeDropdownButtonModel<T>? model,
    ValidateErrorListener<
            FormeValueFieldController<T, FormeDropdownButtonModel<T>>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<T, FormeDropdownButtonModel<T>>>?
        focusListener,
    Key? key,
  }) : super(
          key: key,
          focusListener: focusListener,
          validateErrorListener: validateErrorListener,
          model: (model ?? FormeDropdownButtonModel<T>())
              .copyWith(FormeDropdownButtonModel<T>(
            items: items,
          )),
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

            InputDecoration inputDecoration =
                state.model.decoration ?? InputDecoration();

            DropdownButtonFormField<T> dropdownButton =
                DropdownButtonFormField<T>(
              focusNode: state.focusNode,
              autofocus: state.model.autofocus ?? false,
              selectedItemBuilder: state.model.selectedItemBuilder,
              value: state.value,
              items: state.model.items!,
              onTap: state.model.onTap,
              icon: state.model.icon,
              iconSize: iconSize,
              iconEnabledColor: state.model.iconEnabledColor,
              iconDisabledColor: state.model.iconDisabledColor,
              hint: state.model.hint,
              disabledHint: state.model.disabledHint,
              elevation: state.model.elevation ?? 8,
              style: state.model.style,
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

  @override
  _FormDropdownButtonState<T> createState() => _FormDropdownButtonState();
}

class _FormDropdownButtonState<T>
    extends ValueFieldState<T, FormeDropdownButtonModel<T>> {
  @override
  FormeDropdownButtonModel<T> beforeUpdateModel(
      FormeDropdownButtonModel<T> old, FormeDropdownButtonModel<T> current) {
    if (value == null) return current;
    if (current.items != null &&
        !current.items!.any((element) => element.value == value)) {
      setValue(null);
    }
    return current;
  }

  @override
  FormeDropdownButtonModel<T> beforeSetModel(
      FormeDropdownButtonModel<T> old, FormeDropdownButtonModel<T> current) {
    if (current.items == null) {
      current = current.copyWith(FormeDropdownButtonModel<T>(items: old.items));
    }
    return beforeUpdateModel(old, current);
  }
}

class FormeDropdownButtonModel<T> extends FormeModel {
  final DropdownButtonBuilder? selectedItemBuilder;
  final VoidCallback? onTap;
  final bool? autofocus;
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
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  FormeDropdownButtonModel({
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
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.autofocus,
    this.onTap,
    this.selectedItemBuilder,
  });
  FormeDropdownButtonModel<T> copyWith(FormeModel oldModel) {
    FormeDropdownButtonModel<T> old = oldModel as FormeDropdownButtonModel<T>;
    return FormeDropdownButtonModel<T>(
      selectedItemBuilder: selectedItemBuilder ?? old.selectedItemBuilder,
      onTap: onTap ?? old.onTap,
      autofocus: autofocus ?? old.autofocus,
      items: items ?? old.items,
      hint: hint ?? old.hint,
      disabledHint: disabledHint ?? old.disabledHint,
      elevation: elevation ?? old.elevation,
      style: style ?? old.style,
      isDense: isDense ?? old.isDense,
      isExpanded: isExpanded ?? old.isExpanded,
      itemHeight: itemHeight ?? old.itemHeight,
      focusColor: focusColor ?? old.focusColor,
      dropdownColor: dropdownColor ?? old.dropdownColor,
      iconSize: iconSize ?? old.iconSize,
      decoration:
          FormeRenderUtils.copyInputDecoration(old.decoration, decoration),
      icon: icon ?? old.icon,
      iconDisabledColor: iconDisabledColor ?? old.iconDisabledColor,
      iconEnabledColor: iconEnabledColor ?? old.iconEnabledColor,
    );
  }
}
