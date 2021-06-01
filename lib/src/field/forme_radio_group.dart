import 'package:flutter/material.dart';
import '../render/forme_render_data.dart';
import '../forme_core.dart';

import '../forme_field.dart';
import '../forme_management.dart';
import '../forme_state_model.dart';
import 'forme_list_tile.dart';

class FormeRadioGroup<T> extends ValueField<T, FormeRadioGroupModel<T>> {
  FormeRadioGroup({
    required List<FormeListTileItem<T>> items,
    FormeFieldValueChanged<T, FormeRadioGroupModel<T>>? onChanged,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    FormFieldSetter<T>? onSaved,
    String? name,
    bool readOnly = false,
    FormeRadioGroupModel<T>? model,
    ValidateErrorListener<
            FormeValueFieldManagement<T, FormeRadioGroupModel<T>>>?
        validateErrorListener,
    FocusListener<FormeFieldManagement<FormeRadioGroupModel<T>>>? focusListener,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeRadioGroupModel<T>())
              .copyWith(FormeRadioGroupModel<T>(
            items: items,
          )),
          name: name,
          builder: (baseState) {
            _FormeRadioGroupState<T> state =
                baseState as _FormeRadioGroupState<T>;
            bool readOnly = state.readOnly;

            T? getValue(List<T> list) => state.management.convertValue(list);

            return FormeListTile<T>(
              type: FormeListTileType.Radio,
              model: state.management.deconvertModel(state.widget.model),
              onSaved: onSaved == null ? null : (v) => onSaved(getValue(v)),
              autovalidateMode: autovalidateMode,
              initialValue: initialValue == null ? null : [initialValue],
              validator:
                  validator == null ? null : (v) => validator(getValue(v)),
              items: items,
              readOnly: readOnly,
              onChanged: onChanged == null
                  ? null
                  : (m, o, c) =>
                      onChanged(state.management, getValue(o), getValue(c)),
              validateErrorListener: validateErrorListener == null
                  ? null
                  : (m, errorText) =>
                      validateErrorListener(state.management, errorText),
              focusListener: focusListener == null
                  ? null
                  : (m, f) => focusListener(state.management, f),
            );
          },
        );

  @override
  _FormeRadioGroupState<T> createState() => _FormeRadioGroupState();
}

class _FormeRadioGroupState<T>
    extends ValueFieldState<T, FormeRadioGroupModel<T>> {
  @override
  _ProxyManagement<T> get management => super.management as _ProxyManagement<T>;

  @override
  FormeValueFieldManagement<T, FormeRadioGroupModel<T>>
      createFormeFieldManagement() {
    return _ProxyManagement(super.createFormeFieldManagement());
  }
}

class _ProxyManagement<T> extends FormeProxyValueFieldManagementDelegate<
        T,
        FormeRadioGroupModel<T>,
        List<T>,
        FormeListTileModel<T>,
        FormeValueFieldManagement<List<T>, FormeListTileModel<T>>>
    implements FormeValueFieldManagement<T, FormeRadioGroupModel<T>> {
  _ProxyManagement(
      FormeValueFieldManagement<T, FormeRadioGroupModel<T>> delegate)
      : super(delegate);
  @override
  FormeRadioGroupModel<T> convertModel(FormeListTileModel<T> model) =>
      FormeRadioGroupModel<T>(
        items: model.items,
        radioRenderData: model.radioRenderData,
        wrapRenderData: model.wrapRenderData,
        split: model.split,
        listTileRenderData: model.listTileRenderData,
      );

  @override
  T? convertValue(List<T>? value) =>
      value == null || value.isEmpty ? null : value.first;

  @override
  FormeListTileModel<T> deconvertModel(FormeRadioGroupModel<T> model) =>
      FormeListTileModel<T>(
        items: model.items,
        wrapRenderData: model.wrapRenderData,
        radioRenderData: model.radioRenderData,
        listTileRenderData: model.listTileRenderData,
        split: model.split,
      );

  @override
  List<T>? deconvertValue(T? value) => value == null ? [] : [value];
}

class FormeRadioGroupModel<T> extends FormeModel {
  final int? split;
  final List<FormeListTileItem<T>>? items;
  final FormeListTileRenderData? listTileRenderData;
  final FormeRadioRenderData? radioRenderData;
  final FormeWrapRenderData? wrapRenderData;

  FormeRadioGroupModel({
    this.split,
    this.items,
    this.listTileRenderData,
    this.radioRenderData,
    this.wrapRenderData,
  });
  FormeRadioGroupModel<T> copyWith(FormeModel oldModel) {
    FormeRadioGroupModel<T> old = oldModel as FormeRadioGroupModel<T>;
    return FormeRadioGroupModel<T>(
      split: split ?? old.split,
      items: items ?? old.items,
      listTileRenderData: FormeListTileRenderData.copy(
          old.listTileRenderData, listTileRenderData),
      radioRenderData:
          FormeRadioRenderData.copy(old.radioRenderData, radioRenderData),
      wrapRenderData:
          FormeWrapRenderData.copy(old.wrapRenderData, wrapRenderData),
    );
  }
}
