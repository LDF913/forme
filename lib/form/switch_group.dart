import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'form_theme.dart';

class SwitchGroupController extends ValueNotifier<List<int>> {
  SwitchGroupController({value}) : super(value);
  List<int> get value => super.value == null ? [] : super.value;
  void set(List<int> value) =>
      super.value = value == null ? [] : List.of(value);
}

class SwitchGroup extends FormField {
  final SwitchGroupController controller;
  final List<String> items;
  final String label;
  final String controlKey;
  final ValueChanged onChanged;
  final EdgeInsets padding;
  final bool readOnly;
  final bool hasSelectAllSwitch;

  SwitchGroup(this.controlKey,
      {Key key,
      this.controller,
      this.label,
      this.items = const ['1', '2', '3'],
      this.onChanged,
      FormFieldValidator<List<int>> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      this.readOnly = false,
      this.hasSelectAllSwitch = true})
      : assert(controlKey != null, items != null),
        super(
          key: key,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            final _SwitchGroupState state = field as _SwitchGroupState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);
            List<int> indexs =
                List<int>.generate(items.length, (index) => index);
            bool selectAll = listEquals(indexs, controller.value);

            void onChangeValue(List<int> value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            void changeValue(int index) {
              List<int> value = controller.value;
              if (value.contains(index)) {
                value.remove(index);
              } else {
                value.add(index);
              }
              onChangeValue(value);
            }

            void toggleValues() {
              if (selectAll) {
                onChangeValue([]);
              } else {
                onChangeValue(indexs);
              }
            }

            List<Widget> columns = [];
            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style:
                      FormThemeData.getLabelStyle(themeData, state.hasError));
              columns.add(Padding(
                padding: formThemeData.labelPadding ?? EdgeInsets.zero,
                child: Row(
                  children: [Flexible(child: text)],
                ),
              ));
            }

            if (items.length > 1 && hasSelectAllSwitch) {
              columns.add(InkWell(
                child: Padding(
                  child: Row(
                    children: [
                      Expanded(child: Text('全选')),
                      CupertinoSwitch(
                        value: selectAll,
                        onChanged: readOnly
                            ? null
                            : (value) {
                                toggleValues();
                              },
                        activeColor: themeData.primaryColor,
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onTap: readOnly ? null : toggleValues,
              ));
              columns.add(Divider());
            }

            for (int i = 0; i < items.length; i++) {
              String item = items[i];
              columns.add(InkWell(
                child: Padding(
                  child: Row(
                    children: [
                      Expanded(child: Text(item)),
                      CupertinoSwitch(
                        value: controller.value.contains(i),
                        onChanged: readOnly
                            ? null
                            : (value) {
                                changeValue(i);
                              },
                        activeColor: themeData.primaryColor,
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                ),
                onTap: readOnly
                    ? null
                    : () {
                        changeValue(i);
                      },
              ));
            }

            return Padding(
              child: Column(
                children: columns,
              ),
              padding: formThemeData.padding ?? padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  _SwitchGroupState createState() => _SwitchGroupState();
}

class _SwitchGroupState extends FormFieldState {
  @override
  SwitchGroup get widget => super.widget as SwitchGroup;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(dynamic value) {
    super.didChange(value);
    if (widget.controller.value != value) widget.controller.value = value ?? [];
  }

  @override
  void reset() {
    widget.controller.value = [];
    super.reset();
  }

  void _handleControllerChanged() {
    if (widget.controller.value != value)
      didChange(widget.controller.value);
    else
      setState(() {});
  }
}
