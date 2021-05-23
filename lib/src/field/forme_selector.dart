import 'package:flutter/material.dart';
import '../forme_management.dart';
import '../render/forme_render_data.dart';
import '../render/forme_render_utils.dart';

import '../forme_core.dart';
import '../forme_state_model.dart';
import '../forme_field.dart';

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
typedef FormeSelectItemRender<T> = Widget Function(T item, bool multiSelect,
    bool isSelected, ThemeData themeData, VoidCallback? select);

/// used to render selected item
///
/// [item] selected item data from FormeSelectItemProvider
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
typedef FormeSelectedItemRender<T> = Widget Function(T item, bool multiSelect,
    bool readOnly, ThemeData themeData, VoidCallback? remove);

/// used to sort selected items
typedef FormeSelectedSorter<T> = void Function(List<T> selected);

/// used to provider select items
///
/// [page] target page
///
/// [params] query params get from query form builder
typedef FormeSelectItemProvider<T> = Future<FormeSelectItemPage<T>> Function(
    int page, Map<String, dynamic> params);

/// used to build a query form
///
/// [submit] an function used to submit query
///
/// **return a form widget **
typedef QueryFormBuilder = Widget? Function(VoidCallback submit);

/// used to listen select dialog open
///
/// helpful if you want to set initialValue for query form
///
/// if return true,will set query params before query otherwise just control form
typedef OnFormeSelectorDialogShow = bool Function(
    FormeManagement formeManagement);

/// used to render selector
class FormeSelectorThemeData {
  //used to render select items
  final FormeListTileRenderData? formeListTileRenderData;

  /// used to render selected item
  final ChipThemeData? chipThemeData;

  ///used to render selector
  final InputDecorationTheme? inputDecorationTheme;

  const FormeSelectorThemeData(
      {this.formeListTileRenderData,
      this.chipThemeData,
      this.inputDecorationTheme});
}

class FormeSelector<T> extends NonnullValueField<List<T>, FormeSelectorModel> {
  final FormeSelectItemRender<T>? selectItemRender;
  final FormeSelectedItemRender<T>? selectedItemRender;
  final FormeSelectedSorter<T>? selectedSorter;
  final FormeSelectItemProvider<T>? selectItemProvider;
  final QueryFormBuilder? queryForme;
  final OnFormeSelectorDialogShow? onSelectDialogShow;
  final VoidCallback? onTap;

