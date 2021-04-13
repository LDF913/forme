import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'form_builder.dart';
import 'form_theme.dart';

class SwitchGroupController extends ValueNotifier<List<int>> {
  SwitchGroupController({value}) : super(value);
  List<int> get value => super.value == null ? [] : super.value;
  void set(List<int> value) =>
      super.value = value == null ? [] : List.of(value);
}

class SwitchGroupFormField extends FormBuilderField<List<int>> {
  final List<String> items;
  final String label;
  final EdgeInsets padding;
  final bool hasSelectAllSwitch;

  SwitchGroupFormField(
    String controlKey,
    SwitchGroupController controller, {
    Key key,
    this.label,
    this.items,
    bool readOnly = false,
    ValueChanged<List<int>> onChanged,
    FormFieldValidator<List<int>> validator,
    AutovalidateMode autovalidateMode,
    this.padding,
    this.hasSelectAllSwitch = true,
    List<int> initialValue,
  })  : assert(controlKey != null, items != null),
        super(
          controlKey,
          controller,
          key: key,
          onChanged: onChanged,
          replace: () => [],
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? [],
          validator: validator,
          builder: (field) {
            final FormBuilderFieldState<List<int>> state =
                field as FormBuilderFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);
            List<int> indexs =
                List<int>.generate(items.length, (index) => index);
            bool selectAll =
                indexs.every((element) => controller.value.contains(element));

            void changeValue(int index) {
              List<int> value = controller.value;
              if (value.contains(index)) {
                value.remove(index);
              } else {
                value.add(index);
              }
              state.didChange(value);
            }

            void toggleValues() {
              if (selectAll) {
                state.didChange([]);
              } else {
                state.didChange(indexs);
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
                child: text,
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
              List<Widget> children = [];
              children.add(Expanded(child: Text(item)));
              children.add(CupertinoSwitch(
                value: controller.value.contains(i),
                onChanged: readOnly
                    ? null
                    : (value) {
                        changeValue(i);
                      },
                activeColor: themeData.primaryColor,
              ));
              columns.add(InkWell(
                child: Padding(
                  child: Row(
                    children: children,
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
            if (state.hasError) {
              columns.add(Text(state.errorText,
                  style: FormThemeData.getErrorStyle(themeData)));
            }

            return Padding(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns,
              ),
              padding: formThemeData.padding ?? padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  FormBuilderFieldState<List<int>> createState() => FormBuilderFieldState();
}

class SwitchController extends ValueNotifier<bool> {
  SwitchController({value}) : super(value);
  bool get value => super.value ?? false;
}

class SwitchInlineFormField extends FormBuilderField<bool> {
  final EdgeInsets padding;

  SwitchInlineFormField(String controlKey, SwitchController controller,
      {Key key,
      bool readOnly = false,
      ValueChanged<bool> onChanged,
      FormFieldValidator<bool> validator,
      AutovalidateMode autovalidateMode,
      this.padding,
      bool initialValue})
      : assert(controlKey != null),
        super(
          controlKey,
          controller,
          key: key,
          onChanged: onChanged,
          replace: () => false,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue ?? false,
          validator: validator,
          builder: (field) {
            final FormBuilderFieldState state = field as FormBuilderFieldState;
            FormThemeData formThemeData = FormThemeData.of(field.context);
            ThemeData themeData = Theme.of(field.context);

            List<Widget> columns = [];
            columns.add(InkWell(
              child: Padding(
                child: Row(
                  children: [
                    CupertinoSwitch(
                      value: controller.value,
                      onChanged: readOnly
                          ? null
                          : (value) {
                              state.didChange(!controller.value);
                            },
                      activeColor: themeData.primaryColor,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onTap: readOnly
                  ? null
                  : () {
                      state.didChange(!controller.value);
                    },
            ));

            if (state.hasError) {
              columns.add(Text(state.errorText,
                  overflow: TextOverflow.ellipsis,
                  style: FormThemeData.getErrorStyle(themeData)));
            }

            return Padding(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns,
              ),
              padding: formThemeData.padding ?? padding ?? EdgeInsets.zero,
            );
          },
        );

  @override
  FormBuilderFieldState<bool> createState() => FormBuilderFieldState();
}
