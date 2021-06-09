import 'dart:math';

import 'package:flutter/material.dart';

import 'package:forme/forme.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final FormeKey formKey = FormeKey();

  @override
  void initState() {
    super.initState();
  }

  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  FormeChipItem<String> _buildItem(String label, Color color) {
    return FormeChipItem<String>(
      data: label,
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('form'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: createForm(),
            ),
            // for using snackbar here
            Builder(builder: (context) => createButtons(context)),
          ]),
        ));
  }

  Widget createButtons(BuildContext context) {
    Wrap buttons = Wrap(
      children: [
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  formKey.readOnly = !formKey.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(formKey.readOnly
                    ? 'set form editable'
                    : 'set form readonly'));
          },
        ),
        //sliderVisible
        Builder(builder: (context) {
          FormeFieldController controller = formKey.field('sliderVisible');
          bool visible =
              (controller.model as FormeVisibleModel).visible ?? true;
          return TextButton(
              onPressed: () {
                controller.model = FormeVisibleModel(visible: !visible);
                (context as Element).markNeedsBuild();
              },
              child: Text(
                visible ? 'hide slider' : 'show slider',
              ));
        }),
        TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('rebuild page')),
        TextButton(
            onPressed: () {
              Map<FormeValueFieldController, String> errorMap =
                  formKey.performValidate(quietly: true);
              if (errorMap.isNotEmpty) {
                MapEntry<FormeValueFieldController, String> entry =
                    errorMap.entries.first;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(entry.value),
                  backgroundColor: Colors.red,
                ));
                FormeFieldController formeFieldController = entry.key;
                formeFieldController.ensureVisible().then((value) {
                  formeFieldController.requestFocus();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('congratulations! no validate error found!'),
                  backgroundColor: Colors.green,
                ));
              }
            },
            child: Text('validate')),
        TextButton(
            onPressed: () {
              formKey.reset();
            },
            child: Text('reset')),
        TextButton(
          onPressed: () {
            print(formKey.data);
          },
          child: Text('get form data'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.append(FormeNumberField(
              name: Random.secure().nextDouble().toString(),
              model: FormeNumberFieldModel(
                textFieldModel: FormeTextFieldModel(),
              ),
            ));
          },
          child: Text('append field into dynamic column'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.prepend(FormeNumberField(
              name: Random.secure().nextDouble().toString(),
              model: FormeNumberFieldModel(
                textFieldModel: FormeTextFieldModel(
                  decoration: InputDecoration(
                    labelText: '456',
                  ),
                ),
              ),
            ));
          },
          child: Text('prepend field into dynamic column'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.swap(0, 1);
          },
          child: Text('swap first and second'),
        ),

        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.remove(0);
          },
          child: Text('remove first'),
        ),

        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.append(
              FormeRow(children: [], name: 'row'),
            );
          },
          child: Text('append a dynamic row'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model = formKey.field('row').model as FormeFlexModel;
            formKey.field('row').model = model.append(FormeSingleCheckbox(
                name: Random.secure().nextDouble().toString()));
          },
          child: Text('append field into dynamic row'),
        ),
      ],
    );
    return buttons;
  }

  Widget createForm() {
    Widget child = Column(
      children: [
        FormeTextField(
          name: 'text',
          focusListener: (field, hasFocus) {
            field.updateModel(FormeTextFieldModel(
                decoration: InputDecoration(labelText: 'Focus:$hasFocus')));
          },
          validateErrorListener: (c, e) {
            c.updateModel(FormeTextFieldModel(
              maxLines: 1,
            ));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value!.length <= 10
                ? 'length must bigger than 10,current is ${value.length} '
                : null;
          },
          model: FormeTextFieldModel(
            selectAllOnFocus: true,
            decoration: InputDecoration(
              labelText: 'Text',
              suffixIcon: Builder(
                builder: (context) {
                  return ValueListenableBuilder<FormeValidateError?>(
                    valueListenable:
                        formKey.fieldListenable('text').errorTextListenable,
                    builder: (context, focus, child) {
                      return focus == null || !focus.hasError
                          ? Icon(Icons.check)
                          : Icon(Icons.error);
                    },
                  );
                },
              ),
            ),
          ),
        ),
        FormeNumberField(
          name: 'number',
          model: FormeNumberFieldModel(
            max: 99,
            decimal: 2,
            textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(labelText: 'Number'),
            ),
          ),
        ),
        FormeDateRangeField(
          name: 'dateRange',
          model: FormeDateRangeFieldModel(
              textFieldModel: FormeTextFieldModel(
            decoration: InputDecoration(
              labelText: 'Date Range',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => formKey.valueField('dateRange').value = null,
              ),
            ),
          )),
        ),
        FormeDateTimeField(
          name: 'datetime',
          model: FormeDateTimeFieldModel(
            textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(
                labelText: 'DateTime',
                prefixIcon: Builder(
                  builder: (context) {
                    return IconButton(
                        icon: Icon(Icons.tab),
                        onPressed: () {
                          FormeValueFieldController<DateTime,
                                  FormeDateTimeFieldModel> controller =
                              FormeFieldController.of(context);
                          controller.updateModel(FormeDateTimeFieldModel(
                            type: FormeDateTimeFieldType.DateTime,
                          ));
                          toast(context,
                              'field type has been changed to DateTime');
                        });
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => formKey.valueField('datetime').value = null,
                ),
              ),
            ),
          ),
        ),
        FormeCupertinoDateField(
          name: 'cupertinoDatetime',
          model: FormeCupertinoDateFieldModel(
            type: FormeDateTimeFieldType.DateTime,
            textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(
                labelText: 'Cupertino DateTime',
                prefixIcon: Builder(
                  builder: (context) {
                    return IconButton(
                        icon: Icon(Icons.tab),
                        onPressed: () {
                          FormeValueFieldController<DateTime,
                                  FormeCupertinoDateFieldModel> controller =
                              FormeFieldController.of(context);
                          controller.updateModel(FormeCupertinoDateFieldModel(
                            type: FormeDateTimeFieldType.Date,
                          ));
                          toast(context, 'field type has been changed to Date');
                        });
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () =>
                      formKey.valueField('cupertinoDatetime').value = null,
                ),
              ),
            ),
          ),
        ),
        FormeCupertinoTimerField(
          name: 'cupertinoTimer',
          model: FormeCupertinoTimerFieldModel(
            textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(
                labelText: 'Cupertino Timer',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () =>
                      formKey.valueField('cupertinoTimer').value = null,
                ),
              ),
            ),
          ),
        ),
        FormeTimeField(
            name: 'time',
            model: FormeTimeFieldModel(
              textFieldModel: FormeTextFieldModel(
                decoration: InputDecoration(
                  labelText: 'Time',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        formKey.valueField('time').value = null;
                      }),
                ),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        FormeFilterChip(
          name: 'filterChip',
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Filter Chip')),
          items: [
            _buildItem('Gamer', Colors.cyan),
            _buildItem('Hacker', Colors.cyan),
            _buildItem('Developer', Colors.cyan),
          ],
        ),
        FormeChoiceChip(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Choice Chip')),
          name: 'choiceChip',
          items: [
            _buildItem('Gamer', Color(0xFFff6666)),
            _buildItem('Hacker', Color(0xFF007f5c)),
            _buildItem('Developer', Color(0xFF5f65d3)),
            _buildItem('Racer', Color(0xFF19ca21)),
            _buildItem('Traveller', Color(0xFF60230b)),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        FormeVisible(
          name: 'sliderVisible',
          child: FormeSlider(
            decoratorBuilder: FormeInputDecoratorBuilder(
                decoration: InputDecoration(labelText: 'Slider')),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value! < 50
                  ? 'value must bigger than 50 ,current is $value'
                  : null;
            },
            name: 'slider',
            min: 0,
            max: 100,
            model: FormeSliderModel(
              labelRender: (value) => value.round().toString(),
              sliderThemeData: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.red[700],
                inactiveTrackColor: Colors.red[100],
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Colors.redAccent,
                overlayColor: Colors.red.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.red[700],
                inactiveTickMarkColor: Colors.red[100],
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.redAccent,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        FormeRangeSlider(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Range Slider')),
          name: 'rangeSlider',
          min: 1,
          max: 100,
        ),
        FormeColumn(
          name: 'column',
          children: [],
        ),
        FormeCupertinoPicker(
            decoratorBuilder: FormeInputDecoratorBuilder(
                decoration: InputDecoration(labelText: 'Cupertino Picker')),
            validator: (value) => value! < 100
                ? 'value must bigger than 100,current is $value'
                : null,
            name: 'cupertinoPicker',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: 50,
            itemExtent: 50,
            children:
                List<Widget>.generate(1000, (index) => Text(index.toString()))),
        FormeRadioGroup<String>(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Radio Group')),
          items: FormeUtils.toFormeListTileItems(['1', '2', '3', '4'],
              style: Theme.of(context).textTheme.subtitle1),
          name: 'radioGroup',
          model: FormeRadioGroupModel(
            radioRenderData: FormeRadioRenderData(
              activeColor: Color(0xFF6200EE),
            ),
            split: 2,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => value != '2' ? 'pls select 2' : null,
        ),
        FormeListTile(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Checkbox Tile')),
          items: [
            FormeListTileItem(
                title: Text("Checkbox 1"),
                subtitle: Text("Checkbox 1 Subtitle"),
                secondary: OutlinedButton(
                  child: Text("Say Hi"),
                  onPressed: () {
                    formKey
                        .valueField('checkboxTile')
                        .decoratorController
                        .update(
                          FormeInputDecoratorModel(
                              decoration: InputDecoration(labelText: 'xxx')),
                        );
                  },
                ),
                data: 'Checkbox 1'),
            FormeListTileItem(
                title: Text("Checkbox 1"),
                subtitle: Text("Checkbox 1 Subtitle"),
                secondary: IconButton(
                  icon: Icon(Icons.ac_unit),
                  onPressed: () {},
                ),
                data: 'Checkbox 2'),
          ],
          name: 'checkboxTile',
          type: FormeListTileType.Checkbox,
          model: FormeListTileModel(
              split: 1,
              listTileRenderData: FormeListTileRenderData(
                contentPadding: EdgeInsets.zero,
              ),
              checkboxRenderData: FormeCheckboxRenderData(
                activeColor: Colors.transparent,
                checkColor: Colors.green,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )),
        ),
        FormeListTile(
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Switch Tile')),
          name: 'switchTile',
          type: FormeListTileType.Switch,
          items: FormeUtils.toFormeListTileItems(['1', '2'],
              controlAffinity: ListTileControlAffinity.trailing),
          model: FormeListTileModel(
            split: 1,
          ),
        ),
        Row(children: [
          Flexible(
            flex: 1,
            child: FormeSlider(
              decoratorBuilder: FormeInputDecoratorBuilder(
                  decoration: InputDecoration(labelText: 'Slider')),
              onChanged: (m, v) {
                formKey.valueField('test').value = v!.round();
              },
              min: 0,
              max: 100,
              name: 'testSlider',
            ),
          ),
          Expanded(
              child: FormeNumberField(
            name: 'test',
            onChanged: (m, v) {
              formKey.valueField('testSlider').value = v?.toDouble() ?? 0.0;
            },
            model: FormeNumberFieldModel(allowNegative: false, max: 100),
          ))
        ])
      ],
    );
    return Forme(
      child: child,
      key: formKey,
      onChanged: (a, b) {
        print('${a.name} ... $b');
      },
      validateErrorListener: (a, b) {
        print(b?.text);
      },
      initialValue: {
        'text': '',
        'number': null,
        'dateRange': null,
        'datetime': DateTime.now(),
        'time': TimeOfDay(hour: 12, minute: 12),
        'filterChip': <String>['Gamer'],
        'choiceChip': null,
        'slider': 40.0,
        'rangeSlider': RangeValues(1.0, 10.0),
        'switchTile': ['1'],
        'testSlider': 0.0,
        'test': null,
        'dropdown': 'Flutter'
      },
    );
  }
}
