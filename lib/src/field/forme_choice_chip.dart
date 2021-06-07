import 'package:flutter/material.dart';
import '../../forme.dart';
import '../render/forme_render_utils.dart';
import '../render/forme_render_data.dart';

import '../forme_state_model.dart';
import '../forme_field.dart';
import 'forme_filter_chip.dart';

class FormeChoiceChip<T> extends ValueField<T, FormeChoiceChipModel<T>> {
  FormeChoiceChip({
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<T>? validator,
    FormeFieldValueChanged<T, FormeChoiceChipModel<T>>? onChanged,
    FormFieldSetter<T>? onSaved,
    String? name,
    bool readOnly = false,
    required List<FormeChipItem<T>>? items,
    FormeChoiceChipModel<T>? model,
    ValidateErrorListener<
            FormeValueFieldController<T, FormeChoiceChipModel<T>>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<T, FormeChoiceChipModel<T>>>?
        focusListener,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeChoiceChipModel<T>())
              .copyWith(FormeChoiceChipModel<T>(items: items)),
          readOnly: readOnly,
          name: name,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validateErrorListener: validateErrorListener,
          focusListener: focusListener,
          builder: (state) {
            bool readOnly = state.readOnly;
            FormeChoiceChipModel<T> model = state.model;
            List<FormeChipItem<T>> items = model.items!;
            ChipThemeData chipThemeData =
                model.chipThemeData ?? ChipTheme.of(state.context);
            List<Widget> chips = [];
            for (FormeChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              ChoiceChip chip = ChoiceChip(
                selected: state.value == item.data,
                label: item.label,
                avatar: item.avatar,
                padding: item.padding,
                pressElevation: item.pressElevation,
                tooltip: item.tooltip ?? item.tooltip,
                materialTapTargetSize: item.materialTapTargetSize,
                avatarBorder: item.avatarBorder ?? const CircleBorder(),
                backgroundColor: item.backgroundColor,
                shadowColor: item.shadowColor,
                disabledColor: item.disabledColor,
                selectedColor: item.selectedColor,
                selectedShadowColor: item.selectedShadowColor,
                visualDensity: item.visualDensity,
                elevation: item.elevation,
                labelPadding: item.labelPadding,
                labelStyle: item.labelStyle,
                shape: item.shape,
                side: item.side,
                onSelected: isReadOnly
                    ? null
                    : (bool selected) {
                        if (state.value == item.data) {
                          state.didChange(null);
                        } else {
                          state.didChange(item.data);
                        }
                        state.requestFocus();
                      },
              );
              chips.add(Visibility(
                  child: Padding(
                    padding: item.padding,
                    child: chip,
                  ),
                  visible: item.visible));
            }

            Widget chipWidget =
                FormeRenderUtils.wrap(state.model.wrapRenderData, chips);
            return Focus(
              focusNode: state.focusNode,
              child: ChipTheme(
                data: chipThemeData,
                child: chipWidget,
              ),
            );
          },
        );

  @override
  _FormeChoiceChipState<T> createState() => _FormeChoiceChipState();
}

class _FormeChoiceChipState<T>
    extends ValueFieldState<T, FormeChoiceChipModel<T>> {
  @override
  FormeChoiceChipModel<T> beforeUpdateModel(
      FormeChoiceChipModel<T> old, FormeChoiceChipModel<T> current) {
    if (value == null) return current;
    if (current.items != null) {
      if (!current.items!.any((element) => element.data == value)) {
        setValue(null);
      }
    }
    return current;
  }

  @override
  FormeChoiceChipModel<T> beforeSetModel(
      FormeChoiceChipModel<T> old, FormeChoiceChipModel<T> current) {
    if (current.items == null) {
      return current.copyWith(FormeChoiceChipModel(items: old.items));
    }
    return current;
  }
}

class FormeChoiceChipModel<T> extends FormeModel {
  final List<FormeChipItem<T>>? items;
  final ChipThemeData? chipThemeData;
  final FormeWrapRenderData? wrapRenderData;

  FormeChoiceChipModel({
    this.items,
    this.chipThemeData,
    this.wrapRenderData,
  });

  @override
  FormeChoiceChipModel<T> copyWith(FormeModel oldModel) {
    FormeChoiceChipModel<T> old = oldModel as FormeChoiceChipModel<T>;
    return FormeChoiceChipModel<T>(
      items: items ?? old.items,
      chipThemeData:
          FormeRenderUtils.copyChipThemeData(old.chipThemeData, chipThemeData),
      wrapRenderData:
          FormeWrapRenderData.copy(old.wrapRenderData, wrapRenderData),
    );
  }
}
