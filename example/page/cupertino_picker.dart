import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class CupertinoPickerFieldPage
    extends BasePage<int, FormeCupertinoPickerModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeInputDecorator(
          name: name,
          decoration: InputDecoration(labelText: 'CupertinoPicker'),
          child: FormeCupertinoPicker(
              validator: (value) => value < 100
                  ? 'value must bigger than 100,current is $value'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validateErrorListener: (field, errorText) {
                controller.updateModel(FormeCupertinoPickerModel(
                  useMagnifier: errorText != null,
                  magnification:
                      errorText != null ? 1.0 + field.value / 100 : 1.0,
                ));
              },
              name: name,
              initialValue: 50,
              itemExtent: 50,
              children: List<Widget>.generate(
                  1000, (index) => Text(index.toString()))),
        ),
        Wrap(
          children: [
            createButton('change item extent to 30', () {
              controller.updateModel(FormeCupertinoPickerModel(itemExtent: 30));
            }),
            createButton('set children', () {
              controller.updateModel(
                FormeCupertinoPickerModel(
                    looping: true,
                    magnification: 1.2,
                    backgroundColor: Colors.black87,
                    children: <Widget>[
                      Text(
                        "TextWidget",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        color: Colors.redAccent,
                        child: MaterialButton(
                            child: Text(
                              'Button Widget',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {}),
                      ),
                      IconButton(
                        icon: Icon(Icons.home),
                        color: Colors.white,
                        iconSize: 40,
                        onPressed: () {},
                      )
                    ]),
              );
            }),
            createButton('use useMagnifier', () {
              controller.updateModel(FormeCupertinoPickerModel(
                useMagnifier: true,
                magnification: 1.3,
              ));
            }),
            createButton('update backgroundColor ', () {
              controller.updateModel(FormeCupertinoPickerModel(
                backgroundColor: Colors.purpleAccent.withOpacity(0.3),
              ));
            }),
            createButton('update selection overlay ', () {
              controller.updateModel(FormeCupertinoPickerModel(
                selectionOverlay: Container(
                  color: Colors.pink.withOpacity(0.5),
                ),
              ));
            }),
            Builder(builder: (context) {
              bool lock = controller.model.locked ?? false;
              return createButton(lock ? 'enable scroll' : 'disable scroll',
                  () {
                controller.updateModel(FormeCupertinoPickerModel(
                  locked: !lock,
                ));
                (context as Element).markNeedsBuild();
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
  String get title => 'FormeCupertinoPicker';
}
