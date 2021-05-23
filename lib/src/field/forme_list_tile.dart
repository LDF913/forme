import 'package:flutter/material.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import 'forme_decoration_field.dart';
import '../forme_field.dart';

class FormeListTileItem<T> {
  final Widget title;
  final bool readOnly;
  final bool visible;
  final EdgeInsets padding;

  /// only work when split = 1
  final Widget? secondary;
  final ListTileControlAffinity controlAffinity;

  /// only work when split = 1
  final Widget? subtitle;
  final bool dense;
  final T data;
  final bool ignoreSplit;

  FormeListTileItem(
      {required this.title,
      this.subtitle,
      this.secondary,
      ListTileControlAffinity? controlAffinity,
      this.readOnly = false,
      this.visible = true,
      this.dense = false,
      EdgeInsets? padding,
      required this.data,
      this.ignoreSplit = false})
      : this.controlAffinity =
            controlAffinity ?? ListTileControlAffinity.leading,
        this.padding = padding ?? EdgeInsets.zero;
}

enum FormeListTileType { Checkbox, Switch, Radio }

class FormeListTile<T>
    extends NonnullValueField<List<T>, FormeListTileModel<T>> {
  FormeListTile({
    ValueChanged<List<T>>? onChanged,
    NonnullFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    List<T>? initialValue,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    FormeListTileType type = FormeListTileType.Checkbox,
    required List<FormeListTileItem<T>>? items,
    FormeListTileModel<T>? model,
    Key? key,
  }) : super(
            key: key,
            model: (model ?? FormeListTileModel<T>())
                .merge(FormeListTileModel(items: items)),
            readOnly: readOnly,
            name: name,
            onChanged: onChanged,
            onSaved: onSaved,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue ?? [],
            validator: validator,
            builder: (state) {
              bool readOnly = state.readOnly;
              int split = state.model.split ?? 2;
              List<FormeListTileItem<T>> items = state.model.items ?? [];
              bool hasSelectAll = state.model.hasSelectAll ?? true;

              FormeListTileRenderData? formeListTileRenderData =
                  state.model.formeListTileRenderData;
              FormeCheckboxRenderData? formeCheckboxRenderData =
                  state.model.formeCheckboxRenderData;
              FormeRadioRenderData? formeRadioRenderData =
                  state.model.formeRadioRenderData;
              FormeSwitchRenderData? formeSwitchRenderData =
                  state.model.formeSwitchRenderData;

              List<Widget> wrapWidgets = [];

              void changeValue(T value) {
                state.requestFocus();
                switch (type) {
                  case FormeListTileType.Checkbox:
                  case FormeListTileType.Switch:
                    List<T> values = List.of(state.value);
                    if (!values.remove(value)) {
                      values.add(value);
                    }
                    state.didChange(values);
                    break;
                  case FormeListTileType.Radio:
                    state.didChange([value]);
                    break;
                }
              }

              Widget createFormeListTileItem(
                  FormeListTileItem item, bool selected, bool readOnly) {
                switch (type) {
                  case FormeListTileType.Radio:
                    return RadioListTile<T>(
                      shape: formeRadioRenderData?.shape,
                      tileColor: formeRadioRenderData?.tileColor,
                      selectedTileColor:
                          formeRadioRenderData?.selectedTileColor,
                      activeColor: formeRadioRenderData?.activeColor,
                      secondary: item.secondary,
                      subtitle: item.subtitle,
                      groupValue: state.value.isEmpty ? null : state.value[0],
                      controlAffinity: item.controlAffinity,
                      contentPadding: item.padding,
                      dense: item.dense,
                      title: item.title,
                      value: item.data,
                      onChanged:
                          readOnly ? null : (v) => changeValue(item.data),
                    );
                  case FormeListTileType.Checkbox:
                    return CheckboxListTile(
                      shape: formeCheckboxRenderData?.shape,
                      tileColor: formeCheckboxRenderData?.tileColor,
                      selectedTileColor:
                          formeCheckboxRenderData?.selectedTileColor,
                      activeColor: formeCheckboxRenderData?.activeColor,
                      checkColor: formeCheckboxRenderData?.checkColor,
                      secondary: item.secondary,
                      subtitle: item.subtitle,
                      controlAffinity: item.controlAffinity,
                      contentPadding: item.padding,
                      dense: item.dense,
                      title: item.title,
                      value: selected,
                      onChanged:
                          readOnly ? null : (v) => changeValue(item.data),
                    );
                  case FormeListTileType.Switch:
                    return SwitchListTile(
                      tileColor: formeSwitchRenderData?.tileColor,
                      activeColor: formeSwitchRenderData?.activeColor,
                      activeTrackColor: formeSwitchRenderData?.activeTrackColor,
                      inactiveThumbColor:
                          formeSwitchRenderData?.inactiveThumbColor,
                      inactiveTrackColor:
                          formeSwitchRenderData?.inactiveTrackColor,
                      activeThumbImage: formeSwitchRenderData?.activeThumbImage,
                      inactiveThumbImage:
                          formeSwitchRenderData?.inactiveThumbImage,
                      shape: formeSwitchRenderData?.shape,
                      selectedTileColor:
                          formeSwitchRenderData?.selectedTileColor,
                      secondary: item.secondary,
                      subtitle: item.subtitle,
                      controlAffinity: item.controlAffinity,
                      contentPadding: item.padding,
                      dense: item.dense,
                      title: item.title,
                      value: selected,
                      onChanged:
                          readOnly ? null : (v) => changeValue(item.data),
                    );
                }
              }

              Widget createCommonItem(
                  FormeListTileItem item, bool selected, bool readOnly) {
                switch (type) {
                  case FormeListTileType.Checkbox:
                    return FormeRenderUtils.checkbox(
                        selected,
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        formeCheckboxRenderData);
                  case FormeListTileType.Switch:
                    return FormeRenderUtils.adaptiveSwitch(
                        selected,
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        formeSwitchRenderData);
                  case FormeListTileType.Radio:
                    return FormeRenderUtils.radio<T>(
                        item.data,
                        state.value.isEmpty ? null : state.value[0],
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        formeRadioRenderData);
                }
              }

              for (int i = 0; i < items.length; i++) {
                FormeListTileItem<T> item = items[i];
                bool isReadOnly = readOnly || item.readOnly;
                bool selected = state.value.contains(item.data);
                if (split > 0) {
                  double factor = 1 / split;
                  if (factor == 1) {
                    wrapWidgets.add(
                        createFormeListTileItem(item, selected, isReadOnly));
                    continue;
                  }
                }

                Widget tileItem = createCommonItem(item, selected, readOnly);

                final Widget title = split == 0
                    ? item.title
                    : Flexible(
                        child: item.title,
                      );

                List<Widget> children;
                switch (item.controlAffinity) {
                  case ListTileControlAffinity.leading:
                    children = [tileItem, title];
                    break;
                  default:
                    children = [title, tileItem];
                    break;
                }

                Row tileItemRow = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                );

                Widget groupItemWidget = Padding(
                  padding: item.padding,
                  child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      onTap: isReadOnly
                          ? null
                          : () {
                              changeValue(item.data);
                            },
                      child: tileItemRow),
                );

                bool visible = item.visible;
                if (split <= 0) {
                  wrapWidgets.add(Visibility(
                    child: groupItemWidget,
                    visible: visible,
                  ));
                  if (visible && i < items.length - 1)
                    wrapWidgets.add(SizedBox(
                      width: 8.0,
                    ));
                } else {
                  double factor = item.ignoreSplit ? 1 : 1 / split;
                  wrapWidgets.add(Visibility(
                    child: FractionallySizedBox(
                      widthFactor: factor,
                      child: groupItemWidget,
                    ),
                    visible: visible,
                  ));
                }
              }

              bool isAllReadOnly = true;
              bool isAllInvisible = true;
              List<T> controllableItems = [];
              items.forEach((element) {
                bool readOnly = element.readOnly;
                bool visible = element.visible;
                if (!readOnly) {
                  isAllReadOnly = false;
                }
                if (visible) {
                  isAllInvisible = false;
                }
                if (!readOnly && visible) {
                  controllableItems.add(element.data);
                }
              });

              Widget? icon;

              if (items.length > 1 &&
                  hasSelectAll &&
                  type != FormeListTileType.Radio) {
                bool selectAll = controllableItems.isNotEmpty &&
                    controllableItems
                        .every((element) => state.value.contains(element));

                if (!isAllInvisible) {
                  IconData iconData =
                      selectAll ? Icons.switch_right : Icons.switch_left;
                  void toggleValues() {
                    state.requestFocus();
                    List<T> values = List.of(state.value);
                    if (selectAll) {
                      state.didChange(values
                          .where(
                              (element) => !controllableItems.contains(element))
                          .toList());
                    } else {
                      state.didChange(values
                        ..removeWhere(
                            (element) => controllableItems.contains(element))
                        ..addAll(controllableItems)
                        ..toSet()
                        ..toList());
                    }
                  }

                  icon = InkWell(
                    child: IconButton(
                      icon: Icon(
                        iconData,
                      ),
                      onPressed:
                          readOnly || isAllReadOnly ? null : toggleValues,
                    ),
                  );
                }
              }

              Widget child = FormeRenderUtils.wrap(
                  state.model.formeWrapRenderData, wrapWidgets);
              if (split == 1) {
                child = FormeRenderUtils.mergeListTileTheme(
                    child, formeListTileRenderData);
              }

              return FormeDecoration(
                formeDecorationFieldRenderData:
                    state.model.formeDecorationFieldRenderData,
                labelText: state.model.labelText,
                helperText: state.model.helperText,
                errorText: state.errorText,
                child: child,
                focusNode: state.focusNode,
                icon: icon,
              );
            });

  @override
  _FormeListTileState<T> createState() => _FormeListTileState();
}

