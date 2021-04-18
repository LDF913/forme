import 'dart:ui';
import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

typedef SelectedChecker = bool Function(dynamic value, dynamic selectedValue);
typedef SelectItemRender = Widget Function(dynamic item, bool multiSelect,
    bool isSelected, ThemeData themeData, FormThemeData formThemeData);
typedef SelectedItemRender = Widget Function(dynamic item, bool multiSelect,
    bool readOnly, ThemeData themeData, FormThemeData formThemeData);
typedef SelectedSorter = void Function(List selected);
typedef SelectItemProvider = Future<SelectItemPage> Function(
    int page, Map<String, dynamic> params);
typedef QueryFormBuilder = void Function(
    FormBuilder builder, VoidCallback submit);
typedef OnSelectDialogShow = bool Function(
    FormControllerDelegate formController);

class _SelectorController extends ValueNotifier<List> {
  _SelectorController({List value}) : super(value);
  final UniqueKey key = UniqueKey();
  List<dynamic> get value => super.value == null ? [] : super.value;
  void set(List value) => super.value == null ? [] : List.from(value);
}

class SelectorFormField extends ValueField<List> {
  final bool clearable;
  final String labelText;
  final String hintText;
  final double iconSize;
  final bool multi;
  final SelectedChecker selectedChecker;
  final SelectItemRender selectItemRender;
  final SelectedItemRender selectedItemRender;
  final SelectedSorter selectedSorter;
  final SelectItemProvider selectItemProvider;
  final SelectedItemLayoutType selectedItemLayoutType;
  final QueryFormBuilder queryFormBuilder;
  final OnSelectDialogShow onSelectDialogShow;
  final VoidCallback onTap;

  static Widget _defaultSelectedItemRender(dynamic item, bool multiSelect,
      bool readOnly, ThemeData themeData, FormThemeData formThemeData) {
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

  static bool _defaultSelectedChecker(dynamic v1, dynamic v2) {
    return v1 == v2;
  }

  SelectorFormField(this.selectItemProvider,
      {Key key,
      bool readOnly = false,
      ValueChanged<List> onChanged,
      this.clearable,
      this.labelText,
      this.hintText,
      FormFieldValidator<List> validator,
      AutovalidateMode autovalidateMode,
      this.iconSize = 24,
      this.multi = false,
      List initialValue,
      this.selectedChecker,
      this.selectItemRender,
      this.selectedItemRender,
      this.selectedSorter,
      this.selectedItemLayoutType,
      this.queryFormBuilder,
      this.onSelectDialogShow,
      this.onTap,
      InputDecorationTheme inputDecorationTheme})
      : super(
          () => _SelectorController(value: initialValue),
          {
            'labelText': labelText,
            'hintText': hintText,
            'multi': multi,
            'clearable': clearable,
            'inputDecorationTheme': inputDecorationTheme,
          },
          key: key,
          readOnly: readOnly,
          onChanged: onChanged,
          replace: () => [],
          validator: validator,
          initialValue: initialValue ?? [],
          autovalidateMode: autovalidateMode,
          builder: (state, context, readOnly, stateMap, themeData,
              formThemeData, focusNodeProvider, notifier) {
            _SelectorController controller = notifier;
            FocusNode focusNode = focusNodeProvider();
            String labelText = stateMap['labelText'];
            String hintText = stateMap['hintText'];
            bool multi = stateMap['multi'];
            bool clearable = stateMap['clearable'];
            InputDecorationTheme inputDecorationTheme =
                stateMap['inputDecorationTheme'] ??
                    themeData.inputDecorationTheme;

            SelectedChecker checker =
                selectedChecker ?? _defaultSelectedChecker;

            List<Widget> icons = [];
            if (clearable && !readOnly && controller.value.isNotEmpty) {
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

            Widget widget;

            if (controller.value.isNotEmpty) {
              SelectedItemRender render =
                  selectedItemRender ?? _defaultSelectedItemRender;
              if (!multi) {
                widget = render(controller.value[0], multi, readOnly, themeData,
                    formThemeData);
              } else {
                List value = List.from(controller.value);
                if (selectedSorter != null) selectedSorter(value);
                SelectedItemLayoutType layoutType =
                    selectedItemLayoutType ?? SelectedItemLayoutType.wrap;

                List<Widget> itemWidgets = value.map((item) {
                  return InkWell(
                    onTap: readOnly
                        ? null
                        : onTap ??
                            () {
                              state.didChange(controller.value
                                  .where((element) => !checker(item, element))
                                  .toList());
                              focusNode.requestFocus();
                            },
                    child:
                        render(item, multi, readOnly, themeData, formThemeData),
                  );
                }).toList();

                switch (layoutType) {
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

            FormControllerDelegate delegate =
                FormControllerDelegate.copyTheme(context);

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
                                  List selected = await Navigator.of(context,
                                          rootNavigator: true)
                                      .push(MaterialPageRoute<List>(
                                          settings: RouteSettings(
                                              arguments: controller.key),
                                          builder: (BuildContext context) {
                                            return _SelectorDialog(
                                                delegate,
                                                selectItemRender,
                                                checker,
                                                controller.value,
                                                selectItemProvider,
                                                multi,
                                                queryFormBuilder,
                                                onSelectDialogShow);
                                          },
                                          fullscreenDialog: true));
                                  if (selected != null) {
                                    state.didChange(selected);
                                    focusNode.requestFocus();
                                  }
                                },
                          child: InputDecorator(
                            decoration: effectiveDecoration.copyWith(
                                errorText: state.errorText),
                            isEmpty: controller.value.isEmpty,
                            isFocused: Focus.of(context).hasFocus,
                            child: widget,
                          ),
                        )));
            return child;
          },
        );

  @override
  _SelectorFormFieldState createState() => _SelectorFormFieldState();
}

class _SelectorFormFieldState extends ValueFieldState<List> {
  UniqueKey get dialogKey => (super.controller as _SelectorController).key;

