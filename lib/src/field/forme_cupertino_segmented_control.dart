import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeCupertinoSegmentedControl<T extends Object>
    extends ValueField<T, FormeCupertinoSegmentedControlModel<T>> {
  FormeCupertinoSegmentedControl({
    required String name,
    required Map<T, Widget> chidren,
    FormeCupertinoSegmentedControlModel<T>? model,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<T>? validator,
    FormeValueChanged<T, FormeCupertinoSegmentedControlModel<T>>?
        onValueChanged,
    FormFieldSetter<T>? onSaved,
    bool readOnly = false,
    FormeErrorChanged<
            FormeValueFieldController<T,
                FormeCupertinoSegmentedControlModel<T>>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<T,
                FormeCupertinoSegmentedControlModel<T>>>?
        onFocusChanged,
    Key? key,
    FormeDecoratorBuilder<T>? decoratorBuilder,
  }) : super(
            name: name,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            onErrorChanged: onErrorChanged,
            validator: validator,
            onValueChanged: onValueChanged,
            onSaved: onSaved,
            readOnly: readOnly,
            onFocusChanged: onFocusChanged,
            key: key,
            decoratorBuilder: decoratorBuilder,
            model: (model ?? FormeCupertinoSegmentedControlModel<T>()).copyWith(
                FormeCupertinoSegmentedControlModel(children: chidren)),
            builder: (state) {
              bool readOnly = state.readOnly;
              ThemeData themeData = Theme.of(state.context);
              return Row(
                children: [
                  Expanded(
                      child: Focus(
                    focusNode: state.focusNode,
                    child: AbsorbPointer(
                      absorbing: readOnly,
                      child: CupertinoSegmentedControl<T>(
                          groupValue: state.value,
                          children: state.model.children!,
                          unselectedColor: readOnly
                              ? state.model.disableUnselectedColor
                              : state.model.unselectedColor,
                          selectedColor: readOnly
                              ? state.model.disableSelectedColor ??
                                  themeData.disabledColor
                              : state.model.selectedColor,
                          borderColor: readOnly
                              ? state.model.disableBorderColor ??
                                  themeData.disabledColor
                              : state.model.borderColor,
                          pressedColor: state.model.pressedColor,
                          padding: state.model.padding,
                          onValueChanged: (v) {
                            state.didChange(v);
                            state.requestFocus();
                          }),
                    ),
                  ))
                ],
              );
            });

  @override
  _FormeCupertinoSegmentedControlState<T> createState() =>
      _FormeCupertinoSegmentedControlState();
}

class _FormeCupertinoSegmentedControlState<T>
    extends ValueFieldState<T, FormeCupertinoSegmentedControlModel<T>> {
  @override
  FormeCupertinoSegmentedControlModel<T> beforeUpdateModel(
      FormeCupertinoSegmentedControlModel<T> old,
      FormeCupertinoSegmentedControlModel<T> current) {
    if (current.children != null &&
        value != null &&
        !current.children!.containsKey(value)) {
      setValue(null);
    }
    return super.beforeUpdateModel(old, current);
  }

  @override
  FormeCupertinoSegmentedControlModel<T> beforeSetModel(
      FormeCupertinoSegmentedControlModel<T> old,
      FormeCupertinoSegmentedControlModel<T> current) {
    if (current.children == null || current.children!.length < 2) {
      current = current.copyWith(
          FormeCupertinoSegmentedControlModel<T>(children: old.children));
    }
    return beforeUpdateModel(old, current);
  }
}

class FormeCupertinoSegmentedControlModel<T> extends FormeModel {
  final Color? unselectedColor;
  final Color? selectedColor;
  final Color? borderColor;
  final Color? pressedColor;
  final EdgeInsetsGeometry? padding;
  final Map<T, Widget>? children;
  final Color? disableUnselectedColor;
  final Color? disableSelectedColor;
  final Color? disableBorderColor;

  FormeCupertinoSegmentedControlModel({
    this.unselectedColor,
    this.selectedColor,
    this.borderColor,
    this.pressedColor,
    this.padding,
    this.children,
    this.disableBorderColor,
    this.disableSelectedColor,
    this.disableUnselectedColor,
  });

  @override
  FormeCupertinoSegmentedControlModel<T> copyWith(FormeModel oldModel) {
    FormeCupertinoSegmentedControlModel<T> old =
        oldModel as FormeCupertinoSegmentedControlModel<T>;
    return FormeCupertinoSegmentedControlModel<T>(
      borderColor: borderColor ?? old.borderColor,
      unselectedColor: unselectedColor ?? old.unselectedColor,
      selectedColor: selectedColor ?? old.selectedColor,
      pressedColor: pressedColor ?? old.pressedColor,
      disableBorderColor: disableBorderColor ?? old.disableBorderColor,
      disableSelectedColor: disableSelectedColor ?? old.disableSelectedColor,
      disableUnselectedColor:
          disableUnselectedColor ?? old.disableUnselectedColor,
      padding: padding ?? old.padding,
      children: children ?? old.children,
    );
  }
}
