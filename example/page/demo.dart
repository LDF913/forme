import 'dart:math';

import 'package:flutter/material.dart';

import 'package:forme/forme.dart';

import 'async_autocomplete_text.dart';
import 'cupertino_segmented_control.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final FormeKey formKey = FormeKey();
  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];
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
                  formKey.validate(quietly: true);
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
        Row(children: [
          Expanded(
            child: FormeTextField(
              name: 'text',
              onFocusChanged: (field, hasFocus) {
                field.updateModel(FormeTextFieldModel(
                    decoration: InputDecoration(labelText: 'Focus:$hasFocus')));
              },
              onErrorChanged: (c, e) {
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
          ),
          FormeSingleCheckbox(name: 'checkbox'),
          FormeSingleSwitch(name: 'switch'),
        ]),
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
        FormeTextFieldOnTapProxyWidget(
          child: FormeDateRangeField(
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
        ),
        FormeTextFieldOnTapProxyWidget(
          child: FormeDateTimeField(
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
                    onPressed: () =>
                        formKey.valueField('datetime').value = null,
                  ),
                ),
              ),
            ),
          ),
        ),
        FormeTextFieldOnTapProxyWidget(
          child: FormeCupertinoDateField(
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
                            toast(
                                context, 'field type has been changed to Date');
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
        ),
        FormeTextFieldOnTapProxyWidget(
          child: FormeCupertinoTimerField(
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
        ),
        FormeTextFieldOnTapProxyWidget(
          child: FormeTimeField(
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
            ),
          ),
        ),
        FormeDropdownButton<String>(
          items: [],
          model: FormeDropdownButtonModel<String>(
            icon: InkWell(
              child: Icon(
                Icons.local_dining,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () async {
                FormeValueFieldController controller =
                    formKey.valueField('dropdown');
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
                      icon: Row(
                        children: [
                          InkWell(
                            child: Icon(Icons.clear),
                            onTap: () {
                              formKey.valueField('dropdown').value = null;
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      items: value));
                });
              },
            ),
          ),
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Dropdown'),
              wrapper: (child) => DropdownButtonHideUnderline(
                    child: child,
                  ),
              emptyChecker: (value) => value == null),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          name: 'dropdown',
          validator: (value) => value == null ? 'pls select one item!' : null,
        ),
        SizedBox(
          height: 20,
        ),
        FormeFilterChip<String>(
          name: 'filterChip',
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration: InputDecoration(labelText: 'Filter Chip')),
          items: [
            _buildItem('Gamer', Colors.cyan),
            _buildItem('Hacker', Colors.cyan),
            _buildItem('Developer', Colors.cyan),
          ],
        ),
        FormeChoiceChip<String>(
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
        FormeCupertinoSegmentedControl<String>(
          model: FormeCupertinoSegmentedControlModel<String>(
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          decoratorBuilder: FormeInputDecoratorBuilder(
              decoration:
                  InputDecoration(labelText: 'CupertinoSegmentedControl')),
          onValueChanged: (c, v) => print('value changed,current value is $v'),
          name: 'segmentedControl',
          chidren: {
            'A': ReadOnlyWidget(
              text: 'A',
              formeKey: formKey,
              name: 'segmentedControl',
            ),
            'B': ReadOnlyWidget(
              text: 'B',
              formeKey: formKey,
              name: 'segmentedControl',
            ),
            'C': ValueListenableBuilder2<bool, FormeValidateError?>(
              formKey
                  .lazyFieldListenable('segmentedControl')
                  .readOnlyListenable,
              formKey
                  .lazyFieldListenable('segmentedControl')
                  .errorTextListenable,
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
        FormeCupertinoSlidingSegmentedControl<String>(
          decoratorBuilder: FormeInputDecoratorBuilder(
              wrapper: (child) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: child,
                  ),
              decoration: InputDecoration(
                  labelText: 'CupertinoSlidingSegmentedControl')),
          onValueChanged: (c, v) => print('value changed,current value is $v'),
          name: 'segmentedSlidingControl',
          chidren: {
            'A': ReadOnlyWidget(
              text: 'A',
              formeKey: formKey,
              name: 'segmentedSlidingControl',
            ),
            'B': ReadOnlyWidget(
              text: 'B',
              formeKey: formKey,
              name: 'segmentedSlidingControl',
            ),
            'C': ValueListenableBuilder2<bool, FormeValidateError?>(
              formKey
                  .lazyFieldListenable('segmentedSlidingControl')
                  .readOnlyListenable,
              formKey
                  .lazyFieldListenable('segmentedSlidingControl')
                  .errorTextListenable,
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
        FormeCupertinoPicker(
            decoratorBuilder: FormeInputDecoratorBuilder(
                decoration: InputDecoration(labelText: 'Cupertino Picker')),
            validator: (value) => value! < 100
                ? 'value must bigger than 100,current is $value'
                : null,
            name: 'cupertinoPicker',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            itemExtent: 50,
            children: List<Widget>.generate(1000, (index) {
              return ValueListenableBuilder<bool>(
                  valueListenable: formKey
                      .lazyFieldListenable('cupertinoPicker')
                      .readOnlyListenable,
                  builder: (context, v, child) {
                    if (v)
                      return Text(
                        index.toString(),
                        style: TextStyle(color: Colors.grey),
                      );
                    return Text(index.toString());
                  });
            })),
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
        FormeListTile<String>(
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
        FormeListTile<String>(
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
        FormeAutocompleteText<User>(
          optionsBuilder: (v) {
            if (v.text == '') {
              return Iterable.empty();
            }
            return _userOptions.where((User option) {
              return option.toString().contains(v.text.toLowerCase());
            });
          },
          decoration: InputDecoration(labelText: 'Autocomplete Text'),
          model: FormeAutocompleteTextModel<User>(
              textFieldModel: FormeTextFieldModel(maxLines: 1)),
          name: 'autocomplete',
          validator: (v) => v == null ? 'pls select one !' : null,
        ),
        FormeAsnycAutocompleteText<User>(
          optionsBuilder: (v) {
            if (v.text == '') {
              return Future.delayed(Duration.zero, () {
                return Iterable.empty();
              });
            }
            return Future.delayed(Duration(milliseconds: 800), () {
              return _userOptions.where((User option) {
                return option.toString().contains(v.text.toLowerCase());
              });
            });
          },
          model: FormeAsyncAutocompleteTextModel<User>(
              emptyOptionBuilder: (context) {
                return Text('no options found');
              },
              textFieldModel: FormeTextFieldModel(
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Async Autocomplete Text',
                    suffixIcon: IconButton(
                      onPressed: () {
                        formKey.valueField('asyncAutocomplete').value = null;
                      },
                      icon: Icon(Icons.clear),
                    )),
              )),
          name: 'asyncAutocomplete',
          validator: (v) => v == null ? 'pls select one !' : null,
        ),
        Row(children: [
          Flexible(
            flex: 1,
            child: FormeSlider(
              decoratorBuilder: FormeInputDecoratorBuilder(
                  decoration: InputDecoration(labelText: 'Slider')),
              onValueChanged: (m, v) {
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
            onValueChanged: (m, v) {
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
      onValueChanged: (a, b) {
        print('${a.name} ... value: $b');
      },
      onErrorChanged: (a, b) {
        print('${a.name} ... error: ${b?.text}');
      },
      onFocusChanged: (a, b) {
        print('${a.name} ... focus: $b');
      },
      initialValue: {
        'text': '123',
        'number': 25,
        'dateRange': DateTimeRange(
            start: DateTime.now(), end: DateTime.now().add(Duration(days: 30))),
        'datetime': DateTime.now(),
        'time': TimeOfDay(hour: 12, minute: 12),
        'filterChip': ['Gamer'],
        'choiceChip': 'Gamer',
        'slider': 40.0,
        'rangeSlider': RangeValues(1.0, 10.0),
        'switchTile': ['1'],
        'testSlider': 0.0,
        'segmentedControl': 'A',
        'segmentedSlidingControl': 'B',
        'cupertinoPicker': 70,
        'radioGroup': '1',
        'checkboxTile': ['Checkbox 2'],
        'cupertinoDatetime': DateTime.now(),
        'asyncAutocomplete': _userOptions[0],
      },
    );
  }
}
