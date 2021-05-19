import 'package:flutter/material.dart';
import '../render/theme_data.dart';
import '../render/form_render_utils.dart';

import '../form_field.dart';
import '../state_model.dart';
import 'decoration_field.dart';

class ListTileItem<T> {
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

  ListTileItem(
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

enum ListTileItemType { Checkbox, Switch, Radio }

class ListTileFormField<T>
    extends BaseNonnullValueField<List<T>, ListTileModel<T>> {
  ListTileFormField({
    required List<ListTileItem<T>> items,
    String? labelText,
    ValueChanged<List<T>>? onChanged,
    int split = 2,
    NonnullFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    List<T>? initialValue,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    ListTileItemType type = ListTileItemType.Checkbox,
    bool hasSelectAll = true,
    CheckboxRenderData? checkboxRenderData,
    RadioRenderData? radioRenderData,
    SwitchRenderData? switchRenderData,
    ListTileThemeData? listTileThemeData,
    WidgetWrapper? wrapper,
  }) : super(
            model: ListTileModel<T>(
              labelText: labelText,
              split: split,
              items: items,
              hasSelectAll: hasSelectAll,
              listTileThemeData: listTileThemeData,
              checkboxRenderData: checkboxRenderData,
              radioRenderData: radioRenderData,
              switchRenderData: switchRenderData,
            ),
            wrapper: wrapper,
            visible: visible,
            readOnly: readOnly,
            flex: flex,
            padding: padding,
            name: name,
            onChanged: onChanged,
            onSaved: onSaved,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue ?? [],
            validator: validator,
            builder: (state) {
              bool readOnly = state.readOnly;
              String? labelText = state.model.labelText;
              int split = state.model.split!;
              List<ListTileItem<T>> items = state.model.items!;
              bool hasSelectAll = state.model.hasSelectAll!;

              ListTileThemeData? listTileThemeData =
                  state.model.listTileThemeData;
              CheckboxRenderData? checkboxRenderData =
                  state.model.checkboxRenderData;
              RadioRenderData? radioRenderData = state.model.radioRenderData;
              SwitchRenderData? switchRenderData = state.model.switchRenderData;

              List<Widget> wrapWidgets = [];

              void changeValue(T value) {
                state.requestFocus();
                switch (type) {
                  case ListTileItemType.Checkbox:
                  case ListTileItemType.Switch:
                    List<T> values = List.of(state.value);
                    if (!values.remove(value)) {
                      values.add(value);
                    }
                    state.didChange(values);
                    break;
                  case ListTileItemType.Radio:
                    state.didChange([value]);
                    break;
                }
              }

              Widget createListTileItem(
                  ListTileItem item, bool selected, bool readOnly) {
                switch (type) {
                  case ListTileItemType.Radio:
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
                  case ListTileItemType.Checkbox:
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
                  case ListTileItemType.Switch:
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
                  ListTileItem item, bool selected, bool readOnly) {
                switch (type) {
                  case ListTileItemType.Checkbox:
                    return FormRenderUtils.checkbox(
                        selected,
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        checkboxRenderData);
                  case ListTileItemType.Switch:
                    return FormRenderUtils.adaptiveSwitch(
                        selected,
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        switchRenderData);
                  case ListTileItemType.Radio:
                    return FormRenderUtils.radio<T>(
                        item.data,
                        state.value.isEmpty ? null : state.value[0],
                        readOnly || item.readOnly
                            ? null
                            : (v) => changeValue(item.data),
                        radioRenderData);
                }
              }

              for (int i = 0; i < items.length; i++) {
                ListTileItem<T> item = items[i];
                bool isReadOnly = readOnly || item.readOnly;
                bool selected = state.value.contains(item.data);
                if (split > 0) {
                  double factor = 1 / split;
                  if (factor == 1) {
                    wrapWidgets
                        .add(createListTileItem(item, selected, isReadOnly));
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
                  type != ListTileItemType.Radio) {
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

              Widget child = Wrap(children: wrapWidgets);
              if (split == 1) {
                child = FormRenderUtils.mergeListTileTheme(
                    child, listTileThemeData);
              }

              return DecorationField(
                  labelText: labelText,
                  readOnly: readOnly || isAllReadOnly,
                  errorText: state.errorText,
                  child: child,
                  focusNode: state.focusNode,
                  icon: icon);
            });

  @override
  _ListTileFormFieldState<T> createState() => _ListTileFormFieldState();
}

class _ListTileFormFieldState<T>
    extends BaseNonnullValueFieldState<List<T>, ListTileModel<T>> {
  @override
  void beforeMerge(ListTileModel<T> old, ListTileModel<T> current) {
    if (current.items != null) {
      List<T> items = List.of(value);
      Iterable<T> datas = current.items!.map((e) => e.data);
      items.removeWhere((element) => !datas.contains(element));
      setValue(items);
    }
  }
}

class ListTileModel<T> extends AbstractFieldStateModel {
  final String? labelText;
  final int? split;
  final List<ListTileItem<T>>? items;
  final bool? hasSelectAll;
  final ListTileThemeData? listTileThemeData;
  final CheckboxRenderData? checkboxRenderData;
  final RadioRenderData? radioRenderData;
  final SwitchRenderData? switchRenderData;
  ListTileModel(
      {this.labelText,
      this.split,
      this.items,
      this.hasSelectAll,
      this.listTileThemeData,
      this.checkboxRenderData,
      this.radioRenderData,
      this.switchRenderData});

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    ListTileModel<T> oldModel = old as ListTileModel<T>;
    return ListTileModel<T>(
      labelText: labelText ?? oldModel.labelText,
      split: split ?? oldModel.split,
      items: items ?? oldModel.items,
      hasSelectAll: hasSelectAll ?? oldModel.hasSelectAll,
      listTileThemeData: listTileThemeData ?? oldModel.listTileThemeData,
      checkboxRenderData: checkboxRenderData ?? oldModel.checkboxRenderData,
      radioRenderData: radioRenderData ?? oldModel.radioRenderData,
      switchRenderData: switchRenderData ?? oldModel.switchRenderData,
    );
  }
}
