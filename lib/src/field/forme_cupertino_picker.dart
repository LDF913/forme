import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forme_core.dart';
import '../forme_management.dart';
import '../forme_state_model.dart';
import 'forme_decoration.dart';
import '../forme_field.dart';

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
    Widget? suffixIcon,
    Key? key,
  }) : super(
          key: key,
          model: (model ?? FormeCupertinoPickerModel())
              .copyWith(children: children, itemExtent: itemExtent),
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
            bool locked = state.model.locked ?? false;
            Widget child = NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {}
                  if (scrollNotification is ScrollStartNotification) {
                    state.requestFocus();
                  }
                  if (scrollNotification is ScrollEndNotification) {
                    state.didChange(state.scrollController.selectedItem);
                  }
                  return true;
                },
                child: AbsorbPointer(
                    absorbing: state.readOnly || locked,
                    child: CupertinoPicker(
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
              icon: suffixIcon,
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
  late FixedExtentScrollController scrollController;

  @override
  void afterSetInitialValue() {
    scrollController = FixedExtentScrollController(initialItem: initialValue!);
  }

  @override
  void afterValueChanged(num? oldValue, num? current) {
    scrollController.jumpToItem(super.value);
  }

  @override
  void beforeUpdateModel(
      FormeCupertinoPickerModel old, FormeCupertinoPickerModel current) {
    if (current.children != null) {
      int max = current.children!.length - 1;
      if (value > max) {
        setValue(max);
        scrollController.jumpToItem(max);
      }
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
  final String? labelText;
  final String? helperText;
  final double? aspectRatio;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;
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
    this.labelText,
    this.aspectRatio,
    this.formeDecorationFieldRenderData,
    this.helperText,
    this.locked,
  });

  @override
  FormeCupertinoPickerModel copyWith({
    double? itemExtent,
    Optional<double>? diameterRatio,
    Optional<Color>? backgroundColor,
    Optional<double>? offAxisFraction,
    bool? useMagnifier,
    Optional<double>? magnification,
    Optional<double>? squeeze,
    Optional<Widget>? selectionOverlay,
    List<Widget>? children,
    bool? looping,
    Optional<String>? labelText,
    Optional<String>? helperText,
    Optional<double>? aspectRatio,
    Optional<FormeDecorationRenderData>? formeDecorationFieldRenderData,
    bool? locked,
  }) {
    return FormeCupertinoPickerModel(
      itemExtent: itemExtent ?? this.itemExtent,
      diameterRatio: Optional.copyWith(diameterRatio, this.diameterRatio),
      backgroundColor: Optional.copyWith(backgroundColor, this.backgroundColor),
      offAxisFraction: Optional.copyWith(offAxisFraction, this.offAxisFraction),
      useMagnifier: useMagnifier ?? useMagnifier,
      magnification: Optional.copyWith(magnification, this.magnification),
      squeeze: Optional.copyWith(squeeze, this.squeeze),
      selectionOverlay:
          Optional.copyWith(selectionOverlay, this.selectionOverlay),
      children: children ?? this.children,
      looping: looping ?? looping,
      labelText: Optional.copyWith(labelText, this.labelText),
      helperText: Optional.copyWith(helperText, this.helperText),
      aspectRatio: Optional.copyWith(aspectRatio, this.aspectRatio),
      formeDecorationFieldRenderData: Optional.copyWith(
          formeDecorationFieldRenderData, this.formeDecorationFieldRenderData),
      locked: locked ?? locked,
    );
  }
}

/// a lock button used to enable|disable picker scroll
class FormeCupertinoPickerLockButton extends StatelessWidget {
  final Widget lockedButton;
  final Widget unlockedButton;

  const FormeCupertinoPickerLockButton({
    Key? key,
    this.lockedButton = const Icon(Icons.lock),
    this.unlockedButton = const Icon(Icons.lock_open),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FormeFieldManagement formeFieldManagement =
        FormeFieldManagement.of(context);
    FormeCupertinoPickerModel oldModel =
        formeFieldManagement.model as FormeCupertinoPickerModel;
    bool locked = oldModel.locked ?? false;
    return IconButton(
        icon: locked ? lockedButton : unlockedButton,
        onPressed: formeFieldManagement.readOnly
            ? null
            : () {
                formeFieldManagement.model = oldModel.copyWith(
                  locked: !locked,
                );
              });
  }
}
