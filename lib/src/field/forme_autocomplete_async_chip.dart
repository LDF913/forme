import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'raw_autocomplete_async.dart';

class FormeAsnycAutocompleteChip<T extends Object>
    extends ValueField<List<T>, FormeAsyncAutocompleteChipModel<T>> {
  FormeAsnycAutocompleteChip({
    required String name,
    required AutocompleteAsyncOptionsBuilder<T> optionsBuilder,
    FormeAsyncAutocompleteChipModel<T>? model,
    FormeValueChanged<List<T>, FormeAsyncAutocompleteChipModel<T>>?
        onValueChanged,
    FormFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    List<T>? initialValue,
    FormFieldSetter<List<T>>? onSaved,
    bool readOnly = false,
    FormeErrorChanged<
            FormeValueFieldController<List<T>,
                FormeAsyncAutocompleteChipModel<T>>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<List<T>,
                FormeAsyncAutocompleteChipModel<T>>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<List<T>,
                FormeAsyncAutocompleteChipModel<T>>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<List<T>>? decoratorBuilder,
    InputDecoration? decoration,
  }) : super(
          nullValueReplacement: [],
          onInitialed: onInitialed,
          decoratorBuilder: decoratorBuilder,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          key: key,
          readOnly: readOnly,
          name: name,
          onValueChanged: onValueChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          model: (model ?? FormeAsyncAutocompleteChipModel())
              .copyWith(FormeAsyncAutocompleteChipModel(
                  optionsBuilder: optionsBuilder,
                  textFieldModel: FormeTextFieldModel(
                    decoration: decoration,
                    maxLines: 1,
                  ))),
          builder: (baseState) {
            _FormeAutocompleteTextState<T> state =
                baseState as _FormeAutocompleteTextState<T>;
            FormeAsyncAutocompleteChipModel<T> model =
                FormeAsyncAutocompleteChipModel<T>(
                        textFieldModel: FormeTextFieldModel(
                            decoration:
                                InputDecoration(errorText: state.errorText)))
                    .copyWith(state.model);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormeRawAutoComplete<T>(
                  model: model,
                  readOnly: readOnly,
                  controller: state,
                ),
                FormeRenderUtils.wrap(
                    state.model.wrapRenderData,
                    state.value!
                        .map((e) => (state.model.chipBuilder ??
                                state.defaultChipBuilder)(state.context, e, () {
                              state.didChange(List.of(state.value!)..remove(e));
                              state.unfocus();
                            }))
                        .toList()),
              ],
            );
          },
        );

  @override
  _FormeAutocompleteTextState<T> createState() => _FormeAutocompleteTextState();
}

class _FormeAutocompleteTextState<T extends Object>
    extends ValueFieldState<List<T>, FormeAsyncAutocompleteChipModel<T>>
    with RawAutocompleteController<T> {
  Widget defaultChipBuilder(
      BuildContext context, T value, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InputChip(
        label: Text(model.displayStringForOption == null
            ? value.toString()
            : model.displayStringForOption!(value)),
        isEnabled: true,
        onDeleted: onDeleted,
      ),
    );
  }

  @override
  FormeAsyncAutocompleteChipModel<T> beforeSetModel(
      FormeAsyncAutocompleteChipModel<T> old,
      FormeAsyncAutocompleteChipModel<T> current) {
    if (current.optionsBuilder == null)
      current = current.copyWith(FormeAsyncAutocompleteChipModel<T>(
          optionsBuilder: old.optionsBuilder));
    return current;
  }

  @override
  void afterUpdateModel(FormeAsyncAutocompleteChipModel<T> old,
      FormeAsyncAutocompleteChipModel<T> current) {
    rebuild(model);
    if (current.optionsBuilder != null) loadOptions();
  }

  @override
  FormeValueFieldController<List<T>, FormeAsyncAutocompleteChipModel<T>>
      createFormeFieldController() {
    return _FormeValueFieldController(super.createFormeFieldController(), this);
  }

  void clearValue() {
    selection = null;
    didChange(null);
  }

  @override
  void afterFocusChanged(bool hasFocus) {
    if (widget.onFocusChanged != null)
      widget.onFocusChanged!(controller, hasFocus);
  }

  @override
  void onSelected(T value) {
    List<T> values = List.of(this.value!);
    if (values.contains(value))
      didChange(values..remove(value));
    else
      didChange(values..add(value));
    rebuildOptionsView();
  }

  @override
  bool isSelected(T option) {
    return value!.contains(option);
  }
}

