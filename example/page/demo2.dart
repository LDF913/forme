import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class Demo2Page extends StatefulWidget {
  @override
  _Demo2PageState createState() => _Demo2PageState();
}

class _Demo2PageState extends State<Demo2Page> {
  final FormeKey formKey = FormeKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      formKey.field('text').focusListener = (v) => print('focused: $v');
    });
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
                  formKey.currentManagement.readOnly =
                      !formKey.currentManagement.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(formKey.currentManagement.readOnly
                    ? 'set form editable'
                    : 'set form readonly'));
          },
        ),
        //sliderVisible
        Builder(builder: (context) {
          FormeFieldManagement management =
              formKey.currentManagement.field('sliderVisible');
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
              formKey.currentManagement.validate();
            },
            child: Text('validate')),
        TextButton(
            onPressed: () {
              for (FormeFieldManagementWithError error
                  in formKey.currentManagement.quietlyValidate()) {
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
              formKey.currentManagement.reset();
            },
            child: Text('reset')),
        TextButton(
          onPressed: () {
            print(formKey.currentManagement.data);
          },
          child: Text('get form data'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.append(FormeNumberTextField(
              model: FormeNumberTextFieldModel(
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
            formKey.field('column').model = model.prepend(FormeNumberTextField(
              model: FormeNumberTextFieldModel(
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
            formKey.field('row').model = model.prepend(FormeRate());
          },
          child: Text('prepend field into dynamic row'),
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
          model: FormeTextFieldModel(
            selectAllOnFocus: true,
            decoration: InputDecoration(
              labelText: 'Text',
            ),
          ),
          onEditingComplete: () {},
        ),
        FormeTextField(
          name: 'obscureText',
          model: FormeTextFieldModel(
            obscureText: true,
            maxLines: 1,
            toolbarOptions: ToolbarOptions(),
            decoration: InputDecoration(
              labelText: 'Obscure Text',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormeClearButton(onPressed: (valueField) {
                    valueField.value = '';
                  }),
                  FormePasswordVisibleButton(),
                ],
              ),
            ),
          ),
          onEditingComplete: () {},
        ),
        FormeNumberTextField(
          name: 'number',
          model: FormeNumberTextFieldModel(
            max: 99,
            decimal: 2,
            textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(
                labelText: 'Number',
                suffixIcon: FormeClearButton(
                  onPressed: (valueField) {
                    valueField.value = null;
                  },
                ),
              ),
            ),
          ),
        ),
        FormeDateRangeTextField(
          name: 'dateRange',
          model: FormeDateRangeTextFieldModel(
              textFieldModel: FormeTextFieldModel(
            decoration: InputDecoration(
              labelText: 'Date Range',
              suffixIcon: FormeClearButton(
                visibleWhenUnfocus: true,
                onPressed: (valueField) {
                  valueField.value = null;
                },
              ),
            ),
          )),
        ),
        FormeDateTimeTextField(
          name: 'datetime',
          model: FormeDateTimeTextFieldModel(
            type: FormeDateTimeTextFieldType.DateTime,
            textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(
                labelText: 'DateTime',
                suffixIcon: FormeClearButton(
                  visibleWhenUnfocus: true,
                  onPressed: (valueField) {
                    valueField.value = null;
                  },
                ),
              ),
            ),
          ),
        ),
        FormeTimeTextField(
          name: 'time',
          model: FormeTimeTextFieldModel(
            textFieldModel: FormeTextFieldModel(
              decoration: InputDecoration(
                labelText: 'Time',
                suffixIcon: FormeClearButton(
                  visibleWhenUnfocus: true,
                  onPressed: (valueField) {
                    valueField.value = null;
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FormeCupertinoPicker(
          name: 'cupertinoPicker',
          initialValue: 20,
          children: List<Widget>.generate(
              1000,
              (index) => Center(
                    child: Text(index.toString()),
                  )),
          model: FormeCupertinoPickerModel(
            itemExtent: 50,
            labelText: 'Cupertino Picker',
            useMagnifier: true,
            magnification: 1.2,
          ),
          suffixIcon: FormeCupertinoPickerLockButton(),
        ),
        SizedBox(
          height: 20,
        ),
        FormeFilterChip(
          name: 'filterChip',
          items: FormeUtils.toFormeChipItems(['flutter', 'android', 'iOS']),
          model: FormeFilterChipModel(
            labelText: 'Filter Chip Field',
            formeDecorationFieldRenderData: FormeDecorationRenderData(
                headPadding: EdgeInsets.symmetric(vertical: 10)),
          ),
        ),
        FormeChoiceChip(
          name: 'choiceChip',
          items: FormeUtils.toFormeChipItems(['flutter', 'android', 'iOS']),
          model: FormeChoiceChipModel(
            labelText: 'Choice Chip Field',
            formeDecorationFieldRenderData: FormeDecorationRenderData(
                headPadding: EdgeInsets.symmetric(vertical: 10)),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FormeVisible(
          name: 'sliderVisible',
          child: FormeSlider(
            model: FormeSliderModel(
              labelText: 'Slider',
            ),
            name: 'slider',
            min: 0,
            max: 100,
          ),
        ),
        FormeRangeSlider(
          model: FormeSliderModel(
            labelText: 'Range Slider',
          ),
          name: 'rangeSlider',
          min: 1,
          max: 100,
        ),
        FormeColumn(
          name: 'column',
          children: [],
        ),
        FormeListTile(
          items: FormeUtils.toFormeListTileItems(['1', '2']),
          name: 'radioTile',
          type: FormeListTileType.Radio,
          model: FormeListTileModel(
            labelText: 'Radio Tile List',
            split: 1,
          ),
        ),
        FormeListTile(
          items: FormeUtils.toFormeListTileItems(['1', '2']),
          name: 'checkboxTile',
          type: FormeListTileType.Checkbox,
          model: FormeListTileModel(
            labelText: 'Checkbox Tile List',
            allowSelectAll: true,
            split: 1,
          ),
        ),
        FormeListTile(
          name: 'switchTile',
          type: FormeListTileType.Switch,
          items: FormeUtils.toFormeListTileItems(['1', '2'],
              controlAffinity: ListTileControlAffinity.trailing),
          model: FormeListTileModel(
            labelText: 'Switch Tile List',
            split: 1,
          ),
        ),
        FormeDropdownButton<String>(
            name: 'dropdown',
            model: FormeDropdownButtonModel<String>(
                icon: Row(
                  children: [
                    FormeDropdownButtonClearButton(
                      visibleWhenUnfocus: true,
                    ),
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
            ])),
        Row(children: [
          Flexible(
            flex: 1,
            child: FormeSlider(
              onChanged: (v) {
                formKey.valueField('test').setValue(v.round(), trigger: false);
              },
              min: 0,
              max: 100,
              name: 'testSlider',
            ),
          ),
          Expanded(
              child: FormeNumberTextField(
            name: 'test',
            onChanged: (v) {
              formKey
                  .valueField('testSlider')
                  .setValue(v?.toDouble() ?? 0.0, trigger: false);
            },
            model: FormeNumberTextFieldModel(allowNegative: false, max: 100),
          ))
        ])
      ],
    );
    return Forme(
      child: child,
      key: formKey,
    );
  }
}
