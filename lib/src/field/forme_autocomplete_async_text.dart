import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

typedef AutocompleteAsyncOptionsBuilder<T extends Object> = Future<Iterable<T>>
    Function(TextEditingValue textEditingValue);

typedef AutocompleteOptionsViewDecoratorBuilder = Widget Function(
    BuildContext context, Widget child, GlobalKey key, double? width);

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
          model: (model ?? FormeAsyncAutocompleteTextModel()).copyWith(
              FormeAsyncAutocompleteTextModel(optionsBuilder: optionsBuilder)),
          builder: (baseState) {
            _FormeAutocompleteTextState<T> state =
                baseState as _FormeAutocompleteTextState<T>;
            return Autocomplete<T>(
              optionsBuilder: readOnly
                  ? (v) => Iterable<T>.empty()
                  : (v) => _Iterable<T>(state),
              onSelected: readOnly
                  ? null
                  : (T value) {
                      state.didChange(value);
                      state.requestFocus();
                    },
              displayStringForOption: state.displayStringForOption,
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                state.effecitiveTextEditingController = textEditingController;
                state.effecitiveFocusNode = focusNode;
                return OrientationBuilder(builder: (context, o) {
                  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                    state.fieldViewWidgetNotifier.value =
                        (context.findRenderObject() as RenderBox).size.width;
                  });
                  return FormeTextFieldWidget(
                      textEditingController: textEditingController,
                      focusNode: focusNode,
                      errorText: state.errorText,
                      model: FormeTextFieldModel(
                        onChanged: (v) {
                          state.updateOptions();
                          state.timer?.cancel();
                          if (state.queryWhenEmpty || v != '') {
                            state.timer = Timer(
                                state.model.loadOptionsTimerDuration ??
                                    const Duration(milliseconds: 500),
                                () => state.loadOptions());
                          }
                          if (state.model.textFieldModel?.onChanged != null)
                            state.model.textFieldModel!.onChanged!(v);
                        },
                        onSubmitted: state.readOnly
                            ? null
                            : (v) {
                                if (state.model.textFieldModel?.onSubmitted !=
                                    null)
                                  state.model.textFieldModel!.onSubmitted!(v);
                              },
                        readOnly: state.readOnly,
                      ).copyWith(
                          state.model.textFieldModel ?? FormeTextFieldModel()));
                });
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<T> onSelected,
                Iterable<T> options,
              ) {
                if (state.value != null && state.optionsNotifier.value == 0)
                  return const SizedBox();
                if (state._effecitiveTextEditingController!.text == '' &&
                    !state.queryWhenEmpty) return const SizedBox();
                Widget loading = state.model.loadingOptionBuilder == null
                    ? state.defaultLoadingOptionBuilder(context)
                    : state.model.loadingOptionBuilder!(context);
                Widget child = ValueListenableBuilder<int>(
                    child: loading,
                    valueListenable: state.optionsNotifier,
                    builder: (context, data, child) {
                      if (state.options == null || state.options!.gen < data)
                        return child!;
                      if (state.options!.gen == data) {
                        if (state.options!.hasError)
                          return (state.model.errorBuilder ??
                                  state.defaultErrorBuilder)(
                              context, state.options!.error);
                        else {
                          if (state.options!.datas!.isEmpty)
                            return (state.model.emptyOptionBuilder ??
                                state.defaultEmptyOptionBuilder)(context);
                          return (state.model.optionsViewBuilder ??
                                  state.defaultOptionsViewBuilder)(
                              context, onSelected, state.options!.datas!);
                        }
                      }
                      return const SizedBox();
                    });
                return ValueListenableBuilder2<double?, int>(
                    state.fieldViewWidgetNotifier,
                    state.optionsViewRebuildNotifier,
                    builder: (context, width, gen, _child) {
                  return (state.model.optionsViewDecoratorBuilder ??
                          state.defaultOptionsViewDecoratorBuilder)(
                      context, child, state._key, width);
                });
              },
            );
          },
        );

  @override
  _FormeAutocompleteTextState<T> createState() => _FormeAutocompleteTextState();
}

