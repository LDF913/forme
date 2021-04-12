import 'dart:ui';
import 'package:flutter/material.dart';

import 'form_builder.dart';
import 'form_theme.dart';

class SelectorController extends ValueNotifier<List> {
  SelectorController({List value}) : super(value);
  List<dynamic> get value => super.value == null ? [] : super.value;
  void set(List value) => super.value == null ? [] : List.from(value);
}

class SelectorItem {
  final dynamic value;
  final String label;

  SelectorItem(this.label, this.value);
}

class SelectorFormField extends FormBuilderField<List> {
  final FocusNode focusNode;
  final bool clearable;
  final EdgeInsets padding;
  final String labelText;
  final String hintText;
  final TextStyle style;
  final double iconSize;
  final bool loading;
  final bool multi;

  SelectorFormField(String controlKey, this.focusNode, List<SelectorItem> items,
      SelectorController controller,
      {Key key,
      bool readOnly = false,
      ValueChanged<List> onChanged,
      this.clearable,
      this.labelText,
      this.hintText,
      FormFieldValidator<List> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      this.style,
      this.iconSize = 24,
      this.loading = false,
      this.multi = false,
      List initialValue})
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

            int _getIndex(dynamic value) {
              for (int i = 0; i < items.length; i++) {
                if (items[i].value == value) return i;
              }
              return null;
            }

            SelectorItem _getItem(dynamic value) {
              int index = _getIndex(value);
              if (index == null) return null;
              return items[index];
            }

            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

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
            icons.add(Icon(
              Icons.arrow_drop_down,
            ));

            Widget tags;

            if (controller.value.isNotEmpty) {
              if (!multi) {
                SelectorItem item = _getItem(controller.value[0]);
                if (item == null) {
                  tags = Padding(
                    child: Text('unknow',
                        style: TextStyle(color: themeData.errorColor)),
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                  );
                } else
                  tags = Padding(
                    child: Text(item.label),
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                  );
              } else {
                tags = Wrap(
                  children: controller.value.map((e) {
                    SelectorItem item = _getItem(e);
                    return InkWell(
                      onTap: readOnly
                          ? null
                          : () {
                              state.didChange(controller.value
                                  .where((element) => element != e)
                                  .toList());
                              focusNode.requestFocus();
                            },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Chip(
                            backgroundColor: item == null
                                ? themeData.errorColor
                                : readOnly
                                    ? themeData.primaryColor.withOpacity(0.5)
                                    : themeData.primaryColor,
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item == null ? 'unknow' : item.label,
                                  style: style ?? TextStyle(),
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
                            )),
                      ),
                    );
                  }).toList(),
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
                )).applyDefaults(
              themeData.inputDecorationTheme,
            );

            Widget child = Focus(
                focusNode: focusNode,
                canRequestFocus: true,
                skipTraversal: true,
                child: Builder(
                    builder: (context) => InkWell(
                          onTap: (readOnly || loading)
                              ? null
                              : () {
                                  _SelectableDialog(
                                    formThemeData,
                                    themeData,
                                    field.context,
                                    items.map((e) => e.label).toList(),
                                    controller.value
                                        .map((e) => _getIndex(e))
                                        .where((element) => element != null)
                                        .toList(),
                                    (indexs) {
                                      state.didChange(indexs
                                          .map((e) => items[e].value)
                                          .toList());
                                      focusNode.requestFocus();
                                    },
                                    multi: multi,
                                    title: labelText ?? hintText,
                                  ).show();
                                },
                          child: InputDecorator(
                            decoration: effectiveDecoration.copyWith(
                                errorText: field.errorText),
                            isEmpty: controller.value.isEmpty,
                            isFocused: Focus.of(context).hasFocus,
                            child: tags,
                          ),
                        )));
            return Padding(
              child: child,
              padding: padding ?? formThemeData.padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  FormBuilderFieldState<List> createState() => FormBuilderFieldState();
}

typedef _SelectedCallback = void Function(List<int> indexs);

class _SelectableDialog extends StatefulWidget {
  final bool multi;
  final List<String> items;
  final _SelectedCallback callback;
  final BuildContext context;
  final String title;
  final UniqueKey key = UniqueKey();
  final List<int> selected;
  final FormThemeData formThemeData;
  final ThemeData themeData;

  _SelectableDialog(this.formThemeData, this.themeData, this.context,
      this.items, this.selected, this.callback,
      {this.multi = false, this.title});

  @override
  State<_SelectableDialog> createState() => _SelectableDialogState();

  void show() {
    showDialog(
      barrierDismissible: true,
      context: context,
      routeSettings: RouteSettings(arguments: key),
      builder: (BuildContext context) {
        return this;
      },
    );
  }
}

