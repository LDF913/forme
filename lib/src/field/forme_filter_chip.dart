import 'package:flutter/material.dart';
import '../render/forme_render_utils.dart';
import '../render/forme_render_data.dart';

import '../forme_state_model.dart';
import 'forme_decoration_field.dart';
import '../forme_field.dart';

class FormeChipItem<T> {
  final Widget label;
  final Widget? avatar;
  final T data;
  final EdgeInsets? contentPadding;
  final EdgeInsets? labelPadding;
  final EdgeInsets padding;
  final bool readOnly;
  final bool visible;
  final String? tooltip;
  final TextStyle? labelStyle;

  FormeChipItem({
    required this.label,
    this.avatar,
    required this.data,
    EdgeInsets? padding,
    this.readOnly = false,
    this.visible = true,
    this.contentPadding = const EdgeInsets.all(10),
    this.labelPadding,
    this.tooltip,
    this.labelStyle,
  }) : this.padding = padding ?? EdgeInsets.symmetric(horizontal: 10);
}

class FormeFilterChip<T>
    extends NonnullValueField<List<T>, FormeFilterChipModel<T>> {
  FormeFilterChip({
    List<T>? initialValue,
    AutovalidateMode? autovalidateMode,
    NonnullFieldValidator<List<T>>? validator,
    ValueChanged<List<T>>? onChanged,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    VoidCallback? exceedCallback,
    required List<FormeChipItem<T>>? items,
    FormeFilterChipModel<T>? model,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeFilterChipModel<T>())
              .merge(FormeFilterChipModel<T>(items: items)),
          readOnly: readOnly,
          name: name,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? [],
          builder: (state) {
            bool readOnly = state.readOnly;
            FormeFilterChipModel<T> model = state.model;
            List<FormeChipItem<T>> items = model.items!;
            double? pressElevation = model.pressElevation;
            int? count = model.count;
            ChipThemeData chipThemeData =
                model.chipThemeData ?? ChipTheme.of(state.context);
            FormeFilterChipRenderData? formeFilterChipRenderData =
                model.formeFilterChipRenderData;

            List<Widget> chips = [];
            for (FormeChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              FilterChip chip = FilterChip(
                selected: state.value.contains(item.data),
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
                checkmarkColor: formeFilterChipRenderData?.checkmarkColor,
                showCheckmark: formeFilterChipRenderData?.showCheckmark,
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
                        if (selected) {
                          if (count != null && state.value.length >= count) {
                            if (exceedCallback != null) exceedCallback();
                            return;
                          }
                          state.didChange(List.of(state.value)..add(item.data));
                        } else {
                          state.didChange(
                              List.of(state.value)..remove(item.data));
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
  _FormeFilterChipState<T> createState() => _FormeFilterChipState();
}

class _FormeFilterChipState<T>
    extends NonnullValueFieldState<List<T>, FormeFilterChipModel<T>> {
  @override
  void beforeMerge(
      FormeFilterChipModel<T> old, FormeFilterChipModel<T> current) {
    if (current.items != null) {
      List<T> items = List.of(value);
      Iterable<T> datas = current.items!.map((e) => e.data);
      items.removeWhere((element) => !datas.contains(element));
      setValue(items);
    }
  }
}

class FormeFilterChipModel<T> extends AbstractFormeModel {
  final List<FormeChipItem<T>>? items;
  final String? labelText;
  final String? helperText;
  final int? count;
  final double? pressElevation;
  final FormeFilterChipRenderData? formeFilterChipRenderData;
  final ChipThemeData? chipThemeData;
  final FormeWrapRenderData? formeWrapRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  FormeFilterChipModel({
    this.items,
    this.labelText,
    this.helperText,
    this.pressElevation,
    this.count,
    this.formeFilterChipRenderData,
    this.chipThemeData,
    this.formeWrapRenderData,
    this.formeDecorationFieldRenderData,
  });

  @override
  FormeFilterChipModel<T> merge(AbstractFormeModel oldFieldState) {
    FormeFilterChipModel<T> old = oldFieldState as FormeFilterChipModel<T>;
    return FormeFilterChipModel<T>(
      items: items ?? old.items,
      labelText: labelText ?? old.labelText,
      helperText: helperText ?? old.helperText,
      pressElevation: pressElevation ?? old.pressElevation,
      count: count ?? old.count,
      chipThemeData: chipThemeData ?? old.chipThemeData,
      formeFilterChipRenderData:
          formeFilterChipRenderData ?? old.formeFilterChipRenderData,
      formeWrapRenderData: formeWrapRenderData ?? old.formeWrapRenderData,
      formeDecorationFieldRenderData:
          formeDecorationFieldRenderData ?? old.formeDecorationFieldRenderData,
    );
  }
}
