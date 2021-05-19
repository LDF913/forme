import 'package:flutter/material.dart';
import '../management.dart';
import '../render/theme_data.dart';
import '../render/form_render_utils.dart';

import '../builder.dart';
import '../state_model.dart';
import '../form_field.dart';

/// used to render select list
///
/// [item] current item data
///
/// [multiSelect] whether mulitSelect or not
///
/// [isSelected] whether is selected or not
///
/// [themeData] current theme data
///
/// [select] a function used to select this item , select is null if selector is readOnly
///
/// **since the items was wrapped by ListTileTheme ,
///  so better to return a widget contain CheckboxListTile or RadioListTile**
///
/// **default used item.toString() as label text**
typedef SelectItemRender<T> = Widget Function(T item, bool multiSelect,
    bool isSelected, ThemeData themeData, VoidCallback? select);

/// used to render selected item
///
/// [item] selected item data from SelectItemProvider
///
/// [multiSelect] whether multiSelect or not
///
/// [readOnly] whether item should be readOnly
///
/// [themeData] current theme data
///
/// [remove] a function used to remove this widget, when mutilSelect or readOnly this parameter is null!
///
/// **since selected items wrapped by ChipTheme ,so better to return a widget contain Chip**
///
/// **default used item.toString() as label text**
typedef SelectedItemRender<T> = Widget Function(T item, bool multiSelect,
    bool readOnly, ThemeData themeData, VoidCallback? remove);

/// used to sort selected items
typedef SelectedSorter<T> = void Function(List<T> selected);

/// used to provider select items
///
/// [page] target page
///
/// [params] query params get from query form builder
typedef SelectItemProvider<T> = Future<SelectItemPage<T>> Function(
    int page, Map<String, dynamic> params);

/// used to build a query form
///
/// [builder] form builder
///
/// [submit] an function used to submit query
typedef QueryFormBuilder = Widget Function(
    FormBuilder builder, VoidCallback submit);

/// used to listen select dialog open
///
/// helpful if you want to set initialValue for query form
///
/// if return true,will set query params before query otherwise just control form
typedef OnSelectDialogShow = bool Function(FormManagement formManagement);

/// used to render selector
class SelectorThemeData {
  //used to render select items
  final ListTileThemeData? listTileThemeData;

  /// used to render selected item
  final ChipThemeData? chipThemeData;

  ///used to render selector
  final InputDecorationTheme? inputDecorationTheme;

  const SelectorThemeData(
      {this.listTileThemeData, this.chipThemeData, this.inputDecorationTheme});
}

