import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_builder.dart';
import 'form_theme.dart';

class SelectorController extends ValueNotifier<List> {
  SelectorController({List value}) : super(value);
  List<dynamic> get value => super.value == null ? [] : super.value;
  void set(List value) => super.value == null ? [] : List.from(value);

  TextEditingController _searchTextEditingController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
    _searchFocusNode.dispose();
  }
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
                          onTap: (readOnly || loading)
                              ? null
                              : () {
                                  Navigator.of(field.context,
                                          rootNavigator: true)
                                      .push(MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return SelectorDialog(
                                              formController,
                                            );
                                          },
                                          fullscreenDialog: true));
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

class SelectorDialog extends StatefulWidget {
  final FormController formController;

  const SelectorDialog(this.formController, {Key key}) : super(key: key);
  @override
  SelectorDialogState createState() => new SelectorDialogState();
}

class SelectorDialogState extends State<SelectorDialog> {
  List<String> items = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    widget.formController.addListener(update);
  }

  @override
  void dispose() {
    super.dispose();
    widget.formController.removeListener(update);
  }

  void update() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData =
        widget.formController.themeData.themeData ?? Theme.of(context);

    List<Widget> columns = [];

    columns.add(Expanded(
        child: ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_box_outline_blank,
                          color: themeData.unselectedWidgetColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(child: Text(items[index]))
                      ],
                    ),
                    padding: EdgeInsets.all(4)),
                onTap: () {},
              );
            },
            itemCount: items.length)));

    return Theme(
      data: themeData,
      child: Material(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: columns,
              ))),
    );
  }
}
