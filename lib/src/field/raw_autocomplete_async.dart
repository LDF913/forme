import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'package:forme/src/widget/forme_mounted_value_notifier.dart';
import 'package:forme/src/widget/widgets.dart';

import 'forme_autocomplete_async_text.dart';
import 'forme_text_field.dart';

typedef AutocompleteAsyncOptionsBuilder<T extends Object> = Future<Iterable<T>>
    Function(TextEditingValue textEditingValue);

typedef AutocompleteOptionsViewDecoratorBuilder = Widget Function(
    BuildContext context,
    Widget child,
    double? width,
    VoidCallback closeOptionsView);

class FormeRawAutoComplete<T extends Object> extends StatefulWidget {
  final FormeAsyncAutocompleteTextModel<T> model;
  final RawAutocompleteController<T> controller;
  final Widget Function(BuildContext context, Widget textField)?
      fieldViewBuilder;
  final bool readOnly;

  FormeRawAutoComplete({
    Key? key,
    required this.model,
    this.fieldViewBuilder,
    required this.controller,
    required this.readOnly,
  }) : super(key: key);

  @override
  _FormeRowAutoCompleteState<T> createState() => _FormeRowAutoCompleteState();
}

class _FormeRowAutoCompleteState<T extends Object>
    extends State<FormeRawAutoComplete<T>> {
  TextEditingController? _effecitiveTextEditingController;
  FocusNode? _effecitiveFocusNode;

  FormeAsyncAutocompleteTextModel<T>? _model;

  FormeAsyncAutocompleteTextModel<T> get model => _model ?? widget.model;

  set model(FormeAsyncAutocompleteTextModel<T> model) {
    _model = model;
    rebuildOptionsView();
  }

  AutocompleteOptionToString<T> get displayStringForOption =>
      model.displayStringForOption ?? RawAutocomplete.defaultStringForOption;
  Timer? timer;

  late final FormeMountedValueNotifier<int> optionsNotifier =
      FormeMountedValueNotifier(0, this);
  late final FormeMountedValueNotifier<double?> fieldViewWidgetNotifier =
      FormeMountedValueNotifier(null, this);
  late final FormeMountedValueNotifier<int> optionsViewRebuildNotifier =
      FormeMountedValueNotifier(0, this);

  AutocompleteOnSelected<T>? _onSelected;

  set onSelected(AutocompleteOnSelected<T>? onSelected) {
    if (_onSelected != null) return;
    _onSelected = onSelected;
    if (_selection != null)
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _onSelected!(_selection!);
      });
    else {
      loadOptions();
    }
  }

  final _key = GlobalKey();

  _Options<T>? options;

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

  Widget defaultOptionsViewDecoratorBuilder(BuildContext context, Widget child,
      double? width, VoidCallback closeOptionsView) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: child),
              IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    unfocus();
                  }),
            ],
          ),
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
          bool isSelected = widget.controller.isSelected(option);
          ThemeData themeData = Theme.of(context);
          return InkWell(
            onTap: () {
              onSelected(option);
            },
            child: model.optionBuilder == null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      displayStringForOption(option),
                      style: TextStyle(
                          color: isSelected ? themeData.disabledColor : null),
                    ),
                  )
                : model.optionBuilder!(context, option, isSelected),
          );
        },
      ),
    );
  }

  Widget defaultChipBuilder(
      BuildContext context, T value, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InputChip(
        label: Text(displayStringForOption(value)),
        isEnabled: true,
        onDeleted: onDeleted,
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
        if (hasFocus) {
          loadOptions();
        }
        widget.controller.afterFocusChanged(_effecitiveFocusNode!.hasFocus);
      });
    }
  }

  void requestFocus() {
    _effecitiveFocusNode?.requestFocus();
  }

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    _effecitiveFocusNode?.unfocus(disposition: disposition);
  }

  void loadOptions() {
    if (!queryWhenEmpty && _effecitiveTextEditingController!.text == '') return;
    updateOptions();
    int gen = optionsNotifier.value + 1;
    model.optionsBuilder!(_effecitiveTextEditingController!.value)
        .then((value) {
      options = _Options(hasError: false, gen: gen, datas: value);
    }).catchError((e) {
      options = _Options(hasError: true, error: e, gen: gen);
    }).whenComplete(() {
      if (gen == optionsNotifier.value + 1 && mounted) updateOptions();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }

  T? _selection;

  set selection(T? value) {
    String text = value == null ? '' : displayStringForOption(value);
    if (_effecitiveTextEditingController?.text != text)
      _effecitiveTextEditingController?.text = text;
    _selection = value;
    if (_onSelected != null && value != null) _onSelected!(value);
    if (value == null) loadOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: widget.readOnly
          ? (v) => Iterable<T>.empty()
          : (v) => _Iterable<T>(this),
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        effecitiveTextEditingController = textEditingController;
        effecitiveFocusNode = focusNode;
        return OrientationBuilder(builder: (context, o) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            fieldViewWidgetNotifier.value =
                (context.findRenderObject() as RenderBox).size.width;
          });
          FormeTextFieldWidget textFieldWidget = FormeTextFieldWidget(
              textEditingController: textEditingController,
              focusNode: focusNode,
              model: FormeTextFieldModel(
                onChanged: (v) {
                  updateOptions();
                  timer?.cancel();
                  if (queryWhenEmpty || v != '') {
                    timer = Timer(
                        model.loadOptionsTimerDuration ??
                            const Duration(milliseconds: 500),
                        () => loadOptions());
                  }
                  if (model.textFieldModel?.onChanged != null)
                    model.textFieldModel!.onChanged!(v);
                },
                onSubmitted: widget.readOnly
                    ? null
                    : (v) {
                        if (model.textFieldModel?.onSubmitted != null)
                          model.textFieldModel!.onSubmitted!(v);
                      },
                readOnly: widget.readOnly,
              ).copyWith(model.textFieldModel ?? FormeTextFieldModel()));

          if (widget.fieldViewBuilder != null)
            return widget.fieldViewBuilder!(context, textFieldWidget);
          return textFieldWidget;
        });
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<T> onSelected,
        Iterable<T> _options,
      ) {
        return ValueListenableBuilder3<double?, int, int>(
            fieldViewWidgetNotifier,
            optionsViewRebuildNotifier,
            optionsNotifier,
            key: _key, builder: (context, width, gen, gen2, _child) {
          if (this._onSelected == null) {
            this.onSelected = onSelected;
            return const SizedBox();
          }
          if (_effecitiveTextEditingController!.text == '' && !queryWhenEmpty)
            return const SizedBox();

          Widget child;
          if (options == null || options!.gen < gen2)
            child = model.loadingOptionBuilder == null
                ? defaultLoadingOptionBuilder(context)
                : model.loadingOptionBuilder!(context);
          else {
            if (isLatestOption) {
              if (options!.hasError)
                child = (model.errorBuilder ?? defaultErrorBuilder)(
                    context, options!.error);
              else {
                Iterable<T> datas = options!.datas!;
                if (datas.isEmpty)
                  child = (model.emptyOptionBuilder ??
                      defaultEmptyOptionBuilder)(context);
                else {
                  child =
                      (model.optionsViewBuilder ?? defaultOptionsViewBuilder)(
                          context, widget.controller.onSelected, datas);
                }
              }
            } else
              throw 'current options\'s gen is bigger than notify\'s,this should not happened!!';
          }

          return (model.optionsViewDecoratorBuilder ??
                  defaultOptionsViewDecoratorBuilder)(
              context, child, width, unfocus);
        });
      },
    );
  }

  bool get isLatestOption =>
      options != null && options!.gen == optionsNotifier.value;

  @override
  void dispose() {
    optionsNotifier.dispose();
    fieldViewWidgetNotifier.dispose();
    optionsViewRebuildNotifier.dispose();
    super.dispose();
  }

  bool get hasFocus => _effecitiveFocusNode?.hasFocus ?? false;
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
  final _FormeRowAutoCompleteState<T> state;

  _Iterable(this.state);

  @override
  Iterator<T> get iterator => throw UnimplementedError();

  bool get isEmpty => false;
  bool get isNotEmpty => !isEmpty;
}

abstract class RawAutocompleteController<T extends Object> {
  late final _FormeRowAutoCompleteState<T> _state;
  void afterFocusChanged(bool hasFocus);

  void onSelected(T value);

  void closeOptionsView() {
    _state.unfocus();
  }

  void requestFocus() {
    _state.requestFocus();
  }

  void unfocus({
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) {
    _state._effecitiveFocusNode?.unfocus(disposition: disposition);
  }

  set selection(T? value) => _state.selection = value;

  rebuildOptionsView() {
    _state.rebuildOptionsView();
  }

  updateDisplay(T? value) {
    _state._effecitiveTextEditingController?.text =
        value == null ? '' : _state.displayStringForOption(value);
    _state.rebuildOptionsView();
  }

  loadOptions() {
    _state.loadOptions();
  }

  void rebuild(FormeAsyncAutocompleteTextModel<T> model) {
    _state.model = model;
  }

  bool get hasFocus => _state.hasFocus;

  bool isSelected(T option);
}
