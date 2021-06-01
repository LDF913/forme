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
          FormeFieldManagement management = formKey.field('sliderVisible');
          bool visible =
              (management.model as FormeVisibleModel).visible ?? true;
          return TextButton(
              onPressed: () {
                management.model = FormeVisibleModel(visible: !visible);
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
              formKey.validate();
            },
            child: Text('validate')),
        TextButton(
            onPressed: () {
              for (FormeFieldManagementWithError error
                  in formKey.quietlyValidate()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.errorText),
                  backgroundColor: Colors.red,
                ));
                FormeFieldManagement formeFieldManagement =
                    error.formeFieldManagement;
                formeFieldManagement.ensureVisible().then((value) {});
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('congratulations! no validate error found!'),
                backgroundColor: Colors.green,
              ));
            },
            child: Text('quietly validate')),
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
            formKey.field('row').model = model.append(FormeSingleCheckbox());
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
            field.update(FormeTextFieldModel(
                decoration: InputDecoration(labelText: 'Focus:$hasFocus')));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => value.length <= 10
              ? 'length must bigger than 10,current is ${value.length} '
              : null,
          model: FormeTextFieldModel(
            selectAllOnFocus: true,
            decoration: InputDecoration(
              labelText: 'Text',
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
        )),
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
                            FormeValueFieldManagement<DateTime,
                                    FormeDateTimeFieldModel> management =
                                FormeFieldManagement.of(context);
                            management.update(FormeDateTimeFieldModel(
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
        Row(children: [
          FormeTextFieldOnTapProxyWidget(
            child: Expanded(
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
            )),
          ),
        ]),
        SizedBox(
          height: 20,
        ),
        FormeInputDecorator(
          decoration: InputDecoration(
              labelText: 'Filter Chip', border: InputBorder.none),
          child: FormeFilterChip(
            name: 'filterChip',
            items: [
              _buildItem('Gamer', Colors.cyan),
              _buildItem('Hacker', Colors.cyan),
              _buildItem('Developer', Colors.cyan),
            ],
          ),
        ),
        FormeInputDecorator(
          decoration: InputDecoration(
            labelText: 'Choice Chip',
            border: InputBorder.none,
          ),
          child: FormeChoiceChip(
            name: 'choiceChip',
            items: [
              _buildItem('Gamer', Color(0xFFff6666)),
              _buildItem('Hacker', Color(0xFF007f5c)),
              _buildItem('Developer', Color(0xFF5f65d3)),
              _buildItem('Racer', Color(0xFF19ca21)),
              _buildItem('Traveller', Color(0xFF60230b)),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FormeVisible(
          name: 'sliderVisible',
          child: FormeInputDecorator(
            child: FormeSlider(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value < 50
                  ? 'value must bigger than 50 ,current is $value'
                  : null,
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
            decoration: InputDecoration(
              labelText: 'Slider',
              border: InputBorder.none,
            ),
          ),
        ),
        FormeInputDecorator(
          child: FormeRangeSlider(
            name: 'rangeSlider',
            min: 1,
            max: 100,
          ),
          decoration: InputDecoration(
            labelText: 'Range Slider',
            border: InputBorder.none,
          ),
        ),
        FormeColumn(
          name: 'column',
          children: [],
        ),
        FormeInputDecorator(
          decoration:
              InputDecoration(labelText: 'Radios', border: InputBorder.none),
          child: FormeRadioGroup<String>(
            items: FormeUtils.toFormeListTileItems(['1', '2', '3', '4'],
                style: Theme.of(context).textTheme.subtitle1),
            name: 'radioGroup',
            model: FormeRadioGroupModel(
              radioRenderData: FormeRadioRenderData(
                activeColor: Color(0xFF6200EE),
              ),
              split: 2,
            ),
            onChanged: (m, oldValue, newValue) => print(newValue),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != '2' ? 'pls select 2' : null,
            validateErrorListener: (field, errorText) => print(errorText),
            focusListener: (field, hasFocus) {
              print((field as FormeValueFieldManagement).errorText);
            },
          ),
        ),
        FormeInputDecorator(
          decoration: InputDecoration(
              labelText: 'Checkbox Tile', border: InputBorder.none),
          child: FormeListTile(
            items: [
              FormeListTileItem(
                  title: Text("Checkbox 1"),
                  subtitle: Text("Checkbox 1 Subtitle"),
                  secondary: OutlinedButton(
                    child: Text("Say Hi"),
                    onPressed: () {
                      print("Say Hello");
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
        ),
        FormeInputDecorator(
          decoration: InputDecoration(
            labelText: 'Switch Tile',
          ),
          child: FormeListTile(
            name: 'switchTile',
            type: FormeListTileType.Switch,
            items: FormeUtils.toFormeListTileItems(['1', '2'],
                controlAffinity: ListTileControlAffinity.trailing),
            model: FormeListTileModel(
              split: 1,
            ),
          ),
        ),
        FormeDropdownButton<String>(
          name: 'dropdown',
          model: FormeDropdownButtonModel<String>(
              icon: Row(
                children: [
                  InkWell(
                      child: Icon(Icons.clear),
                      onTap: () {
                        formKey.valueField('dropdown').value = null;
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
              decoration: InputDecoration(
                labelText: 'Dropdown Button',
              )),
          items: FormeUtils.toDropdownMenuItems([
            'Flutter',
            'Android',
            'IOS',
          ]),
        ),
        Row(children: [
          Flexible(
            flex: 1,
            child: FormeInputDecorator(
              decoration: InputDecoration(
                  labelText: 'Switch Tile', border: InputBorder.none),
              child: FormeSlider(
                onChanged: (m, o, v) {
                  formKey
                      .valueField('test')
                      .setValue(v.round(), trigger: false);
                },
                min: 0,
                max: 100,
                name: 'testSlider',
              ),
            ),
          ),
          Expanded(
              child: FormeNumberField(
            name: 'test',
            onChanged: (m, o, v) {
              formKey
                  .valueField('testSlider')
                  .setValue(v?.toDouble() ?? 0.0, trigger: false);
            },
            model: FormeNumberFieldModel(allowNegative: false, max: 100),
          ))
        ])
      ],
    );
    return Forme(
      child: child,
      key: formKey,
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
