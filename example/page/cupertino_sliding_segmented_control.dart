import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';
import 'cupertino_segmented_control.dart';

class CupertinoSlidingSegmentedControlPage extends BasePage<String,
    FormeCupertinoSlidingSegmentedControlModel<String>> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeCupertinoSlidingSegmentedControl<String>(
          model: FormeCupertinoSlidingSegmentedControlModel<String>(),
          decoratorBuilder: FormeInputDecoratorBuilder(
              wrapper: (child) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: child,
                  ),
              decoration: InputDecoration(
                  labelText: 'CupertinoSlidingSegmentedControl')),
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
            createButton('update children', () async {
              controller.updateModel(
                  FormeCupertinoSlidingSegmentedControlModel<String>(
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
  String get title => 'FormeCupertinoSlidingSegmentedControl';
}