  Widget _defaultFormeSelectedItemRender<T>(T item, bool multiSelect,
      bool readOnly, ThemeData themeData, VoidCallback? remove) {
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

  FormeSelector({
    required this.selectItemProvider,
    ValueChanged<List<T>>? onChanged,
    final double iconSize = 24,
    NonnullFieldValidator<List<T>>? validator,
    AutovalidateMode? autovalidateMode,
    List<T>? initialValue,
    this.selectItemRender,
    this.selectedItemRender,
    this.selectedSorter,
    this.queryForme,
    this.onSelectDialogShow,
    this.onTap,
    InputDecorationTheme? inputDecorationTheme,
    NonnullFormFieldSetter<List<T>>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    required FormeSelectorModel model,
    Key? key,
  }) : super(
          key: key,
          model: model,
          readOnly: readOnly,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? List<T>.empty(growable: true),
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            FocusNode focusNode = state.focusNode;
            String? labelText = state.model.labelText;
            String? hintText = state.model.hintText;
            bool multi = state.model.multi ?? false;
            bool clearable = state.model.clearable ?? true;
            FormeSelectorThemeData formeSelectorThemeData =
                state.model.formeSelectorThemeData ??
                    const FormeSelectorThemeData();
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
              FormeSelectedItemRender<T> render = selectedItemRender ??
                  (state.widget as FormeSelector)
                      ._defaultFormeSelectedItemRender;
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

                widget = FormeRenderUtils.wrap(
                    state.model.formeWrapRenderData, itemWidgets);

                widget = ChipTheme(
                  child: widget,
                  data: formeSelectorThemeData.chipThemeData ??
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
                .applyDefaults(formeSelectorThemeData.inputDecorationTheme ??
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
                                            return _FormeSelectorDialog<T>(
                                              selectItemRender,
                                              state.value,
                                              selectItemProvider,
                                              multi,
                                              queryForme,
                                              onSelectDialogShow,
                                              themeData,
                                              formeSelectorThemeData,
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
  _FormeSelectorState<T> createState() => _FormeSelectorState();
}

class _FormeSelectorDialog<T> extends StatefulWidget {
  final FormeSelectItemRender<T>? selectItemRender;
  final List<T> selected;
  final FormeSelectItemProvider<T> selectItemProvider;
  final bool multi;
  final QueryFormBuilder? queryForme;
  final OnFormeSelectorDialogShow? onSelectDialogShow;
  final ThemeData themeData;
  final FormeSelectorThemeData formeSelectorThemeData;
  _FormeSelectorDialog(
    this.selectItemRender,
    this.selected,
    this.selectItemProvider,
    this.multi,
    this.queryForme,
    this.onSelectDialogShow,
    this.themeData,
    this.formeSelectorThemeData,
  );
  @override
  _FormeSelectorDialogState<T> createState() => _FormeSelectorDialogState();
}

class _FormeSelectorDialogState<T> extends State<_FormeSelectorDialog> {
  List<T>? selected;
  bool loading = false;
  List items = [];
  int page = 1;
  int count = 0;
  bool error = false;
  bool empty = false;

  int gen = 0;

  final FormeKey _formKey = FormeKey();
  Map<String, dynamic> params = {};

  ThemeData? themeData;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selected);
    themeData = widget.themeData;

    if (widget.onSelectDialogShow != null && widget.queryForme != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        FormeManagement? formeManagement = _formKey.quietlyManagement;
        if (formeManagement == null) return;
        bool queryAfterLoadParams = widget.onSelectDialogShow!(formeManagement);
        if (queryAfterLoadParams && formeManagement.validate()) {
          params = formeManagement.data;
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
    FormeManagement? formeManagement = _formKey.quietlyManagement;
    if (formeManagement != null && !formeManagement.validate()) return;
    update(() {
      gen++;
      empty = false;
      loading = true;
      page = 1;
      items = [];
      error = false;
      count = 0;
      params = formeManagement == null ? {} : formeManagement.data;
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
    if (widget.queryForme == null) {
      return null;
    }
    Widget? formWidget = widget.queryForme!(query);
    if (formWidget != null) {
      return Forme(
        key: _formKey,
        child: formWidget,
      );
    }
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
      child: FormeRenderUtils.mergeListTileTheme(
          ListView.builder(
            itemBuilder: (context, index) {
              var item = items[index];
              bool selected = isSelected(item);
              FormeSelectItemRender<T> render =
                  widget.selectItemRender ?? renderSelectItems;
              return render(item, widget.multi, selected, themeData, () {
                toggle(item);
              });
            },
            itemCount: items.length,
          ),
          widget.formeSelectorThemeData.formeListTileRenderData),
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

class _FormeSelectorState<T>
    extends NonnullValueFieldState<List<T>, FormeSelectorModel> {
  @override
  void beforeMerge(FormeSelectorModel old, FormeSelectorModel current) {
    if (current.multi != null && current.multi != old.multi) {
      setValue([]);
    }
  }
}

class FormeSelectItemPage<T> {
  final List<T> items; //current page items loaded from storage
  final int count;

  FormeSelectItemPage(this.items, this.count); //total record counts;
}

class FormeSelectorModel extends AbstractFormeModel {
  final String? labelText;
  final String? hintText;
  final bool? multi;
  final bool? clearable;
  final FormeSelectorThemeData? formeSelectorThemeData;
  final FormeWrapRenderData? formeWrapRenderData;

  FormeSelectorModel({
    this.labelText,
    this.hintText,
    this.multi,
    this.clearable,
    this.formeSelectorThemeData,
    this.formeWrapRenderData,
  });

  @override
  AbstractFormeModel merge(AbstractFormeModel old) {
    FormeSelectorModel oldModel = old as FormeSelectorModel;
    return FormeSelectorModel(
      labelText: labelText ?? oldModel.labelText,
      hintText: hintText ?? oldModel.hintText,
      multi: multi ?? oldModel.multi,
      clearable: clearable ?? oldModel.clearable,
      formeSelectorThemeData:
          formeSelectorThemeData ?? oldModel.formeSelectorThemeData,
      formeWrapRenderData: formeWrapRenderData ?? oldModel.formeWrapRenderData,
    );
  }
}