  @override
  void didUpdateWidget(SelectorFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isClosed = false;
      Navigator.of(context).popUntil((route) {
        if (isClosed) return true;
        if (route is MaterialPageRoute) {
          RouteSettings settings = route.settings;
          if (settings != null && settings.arguments == dialogKey) return false;
        }
        isClosed = true;
        return true;
      });
    });
  }
}

class _SelectorDialog extends StatefulWidget {
  final FormControllerDelegate formController;
  final SelectItemRender selectItemRender;
  final SelectedChecker selectedChecker;
  final List selected;
  final SelectItemProvider selectItemProvider;
  final bool multi;
  final QueryFormBuilder queryFormBuilder;
  final OnSelectDialogShow onSelectDialogShow;
  _SelectorDialog(
      this.formController,
      this.selectItemRender,
      this.selectedChecker,
      this.selected,
      this.selectItemProvider,
      this.multi,
      this.queryFormBuilder,
      this.onSelectDialogShow,
      {Key key})
      : super(key: key);
  @override
  _SelectorDialogState createState() => _SelectorDialogState();
}

class _SelectorDialogState extends State<_SelectorDialog> {
  List selected;
  bool loading = false;
  List items = [];
  int page = 1;
  int count = 0;
  bool error = false;
  bool empty = false;

  int gen = 0;

  FormControllerDelegate queryFormController;
  Map<String, dynamic> params = {};

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selected);
    queryFormController = widget.formController;

    if (widget.onSelectDialogShow != null && widget.queryFormBuilder != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bool queryAfterLoadParams =
            widget.onSelectDialogShow(queryFormController);
        if (queryAfterLoadParams && queryFormController.validate()) {
          params = queryFormController.getData();
        }
        loadData(gen);
      });
    } else {
      loadData(gen);
    }
  }

  void toggle(dynamic value) {
    update(() {
      if (widget.multi) {
        int len = selected.length;
        selected
            .removeWhere((element) => widget.selectedChecker(value, element));
        if (len == selected.length) {
          selected.add(value);
        }
      } else {
        selected = [value];
      }
    });
  }

  void query() {
    if (!queryFormController.validate()) {
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
      params = queryFormController.getData();
    });
    loadData(gen);
  }

  bool isSelected(dynamic value) {
    return selected.any((element) => widget.selectedChecker(value, element));
  }

  void update(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  Widget renderSelectItems(dynamic item, bool multiSelect, bool isSelected,
      ThemeData themeData, FormThemeData formThemeData) {
    Color color =
        isSelected ? themeData.primaryColor : themeData.unselectedWidgetColor;
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

  Widget buildQueryForm() {
    if (widget.queryFormBuilder == null) {
      return null;
    }
    FormBuilder form = FormBuilder(queryFormController);
    widget.queryFormBuilder(form, query);
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
            SelectItemRender render =
                widget.selectItemRender ?? renderSelectItems;
            return InkWell(
              child: render(item, widget.multi, selected, themeData,
                  widget.formController.themeData),
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
    ThemeData themeData =
        widget.formController.themeData.themeData ?? Theme.of(context);
    List<Widget> columns = [];

    Widget queryForm = buildQueryForm();
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
                      color: themeData.errorColor,
                      size: 50,
                    )
                  : empty
                      ? SizedBox()
                      : CircularProgressIndicator())
        ],
      )));
    } else {
      columns.add(Expanded(child: buildView(themeData)));
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
                  color: themeData.errorColor,
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
          data: themeData,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: columns,
              ))),
    );
  }
}

class SelectItemPage {
  final List items; //current page items loaded from storage
  final int count;

  SelectItemPage(this.items, this.count); //total record counts;
}

enum SelectedItemLayoutType { wrap, scroll }
