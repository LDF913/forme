import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'base_page.dart';

class DropdownButtonFieldPage
    extends BasePage<String, FormeDropdownButtonModel> {
  @override
  Widget get body {
    return Column(
      children: [
        FormeTextFieldOnTapProxyWidget(
          child: FormeDropdownButton<String>(
            items: [],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            model: FormeDropdownButtonModel(
              decoration: InputDecoration(labelText: 'dropdown'),
            ),
            validator: (value) => value == null ? 'pls select one item!' : null,
          ),
        ),
        Wrap(
          children: [
            createButton('load items', () async {
              controller.updateModel(FormeDropdownButtonModel<String>(
                  icon: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(),
              )));
              Future<List<DropdownMenuItem<String>>> future =
                  Future.delayed(Duration(seconds: 2), () {
                return FormeUtils.toDropdownMenuItems(
                    ['java', 'dart', 'c#', 'python', 'flutter']);
              });
              future.then((value) {
                controller.updateModel(FormeDropdownButtonModel<String>(
                    icon: Icon(Icons.arrow_drop_down), items: value));
              });
            }),
            createButton('update labelText', () async {
              controller.updateModel(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  labelText: 'New Label Text',
                ),
              ));
            }),
            createButton('update labelStyle', () {
              controller.updateModel(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 30, color: Colors.pinkAccent),
                ),
              ));
            }),
            createButton('update style', () {
              controller.updateModel(FormeDropdownButtonModel<String>(
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              ));
            }),
            createButton('set helper text', () {
              controller.updateModel(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  helperText: 'helper text',
                ),
              ));
            }),
            createButton('set prefix icon', () {
              controller.updateModel(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_drop_down_circle),
                    onPressed: () {
                      controller.value = 'flutter';
                    },
                  ),
                ),
              ));
            }),
            createButton('set suffix icon', () {
              controller.updateModel(FormeDropdownButtonModel<String>(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      controller.value = null;
                    },
                  ),
                ),
              ));
            }),
            createButton('validate', () {
              controller.validate();
            }),
            Builder(builder: (context) {
              return createButton('quietly validate', () {
                String? error = controller.quietlyValidate();
                if (error != null) showError(context, error);
              });
            }),
          ],
        )
      ],
    );
  }

  @override
  String get title => 'FormeDropdown';
}
