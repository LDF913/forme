import 'package:flutter/material.dart';

import '../builder.dart';
import '../form_theme.dart';

typedef SelectItemRender<T> = Widget Function(T item, bool multiSelect,
    bool isSelected, ThemeData themeData, FormThemeData formThemeData);
typedef SelectedItemRender<T> = Widget Function(T item, bool multiSelect,
    bool readOnly, ThemeData themeData, FormThemeData formThemeData);
typedef SelectedSorter<T> = void Function(List<T> selected);
typedef SelectItemProvider<T> = Future<SelectItemPage<T>> Function(
    int page, Map<String, dynamic> params);
typedef QueryFormBuilder = void Function(
    FormBuilder builder, VoidCallback submit);
typedef OnSelectDialogShow = bool Function(FormManagement formManagement);

class SelectorFormField<T> extends NonnullValueField<List<T>> {
  final SelectItemRender<T>? selectItemRender;
  final SelectedItemRender<T>? selectedItemRender;
  final SelectedSorter<T>? selectedSorter;
  final SelectItemProvider<T>? selectItemProvider;
  final SelectedItemLayoutType selectedItemLayoutType;
  final QueryFormBuilder? queryFormBuilder;
  final OnSelectDialogShow? onSelectDialogShow;
  final VoidCallback? onTap;

