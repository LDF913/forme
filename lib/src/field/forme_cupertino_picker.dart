import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forme_state_model.dart';
import 'forme_decoration_field.dart';
import '../forme_field.dart';
import '../render/forme_render_data.dart';

class FormeCupertinoPicker
    extends NonnullValueField<int, FormeCupertinoPickerModel> {
  FormeCupertinoPicker({
    ValueChanged<int>? onChanged,
    NonnullFieldValidator<int>? validator,
    AutovalidateMode? autovalidateMode,
    required int initialValue,
    FormFieldSetter<int>? onSaved,
    String? name,
    bool readOnly = false,
    double itemExtent = 30,
    required List<Widget> children,
    FormeCupertinoPickerModel? model,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeCupertinoPickerModel()).merge(
              FormeCupertinoPickerModel(
                  children: children, itemExtent: itemExtent)),
          name: name,
          readOnly: readOnly,
          onChanged: onChanged,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          onSaved: onChanged,
          builder: (baseState) {
            _FormeCupertinoPickerState state =
                baseState as _FormeCupertinoPickerState;
            Widget child = AbsorbPointer(
                absorbing: state.readOnly,
                child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollStartNotification) {
                        state.requestFocus();
                      }
                      if (scrollNotification is ScrollEndNotification) {
                        state.doChangeValue(state.scrollController.selectedItem,
                            scrollToItem: false);
                      }
                      return true;
                    },
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
                        onSelectedItemChanged:
                            state.readOnly ? null : (index) {},
                        children: state.model.children!)));
            return FormeDecoration(
              formeDecorationFieldRenderData:
                  state.model.formeDecorationFieldRenderData,
              child: AspectRatio(
                aspectRatio: state.model.aspectRatio ?? 3,
                child: child,
              ),
              errorText: state.errorText,
              labelText: state.model.labelText,
              helperText: state.model.helperText,
              focusNode: state.focusNode,
            );
          },
        );

  @override
  _FormeCupertinoPickerState createState() => _FormeCupertinoPickerState();
}

class _FormeCupertinoPickerState
    extends NonnullValueFieldState<int, FormeCupertinoPickerModel> {
  Key? key = UniqueKey();
  FixedExtentScrollController scrollController = FixedExtentScrollController();

  @override
  void doChangeValue(int? value,
      {bool trigger = true, bool scrollToItem = true}) {
    super.doChangeValue(value, trigger: trigger);
    if (scrollToItem) scrollController.jumpToItem(super.value);
  }

  @override
  void beforeMerge(
      FormeCupertinoPickerModel old, FormeCupertinoPickerModel current) {
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

class FormeCupertinoPickerModel extends AbstractFormeModel {
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
  final String? helperText;
  final double? aspectRatio;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

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
    this.labelText,
    this.aspectRatio,
    this.formeDecorationFieldRenderData,
    this.helperText,
  });

  @override
  FormeCupertinoPickerModel merge(AbstractFormeModel old) {
    FormeCupertinoPickerModel oldModel = old as FormeCupertinoPickerModel;
    return FormeCupertinoPickerModel(
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
      helperText: helperText ?? oldModel.helperText,
      formeDecorationFieldRenderData:
          formeDecorationFieldRenderData ?? old.formeDecorationFieldRenderData,
    );
  }
}
