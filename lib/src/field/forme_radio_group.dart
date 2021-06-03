import 'package:flutter/material.dart';
import '../render/forme_render_data.dart';
import '../forme_core.dart';

import '../forme_field.dart';
import '../forme_controller.dart';
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
            FormeValueFieldController<T, FormeRadioGroupModel<T>>>?
        validateErrorListener,
    FocusListener<FormeValueFieldController<T, FormeRadioGroupModel<T>>>?
        focusListener,
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

            T? getValue(List<T> list) => state.controller.convertValue(list);

            return FormeListTile<T>(
              type: FormeListTileType.Radio,
              model: state.controller.deconvertModel(state.widget.model),
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
                      onChanged(state.controller, getValue(o), getValue(c)),
              validateErrorListener: validateErrorListener == null
                  ? null
                  : (m, errorText) =>
                      validateErrorListener(state.controller, errorText),
              focusListener: focusListener == null
                  ? null
                  : (m, f) => focusListener(state.controller, f),
            );
          },
        );

  @override
  _FormeRadioGroupState<T> createState() => _FormeRadioGroupState();
}

class _FormeRadioGroupState<T>
    extends ValueFieldState<T, FormeRadioGroupModel<T>> {
  @override
  _ProxyController<T> get controller => super.controller as _ProxyController<T>;

  @override
  FormeValueFieldController<T, FormeRadioGroupModel<T>>
      createFormeFieldController() {
    return _ProxyController(super.createFormeFieldController());
  }
}

class _ProxyController<T> extends FormeProxyValueFieldControllerDelegate<
        T,
        FormeRadioGroupModel<T>,
        List<T>,
        FormeListTileModel<T>,
        FormeValueFieldController<List<T>, FormeListTileModel<T>>>
    implements FormeValueFieldController<T, FormeRadioGroupModel<T>> {
  _ProxyController(
      FormeValueFieldController<T, FormeRadioGroupModel<T>> delegate)
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
