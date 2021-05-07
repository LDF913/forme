import 'package:flutter/material.dart';
import '../../form_builder.dart';
import '../form_field.dart';
import '../form_theme.dart';
import '../state_model.dart';

class CheckboxGroupItem {
  final Widget title;
  final bool readOnly;
  final bool visible;
  final EdgeInsets padding;

  /// not worked when split != 1
  final Widget? secondary;
  final ListTileControlAffinity controlAffinity;
  final bool ignoreSplit;
  CheckboxGroupItem(
      {String? label,
      this.secondary,
      Widget? title,
      this.readOnly = false,
      this.visible = true,
      this.controlAffinity = ListTileControlAffinity.leading,
      this.ignoreSplit = false,
      EdgeInsets? padding})
      : assert(label != null || title != null),
        this.padding = padding ?? EdgeInsets.zero,
        this.title = title == null ? Text(label!) : title;
}

class CheckboxGroupFormField extends BaseNonnullValueField<List<int>> {
  CheckboxGroupFormField({
    required List<CheckboxGroupItem> items,
    String? label,
    ValueChanged<List<int>>? onChanged,
    int split = 2,
    NonnullFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    List<int>? initialValue,
    EdgeInsets? errorTextPadding,
    NonnullFormFieldSetter<List<int>>? onSaved,
  }) : super({
          'label': StateValue<String?>(label),
          'split': StateValue<int>(split),
          'items': StateValue<List<CheckboxGroupItem>>(items),
          'errorTextPadding': StateValue<EdgeInsets>(errorTextPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8))
        },
            onChanged: onChanged,
            onSaved: onSaved,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue ?? [],
            validator: validator, builder: (state) {
          bool readOnly = state.readOnly;
          FormThemeData formThemeData = state.formThemeData;
          Map<String, dynamic> stateMap = state.currentMap;
          bool inline = state.inline;
          ThemeData themeData = formThemeData.themeData;
          String? label = inline ? null : stateMap['label'];
          int split = inline ? 0 : stateMap['split'];
          List<CheckboxGroupItem> items = stateMap['items'];
          EdgeInsets errorTextPadding = stateMap['errorTextPadding'];

          List<Widget> widgets = [];
          if (label != null) {
            Text text = Text(label,
                textAlign: TextAlign.left,
                style: FormThemeData.getLabelStyle(themeData, state.hasError));
            widgets.add(Padding(
              padding: formThemeData.labelPadding ?? EdgeInsets.zero,
              child: text,
            ));
          }

          List<Widget> wrapWidgets = [];

          void changeValue(int i) {
            if (state.value.contains(i))
              state.value.remove(i);
            else
              state.value.add(i);
            state.didChange(state.value);
          }

          for (int i = 0; i < items.length; i++) {
            CheckboxGroupItem item = items[i];
            bool isReadOnly = readOnly || item.readOnly;

            if (split > 0) {
              double factor = 1 / split;
              if (factor == 1) {
                wrapWidgets.add(CheckboxListTile(
                  dense: true,
                  contentPadding: item.padding,
                  activeColor: themeData.primaryColor,
                  controlAffinity: item.controlAffinity,
                  secondary: item.secondary,
                  value: state.value.contains(i),
                  onChanged: isReadOnly
                      ? null
                      : (g) {
                          changeValue(i);
                        },
                  title: item.title,
                ));
                continue;
              }
            }

            Checkbox checkbox = Checkbox(
                activeColor: themeData.primaryColor,
                value: state.value.contains(i),
                onChanged: isReadOnly
                    ? null
                    : (v) {
                        changeValue(i);
                      });

            Widget title = split == 0
                ? item.title
                : Flexible(
                    child: item.title,
                  );

            List<Widget> children;
            switch (item.controlAffinity) {
              case ListTileControlAffinity.leading:
                children = [checkbox, title];
                break;
              default:
                children = [title, checkbox];
                break;
            }

            Row checkBoxRow = Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            );

            Widget groupItemWidget = Padding(
              padding: item.padding,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: isReadOnly
                        ? null
                        : () {
                            changeValue(i);
                          },
                    child: checkBoxRow),
              ),
            );

            bool visible = item.visible;
            if (split <= 0) {
              wrapWidgets.add(Visibility(
                child: groupItemWidget,
                visible: visible,
              ));
              if (visible && i < items.length - 1)
                wrapWidgets.add(SizedBox(
                  width: 8.0,
                ));
            } else {
              double factor = item.ignoreSplit ? 1 : 1 / split;
              wrapWidgets.add(Visibility(
                child: FractionallySizedBox(
                  widthFactor: factor,
                  child: groupItemWidget,
                ),
                visible: visible,
              ));
            }
          }

          widgets.add(Wrap(children: wrapWidgets));

          if (state.hasError) {
            Text text = Text(state.errorText!,
                overflow: inline ? TextOverflow.ellipsis : null,
                style: FormThemeData.getErrorStyle(themeData));
            widgets.add(Padding(
              padding: errorTextPadding,
              child: text,
            ));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          );
        });
}
