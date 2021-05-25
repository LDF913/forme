import 'package:flutter/material.dart';

import '../forme_field.dart';
import '../forme_state_model.dart';
import 'forme_decoration.dart';

/// used to transfer rate to your rate
///
/// param rate is a double value depends on users tap,it's value is (0,1)
/// default transfer is
/// ``` dart
/// (rate) => rate > 0.5 ? 1 : 0.5;
/// ```
///
/// **return value must be in [0,1]**
typedef FormeRateTransfer = double Function(double rate);

class FormeRate extends ValueField<double, FormeRateModel> {
  FormeRate({
    ValueChanged<double?>? onChanged,
    FormFieldValidator<double>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    FormFieldSetter<double>? onSaved,
    String? name,
    bool readOnly = false,
    FormeRateTransfer? transfer,
    int ratio = 1,
    FormeRateModel? model,
    Key? key,
  }) : super(
          key: key,
          model: model ?? FormeRateModel(),
          readOnly: readOnly,
          name: name,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            bool readOnly = state.readOnly;
            ThemeData themeData = Theme.of(state.context);
            FormeRateRenderData rateThemeData =
                state.model.rateRenderData ?? const FormeRateRenderData();
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

            return FormeDecoration(
              formeDecorationFieldRenderData:
                  state.model.formeDecorationFieldRenderData,
              child: rateWidget,
              errorText: state.errorText,
              focusNode: state.focusNode,
              labelText: state.model.labelText,
              helperText: state.model.helperText,
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

class FormeRateRenderData {
  final IconData icon;
  final double iconSize;
  final Color? seletedColor;
  final Color? disabledColor;
  final EdgeInsets iconPadding;

  const FormeRateRenderData({
    this.icon = Icons.star,
    this.iconSize = 36,
    this.seletedColor,
    this.disabledColor,
    this.iconPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });
}

class FormeRateModel extends FormeModel {
  final String? labelText;
  final String? helperText;
  final FormeRateRenderData? rateRenderData;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  FormeRateModel({
    this.labelText,
    this.helperText,
    this.rateRenderData,
    this.formeDecorationFieldRenderData,
  });

  @override
  FormeRateModel copyWith({
    Optional<String>? labelText,
    Optional<String>? helperText,
    Optional<FormeRateRenderData>? rateRenderData,
    Optional<FormeDecorationRenderData>? formeDecorationFieldRenderData,
  }) {
    return FormeRateModel(
      labelText: Optional.copyWith(labelText, this.labelText),
      helperText: Optional.copyWith(helperText, this.helperText),
      rateRenderData: Optional.copyWith(rateRenderData, this.rateRenderData),
      formeDecorationFieldRenderData: Optional.copyWith(
          formeDecorationFieldRenderData, this.formeDecorationFieldRenderData),
    );
  }
}
