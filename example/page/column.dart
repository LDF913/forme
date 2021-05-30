import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class ColumnPage extends StatelessWidget {
  final String name = 'row';
  final FormeKey formKey = FormeKey();

  FormeFieldManagement<FormeFlexModel> get management => formKey.field(name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Column'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Forme(
                child: FormeColumn(
                  name: name,
                  children: [],
                ),
                key: formKey,
              ),
              Wrap(
                children: [
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: TextButton.icon(
                        onPressed: () {
                          FormeFlexModel model = management.model;
                          if (!formKey.hasField('row1')) {
                            for (int i = 0; i < 10; i++) {
                              model.append(
                                FormeRow(children: [
                                  Expanded(
                                      child: FormeTextField(
                                    initialValue: '$i',
                                  )),
                                  FormeSingleCheckbox(),
                                  FormeSingleSwitch(),
                                ], name: 'row$i'),
                              );
                            }
                            management.model = model;
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text('append 10 rows'),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: TextButton.icon(
                        onPressed: () {
                          management.model = management.model.prepend(Row(
                            children: [
                              Expanded(child: FormeTextField()),
                              FormeSingleCheckbox(),
                              FormeSingleSwitch(),
                            ],
                          ));
                        },
                        icon: Icon(Icons.add),
                        label: Text('preappend a widget'),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: TextButton.icon(
                        onPressed: () {
                          management.model = management.model.swap(0, 1);
                        },
                        icon: Icon(Icons.add),
                        label: Text('swap first and second widget'),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: TextButton.icon(
                        onPressed: () {
                          management.model = management.model.remove(0);
                        },
                        icon: Icon(Icons.remove),
                        label: Text('delete first widget'),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
