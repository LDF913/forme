import 'package:flutter/material.dart';
import '../render/form_render_utils.dart';
import '../render/theme_data.dart';

import '../form_state_model.dart';
import '../form_field.dart';
import 'decoration_field.dart';
import 'base_field.dart';

class FilterChipItem<T> {
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

  FilterChipItem({
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

enum ChipLayoutType { wrap, scroll }

class FilterChipFormField<T>
    extends BaseNonnullValueField<List<T>, FilterChipModel<T>> {
  FilterChipFormField({
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
    WidgetWrapper? wrapper,
    required FilterChipModel<T> model,
    LayoutParam? layoutParam,
  }) : super(
          layoutParam: layoutParam,
          model: model,
          readOnly: readOnly,
          name: name,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? [],
          builder: (state) {
            bool readOnly = state.readOnly;
            FilterChipModel<T> model = state.model;
            List<FilterChipItem<T>> items = model.items ?? [];
            String? labelText = model.labelText;
            double? pressElevation = model.pressElevation;
            ChipLayoutType layoutType = model.layoutType ?? ChipLayoutType.wrap;
            int? count = model.count;
            ChipThemeData chipThemeData =
                model.chipThemeData ?? ChipTheme.of(state.context);
            FilterChipRenderData? filterChipRenderData =
                model.filterChipRenderData;

            List<Widget> chips = [];
            for (FilterChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              FilterChip chip = FilterChip(
                selected: state.value.contains(item.data),
                label: item.label,
                avatar: item.avatar,
                padding: item.contentPadding ?? filterChipRenderData?.padding,
                pressElevation:
                    pressElevation ?? filterChipRenderData?.pressElevation,
                tooltip: item.tooltip ?? filterChipRenderData?.tooltip,
                materialTapTargetSize:
                    filterChipRenderData?.materialTapTargetSize,
                avatarBorder:
                    filterChipRenderData?.avatarBorder ?? const CircleBorder(),
                backgroundColor: filterChipRenderData?.backgroundColor,
                checkmarkColor: filterChipRenderData?.checkmarkColor,
                showCheckmark: filterChipRenderData?.showCheckmark,
                shadowColor: filterChipRenderData?.shadowColor,
                disabledColor: filterChipRenderData?.disabledColor,
                selectedColor: filterChipRenderData?.selectedColor,
                selectedShadowColor: filterChipRenderData?.selectedShadowColor,
                visualDensity: filterChipRenderData?.visualDensity,
                elevation: filterChipRenderData?.elevation,
                labelPadding:
                    item.labelPadding ?? filterChipRenderData?.labelPadding,
                labelStyle: item.labelStyle ?? filterChipRenderData?.labelStyle,
                shape: filterChipRenderData?.shape,
                side: filterChipRenderData?.side,
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

            Widget chipWidget;

            switch (layoutType) {
              case ChipLayoutType.wrap:
                chipWidget =
                    FormRenderUtils.wrap(state.model.wrapRenderData, chips);
                break;
              case ChipLayoutType.scroll:
                chipWidget = SingleChildScrollView(
                    scrollDirection: state.model.singleChildScrollViewRenderData
                            ?.scrollDirection ??
                        Axis.horizontal,
                    reverse:
                        state.model.singleChildScrollViewRenderData?.reverse ??
                            false,
                    padding:
                        state.model.singleChildScrollViewRenderData?.padding,
                    child: Row(children: chips));
                break;
            }

            return DecorationField(
              child: ChipTheme(
                data: chipThemeData,
                child: chipWidget,
              ),
              focusNode: state.focusNode,
              errorText: state.errorText,
              readOnly: readOnly,
              labelText: labelText,
            );
          },
        );

  @override
  _FilterChipFormFieldState<T> createState() => _FilterChipFormFieldState();
}

class _FilterChipFormFieldState<T>
    extends BaseNonnullValueFieldState<List<T>, FilterChipModel<T>> {
  @override
  void beforeMerge(FilterChipModel<T> old, FilterChipModel<T> current) {
    if (current.items != null) {
      List<T> items = List.of(value);
      Iterable<T> datas = current.items!.map((e) => e.data);
      items.removeWhere((element) => !datas.contains(element));
      setValue(items);
    }
  }
}

class FilterChipModel<T> extends AbstractFieldStateModel {
  final List<FilterChipItem<T>>? items;
  final String? labelText;
  final ChipLayoutType? layoutType;
  final int? count;
  final double? pressElevation;
  final FilterChipRenderData? filterChipRenderData;
  final ChipThemeData? chipThemeData;
  final WrapRenderData? wrapRenderData;
  final SingleChildScrollViewRenderData? singleChildScrollViewRenderData;

  FilterChipModel({
    this.items,
    this.labelText,
    this.pressElevation,
    this.count,
    this.layoutType,
    this.filterChipRenderData,
    this.chipThemeData,
    this.wrapRenderData,
    this.singleChildScrollViewRenderData,
  });

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel oldFieldState) {
    FilterChipModel<T> old = oldFieldState as FilterChipModel<T>;
    return FilterChipModel<T>(
      items: items ?? old.items,
      labelText: labelText ?? old.labelText,
      pressElevation: pressElevation ?? old.pressElevation,
      count: count ?? old.count,
      layoutType: layoutType ?? old.layoutType,
      chipThemeData: chipThemeData ?? old.chipThemeData,
      filterChipRenderData: filterChipRenderData ?? old.filterChipRenderData,
      wrapRenderData: wrapRenderData ?? old.wrapRenderData,
    );
  }
}
