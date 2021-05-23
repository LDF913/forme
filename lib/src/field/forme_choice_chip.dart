import 'package:flutter/material.dart';
import '../../forme.dart';
import '../render/forme_render_utils.dart';
import '../render/forme_render_data.dart';

import '../forme_state_model.dart';
import 'forme_decoration_field.dart';
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
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    required List<FormeChipItem<T>>? items,
    FormeChoiceChipModel<T>? model,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeChoiceChipModel<T>())
              .merge(FormeChoiceChipModel<T>(items: items)),
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
            FormeFilterChipRenderData? formeFilterChipRenderData =
                model.formeFilterChipRenderData;

            List<Widget> chips = [];
            for (FormeChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              ChoiceChip chip = ChoiceChip(
                selected: state.value == item.data,
                label: item.label,
                avatar: item.avatar,
                padding:
                    item.contentPadding ?? formeFilterChipRenderData?.padding,
                pressElevation:
                    pressElevation ?? formeFilterChipRenderData?.pressElevation,
                tooltip: item.tooltip ?? formeFilterChipRenderData?.tooltip,
                materialTapTargetSize:
                    formeFilterChipRenderData?.materialTapTargetSize,
                avatarBorder: formeFilterChipRenderData?.avatarBorder ??
                    const CircleBorder(),
                backgroundColor: formeFilterChipRenderData?.backgroundColor,
                shadowColor: formeFilterChipRenderData?.shadowColor,
                disabledColor: formeFilterChipRenderData?.disabledColor,
                selectedColor: formeFilterChipRenderData?.selectedColor,
                selectedShadowColor:
                    formeFilterChipRenderData?.selectedShadowColor,
                visualDensity: formeFilterChipRenderData?.visualDensity,
                elevation: formeFilterChipRenderData?.elevation,
                labelPadding: item.labelPadding ??
                    formeFilterChipRenderData?.labelPadding,
                labelStyle:
                    item.labelStyle ?? formeFilterChipRenderData?.labelStyle,
                shape: formeFilterChipRenderData?.shape,
                side: formeFilterChipRenderData?.side,
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
  void beforeMerge(
      FormeChoiceChipModel<T> old, FormeChoiceChipModel<T> current) {
    if (value == null) return;
    if (current.items != null) {
      if (!current.items!.any((element) => element.data == value)) {
        setValue(null);
      }
    }
  }
}

class FormeChoiceChipModel<T> extends AbstractFormeModel {
  final List<FormeChipItem<T>>? items;
  final String? labelText;
  final String? helperText;
  final double? pressElevation;
  final FormeFilterChipRenderData? formeFilterChipRenderData;
  final ChipThemeData? chipThemeData;
  final FormeWrapRenderData? formeWrapRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  FormeChoiceChipModel({
    this.items,
    this.labelText,
    this.pressElevation,
    this.formeFilterChipRenderData,
    this.chipThemeData,
    this.formeWrapRenderData,
    this.formeDecorationFieldRenderData,
    this.helperText,
  });

  @override
  FormeChoiceChipModel<T> merge(AbstractFormeModel oldFieldState) {
    FormeChoiceChipModel<T> old = oldFieldState as FormeChoiceChipModel<T>;
    return FormeChoiceChipModel<T>(
      items: items ?? old.items,
      labelText: labelText ?? old.labelText,
      helperText: helperText ?? old.helperText,
      pressElevation: pressElevation ?? old.pressElevation,
      chipThemeData: chipThemeData ?? old.chipThemeData,
      formeFilterChipRenderData:
          formeFilterChipRenderData ?? old.formeFilterChipRenderData,
      formeWrapRenderData: formeWrapRenderData ?? old.formeWrapRenderData,
      formeDecorationFieldRenderData:
          formeDecorationFieldRenderData ?? old.formeDecorationFieldRenderData,
    );
  }
}