class _FormeAutocompleteTextState<T extends Object>
    extends ValueFieldState<T, FormeAsyncAutocompleteTextModel<T>> {
  TextEditingController? _effecitiveTextEditingController;
  FocusNode? _effecitiveFocusNode;

  AutocompleteOptionToString<T> get displayStringForOption =>
      model.displayStringForOption ?? RawAutocomplete.defaultStringForOption;
  Timer? timer;

  late final FormeMountedValueNotifier<int> optionsNotifier =
      FormeMountedValueNotifier(0, this);

  late final FormeMountedValueNotifier<double?> fieldViewWidgetNotifier =
      FormeMountedValueNotifier(null, this);

  late final FormeMountedValueNotifier<int> optionsViewRebuildNotifier =
      FormeMountedValueNotifier(0, this);

  final _key = GlobalKey();

  bool get queryWhenEmpty => model.queryWhenEmpty ?? false;

  void rebuildOptionsView() {
    optionsViewRebuildNotifier.value = optionsViewRebuildNotifier.value + 1;
  }

  void updateOptions() {
    optionsNotifier.value = optionsNotifier.value + 1;
  }

  Widget defaultErrorBuilder(BuildContext context, dynamic error) {
    return const SizedBox();
  }

  Widget defaultOptionsViewDecoratorBuilder(
      BuildContext context, Widget child, GlobalKey key, double? width) {
    return Align(
      key: key,
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: SizedBox(
          child: child,
          width: width,
        ),
      ),
    );
  }

  Widget defaultLoadingOptionBuilder(BuildContext context) {
    return Container(
      height: model.optionsViewHeight ?? 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget defaultEmptyOptionBuilder(BuildContext context) {
    return const SizedBox();
  }

  Widget defaultOptionsViewBuilder(
    BuildContext context,
    AutocompleteOnSelected<T> onSelected,
    Iterable<T> options,
  ) {
    return SizedBox(
      height: model.optionsViewHeight ?? 200,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) {
          final T option = options.elementAt(index);
          return InkWell(
            onTap: () {
              onSelected(option);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(displayStringForOption(option)),
            ),
          );
        },
      ),
    );
  }

  set effecitiveTextEditingController(TextEditingController controller) {
    _effecitiveTextEditingController = controller;
  }

  set effecitiveFocusNode(FocusNode focusNode) {
    if (_effecitiveFocusNode != focusNode) {
      _effecitiveFocusNode = focusNode;
      _effecitiveFocusNode!.addListener(() {
        if (_effecitiveFocusNode!.hasFocus) {
          String text = _effecitiveTextEditingController!.text;
          if (text == '' && !queryWhenEmpty) return;
          if (value == null)
            loadOptions();
          else if (displayStringForOption(value!) != text) loadOptions();
        }
        if (widget.onFocusChanged != null) {
          if (widget.onFocusChanged != null)
            widget.onFocusChanged!(controller, _effecitiveFocusNode!.hasFocus);
        }
      });
    }
  }

  @override
  void requestFocus() {
    _effecitiveFocusNode?.requestFocus();
  }

  @override
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    _effecitiveFocusNode?.unfocus(disposition: disposition);
  }

  @override
  void afterInitiation() {
    super.afterInitiation();
    if (initialValue != null)
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _effecitiveTextEditingController?.text =
            displayStringForOption(initialValue!);
      });
  }

  @override
  void didChange(T? newValue) {
    super.didChange(newValue);
    if (value == null && newValue == null) onValueChanged(null);
  }

  @override
  void onValueChanged(T? value) {
    String? text;
    if (value == null) {
      text = '';
    } else {
      text = displayStringForOption(value);
    }
    if (_effecitiveTextEditingController?.text != text) {
      _effecitiveTextEditingController?.text = text;
    }
    if (value == null) {
      timer?.cancel();
      if (queryWhenEmpty) loadOptions();
    }
  }

  _Options<T>? options;

  void loadOptions() {
    updateOptions();
    int gen = optionsNotifier.value + 1;
    model.optionsBuilder!(_effecitiveTextEditingController!.value)
        .then((value) {
      options = _Options(hasError: false, gen: gen, datas: value);
    }).catchError((e) {
      options = _Options(hasError: true, error: e, gen: gen);
    }).whenComplete(() {
      if (gen == optionsNotifier.value + 1) updateOptions();
    });
  }

  @override
  void dispose() {
    optionsNotifier.dispose();
    fieldViewWidgetNotifier.dispose();
    optionsViewRebuildNotifier.dispose();
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    _effecitiveTextEditingController?.text = '';
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
  void afterUpdateModel(
      FormeAsyncAutocompleteTextModel<T> model,
      FormeAsyncAutocompleteTextModel<T> old,
      FormeAsyncAutocompleteTextModel<T> current) {
    if ((current.optionsViewHeight != old.optionsViewHeight &&
            current.optionsViewHeight != null) ||
        current.loadingOptionBuilder != null ||
        current.emptyOptionBuilder != null ||
        current.optionsViewBuilder != null ||
        current.optionsViewDecoratorBuilder != null ||
        current.displayStringForOption != null) {
      rebuildOptionsView();
    }
    if (current.displayStringForOption != null && value != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        String selectionString = current.displayStringForOption!(value!);
        _effecitiveTextEditingController?.value = TextEditingValue(
          selection: TextSelection.collapsed(offset: selectionString.length),
          text: selectionString,
        );
      });
    }

    if (current.optionsBuilder != null) {
      if (_effecitiveTextEditingController!.text == '' && !queryWhenEmpty)
        return;
      loadOptions();
    }
  }

  bool get isLatestOption =>
      options != null && options!.gen == optionsNotifier.value;
}

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
    );
  }
}

class _Options<T> {
  final Iterable<T>? datas;
  final dynamic error;
  final bool hasError;
  final int gen;

  const _Options({
    this.datas,
    this.error,
    required this.hasError,
    required this.gen,
  });
}

class _Iterable<T extends Object> extends Iterable<T> {
  final _FormeAutocompleteTextState<T> state;

  _Iterable(this.state);
  @override
  Iterator<T> get iterator {
    if (state.isLatestOption && state.options!.datas != null)
      return state.options!.datas!.iterator;
    throw UnimplementedError();
  }

  bool get isEmpty => false;
  bool get isNotEmpty => !isEmpty;
}
