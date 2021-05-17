import 'package:flutter/material.dart';

import '../form_field.dart';
import '../state_model.dart';
import 'decoration_field.dart';

/// used to transfer rate to your rate
///
/// param rate is a double value depends on users tap,it's value is (0,1)
/// default transfer is
/// ``` dart
/// (rate) => rate > 0.5 ? 1 : 0.5;
/// ```
///
/// **return value must be in [0,1]**
typedef RateTransfer = double Function(double rate);

class RateFormField extends BaseValueField<double, RateModel> {
  RateFormField({
    ValueChanged<double?>? onChanged,
    FormFieldValidator<double>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    FormFieldSetter<double>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    RateTransfer? transfer,
    int ratio = 1,
    String? labelText,
    RateThemeData? rateThemeData,
    WidgetWrapper? wrapper,
  }) : super(
          model: RateModel(labelText: labelText, rateThemeData: rateThemeData),
          visible: visible,
          readOnly: readOnly,
          flex: flex,
          padding: padding,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          wrapper: wrapper,
          builder: (state) {
            bool readOnly = state.readOnly;
            String? labelText = state.model.labelText;
            ThemeData themeData = Theme.of(state.context);
            RateThemeData rateThemeData =
                state.model.rateThemeData ?? const RateThemeData();
            double? value = (state.value?.toDouble() ?? 0) / ratio;
            double size = rateThemeData.iconSize;
            EdgeInsets iconPadding = rateThemeData.iconPadding;

            List<Widget> icons = [];
            for (int i = 0; i < 5; i++) {
              double rate = value - i;
              if (rate < 0) rate = 0;
              icons.add(Padding(
                child: _RateIcon(
                  icon: rateThemeData.icon,
                  size: size,
                  color: readOnly
                      ? rateThemeData.disabledColor ?? themeData.disabledColor
                      : rateThemeData.seletedColor ?? themeData.primaryColor,
                  rate: rate,
                ),
                padding: iconPadding,
              ));
            }

            double totalWidth =
                (iconPadding.left + iconPadding.right + size) * 5;

            Widget rateWidget = GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: icons,
              ),
              onTapDown: readOnly
                  ? null
                  : (detail) {
                      double dx = detail.localPosition.dx;
                      double tapRate = dx * 5 / totalWidth;
                      double rate = tapRate - tapRate ~/ 1;
                      if (rate == 0 || rate == 1) {
                        state.didChange(tapRate * ratio);
                        return;
                      }
                      double finalRate;

                      if (transfer == null) {
                        finalRate = rate > 0.5 ? 1 : 0.5;
                      } else {
                        finalRate = transfer(rate);
                      }

                      state.didChange((tapRate.floor() + finalRate) * ratio);
                      state.requestFocus();
                    },
            );

            return DecorationField(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: rateWidget,
                ),
              ),
              errorText: state.errorText,
              focusNode: state.focusNode,
              readOnly: readOnly,
              labelText: labelText,
            );
          },
        );
}

class _RateIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final double rate;

  _RateIcon(
      {required this.icon,
      required this.size,
      required this.rate,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: [0, this.rate, this.rate],
          colors: [color, color, color.withOpacity(0)],
        ).createShader(rect);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size, color: Colors.grey[300]),
      ),
    );
  }
}

class RateThemeData {
  final IconData icon;
  final double iconSize;
  final Color? seletedColor;
  final Color? disabledColor;
  final EdgeInsets iconPadding;

  const RateThemeData(
      {this.icon = Icons.star,
      this.iconSize = 36,
      this.seletedColor,
      this.disabledColor,
      this.iconPadding =
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5)});
}

class RateModel extends AbstractFieldStateModel {
  final String? labelText;
  final RateThemeData? rateThemeData;

  RateModel({this.labelText, this.rateThemeData});

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    RateModel oldModel = old as RateModel;
    return RateModel(
        labelText: labelText ?? oldModel.labelText,
        rateThemeData: rateThemeData ?? oldModel.rateThemeData);
  }
}