class _FormeListTileState<T>
    extends NonnullValueFieldState<List<T>, FormeListTileModel<T>> {
  @override
  void beforeMerge(FormeListTileModel<T> old, FormeListTileModel<T> current) {
    if (current.items != null) {
      List<T> items = List.of(value);
      Iterable<T> datas = current.items!.map((e) => e.data);
      items.removeWhere((element) => !datas.contains(element));
      setValue(items);
    }
  }
}

class FormeListTileModel<T> extends AbstractFormeModel {
  final String? labelText;
  final String? helperText;
  final int? split;
  final List<FormeListTileItem<T>>? items;
  final bool? hasSelectAll;
  final FormeListTileRenderData? formeListTileRenderData;
  final FormeCheckboxRenderData? formeCheckboxRenderData;
  final FormeRadioRenderData? formeRadioRenderData;
  final FormeSwitchRenderData? formeSwitchRenderData;
  final FormeWrapRenderData? formeWrapRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;
  FormeListTileModel({
    this.labelText,
    this.split,
    this.items,
    this.hasSelectAll,
    this.formeListTileRenderData,
    this.formeCheckboxRenderData,
    this.formeRadioRenderData,
    this.formeSwitchRenderData,
    this.formeWrapRenderData,
    this.formeDecorationFieldRenderData,
    this.helperText,
  });

  @override
  FormeListTileModel<T> merge(AbstractFormeModel old) {
    FormeListTileModel<T> oldModel = old as FormeListTileModel<T>;
    return FormeListTileModel<T>(
      labelText: labelText ?? oldModel.labelText,
      helperText: helperText ?? oldModel.helperText,
      split: split ?? oldModel.split,
      items: items ?? oldModel.items,
      hasSelectAll: hasSelectAll ?? oldModel.hasSelectAll,
      formeListTileRenderData:
          formeListTileRenderData ?? oldModel.formeListTileRenderData,
      formeCheckboxRenderData:
          formeCheckboxRenderData ?? oldModel.formeCheckboxRenderData,
      formeRadioRenderData:
          formeRadioRenderData ?? oldModel.formeRadioRenderData,
      formeSwitchRenderData:
          formeSwitchRenderData ?? oldModel.formeSwitchRenderData,
      formeWrapRenderData: formeWrapRenderData ?? oldModel.formeWrapRenderData,
      formeDecorationFieldRenderData:
          formeDecorationFieldRenderData ?? old.formeDecorationFieldRenderData,
    );
  }
}
