import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../builder.dart';
import '../form_state_model.dart';
import 'decoration_field.dart';
import '../form_field.dart';

class CupertinoPickerFormField
    extends NonnullValueField<int, CupertinoPickerModel> {
  CupertinoPickerFormField({
    ValueChanged<int>? onChanged,
    NonnullFieldValidator<int>? validator,
    AutovalidateMode? autovalidateMode,
    required int initialValue,
    FormFieldSetter<int>? onSaved,
    String? name,
    bool readOnly = false,
    double itemExtent = 30,
    required List<Widget> children,
    CupertinoPickerModel? model,
  }) : super(
          model: (model ?? CupertinoPickerModel()).merge(
              CupertinoPickerModel(children: children, itemExtent: itemExtent)),
          name: name,
          readOnly: readOnly,
          onChanged: onChanged,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          onSaved: onChanged,
          builder: (baseState) {
            _CupertinoPickerFormFieldState state =
                baseState as _CupertinoPickerFormFieldState;
            Widget child = AbsorbPointer(
                absorbing: state.readOnly,
                child: CupertinoPicker(
                    key: state.key,
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
                    onSelectedItemChanged: state.readOnly
                        ? null
                        : (index) {
                            state.doChangeValue(index, scrollToItem: false);
                            state.requestFocus();
                          },
                    children: state.model.children!));
            return DecorationField(
              child: AspectRatio(
                aspectRatio: state.model.aspectRatio ?? 3,
                child: child,
              ),
              errorText: state.errorText,
              labelText: state.model.labelText,
              readOnly: state.readOnly,
              focusNode: state.focusNode,
            );
          },
        );

  @override
  _CupertinoPickerFormFieldState createState() =>
      _CupertinoPickerFormFieldState();
}

class _CupertinoPickerFormFieldState
    extends NonnullValueFieldState<int, CupertinoPickerModel> {
  Key? key = UniqueKey();
  FixedExtentScrollController scrollController = FixedExtentScrollController();

  @override
  void doChangeValue(int? value,
      {bool trigger = true, bool scrollToItem = true}) {
    super.doChangeValue(value, trigger: trigger);
    if (scrollToItem) scrollController.jumpToItem(super.value);
  }

  @override
  void beforeMerge(CupertinoPickerModel old, CupertinoPickerModel current) {
    bool needRebuild = current.children != null ||
        current.itemExtent != null ||
        current.selectionOverlay != null;

    if (current.children != null) {
      int max = current.children!.length - 1;
      if (value > max) {
        setValue(max);
      }
    }

    if (needRebuild) {
      key = UniqueKey();
      scrollController.dispose();
      scrollController = FixedExtentScrollController(initialItem: value);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    scrollController.jumpToItem(super.value);
  }
}

class CupertinoPickerModel extends AbstractFieldStateModel {
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
  final String? labelText;
  final double? aspectRatio;

  CupertinoPickerModel({
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
    this.labelText,
    this.aspectRatio,
  });

  @override
  CupertinoPickerModel merge(AbstractFieldStateModel old) {
    CupertinoPickerModel oldModel = old as CupertinoPickerModel;
    return CupertinoPickerModel(
      diameterRatio: diameterRatio ?? oldModel.diameterRatio,
      backgroundColor: backgroundColor ?? oldModel.backgroundColor,
      offAxisFraction: offAxisFraction ?? oldModel.offAxisFraction,
      useMagnifier: useMagnifier ?? oldModel.useMagnifier,
      magnification: magnification ?? oldModel.magnification,
      squeeze: squeeze ?? oldModel.squeeze,
      itemExtent: itemExtent ?? oldModel.itemExtent,
      selectionOverlay: selectionOverlay ?? oldModel.selectionOverlay,
      children: children ?? oldModel.children,
      looping: looping ?? oldModel.looping,
      labelText: labelText ?? oldModel.labelText,
    );
  }
}
