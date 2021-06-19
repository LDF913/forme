import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'package:forme/src/field/raw_autocomplete_async.dart';

class FormeAsnycAutocompleteText<T extends Object>
    extends ValueField<T, FormeAsyncAutocompleteTextModel<T>> {
  FormeAsnycAutocompleteText({
    required String name,
    required AutocompleteAsyncOptionsBuilder<T> optionsBuilder,
    FormeAsyncAutocompleteTextModel<T>? model,
    FormeValueChanged<T, FormeAsyncAutocompleteTextModel<T>>? onValueChanged,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    FormFieldSetter<T>? onSaved,
    bool readOnly = false,
    FormeErrorChanged<
            FormeValueFieldController<T, FormeAsyncAutocompleteTextModel<T>>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<T, FormeAsyncAutocompleteTextModel<T>>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<T, FormeAsyncAutocompleteTextModel<T>>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<T>? decoratorBuilder,
    InputDecoration? decoration,
    int? maxLines = 1,
  }) : super(
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
          model: (model ?? FormeAsyncAutocompleteTextModel())
              .copyWith(FormeAsyncAutocompleteTextModel(
            optionsBuilder: optionsBuilder,
            textFieldModel: FormeTextFieldModel(
              decoration: decoration,
              maxLines: maxLines,
            ),
          )),
          builder: (baseState) {
            _FormeAutocompleteTextState<T> state =
                baseState as _FormeAutocompleteTextState<T>;
            FormeAsyncAutocompleteTextModel<T> model =
                FormeAsyncAutocompleteTextModel<T>(
                        textFieldModel: FormeTextFieldModel(
                            decoration:
                                InputDecoration(errorText: state.errorText)))
                    .copyWith(state.model);
            return FormeRawAutoComplete<T>(
              model: model,
              readOnly: readOnly,
              controller: state,
            );
          },
        );

  @override
  _FormeAutocompleteTextState<T> createState() => _FormeAutocompleteTextState();
}

class _FormeAutocompleteTextState<T extends Object>
    extends ValueFieldState<T, FormeAsyncAutocompleteTextModel<T>>
    with RawAutocompleteController<T> {
  @override
  FormeValueFieldController<T, FormeAsyncAutocompleteTextModel<T>>
      createFormeFieldController() {
    return _FormeValueFieldController(super.createFormeFieldController(), this);
  }

  void clearValue() {
    selection = null;
    didChange(null);
  }

  @override
  void onSelected(T value) {
    selection = value;
    didChange(value);
  }

  @override
  void afterFocusChanged(bool hasFocus) {
    if (widget.onFocusChanged != null)
      widget.onFocusChanged!(controller, hasFocus);
  }

  @override
  void afterInitiation() {
    super.afterInitiation();
    if (initialValue != null)
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        selection = initialValue;
      });
  }

  @override
  FormeAsyncAutocompleteTextModel<T> beforeSetModel(
      FormeAsyncAutocompleteTextModel<T> old,
      FormeAsyncAutocompleteTextModel<T> current) {
    if (current.optionsBuilder == null)
      current = current.copyWith(FormeAsyncAutocompleteTextModel<T>(
          optionsBuilder: old.optionsBuilder));
    return current;
  }

  @override
  void afterUpdateModel(FormeAsyncAutocompleteTextModel<T> old,
      FormeAsyncAutocompleteTextModel<T> current) {
    rebuild(model);
    if (current.displayStringForOption != null && value != null) {
      updateDisplay(value);
    }
    if (current.optionsBuilder != null) loadOptions();
  }

  @override
  bool isSelected(T option) {
    return value == option;
  }
}

///
/// **the context provided by builders can not used to get `FormeValueFieldController` ,
/// when you want to access `FormeValueField Controller`,
/// you can use `formeKey.valueField(String name)`**
class FormeAsyncAutocompleteTextModel<T extends Object> extends FormeModel {
  final AutocompleteOptionToString<T>? displayStringForOption;
  final AutocompleteAsyncOptionsBuilder<T>? optionsBuilder;
  final FormeTextFieldModel? textFieldModel;
  final WidgetBuilder? loadingOptionBuilder;
  final WidgetBuilder? emptyOptionBuilder;
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;
  final double? optionsViewHeight;
  final Duration? loadOptionsTimerDuration;
  final AutocompleteOptionsViewDecoratorBuilder? optionsViewDecoratorBuilder;
  final bool? queryWhenEmpty;
  final Widget Function(BuildContext context, dynamic error)? errorBuilder;
  final Widget Function(BuildContext context, T option, bool isSelected)?
      optionBuilder;
  const FormeAsyncAutocompleteTextModel({
    this.optionsBuilder,
    this.displayStringForOption,
    this.textFieldModel,
    this.loadingOptionBuilder,
    this.emptyOptionBuilder,
    this.optionsViewBuilder,
    this.optionsViewHeight,
    this.loadOptionsTimerDuration,
    this.optionsViewDecoratorBuilder,
    this.queryWhenEmpty,
    this.errorBuilder,
    this.optionBuilder,
  });

  @override
  FormeAsyncAutocompleteTextModel<T> copyWith(FormeModel oldModel) {
    FormeAsyncAutocompleteTextModel<T> old =
        oldModel as FormeAsyncAutocompleteTextModel<T>;
    return FormeAsyncAutocompleteTextModel<T>(
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
      optionBuilder: optionBuilder ?? old.optionBuilder,
    );
  }
}

class _FormeValueFieldController<T extends Object>
    extends FormeValueFieldControllerDelegate<T,
        FormeAsyncAutocompleteTextModel<T>> {
  final _FormeAutocompleteTextState state;
  final FormeValueFieldController<T, FormeAsyncAutocompleteTextModel<T>>
      delegate;
  _FormeValueFieldController(this.delegate, this.state);

  @override
  bool get hasFocus => state.hasFocus;

  @override
  void clearValue() {
    state.clearValue();
  }
}
