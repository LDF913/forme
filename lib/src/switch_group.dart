import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../form_builder.dart';
import 'builder.dart';
import 'form_theme.dart';

class SwitchGroupItem {
  final String label;
  final bool readOnly;
  final bool visible;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  SwitchGroupItem(this.label,
      {this.readOnly = false,
      this.visible = true,
      this.textStyle,
      EdgeInsets? padding})
      : this.padding = padding ?? EdgeInsets.all(4);
}

class SwitchGroupFormField extends NonnullValueField<List<int>> {
  SwitchGroupFormField(
      {String? label,
      required List<SwitchGroupItem> items,
      bool readOnly = false,
      ValueChanged<List<int>>? onChanged,
      NonnullFieldValidator<List<int>>? validator,
      AutovalidateMode? autovalidateMode,
      bool hasSelectAllSwitch = true,
      List<int>? initialValue,
      EdgeInsets? errorTextPadding,
      EdgeInsets? selectAllPadding})
      : super(
          {
            'label': TypedValue<String>(label),
            'items': TypedValue<List<SwitchGroupItem>>(items, nullable: false),
            'hasSelectAllSwitch':
                TypedValue<bool>(hasSelectAllSwitch, nullable: false),
            'selectAllPadding': TypedValue<EdgeInsets>(
                selectAllPadding ?? const EdgeInsets.symmetric(horizontal: 4),
                nullable: false),
            'errorTextPadding': TypedValue<EdgeInsets>(
                errorTextPadding ?? const EdgeInsets.all(4),
                nullable: false),
          },
          readOnly: readOnly,
          onChanged: onChanged,
          replace: () => [],
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? List<int>.empty(),
          validator: validator,
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            String? label = stateMap['label'];
            List<SwitchGroupItem> items = stateMap['items'];
            bool hasSelectAllSwitch = stateMap['hasSelectAllSwitch'];
            EdgeInsets errorTextPadding = stateMap['errorTextPadding'];
            EdgeInsets selectAllPadding = stateMap['selectAllPadding'];

            bool isAllReadOnly = true;
            bool isAllInvisible = true;
            List<int> controllableItems = [];

            items.asMap().forEach((index, element) {
              bool readOnly = element.readOnly;
              bool visible = element.visible;
              if (!readOnly) {
                isAllReadOnly = false;
              }
              if (visible) {
                isAllInvisible = false;
              }
              if (!readOnly && visible) {
                controllableItems.add(index);
              }
            });

            List<int> value = List.of(state.value!);

            bool selectAll = controllableItems.isNotEmpty &&
                controllableItems.every((element) => value.contains(element));

            void changeValue(int index) {
              if (value.contains(index)) {
                value.remove(index);
              } else {
                value.add(index);
              }
              state.didChange(value);
            }

            void toggleValues() {
              if (selectAll) {
                state.didChange(value
                    .where((element) => !controllableItems.contains(element))
                    .toList());
              } else {
                state.didChange(value
                  ..addAll(controllableItems)
                  ..toSet()
                  ..toList());
              }
            }

            List<Widget> columns = [];

            List<Widget> headerRow = [];

            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style:
                      FormThemeData.getLabelStyle(themeData, state.hasError));
              headerRow.add(Padding(
                padding: formThemeData.labelPadding ?? EdgeInsets.zero,
                child: text,
              ));
            }

            if (items.length > 1 && hasSelectAllSwitch && !isAllInvisible) {
              headerRow.add(Spacer());
              headerRow.add(InkWell(
                child: Padding(
                  child: CupertinoSwitch(
                    value: selectAll,
                    onChanged: readOnly || isAllReadOnly
                        ? null
                        : (value) {
                            toggleValues();
                          },
                    activeColor: themeData.primaryColor,
                  ),
                  padding: selectAllPadding,
                ),
                onTap: readOnly || isAllReadOnly ? null : toggleValues,
              ));
            }

            if (headerRow.isNotEmpty) {
              columns.add(Row(
                children: headerRow,
              ));
            }

            for (int i = 0; i < items.length; i++) {
              SwitchGroupItem item = items[i];
              List<Widget> children = [];
              children.add(Expanded(
                  child: Text(
                item.label,
                style: item.textStyle,
              )));
              bool isReadOnly = readOnly || item.readOnly;
              children.add(CupertinoSwitch(
                value: value.contains(i),
                onChanged: isReadOnly
                    ? null
                    : (value) {
                        changeValue(i);
                      },
                activeColor: themeData.primaryColor,
              ));
              columns.add(Visibility(
                child: InkWell(
                  child: Padding(
                      child: Row(
                        children: children,
                      ),
                      padding: item.padding),
                  onTap: isReadOnly
                      ? null
                      : () {
                          changeValue(i);
                        },
                ),
                visible: item.visible,
              ));
            }
            if (state.hasError) {
              columns.add(Padding(
                padding: errorTextPadding,
                child: Text(state.errorText!,
                    style: FormThemeData.getErrorStyle(themeData)),
              ));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns,
            );
          },
        );

  @override
  NonnullValueFieldState<List<int>> createState() => NonnullValueFieldState();
}

class SwitchInlineFormField extends NonnullValueField<bool> {
  SwitchInlineFormField(
      {bool readOnly = false,
      ValueChanged<bool>? onChanged,
      NonnullFieldValidator<bool>? validator,
      AutovalidateMode? autovalidateMode,
      bool initialValue = false})
      : super(
          {},
          readOnly: readOnly,
          onChanged: onChanged,
          replace: () => false,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            bool value = state.value!;
            List<Widget> columns = [];
            columns.add(InkWell(
              child: Row(
                children: [
                  CupertinoSwitch(
                    value: value,
                    onChanged: readOnly
                        ? null
                        : (_) {
                            state.didChange(!value);
                          },
                    activeColor: themeData.primaryColor,
                  )
                ],
              ),
              onTap: readOnly
                  ? null
                  : () {
                      state.didChange(!value);
                    },
            ));

            if (state.hasError) {
              columns.add(Text(state.errorText!,
                  overflow: TextOverflow.ellipsis,
                  style: FormThemeData.getErrorStyle(themeData)));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns,
            );
          },
        );

  @override
  NonnullValueFieldState<bool> createState() => NonnullValueFieldState();
}
