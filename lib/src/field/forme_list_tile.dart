import 'package:flutter/material.dart';
import '../forme_management.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_state_model.dart';
import '../forme_field.dart';
import '../forme_core.dart';

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
  final FormeListTileType type;
  FormeListTile({
    ValueChanged<List<T>>? onChanged,
    NonnullFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    List<T>? initialValue,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    bool readOnly = false,
    this.type = FormeListTileType.Checkbox,
    required List<FormeListTileItem<T>>? items,
    FormeListTileModel<T>? model,
    ValidateErrorListener<
            FormeValueFieldManagement<List<T>, FormeListTileModel<T>>>?
        validateErrorListener,
    FocusListener<FormeFieldManagement<FormeListTileModel<T>>>? focusListener,
    Key? key,
  }) : super(
            focusListener: focusListener,
            validateErrorListener: validateErrorListener,
            key: key,
            model: (model ?? FormeListTileModel<T>())
                .copyWith(FormeListTileModel(items: items)),
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

              FormeListTileRenderData? listTileRenderData =
                  state.model.listTileRenderData;
              FormeCheckboxRenderData? checkboxRenderData =
                  state.model.checkboxRenderData;
              FormeRadioRenderData? radioRenderData =
                  state.model.radioRenderData;
              FormeSwitchRenderData? switchRenderData =
                  state.model.switchRenderData;

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
                      shape: radioRenderData?.shape,
                      tileColor: radioRenderData?.tileColor,
                      selectedTileColor: radioRenderData?.selectedTileColor,
                      activeColor: radioRenderData?.activeColor,
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
                      shape: checkboxRenderData?.shape,
                      tileColor: checkboxRenderData?.tileColor,
                      selectedTileColor: checkboxRenderData?.selectedTileColor,
                      activeColor: checkboxRenderData?.activeColor,
                      checkColor: checkboxRenderData?.checkColor,
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
                      tileColor: switchRenderData?.tileColor,
                      activeColor: switchRenderData?.activeColor,
                      activeTrackColor: switchRenderData?.activeTrackColor,
                      inactiveThumbColor: switchRenderData?.inactiveThumbColor,
                      inactiveTrackColor: switchRenderData?.inactiveTrackColor,
                      activeThumbImage: switchRenderData?.activeThumbImage,
                      inactiveThumbImage: switchRenderData?.inactiveThumbImage,
                      shape: switchRenderData?.shape,
                      selectedTileColor: switchRenderData?.selectedTileColor,
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
                        checkboxRenderData);
                  case FormeListTileType.Switch:
                    return FormeRenderUtils.adaptiveSwitch(
                        selected,
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        switchRenderData);
                  case FormeListTileType.Radio:
                    return FormeRenderUtils.radio<T>(
                        item.data,
                        state.value.isEmpty ? null : state.value[0],
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        radioRenderData);
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

              Widget child = FormeRenderUtils.wrap(
                  state.model.wrapRenderData, wrapWidgets);
              if (split == 1) {
                child = FormeRenderUtils.mergeListTileTheme(
                    child, listTileRenderData);
              }

              return Focus(
                focusNode: state.focusNode,
                child: child,
              );
            });

  @override
  _FormeListTileState<T> createState() => _FormeListTileState();
}

class _FormeListTileState<T>
    extends NonnullValueFieldState<List<T>, FormeListTileModel<T>>
    with FormeDecoratorState {
  bool allowSelectAll = false;

  @override
  FormeListTileModel<T> beforeUpdateModel(
      FormeListTileModel<T> old, FormeListTileModel<T> current) {
    if (current.items != null) {
      List<T> items = List.of(value);
      Iterable<T> datas = current.items!.map((e) => e.data);
      bool removed = false;
      items.removeWhere((element) {
        if (!datas.contains(element)) {
          removed = true;
          return true;
        }
        return false;
      });
      if (removed) setValue(items);
    }
    return current;
  }

  @override
  FormeListTileModel<T> beforeSetModel(
      FormeListTileModel<T> old, FormeListTileModel<T> current) {
    if (current.items == null) {
      return current.copyWith(FormeListTileModel<T>(items: old.items));
    }
    return current;
  }
}

class FormeListTileModel<T> extends FormeModel {
  final int? split;
  final List<FormeListTileItem<T>>? items;
  final FormeListTileRenderData? listTileRenderData;
  final FormeCheckboxRenderData? checkboxRenderData;
  final FormeRadioRenderData? radioRenderData;
  final FormeSwitchRenderData? switchRenderData;
  final FormeWrapRenderData? wrapRenderData;

  FormeListTileModel({
    this.split,
    this.items,
    this.listTileRenderData,
    this.checkboxRenderData,
    this.radioRenderData,
    this.switchRenderData,
    this.wrapRenderData,
  });
  FormeListTileModel<T> copyWith(FormeModel oldModel) {
    FormeListTileModel<T> old = oldModel as FormeListTileModel<T>;
    return FormeListTileModel<T>(
      split: split ?? old.split,
      items: items ?? old.items,
      listTileRenderData: FormeListTileRenderData.copy(
          old.listTileRenderData, listTileRenderData),
      checkboxRenderData: FormeCheckboxRenderData.copy(
          old.checkboxRenderData, checkboxRenderData),
      radioRenderData:
          FormeRadioRenderData.copy(old.radioRenderData, radioRenderData),
      switchRenderData:
          FormeSwitchRenderData.copy(old.switchRenderData, switchRenderData),
      wrapRenderData:
          FormeWrapRenderData.copy(old.wrapRenderData, wrapRenderData),
    );
  }
}
