import 'package:flutter/material.dart';
import '../form_builder.dart';
import 'builder.dart';
import 'form_theme.dart';

class RadioGroupItem<T> extends CheckboxGroupItem {
  final T value;

  RadioGroupItem(
      {String? label,
      required this.value,
      Widget? secondary,
      Widget? title,
      bool readOnly = false,
      bool visible = true,
      ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
      bool ignoreSplit = false,
      EdgeInsets? padding})
      : super(
            secondary: secondary,
            label: label,
            title: title,
            readOnly: readOnly,
            visible: visible,
            controlAffinity: controlAffinity,
            ignoreSplit: ignoreSplit);
}

class RadioGroupFormField<T> extends ValueField<T> {
  RadioGroupFormField(
      {required List<RadioGroupItem<T>> items,
      String? label,
      ValueChanged? onChanged,
      FormFieldValidator? validator,
      AutovalidateMode? autovalidateMode,
      int split = 2,
      dynamic initialValue,
      EdgeInsets? errorTextPadding})
      : super(
          {
            'label': TypedValue<String?>(label),
            'split': TypedValue<int>(split),
            'items': TypedValue<List<RadioGroupItem>>(items),
            'errorTextPadding':
                TypedValue<EdgeInsets>(errorTextPadding ?? EdgeInsets.all(8))
          },
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          builder:
              (state, context, readOnly, stateMap, themeData, formThemeData) {
            bool inline = state.inline;
            String? label = inline ? null : stateMap['label'];
            int split = inline ? 0 : stateMap['split'];
            List<RadioGroupItem> items = stateMap['items'];
            EdgeInsets errorTextPadding = stateMap['errorTextPadding'];

            List<Widget> widgets = [];
            if (label != null) {
              Text text = Text(label,
                  textAlign: TextAlign.left,
                  style:
                      FormThemeData.getLabelStyle(themeData, state.hasError));
              widgets.add(Padding(
                padding: formThemeData.labelPadding ?? EdgeInsets.zero,
                child: text,
              ));
            }

            List<Widget> wrapWidgets = [];

            void changeValue(dynamic value) {
              if (value != state.value) {
                state.didChange(value);
              }
            }

            for (int i = 0; i < items.length; i++) {
              RadioGroupItem item = items[i];
              bool isReadOnly = readOnly || item.readOnly;

              if (split > 0) {
                double factor = 1 / split;
                if (factor == 1) {
                  wrapWidgets.add(RadioListTile<T>(
                    dense: true,
                    contentPadding: item.padding,
                    activeColor: themeData.primaryColor,
                    controlAffinity: item.controlAffinity,
                    secondary: item.secondary,
                    value: item.value,
                    groupValue: state.value,
                    onChanged: isReadOnly
                        ? null
                        : (g) {
                            changeValue(item.value);
                          },
                    title: item.title,
                  ));
                  continue;
                }
              }

              Radio radio = Radio<T>(
                  activeColor: themeData.primaryColor,
                  value: item.value,
                  groupValue: state.value,
                  onChanged: isReadOnly
                      ? null
                      : (v) {
                          changeValue(item.value);
                        });

              Widget title = split == 0
                  ? item.title
                  : Flexible(
                      child: item.title,
                    );

              List<Widget> children;
              switch (item.controlAffinity) {
                case ListTileControlAffinity.leading:
                  children = [radio, title];
                  break;
                default:
                  children = [title, radio];
                  break;
              }

              Row radioRow = Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              );

              Widget groupItemWidget = Padding(
                padding: item.padding,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      onTap: isReadOnly
                          ? null
                          : () {
                              changeValue(i);
                            },
                      child: radioRow),
                ),
              );

              if (split <= 0) {
                wrapWidgets.add(
                    Visibility(child: groupItemWidget, visible: item.visible));
                if (item.visible && i < items.length - 1)
                  wrapWidgets.add(SizedBox(
                    width: 8.0,
                  ));
              } else {
                wrapWidgets.add(Visibility(
                  child: FractionallySizedBox(
                    widthFactor: item.ignoreSplit ? 1 : 1 / split,
                    child: groupItemWidget,
                  ),
                  visible: item.visible,
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
          },
        );

  @override
  ValueFieldState<T> createState() => ValueFieldState();
}