class _SelectableDialogState extends State<_SelectableDialog> {
  List<int> get selected => widget.selected;
  static const EdgeInsets itemPadding = EdgeInsets.all(8);

  TextStyle labelStyle;
  TextEditingController controller;

  String filter;

  @override
  void initState() {
    super.initState();
    labelStyle =
        widget.formThemeData.checkboxGroupTheme.labelStyle ?? TextStyle();
  }

  @override
  Widget build(BuildContext context) {
    Widget dialogChild = IntrinsicWidth(
      stepWidth: 56.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTextStyle(
              style: widget.themeData.textTheme.headline6,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Semantics(
                  child: widget.title == null
                      ? null
                      : Text(
                          widget.title,
                          style: FormThemeData.getLabelStyle(
                              widget.themeData, false),
                        ),
                  namesRoute: false,
                  container: true,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _ClearableTextField((value) {
                  setState(() {
                    filter = value;
                  });
                })),
            Flexible(
              child: SingleChildScrollView(
                child: Builder(
                  builder: (context) {
                    return ListBody(children: buildWidgets(context));
                  },
                ),
              ),
            ),
            Flexible(
                child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      close();
                    },
                    child: Text('取消')),
                Spacer(),
                TextButton(
                    onPressed: () {
                      close();
                      widget.callback(selected..sort());
                    },
                    child: Text('确定'))
              ],
            ))
          ],
        ),
      ),
    );

    return Dialog(
      child: dialogChild,
    );
  }

  Widget _getCheckbox(int i) {
    return Builder(
      builder: (context) {
        String item = widget.items[i];
        if (!doFilter(item)) {
          return SizedBox.shrink();
        }
        bool isSelected = selected.contains(i);
        Color color = isSelected
            ? widget.themeData.primaryColor
            : widget.themeData.unselectedWidgetColor;
        return SimpleDialogOption(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            onPressed: () {
              toggle(i, context);
            },
            child: Padding(
              padding: itemPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSelected
                      ? Icon(Icons.check_box, color: color)
                      : Icon(Icons.check_box_outline_blank, color: color),
                  SizedBox(
                    width: 4.0,
                  ),
                  Flexible(
                    child: Text(
                      item,
                      style: labelStyle,
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  Widget _getRadio(int i, BuildContext context) {
    dynamic item = widget.items[i];
    if (!doFilter(item)) {
      return SizedBox.shrink();
    }
    bool isSelected = selected.contains(i);
    Color color = isSelected
        ? widget.themeData.primaryColor
        : widget.themeData.unselectedWidgetColor;
    return SimpleDialogOption(
      padding: EdgeInsets.symmetric(horizontal: 6),
      onPressed: () {
        toggle(i, context);
      },
      child: Padding(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: labelStyle.fontSize,
                  color: color),
              SizedBox(
                width: 4.0,
              ),
              Flexible(
                child: Text(
                  item,
                  style: labelStyle,
                ),
              )
            ],
          ),
          padding: itemPadding),
    );
  }

  List<Widget> buildWidgets(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.items.length; i++) {
      if (widget.multi) {
        widgets.add(_getCheckbox(i));
      } else {
        widgets.add(_getRadio(i, context));
      }
    }
    return widgets;
  }

  void toggle(int index, BuildContext context) {
    if (widget.multi) {
      if (selected.contains(index))
        selected.remove(index);
      else
        selected.add(index);
      (context as Element).markNeedsBuild();
    } else {
      if (!selected.contains(index)) {
        selected.clear();
        selected.add(index);
        (context as Element).markNeedsBuild();
      }
    }
  }

  void close() {
    bool isClosed = false;
    Navigator.of(context).popUntil((route) {
      if (isClosed) return true;
      if (route is DialogRoute) {
        RouteSettings settings = route.settings;
        if (settings != null && settings.arguments == widget.key) return false;
      }
      isClosed = true;
      return true;
    });
  }

  bool doFilter(String item) {
    return filter == null || filter.isEmpty || item.contains(filter);
  }
}

class _ClearableTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  _ClearableTextField(this.onChanged);

  @override
  State<StatefulWidget> createState() => _ClearableTextFieldState();
}

class _ClearableTextFieldState extends State<_ClearableTextField> {
  bool visible = false;

  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        autofocus: false,
        maxLines: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Visibility(
              visible: controller.text != '',
              child: IconButton(
                onPressed: () {
                  controller.text = '';
                  widget.onChanged('');
                },
                icon: Icon(Icons.clear),
              )),
        ),
        onChanged: widget.onChanged);
  }
}