class FormeAsyncAutocompleteChipModel<T extends Object>
    extends FormeAsyncAutocompleteTextModel<T> {
  final Widget Function(BuildContext context, T value, VoidCallback onDeleted)?
      chipBuilder;
  final FormeWrapRenderData? wrapRenderData;
  const FormeAsyncAutocompleteChipModel({
    AutocompleteOptionToString<T>? displayStringForOption,
    AutocompleteAsyncOptionsBuilder<T>? optionsBuilder,
    FormeTextFieldModel? textFieldModel,
    WidgetBuilder? loadingOptionBuilder,
    WidgetBuilder? emptyOptionBuilder,
    AutocompleteOptionsViewBuilder<T>? optionsViewBuilder,
    double? optionsViewHeight,
    Duration? loadOptionsTimerDuration,
    AutocompleteOptionsViewDecoratorBuilder? optionsViewDecoratorBuilder,
    bool? queryWhenEmpty,
    Widget Function(BuildContext context, dynamic error)? errorBuilder,
    Widget Function(BuildContext context, T option, bool isSelected)?
        optionBuilder,
    this.chipBuilder,
    this.wrapRenderData,
  }) : super(
          displayStringForOption: displayStringForOption,
          optionsBuilder: optionsBuilder,
          optionsViewBuilder: optionsViewBuilder,
          optionsViewDecoratorBuilder: optionsViewDecoratorBuilder,
          optionsViewHeight: optionsViewHeight,
          loadOptionsTimerDuration: loadOptionsTimerDuration,
          emptyOptionBuilder: emptyOptionBuilder,
          loadingOptionBuilder: loadingOptionBuilder,
          errorBuilder: errorBuilder,
          textFieldModel: textFieldModel,
          queryWhenEmpty: queryWhenEmpty,
          optionBuilder: optionBuilder,
        );

  @override
  FormeAsyncAutocompleteChipModel<T> copyWith(FormeModel oldModel) {
    FormeAsyncAutocompleteChipModel<T> old =
        oldModel as FormeAsyncAutocompleteChipModel<T>;
    return FormeAsyncAutocompleteChipModel<T>(
      optionsBuilder: optionsBuilder ?? old.optionsBuilder,
      displayStringForOption:
          displayStringForOption ?? old.displayStringForOption,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
      loadingOptionBuilder: loadingOptionBuilder ?? old.loadingOptionBuilder,
      emptyOptionBuilder: emptyOptionBuilder ?? old.emptyOptionBuilder,
      optionsViewBuilder: optionsViewBuilder ?? old.optionsViewBuilder,
      optionsViewHeight: optionsViewHeight ?? old.optionsViewHeight,
      loadOptionsTimerDuration:
          loadOptionsTimerDuration ?? old.loadOptionsTimerDuration,
      optionsViewDecoratorBuilder:
          optionsViewDecoratorBuilder ?? old.optionsViewDecoratorBuilder,
      queryWhenEmpty: queryWhenEmpty ?? old.queryWhenEmpty,
      errorBuilder: errorBuilder ?? old.errorBuilder,
      chipBuilder: chipBuilder ?? old.chipBuilder,
      optionBuilder: optionBuilder ?? old.optionBuilder,
      wrapRenderData: wrapRenderData ?? old.wrapRenderData,
    );
  }
}

class _FormeValueFieldController<T extends Object>
    extends FormeValueFieldControllerDelegate<List<T>,
        FormeAsyncAutocompleteChipModel<T>> {
  final _FormeAutocompleteTextState state;
  final FormeValueFieldController<List<T>, FormeAsyncAutocompleteChipModel<T>>
      delegate;
  _FormeValueFieldController(this.delegate, this.state);

  @override
  bool get hasFocus => state.hasFocus;

  @override
  void clearValue() {
    state.clearValue();
  }
}
