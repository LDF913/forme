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
typedef SelectItemProvider = Future<SelectItemPage> Function(int page);

class SelectorController extends ValueNotifier<List> {
  SelectorController({List value}) : super(value);
  final UniqueKey _key = UniqueKey();
  List<dynamic> get value => super.value == null ? [] : super.value;
  void set(List value) => super.value == null ? [] : List.from(value);
}

class SelectorFormField extends FormBuilderField<List> {
  final FocusNode focusNode;
  final bool clearable;
  final EdgeInsets padding;
  final String labelText;
  final String hintText;
  final double iconSize;
  final bool loading;
  final bool multi;
  final SelectedChecker selectedChecker;
  final SelectItemRender selectItemRender;
  final SelectedItemRender selectedItemRender;
  final SelectedSorter selectedSorter;
  final SelectItemProvider selectItemProvider;
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

  SelectorFormField(String controlKey, this.focusNode,
      SelectorController controller, this.selectItemProvider,
      {Key key,
      bool readOnly = false,
      ValueChanged<List> onChanged,
      this.clearable,
      this.labelText,
      this.hintText,
      FormFieldValidator<List> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      this.iconSize = 24,
      this.loading = false,
      this.multi = false,
      List initialValue,
      this.selectedChecker,
      this.selectItemRender,
      this.selectedItemRender,
      this.selectedSorter,
      this.onTap})
      : super(
          controlKey,
          controller,
          key: key,
          onChanged: onChanged,
          replace: () => [],
          validator: validator,
          initialValue: initialValue ?? [],
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final FormBuilderFieldState state = field as FormBuilderFieldState;

            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            SelectedChecker checker =
                selectedChecker ?? _defaultSelectedChecker;

            List<Widget> icons = [];
            if (clearable &&
                !readOnly &&
                controller.value.isNotEmpty &&
                !loading) {
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
            if (loading)
              icons.add(Padding(
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  padding: EdgeInsets.only(right: 10)));

            if (!loading) {
              icons.add(Icon(
                Icons.arrow_drop_down,
              ));
            }

            Widget widget;

            if (controller.value.isNotEmpty) {
              SelectedItemRender render =
                  selectedItemRender ?? _defaultSelectedItemRender;
              if (!multi) {
                widget = render(controller.value[0], multi, readOnly || loading,
                    themeData, formThemeData);
              } else {
                List value = List.from(controller.value);
                if (selectedSorter != null) selectedSorter(value);
                widget = Wrap(
                    children: value.map((item) {
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
                    child: render(item, multi, readOnly || loading, themeData,
                        formThemeData),
                  );
                }).toList());
              }
            }
            FormController formController = FormController.of(field.context);

            final InputDecoration effectiveDecoration = InputDecoration(
                contentPadding: multi ? EdgeInsets.zero : null,
                labelText: labelText,
                hintText: hintText,
                suffixIcon: Row(
                  children: icons,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                )).applyDefaults(
              themeData.inputDecorationTheme,
            );

            Widget child = Focus(
                focusNode: focusNode,
                canRequestFocus: true,
                skipTraversal: true,
                child: Builder(
                    builder: (context) => InkWell(
                          onTap: (readOnly ||
                                  loading ||
                                  selectItemProvider == null)
                              ? null
                              : () async {
                                  List selected = await Navigator.of(
                                          field.context,
                                          rootNavigator: true)
                                      .push(MaterialPageRoute<List>(
                                          settings: RouteSettings(
                                              arguments: controller._key),
                                          builder: (BuildContext context) {
                                            return _SelectorDialog(_Arguments(
                                                formController,
                                                selectItemRender,
                                                checker,
                                                controller.value,
                                                selectItemProvider,
                                                multi));
                                          },
                                          fullscreenDialog: true));
                                  if (selected != null) {
                                    field.didChange(selected);
                                    focusNode.requestFocus();
                                  }
                                },
                          child: InputDecorator(
                            decoration: effectiveDecoration.copyWith(
                                errorText: field.errorText),
                            isEmpty: controller.value.isEmpty,
                            isFocused: Focus.of(context).hasFocus,
                            child: widget,
                          ),
                        )));
            return Padding(
              child: child,
              padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  _SelectorFormFieldState createState() => _SelectorFormFieldState();
}

class _SelectorFormFieldState extends FormBuilderFieldState<List> {
  UniqueKey get dialogKey => (widget.controller as SelectorController)._key;

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

class _Arguments {
  final FormController formController;
  final SelectItemRender selectItemRender;
  final SelectedChecker selectedChecker;
  final List selected;
  final SelectItemProvider provider;
  final bool multi;
  _Arguments(this.formController, this.selectItemRender, this.selectedChecker,
      this.selected, this.provider, this.multi);
}

class _SelectorDialog extends StatefulWidget {
  final _Arguments arguments;

  FormController get formController => arguments.formController;
  List get selected => arguments.selected;
  SelectedChecker get selectedChecker => arguments.selectedChecker;
  SelectItemRender get selectItemRender => arguments.selectItemRender;
  SelectItemProvider get selectItemProvider => arguments.provider;
  bool get multi => arguments.multi;

  const _SelectorDialog(this.arguments, {Key key}) : super(key: key);
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

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selected);
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

  Widget buildView(ThemeData themeData) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (items.length < count &&
            !loading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          page++;
          update(() {
            loading = true;
          });
          widget.selectItemProvider(page).then((value) {
            items.addAll(value.items);
            count = value.count;
            loading = false;
          }).onError((err, stackTrace) {
            page--;
            loading = false;
            error = true;
          }).whenComplete(() {
            update(() {});
          });
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

    if (page == 1 && items.isEmpty) {
      columns.add(FutureBuilder(
          future: widget.selectItemProvider(1),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SelectItemPage page = snapshot.data;
              count = page.count;
              items.addAll(page.items);
              return Expanded(child: buildView(themeData));
            }
            return Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: snapshot.hasError
                        ? Icon(
                            Icons.error,
                            color: themeData.errorColor,
                            size: 50,
                          )
                        : CircularProgressIndicator())
              ],
            ));
          }));
    } else {
      columns.add(Expanded(child: buildView(themeData)));
    }

    if (loading || error) {
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

    return Theme(
      data: themeData,
      child: Scaffold(
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
          body: Padding(
              padding: EdgeInsets.all(20),
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