class SelectorFormField<T>
    extends BaseNonnullValueField<List<T>, SelectorModel> {
  final SelectItemRender<T>? selectItemRender;
  final SelectedItemRender<T>? selectedItemRender;
  final SelectedSorter<T>? selectedSorter;
  final SelectItemProvider<T>? selectItemProvider;
  final SelectedItemLayoutType selectedItemLayoutType;
  final QueryFormBuilder? queryFormBuilder;
  final OnSelectDialogShow? onSelectDialogShow;
  final VoidCallback? onTap;
  final SelectorThemeData selectorThemeData;

  Widget _defaultSelectedItemRender<T>(T item, bool multiSelect, bool readOnly,
      ThemeData themeData, VoidCallback? remove) {
    if (!multiSelect) {
      return Padding(
        child: Text(item.toString()),
        padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      );
    }
    return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Chip(
          label: Text(
            item.toString(),
          ),
          onDeleted: remove,
          deleteIcon: Icon(
            Icons.close,
            size: 24,
          ),
        ));
  }

  SelectorFormField({
    required this.selectItemProvider,
    ValueChanged<List<T>>? onChanged,
    bool clearable = true,
    String? labelText,
    String? hintText,
    final double iconSize = 24,
    bool multi = false,
    NonnullFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    List<T>? initialValue,
    this.selectItemRender,
    this.selectedItemRender,
    this.selectedSorter,
    this.selectedItemLayoutType = SelectedItemLayoutType.wrap,
    this.queryFormBuilder,
    this.onSelectDialogShow,
    this.onTap,
    InputDecorationTheme? inputDecorationTheme,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    this.selectorThemeData = const SelectorThemeData(),
    WidgetWrapper? wrapper,
  }) : super(
          model: SelectorModel(
            labelText: labelText,
            hintText: hintText,
            multi: multi,
            clearable: clearable,
            selectorThemeData: selectorThemeData,
            selectedItemLayoutType: selectedItemLayoutType,
          ),
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? List<T>.empty(growable: true),
          autovalidateMode: autovalidateMode,
          wrapper: wrapper,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            String? labelText = state.model.labelText;
            String? hintText = state.model.hintText;
            bool multi = state.model.multi!;
            bool clearable = state.model.clearable!;
            SelectorThemeData selectorThemeData =
                state.model.selectorThemeData!;
            SelectedItemLayoutType selectedItemLayoutType =
                state.model.selectedItemLayoutType!;
            ThemeData themeData = Theme.of(state.context);

            List<Widget> icons = [];
            if (clearable && !readOnly && state.value.isNotEmpty) {
              icons.add(Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Icon(Icons.clear),
                  onTap: () {
                    state.didChange([]);
                  },
                ),
              ));
            }

            icons.add(Icon(
              Icons.arrow_drop_down,
            ));

            Widget? widget;

            if (state.value.isNotEmpty) {
              SelectedItemRender<T> render = selectedItemRender ??
                  (state.widget as SelectorFormField)
                      ._defaultSelectedItemRender;
              if (!multi) {
                widget =
                    render(state.value[0], multi, readOnly, themeData, null);
              } else {
                if (selectedSorter != null) selectedSorter(state.value);
                List<Widget> itemWidgets = state.value.map((item) {
                  return InkWell(
                    child: render(
                        item,
                        multi,
                        readOnly,
                        themeData,
                        readOnly
                            ? null
                            : () {
                                state.didChange(List.of(state.value)
                                  ..removeWhere((element) => element == item));
                              }),
                    onTap: () {}, //prevent show selector dialog
                  );
                }).toList();

                switch (selectedItemLayoutType) {
                  case SelectedItemLayoutType.scroll:
                    widget = SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: itemWidgets));
                    break;
                  default:
                    widget = Wrap(children: itemWidgets);
                }

                widget = ChipTheme(
                  child: widget,
                  data: selectorThemeData.chipThemeData ??
                      ChipTheme.of(state.context),
                );
              }
            }
            final InputDecoration effectiveDecoration = InputDecoration(
                    contentPadding: multi ? EdgeInsets.zero : null,
                    labelText: labelText,
                    hintText: hintText,
                    suffixIcon: Row(
                      children: icons,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                    ))
                .applyDefaults(selectorThemeData.inputDecorationTheme ??
                    themeData.inputDecorationTheme);

            Widget child = Focus(
                focusNode: focusNode,
                canRequestFocus: true,
                skipTraversal: true,
                child: Builder(
                    builder: (context) => InkWell(
                          onTap: (readOnly || selectItemProvider == null)
                              ? null
                              : () async {
                                  focusNode.requestFocus();
                                  List<T>? selected = await Navigator.of(
                                          context,
                                          rootNavigator: true)
                                      .push(MaterialPageRoute<List<T>>(
                                          builder: (BuildContext context) {
                                            return _SelectorDialog<T>(
                                              selectItemRender,
                                              state.value,
                                              selectItemProvider,
                                              multi,
                                              queryFormBuilder,
                                              onSelectDialogShow,
                                              themeData,
                                              selectorThemeData,
                                            );
                                          },
                                          fullscreenDialog: true));
                                  if (selected != null) {
                                    if (compare<T>(state.value, selected))
                                      return;
                                    if (selectedSorter != null)
                                      selectedSorter(selected);
                                    state.didChange(selected);
                                  }
                                },
                          child: InputDecorator(
                            decoration: effectiveDecoration.copyWith(
                                errorText: state.errorText),
                            isEmpty: state.value.isEmpty,
                            isFocused: Focus.of(context).hasFocus,
                            child: widget,
                          ),
                        )));
            return child;
          },
        );

  static bool compare<T>(List<T> old, List<T> selected) {
    if (old.length != selected.length) return false;
    return old.every((element) => selected.contains(element));
  }

  @override
  _SelectorFormFieldState<T> createState() => _SelectorFormFieldState();
}

class _SelectorDialog<T> extends StatefulWidget {
  final SelectItemRender<T>? selectItemRender;
  final List<T> selected;
  final SelectItemProvider<T> selectItemProvider;
  final bool multi;
  final QueryFormBuilder? queryFormBuilder;
  final OnSelectDialogShow? onSelectDialogShow;
  final ThemeData themeData;
  final SelectorThemeData selectorThemeData;
  _SelectorDialog(
    this.selectItemRender,
    this.selected,
    this.selectItemProvider,
    this.multi,
    this.queryFormBuilder,
    this.onSelectDialogShow,
    this.themeData,
    this.selectorThemeData,
  );
  @override
  _SelectorDialogState<T> createState() => _SelectorDialogState();
}

class _SelectorDialogState<T> extends State<_SelectorDialog> {
  List<T>? selected;
  bool loading = false;
  List items = [];
  int page = 1;
  int count = 0;
  bool error = false;
  bool empty = false;

  int gen = 0;

  final FormKey _formKey = FormKey();
  Map<String, dynamic> params = {};

