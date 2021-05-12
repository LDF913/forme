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

class RateFormField extends BaseValueField<double> {
  RateFormField({
    ValueChanged<double?>? onChanged,
    FormFieldValidator<double>? validator,
    AutovalidateMode? autovalidateMode,
    double? initialValue,
    String? labelText,
    FormFieldSetter<double>? onSaved,
    String? name,
    int flex = 1,
    bool visible = true,
    bool readOnly = false,
    EdgeInsets? padding,
    double iconSize = 36,
    EdgeInsets? iconPading,
    RateTransfer? transfer,
    int? ratio,
  }) : super(
          {
            'labelText': StateValue<String?>(labelText),
            'iconSize': StateValue<double>(iconSize),
            'iconPadding': StateValue<EdgeInsets?>(iconPading),
            'ratio': StateValue<int?>(ratio),
          },
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
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            double size = stateMap['iconSize'];
            EdgeInsets iconPadding = stateMap['iconPadding'] ??
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10);
            int ratio = stateMap['ratio'] ?? 1;
            String? labelText = stateMap['labelText'];
            double? value = (state.value?.toDouble() ?? 0) / ratio;

            ThemeData themeData = Theme.of(state.context);

            List<Widget> icons = [];
            for (int i = 0; i < 5; i++) {
              double rate = value - i;
              if (rate < 0) rate = 0;
              icons.add(Padding(
                child: _RateIcon(
                  icon: Icons.star,
                  size: size,
                  color: readOnly
                      ? themeData.disabledColor
                      : themeData.primaryColor,
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