  Widget _defaultSelectedItemRender<T>(T item, bool multiSelect, bool readOnly,
      ThemeData themeData, FormThemeData formThemeData) {
    if (!multiSelect) {
      return Padding(
        child: Text(item.toString()),
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      );
    }
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Chip(
            backgroundColor: readOnly
                ? themeData.primaryColor.withOpacity(0.5)
                : themeData.primaryColor,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.toString(),
                  style: TextStyle(),
                ),
                SizedBox(
                  width: 4,
                ),
                Visibility(
                  child: Icon(
                    Icons.clear,
                    size: 12,
                  ),
                  visible: !readOnly,
                )
              ],
            )));
  }

  SelectorFormField(this.selectItemProvider,
      {bool readOnly = false,
      ValueChanged<List>? onChanged,
      bool clearable = true,
      String? labelText,
      String? hintText,
      final double iconSize = 24,
      bool multi = false,
      NonnullFieldValidator<List>? validator,
      AutovalidateMode? autovalidateMode,
      List<T>? initialValue,
      this.selectItemRender,
      this.selectedItemRender,
      this.selectedSorter,
      this.selectedItemLayoutType = SelectedItemLayoutType.wrap,
      this.queryFormBuilder,
      this.onSelectDialogShow,
      this.onTap,
      InputDecorationTheme? inputDecorationTheme})
      : super(
          {
            'labelText': TypedValue<String?>(labelText),
            'hintText': TypedValue<String?>(hintText),
            'multi': TypedValue<bool>(multi),
            'clearable': TypedValue<bool>(clearable),
            'inputDecorationTheme':
                TypedValue<InputDecorationTheme?>(inputDecorationTheme)
          },
          onChanged: onChanged,
          validator: validator,
          initialValue: initialValue ?? List<T>.empty(growable: true),
          autovalidateMode: autovalidateMode,
          builder: (state, stateMap, readOnly, formThemeData) {
            ThemeData themeData = formThemeData.themeData;
            FocusNode focusNode = state.focusNode;
            String? labelText = stateMap['labelText'];
            String? hintText = stateMap['hintText'];
            bool multi = stateMap['multi'];
            bool clearable = stateMap['clearable'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    themeData.inputDecorationTheme;

            List<Widget> icons = [];
            if (clearable && !readOnly && state.value.isNotEmpty) {
              icons.add(Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Icon(Icons.clear),
                  onTap: () {
                    state.didChange([]);
                    focusNode.requestFocus();
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
                widget = render(
                    state.value[0], multi, readOnly, themeData, formThemeData);
              } else {
                if (selectedSorter != null) selectedSorter(state.value);
                List<Widget> itemWidgets = state.value.map((item) {
                  return InkWell(
                    onTap: readOnly
                        ? null
                        : onTap ??
                            () {
                              state.didChange(state.value
                                ..removeWhere((element) => element == item));
                              focusNode.requestFocus();
                            },
                    child:
                        render(item, multi, readOnly, themeData, formThemeData),
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
                )).applyDefaults(inputDecorationTheme);

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
                                                formThemeData);
                                          },
                                          fullscreenDialog: true));
                                  if (selected != null) {
                                    if (compare<T>(state.value, selected))
                                      return;
                                    if (selectedSorter != null)
                                      selectedSorter(selected);
                                    state.didChange(selected);
                                    focusNode.requestFocus();
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

  @override
  NonnullValueFieldState<List<T>> createState() => NonnullValueFieldState();

  static bool compare<T>(List<T> old, List<T> selected) {
    if (old.length != selected.length) return false;
    return old.every((element) => selected.contains(element));
  }
}

class _SelectorDialog<T> extends StatefulWidget {
  final SelectItemRender<T>? selectItemRender;
  final List<T> selected;
  final SelectItemProvider<T> selectItemProvider;
  final bool multi;
  final QueryFormBuilder? queryFormBuilder;
  final OnSelectDialogShow? onSelectDialogShow;
  final FormThemeData formThemeData;
  _SelectorDialog(
      this.selectItemRender,
      this.selected,
      this.selectItemProvider,
      this.multi,
      this.queryFormBuilder,
      this.onSelectDialogShow,
      this.formThemeData);
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

  FormManagement queryFormManagement = FormManagement();
  Map<String, dynamic> params = {};

  FormThemeData? formThemeData;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selected);
    formThemeData = widget.formThemeData;

    if (widget.onSelectDialogShow != null && widget.queryFormBuilder != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        bool queryAfterLoadParams =
            widget.onSelectDialogShow!(queryFormManagement);
        if (queryAfterLoadParams && queryFormManagement.validate()) {
          params = queryFormManagement.data;
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
    if (!queryFormManagement.validate()) {
      return;
    }
    update(() {
      gen++;
      empty = false;
      loading = true;
      page = 1;
      items = [];
      error = false;
      count = 0;
      params = queryFormManagement.data;
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
      ThemeData themeData, FormThemeData formThemeData) {
    Color color = isSelected
        ? formThemeData.themeData.primaryColor
        : formThemeData.themeData.unselectedWidgetColor;
    return Padding(
        child: Row(
          children: [
            Expanded(child: Text(item.toString())),
            Icon(
              isSelected
                  ? multiSelect
                      ? Icons.check_box
                      : Icons.radio_button_checked
                  : multiSelect
                      ? Icons.check_box_outline_blank
                      : Icons.radio_button_off,
              color: color,
            ),
          ],
        ),
        padding: EdgeInsets.all(4));
  }

  Widget? buildQueryForm() {
    if (widget.queryFormBuilder == null) {
      return null;
    }
    FormBuilder form = FormBuilder(
      formThemeData: formThemeData,
      formManagement: queryFormManagement,
    );
    widget.queryFormBuilder!(form, query);
    return form;
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
      child: ListView.builder(
          itemBuilder: (context, index) {
            var item = items[index];
            bool selected = isSelected(item);
            SelectItemRender<T> render =
                widget.selectItemRender ?? renderSelectItems;
            return InkWell(
              child: render(item, widget.multi, selected,
                  formThemeData!.themeData, formThemeData!),
              onTap: () {
                toggle(item);
              },
            );
          },
          itemCount: items.length),
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
                      color: formThemeData!.themeData.errorColor,
                      size: 50,
                    )
                  : empty
                      ? SizedBox()
                      : CircularProgressIndicator())
        ],
      )));
    } else {
      columns.add(Expanded(child: buildView(formThemeData!.themeData)));
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
                  color: formThemeData!.themeData.errorColor,
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
          data: formThemeData!.themeData,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: columns,
              ))),
    );
  }
}

class SelectItemPage<T> {
  final List<T> items; //current page items loaded from storage
  final int count;

  SelectItemPage(this.items, this.count); //total record counts;
}

enum SelectedItemLayoutType { wrap, scroll }
