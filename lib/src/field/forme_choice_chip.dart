import 'package:flutter/material.dart';
import '../../forme.dart';
import '../render/forme_render_utils.dart';
import '../render/forme_render_data.dart';

import '../forme_state_model.dart';
import 'forme_decoration.dart';
import '../forme_field.dart';
import 'forme_filter_chip.dart';

class FormeChoiceChip<T> extends ValueField<T, FormeChoiceChipModel<T>> {
  FormeChoiceChip({
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<T>? validator,
    ValueChanged<T?>? onChanged,
    FormFieldSetter<T>? onSaved,
    String? name,
    bool readOnly = false,
    required List<FormeChipItem<T>>? items,
    FormeChoiceChipModel<T>? model,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeChoiceChipModel<T>()).copyWith(items: items),
          readOnly: readOnly,
          name: name,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          builder: (state) {
            bool readOnly = state.readOnly;
            FormeChoiceChipModel<T> model = state.model;
            List<FormeChipItem<T>> items = model.items!;
            double? pressElevation = model.pressElevation;
            ChipThemeData chipThemeData =
                model.chipThemeData ?? ChipTheme.of(state.context);
            FormeChipRenderData? formeChipRenderData =
                model.formeChipRenderData;

            List<Widget> chips = [];
            for (FormeChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              ChoiceChip chip = ChoiceChip(
                selected: state.value == item.data,
                label: item.label,
                avatar: item.avatar,
                padding: item.contentPadding ?? formeChipRenderData?.padding,
                pressElevation:
                    pressElevation ?? formeChipRenderData?.pressElevation,
                tooltip: item.tooltip ?? formeChipRenderData?.tooltip,
                materialTapTargetSize:
                    formeChipRenderData?.materialTapTargetSize,
                avatarBorder:
                    formeChipRenderData?.avatarBorder ?? const CircleBorder(),
                backgroundColor: formeChipRenderData?.backgroundColor,
                shadowColor: formeChipRenderData?.shadowColor,
                disabledColor: formeChipRenderData?.disabledColor,
                selectedColor: formeChipRenderData?.selectedColor,
                selectedShadowColor: formeChipRenderData?.selectedShadowColor,
                visualDensity: formeChipRenderData?.visualDensity,
                elevation: formeChipRenderData?.elevation,
                labelPadding:
                    item.labelPadding ?? formeChipRenderData?.labelPadding,
                labelStyle: item.labelStyle ?? formeChipRenderData?.labelStyle,
                shape: formeChipRenderData?.shape,
                side: formeChipRenderData?.side,
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
                FormeRenderUtils.wrap(state.model.formeWrapRenderData, chips);

            return FormeDecoration(
              formeDecorationFieldRenderData:
                  state.model.formeDecorationFieldRenderData,
              child: ChipTheme(
                data: chipThemeData,
                child: chipWidget,
              ),
              focusNode: state.focusNode,
              errorText: state.errorText,
              labelText: state.model.labelText,
              helperText: state.model.helperText,
            );
          },
        );

  @override
  _FormeChoiceChipState<T> createState() => _FormeChoiceChipState();
}

class _FormeChoiceChipState<T>
    extends ValueFieldState<T, FormeChoiceChipModel<T>> {
  @override
  void beforeUpdateModel(
      FormeChoiceChipModel<T> old, FormeChoiceChipModel<T> current) {
    if (value == null) return;
    if (current.items != null) {
      if (!current.items!.any((element) => element.data == value)) {
        setValue(null);
      }
    }
  }
}

class FormeChoiceChipModel<T> extends FormeModel {
  final List<FormeChipItem<T>>? items;
  final String? labelText;
  final String? helperText;
  final double? pressElevation;
  final FormeChipRenderData? formeChipRenderData;
  final ChipThemeData? chipThemeData;
  final FormeWrapRenderData? formeWrapRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  FormeChoiceChipModel({
    this.items,
    this.labelText,
    this.pressElevation,
    this.formeChipRenderData,
    this.chipThemeData,
    this.formeWrapRenderData,
    this.formeDecorationFieldRenderData,
    this.helperText,
  });

  @override
  FormeChoiceChipModel<T> copyWith({
    List<FormeChipItem<T>>? items,
    Optional<String>? labelText,
    Optional<String>? helperText,
    Optional<double>? pressElevation,
    Optional<FormeChipRenderData>? formeChipRenderData,
    Optional<ChipThemeData>? chipThemeData,
    Optional<FormeWrapRenderData>? formeWrapRenderData,
    Optional<FormeDecorationRenderData>? formeDecorationFieldRenderData,
  }) {
    return FormeChoiceChipModel<T>(
      items: items ?? this.items,
      labelText: Optional.copyWith(labelText, this.labelText),
      helperText: Optional.copyWith(helperText, this.helperText),
      pressElevation: Optional.copyWith(pressElevation, this.pressElevation),
      formeChipRenderData:
          Optional.copyWith(formeChipRenderData, this.formeChipRenderData),
      chipThemeData: Optional.copyWith(chipThemeData, this.chipThemeData),
      formeWrapRenderData:
          Optional.copyWith(formeWrapRenderData, this.formeWrapRenderData),
      formeDecorationFieldRenderData: Optional.copyWith(
          formeDecorationFieldRenderData, this.formeDecorationFieldRenderData),
    );
  }
}
