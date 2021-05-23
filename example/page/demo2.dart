import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class Demo2Page extends StatefulWidget {
  @override
  _Demo2PageState createState() => _Demo2PageState();
}

class _Demo2PageState extends State<Demo2Page> {
  final FormeKey formKey = FormeKey();

  final GlobalKey key1 = GlobalKey();
  @override
  void initState() {
    super.initState();
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
          FormeFieldManagement management = formKey.currentManagement
              .newFormeFieldManagement('sliderVisible');
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
            FormeFieldManagement fieldManagement =
                formKey.currentManagement.newFormeFieldManagement('column');
            FormeFlexModel model = fieldManagement.model as FormeFlexModel;
            fieldManagement.model = model.append(FormeNumberTextField(
              model: FormeNumberTextFieldModel(labelText: '123'),
            ));
          },
          child: Text('append field into dynamic column'),
        ),
        TextButton(
          onPressed: () {
            FormeFieldManagement fieldManagement =
                formKey.currentManagement.newFormeFieldManagement('column');
            FormeFlexModel model = fieldManagement.model as FormeFlexModel;
            fieldManagement.model = model.prepend(FormeNumberTextField(
              model: FormeNumberTextFieldModel(labelText: '456'),
            ));
          },
          child: Text('prepend field into dynamic column'),
        ),
        TextButton(
          onPressed: () {
            FormeFieldManagement fieldManagement =
                formKey.currentManagement.newFormeFieldManagement('column');
            FormeFlexModel model = fieldManagement.model as FormeFlexModel;
            fieldManagement.model = model.swap(0, 1);
          },
          child: Text('swap first and second'),
        ),

        TextButton(
          onPressed: () {
            FormeFieldManagement fieldManagement =
                formKey.currentManagement.newFormeFieldManagement('column');
            FormeFlexModel model = fieldManagement.model as FormeFlexModel;
            fieldManagement.model = model.remove(0);
          },
          child: Text('remove first'),
        ),

        TextButton(
          onPressed: () {
            FormeFieldManagement fieldManagement =
                formKey.currentManagement.newFormeFieldManagement('column');
            FormeFlexModel model = fieldManagement.model as FormeFlexModel;
            fieldManagement.model = model.append(Container(
              color: Colors.red,
              child: FormeRow(children: [], name: 'row'),
            ));
          },
          child: Text('append a dynamic row'),
        ),

        TextButton(
          onPressed: () {
            FormeFieldManagement fieldManagement =
                formKey.currentManagement.newFormeFieldManagement('row');
            FormeFlexModel model = fieldManagement.model as FormeFlexModel;
            fieldManagement.model = model.prepend(FormeRate());
          },
          child: Text('prepend field into dynamic row'),
        ),
        TextButton(
          onPressed: () {
            FormeFieldManagement fieldManagement =
                formKey.currentManagement.newFormeFieldManagement('row');
            FormeFlexModel model = fieldManagement.model as FormeFlexModel;
            fieldManagement.model = model.append(FormeSingleCheckbox());
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(13.0),
              bottomLeft: Radius.circular(13.0),
              topLeft: Radius.circular(13.0),
              topRight: Radius.circular(13.0),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: FormeTextField(
                    name: 'text',
                    model: FormeTextFieldModel(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      selectAllOnFocus: true,
                      labelText: 'username',
                      keyboardType: TextInputType.text,
                      inputDecorationTheme: InputDecorationTheme(
                        border: InputBorder.none,
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    onEditingComplete: () {},
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.search,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
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
        FormeNumberTextField(
          name: 'number',
          model: FormeNumberTextFieldModel(
            max: 99,
            decimal: 2,
            labelText: 'Number Field',
          ),
        ),
        FormeDateTime(
          name: 'datetime',
          model: FormeDateTimeModel(
            labelText: 'DateTime Field',
            type: FormeDateTimeType.DateTime,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FormeCupertinoPicker(
          name: 'cupertinoPicker',
          initialValue: 0,
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
        FormeRangeSlider(
          model: FormeSliderModel(
            labelText: 'Range Slider',
          ),
          name: 'rangeSlider',
          min: 1,
          max: 100,
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
            hasSelectAll: true,
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
            model: FormeDropdownButtonModel<String>(
              labelText: 'Dropdown Button',
            ),
            items: FormeUtils.toDropdownMenuItems([
              'Android',
              'IOS',
              'Flutter',
              'Node',
              'Java',
              'Python',
              'PHP',
            ])),
        Row(children: [
          Flexible(
            flex: 1,
            child: FormeSlider(
              onChanged: (v) {
                (formKey.currentManagement.newFormeFieldManagement('test')
                        as FormeValueFieldManagement)
                    .setValue(v.round(), trigger: false);
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
              (formKey.currentManagement.newFormeFieldManagement('testSlider')
                      as FormeValueFieldManagement)
                  .setValue(v?.toDouble() ?? 0.0, trigger: false);
            },
            model: FormeNumberTextFieldModel(allowNegative: false, max: 100),
          ))
        ]),
        Text(
          'dynamic column ',
          style: TextStyle(fontSize: 30),
        ),
        FormeColumn(
          name: 'column',
          children: [],
        )
      ],
    );
    return Forme(
      child: child,
      key: formKey,
    );
  }
}
