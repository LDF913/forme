import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/form/text_field.dart';

import 'form_theme.dart';

class SelectorController extends ValueNotifier<List<dynamic>> {
  SelectorController({List<dynamic> value}) : super(value);
  List<dynamic> get value => super.value == null ? [] : super.value;
}

class SelectorItem {
  final dynamic value;
  final String label;
  final bool readOnly;

  SelectorItem(this.label, this.value, {this.readOnly});
}

class SelectorFormField extends FormField<List> {
  final String controlKey;
  final SelectorController controller;
  final FocusNode focusNode;
  final ValueChanged<List> onChanged;
  final List<SelectorItem> items;
  final bool clearable;
  final FormFieldValidator validator;
  final AutovalidateMode autovalidateMode;
  final EdgeInsets padding;
  final bool readOnly;
  final String labelText;
  final String hintText;
  final TextStyle style;
  final double iconSize;
  final bool loading;
  final bool multi;

  SelectorFormField(
      this.controlKey, this.controller, this.focusNode, this.items,
      {this.onChanged,
      this.clearable,
      this.labelText,
      this.hintText,
      this.validator,
      this.autovalidateMode,
      this.padding,
      this.readOnly = false,
      this.style,
      this.iconSize = 24,
      this.loading = false,
      this.multi = false})
      : super(
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            void onChangedHandler(List value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value.map((e) => e.value).toList());
              }
              focusNode.requestFocus();
            }

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
                    onChangedHandler([]);
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
            Widget tags = controller.value.isEmpty
                ? null
                : Wrap(
                    children: controller.value.map((e) {
                      SelectorItem item = _getItem(e);
                      return InkWell(
                        onTap: () {
                          onChangedHandler(controller.value
                              .where((element) => element != e)
                              .toList());
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Chip(
                              backgroundColor: item == null
                                  ? themeData.errorColor
                                  : themeData.primaryColor.withOpacity(0.6),
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
                                  Icon(
                                    Icons.clear,
                                    size: 12,
                                  )
                                ],
                              )),
                        ),
                      );
                    }).toList(),
                  );
            final InputDecoration effectiveDecoration = InputDecoration(
                labelText: labelText,
                hintText: hintText,
                suffixIcon: Row(
                  children: icons,
                  mainAxisSize: MainAxisSize.min,
                )).applyDefaults(
              themeData.inputDecorationTheme,
            );
            Widget child = Focus(
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
                                      onChangedHandler(indexs
                                          .map((e) => items[e].value)
                                          .toList());
                                    },
                                    multi: multi,
                                    title: labelText ?? hintText,
                                  ).show();
                                },
                          child: InputDecorator(
                            decoration: effectiveDecoration.copyWith(
                                errorText: field.errorText),
                            isEmpty: controller.value.isEmpty,
                            isFocused: focusNode.hasFocus,
                            child: tags ?? Text(""),
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

class _SelectorFormFieldState extends FormFieldState<List> {
  bool loaded = false;
  @override
  SelectorFormField get widget => super.widget as SelectorFormField;

  @override
  void initState() {
    widget.controller.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChanged);
    super.dispose();
  }

  @override
  void didChange(dynamic value) {
    super.didChange(value);
    if (widget.controller.value != value) widget.controller.value = value;
  }

  @override
  void reset() {
    widget.controller.value = widget.initialValue ?? [];
    super.reset();
  }

  void _handleChanged() {
    if (widget.controller.value != value) didChange(widget.controller.value);
  }
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
                padding: EdgeInsets.only(left: 20, right: 20),
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
            padding: EdgeInsets.only(left: 6),
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
      padding: EdgeInsets.only(left: 6),
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
                      : Icons.radio_button_checked_outlined,
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
        autofocus: true,
        decoration: InputDecoration(
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