import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeCupertinoPicker extends ValueField<int, FormeCupertinoPickerModel> {
  FormeCupertinoPicker({
    FormeValueChanged<int, FormeCupertinoPickerModel>? onValueChanged,
    FormFieldValidator<int>? validator,
    AutovalidateMode? autovalidateMode,
    int? initialValue,
    FormFieldSetter<int>? onSaved,
    required String name,
    bool readOnly = false,
    required double itemExtent,
    required List<Widget> children,
    FormeCupertinoPickerModel? model,
    FormeErrorChanged<
            FormeValueFieldController<int, FormeCupertinoPickerModel>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<int, FormeCupertinoPickerModel>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<int, FormeCupertinoPickerModel>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<int>? decoratorBuilder,
  }) : super(
          onInitialed: onInitialed,
          nullValueReplacement: 0,
          decoratorBuilder: decoratorBuilder,
          key: key,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          model: (model ?? FormeCupertinoPickerModel()).copyWith(
              FormeCupertinoPickerModel(
                  children: children, itemExtent: itemExtent)),
          name: name,
          readOnly: readOnly,
          onValueChanged: onValueChanged,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          onSaved: onSaved,
          builder: (baseState) {
            _FormeCupertinoPickerState state =
                baseState as _FormeCupertinoPickerState;
            bool locked = state.model.locked ?? false;
            Widget child = NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    state.requestFocus();
                    state.onScrollStatusChanged(true);
                  }
                  if (scrollNotification is ScrollEndNotification) {
                    state.onScrollStatusChanged(false);
                  }
                  return true;
                },
                child: AbsorbPointer(
                  absorbing: state.readOnly || locked,
                  child: CupertinoPicker(
                    key: state._key,
                    scrollController: state.scrollController,
                    diameterRatio: state.model.diameterRatio ?? 1.07,
                    backgroundColor: state.model.backgroundColor,
                    offAxisFraction: state.model.offAxisFraction ?? 0.0,
                    useMagnifier: state.model.useMagnifier ?? false,
                    magnification: state.model.magnification ?? 1.0,
                    squeeze: state.model.squeeze ?? 1.45,
                    looping: state.model.looping ?? false,
                    selectionOverlay: state.model.selectionOverlay ??
                        const CupertinoPickerDefaultSelectionOverlay(),
                    itemExtent: state.model.itemExtent!,
                    onSelectedItemChanged: (index) => state.index = index,
                    children: state.model.children!,
                  ),
                ));

            return Focus(
              focusNode: state.focusNode,
              child: AspectRatio(
                aspectRatio: state.model.aspectRatio ?? 3,
                child: child,
              ),
            );
          },
        );

  @override
  _FormeCupertinoPickerState createState() => _FormeCupertinoPickerState();
}

class _FormeCupertinoPickerState
    extends ValueFieldState<int, FormeCupertinoPickerModel> {
  late FixedExtentScrollController scrollController;

  late int index;
  UniqueKey _key = UniqueKey();
  VoidCallback? action;
  bool scrolling = false;

  @override
  void afterInitiation() {
    super.afterInitiation();
    scrollController =
        FixedExtentScrollController(initialItem: initialValue ?? 0);
  }

  @override
  void onValueChanged(int? value) {
    scrollController.jumpToItem(value!);
  }

  void onScrollStatusChanged(bool scrolling) {
    this.scrolling = scrolling;
    if (!scrolling) {
      if (action != null) {
        action!();
        action = null;
      } else {
        didChange(index);
      }
    }
  }

  @override
  FormeCupertinoPickerModel beforeUpdateModel(
      FormeCupertinoPickerModel old, FormeCupertinoPickerModel current) {
    bool updateChildren = current.children != null &&
        !FormeUtils.compare(old.children, current.children);
    bool rebuild = updateChildren ||
        (current.itemExtent != null && current.itemExtent != old.itemExtent) ||
        (current.selectionOverlay != null &&
            current.selectionOverlay != old.selectionOverlay);

    if (rebuild) {
      if (this.scrolling) {
        action = () {
          setState(() {
            if (updateChildren) {
              didChange(0);
            } else {
              didChange(index);
            }
            scrollController.dispose();
            scrollController = FixedExtentScrollController(initialItem: value!);
            _key = UniqueKey();
            setModel(current.copyWith(old));
          });
        };
        return old;
      }

      scrollController.dispose();
      scrollController = FixedExtentScrollController(initialItem: value!);
      _key = UniqueKey();
    }

    return current;
  }

  @override
  FormeCupertinoPickerModel beforeSetModel(
      FormeCupertinoPickerModel old, FormeCupertinoPickerModel current) {
    if (current.children == null || current.itemExtent == null) {
      current = current.copyWith(FormeCupertinoPickerModel(
        children: old.children,
        itemExtent: old.itemExtent,
      ));
    }
    return beforeUpdateModel(old, current);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    scrollController.jumpToItem(value ?? 0);
  }
}

class FormeCupertinoPickerModel extends FormeModel {
  final double? itemExtent;
  final double? diameterRatio;
  final Color? backgroundColor;
  final double? offAxisFraction;
  final bool? useMagnifier;
  final double? magnification;
  final double? squeeze;
  final Widget? selectionOverlay;
  final List<Widget>? children;
  final bool? looping;
  final double? aspectRatio;
  final bool? locked;

  FormeCupertinoPickerModel({
    this.diameterRatio,
    this.backgroundColor,
    this.offAxisFraction,
    this.useMagnifier,
    this.magnification,
    this.squeeze,
    this.itemExtent,
    this.selectionOverlay,
    this.children,
    this.looping,
    this.aspectRatio,
    this.locked,
  });

  @override
  FormeCupertinoPickerModel copyWith(FormeModel oldModel) {
    FormeCupertinoPickerModel old = oldModel as FormeCupertinoPickerModel;
    return FormeCupertinoPickerModel(
      children: children ?? old.children,
      itemExtent: itemExtent ?? old.itemExtent,
      diameterRatio: diameterRatio ?? old.diameterRatio,
      backgroundColor: backgroundColor ?? old.backgroundColor,
      offAxisFraction: offAxisFraction ?? old.offAxisFraction,
      useMagnifier: useMagnifier ?? old.useMagnifier,
      magnification: magnification ?? old.magnification,
      squeeze: squeeze ?? old.squeeze,
      selectionOverlay: selectionOverlay ?? old.selectionOverlay,
      looping: looping ?? old.looping,
      aspectRatio: aspectRatio ?? old.aspectRatio,
      locked: locked ?? old.locked,
    );
  }
}
