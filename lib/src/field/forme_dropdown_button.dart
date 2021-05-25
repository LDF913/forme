import 'package:flutter/material.dart';
import '../forme_core.dart';
import '../forme_management.dart';
import '../widget/forme_clear_button.dart';

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
          model:
              (model ?? FormeDropdownButtonModel<T>()).copyWith(items: items),
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
              autofocus: autofocus,
              selectedItemBuilder: selectedItemBuilder,
              value: state.value,
              items: state.model.items!,
              onTap: onTap,
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
  void focusChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(focusChange);
    super.dispose();
  }
}

class FormeDropdownButtonModel<T> extends FormeModel {
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
  });
  @override
  FormeDropdownButtonModel<T> copyWith({
    List<DropdownMenuItem<T>>? items,
    Optional<Widget>? hint,
    Optional<Widget>? disabledHint,
    Optional<int>? elevation,
    Optional<TextStyle>? style,
    bool? isDense,
    bool? isExpanded,
    Optional<double>? itemHeight,
    Optional<Color>? focusColor,
    Optional<Color>? dropdownColor,
    Optional<double>? iconSize,
    Optional<InputDecoration>? decoration,
    Optional<Widget>? icon,
    Optional<Color>? iconDisabledColor,
    Optional<Color>? iconEnabledColor,
  }) {
    return FormeDropdownButtonModel<T>(
      items: items ?? this.items,
      hint: Optional.copyWith(hint, this.hint),
      disabledHint: Optional.copyWith(disabledHint, this.disabledHint),
      elevation: Optional.copyWith(elevation, this.elevation),
      style: Optional.copyWith(style, this.style),
      isDense: isDense ?? isDense,
      isExpanded: isExpanded ?? isExpanded,
      itemHeight: Optional.copyWith(itemHeight, this.itemHeight),
      focusColor: Optional.copyWith(focusColor, this.focusColor),
      dropdownColor: Optional.copyWith(dropdownColor, this.dropdownColor),
      iconSize: Optional.copyWith(iconSize, this.iconSize),
      decoration: Optional.copyWith(decoration, this.decoration),
      icon: Optional.copyWith(icon, this.icon),
      iconDisabledColor:
          Optional.copyWith(iconDisabledColor, this.iconDisabledColor),
      iconEnabledColor:
          Optional.copyWith(iconEnabledColor, this.iconEnabledColor),
    );
  }
}

/// a clear button for [FormeDropdownButton] field
class FormeDropdownButtonClearButton extends FormeClearButton {
  FormeDropdownButtonClearButton({
    bool visibleWhenUnfocus = true,
    Widget clearIcon = const Icon(Icons.clear),
  }) : super(
          visibleWhenUnfocus: visibleWhenUnfocus,
          clearIcon: clearIcon,
          onPressed: (value) {
            value.focus = true;
            value.value = null;
          },
        );

  @protected
  Widget buildIcon(Widget icon, FormeValueFieldManagement valueField) {
    return InkWell(
      child: clearIcon,
      onTap: valueField.readOnly ? null : () => onPressed(valueField),
    );
  }
}
