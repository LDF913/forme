import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/59123469/how-to-shake-a-widget-in-flutter-on-invalid-input
class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;
  final VoidCallback? onEnd;

  const ShakeWidget({
    Key? key,
    Duration? duration,
    double? deltaX,
    Curve? curve,
    required this.child,
    this.onEnd,
  })  : this.duration = duration ?? const Duration(milliseconds: 500),
        this.deltaX = deltaX ?? 50,
        this.curve = curve ?? Curves.bounceOut,
        super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      onEnd: onEnd,
      builder: (context, animation, child) {
        return Transform.translate(
          offset: Offset(deltaX * shake(animation), 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
