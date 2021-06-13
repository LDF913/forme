import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class CupertinoSegmentedControlPage
    extends BasePage<String, FormeCupertinoSegmentedControlModel<String>> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeCupertinoSegmentedControl<String>(
          model: FormeCupertinoSegmentedControlModel<String>(
            padding: const EdgeInsets.symmetric(vertical: 10),
            disableBorderColor: Colors.grey,
          ),
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration:
                  InputDecoration(labelText: 'CupertinoSegmentedControl')),
          onValueChanged: (c, v) => print('value changed,current value is $v'),
          name: name,
          chidren: {
            'A': ReadOnlyWidget(
              text: 'A',
              formeKey: formKey,
              name: name,
            ),
            'B': ReadOnlyWidget(
              text: 'B',
              formeKey: formKey,
              name: name,
            ),
            'C': ValueListenableBuilder2<bool, FormeValidateError?>(
              formKey.lazyFieldListenable(name).readOnlyListenable,
              formKey.lazyFieldListenable(name).errorTextListenable,
              child: Text('C'),
              builder: (context, r, v, child) {
                if (r)
                  return Text(
                    'C',
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  );
                if (v == null || !v.hasError) return child!;
                return ShakeWidget(
                  child: child!,
                  key: UniqueKey(),
                );
              },
            ),
          },
          validator: (v) => v == 'C' ? null : 'pls select C',
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        Wrap(
          children: [
            createButton('update children', () {
              controller
                  .updateModel(FormeCupertinoSegmentedControlModel<String>(
                children: List.generate(
                        5,
                        (index) => Text(
                              index.toString(),
                              style: TextStyle(color: Colors.green),
                            ))
                    .asMap()
                    .map((key, value) => MapEntry(key.toString(), value)),
              ));
            }),
            ValueListenableBuilder<bool>(
                valueListenable:
                    formKey.lazyFieldListenable(name).readOnlyListenable,
                builder: (context, v, child) {
                  return createButton(v ? 'editable' : 'readOnly', () {
                    controller.readOnly = !v;
                  });
                }),
            createButton('update labelText', () async {
              updateLabel();
            }),
            createButton('update labelStyle', () {
              updateLabelStyle();
            }),
            createButton('set helper text', () {
              updateHelperStyle();
            }),
            createButton('validate', () {
              controller.validate();
            }),
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeCupertinoSegmentedControl';
}

class ReadOnlyWidget extends StatelessWidget {
  final String text;
  final FormeKey formeKey;
  final String name;

  const ReadOnlyWidget(
      {Key? key,
      required this.text,
      required this.formeKey,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      child: Text(text),
      valueListenable: formeKey.lazyFieldListenable(name).readOnlyListenable,
      builder: (context, v, child) {
        if (!v) return child!;
        return Builder(
          builder: (context) {
            return Text(
              text,
              style: TextStyle(color: Theme.of(context).disabledColor),
            );
          },
        );
      },
    );
  }
}

class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}