  ThemeData? themeData;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selected);
    themeData = widget.themeData;

    if (widget.onSelectDialogShow != null && widget.queryFormBuilder != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        FormManagement? formManagement = _formKey.quietlyManagement;
        if (formManagement == null) return;
        bool queryAfterLoadParams = widget.onSelectDialogShow!(formManagement);
        if (queryAfterLoadParams && formManagement.validate()) {
          params = formManagement.data;
        }
        loadData(gen);
      });
    } else {
      loadData(gen);
    }
  }

  void toggle(T value) {
    update(() {
      if (widget.multi) {
        int len = selected!.length;
        selected!.removeWhere((element) => value == element);
        if (len == selected!.length) {
          selected!.add(value);
        }
      } else {
        selected = [value];
      }
    });
  }

  void query() {
    FormManagement? formManagement = _formKey.quietlyManagement;
    if (formManagement != null && !formManagement.validate()) return;
    update(() {
      gen++;
      empty = false;
      loading = true;
      page = 1;
      items = [];
      error = false;
      count = 0;
      params = formManagement == null ? {} : formManagement.data;
    });
    loadData(gen);
  }

  bool isSelected(T value) {
    return selected!.any((element) => value == element);
  }

  void update(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  Widget renderSelectItems(T item, bool multiSelect, bool isSelected,
      ThemeData themeData, VoidCallback? select) {
    if (multiSelect) {
      return CheckboxListTile(
          dense: true,
          title: Text(item.toString()),
          value: isSelected,
          onChanged: select == null ? null : (v) => select());
    } else {
      return RadioListTile<T>(
          dense: true,
          title: Text(item.toString()),
          value: item,
          groupValue: isSelected ? item : null,
          onChanged: select == null ? null : (v) => select());
    }
  }

  Widget? buildQueryForm() {
    if (widget.queryFormBuilder == null) {
      return null;
    }
    FormBuilder form = FormBuilder().key(_formKey);
    return widget.queryFormBuilder!(form, query);
  }

  void loadData(int gen, {bool decreasePageWhenError = false}) {
    widget.selectItemProvider(page, params).then((value) {
      if (this.gen > gen) return;
      items.addAll(value.items);
      count = value.count;
      loading = false;
      empty = page == 1 && items.isEmpty;
    }).onError((err, stackTrace) {
      if (decreasePageWhenError) page--;
      print(stackTrace);
      if (this.gen > gen) return;
      loading = false;
      error = true;
    }).whenComplete(() {
      if (this.gen > gen) return;
      update(() {});
    });
  }

  void nextPage() {
    update(() {
      gen++;
      page++;
      loading = true;
    });
    loadData(gen, decreasePageWhenError: true);
  }

  Widget buildView(ThemeData themeData) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (items.length < count &&
            !loading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          nextPage();
        }
        return true;
      },
      child: FormRenderUtils.mergeListTileTheme(
          ListView.builder(
            itemBuilder: (context, index) {
              var item = items[index];
              bool selected = isSelected(item);
              SelectItemRender<T> render =
                  widget.selectItemRender ?? renderSelectItems;
              return render(item, widget.multi, selected, themeData, () {
                toggle(item);
              });
            },
            itemCount: items.length,
          ),
          widget.selectorThemeData.listTileThemeData),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = [];

    Widget? queryForm = buildQueryForm();
    if (queryForm != null) {
      columns.add(queryForm);
    }

    if (page == 1 && items.isEmpty) {
      columns.add(Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: error
                  ? Icon(
                      Icons.error,
                      color: themeData!.errorColor,
                      size: 50,
                    )
                  : empty
                      ? SizedBox()
                      : CircularProgressIndicator())
        ],
      )));
    } else {
      columns.add(Expanded(child: buildView(themeData!)));
    }

    if ((loading || error) && items.isNotEmpty) {
      columns.add(Container(
        height: 50,
        color: Colors.transparent,
        child: Center(
          child: loading
              ? CircularProgressIndicator()
              : Icon(
                  Icons.error,
                  color: themeData!.errorColor,
                  size: 50,
                ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(selected);
            },
          )
        ],
      ),
      body: Theme(
          data: themeData!,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: columns,
              ))),
    );
  }
}

class _SelectorFormFieldState<T>
    extends BaseNonnullValueFieldState<List<T>, SelectorModel> {
  @override
  void beforeMerge(SelectorModel old, SelectorModel current) {
    if (current.multi != null && current.multi != old.multi) {
      setValue([]);
    }
  }
}

class SelectItemPage<T> {
  final List<T> items; //current page items loaded from storage
  final int count;

  SelectItemPage(this.items, this.count); //total record counts;
}

enum SelectedItemLayoutType { wrap, scroll }

class SelectorModel extends AbstractFieldStateModel {
  final String? labelText;
  final String? hintText;
  final bool? multi;
  final bool? clearable;
  final SelectorThemeData? selectorThemeData;
  final SelectedItemLayoutType? selectedItemLayoutType;

  SelectorModel(
      {this.labelText,
      this.hintText,
      this.multi,
      this.clearable,
      this.selectorThemeData,
      this.selectedItemLayoutType});

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    SelectorModel oldModel = old as SelectorModel;
    return SelectorModel(
      labelText: labelText ?? oldModel.labelText,
      hintText: hintText ?? oldModel.hintText,
      multi: multi ?? oldModel.multi,
      clearable: clearable ?? oldModel.clearable,
      selectorThemeData: selectorThemeData ?? oldModel.selectorThemeData,
      selectedItemLayoutType:
          selectedItemLayoutType ?? oldModel.selectedItemLayoutType,
    );
  }
}
