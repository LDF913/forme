import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int j = 1;

  FormManagement formManagement = FormManagement();
  late FormFieldManagement username;
  late FormPositionManagement positionManagement;
  late FormLayoutManagement formLayoutManagement;

  @override
  void initState() {
    super.initState();
    username = formManagement.newFormFieldManagement('username');
    positionManagement = formManagement.newFormPositionManagement(0);
    formLayoutManagement = formManagement.newFormLayoutManagement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'form1',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: createForm(),
            ),
            createButtons(),
          ]),
        ));
  }

  Widget createButtons() {
    Wrap buttons = Wrap(
      children: [
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  formManagement.visible = !formManagement.visible;
                  (context as Element).markNeedsBuild();
                },
                child:
                    Text(formManagement.visible ? 'hide form' : 'show form'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  formManagement.readOnly = !formManagement.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(formManagement.readOnly
                    ? 'set form editable'
                    : 'set form readonly'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () async {
                  username.visible = !username.visible;
                  (context as Element).markNeedsBuild();
                },
                child:
                    Text(username.visible ? 'hide username' : 'show username'));
          },
        ),
        TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('rebuild page')),
        TextButton(
            onPressed: () {
              formManagement.validate();
            },
            child: Text('validate')),
        TextButton(
            onPressed: () {
              formManagement.reset();
            },
            child: Text('reset')),
        TextButton(
          onPressed: () {
            print(formManagement.data);
          },
          child: Text('get form data'),
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  positionManagement.visible = !positionManagement.visible;
                  (context as Element).markNeedsBuild();
                },
                child: Text(positionManagement.visible
                    ? 'hide first row'
                    : 'show first row'));
          },
        ),
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  positionManagement.readOnly = !positionManagement.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(positionManagement.readOnly
                    ? 'set first row editable'
                    : 'set first row readOnly'));
          },
        ),
        TextButton(
            onPressed: () {
              formManagement.setData({
                'username': 'user name',
                'password': 'password',
                'checkbox': [0],
                'age': 38,
                'radio': '1',
                'startTime': DateTime.now(),
                'switchGroup': [0, 1],
                'sliderInline': 50,
                'filterChip': ['java', 'C#', 'flutter'],
                'rangeSlider': RangeValues(10, 100)
              });
            },
            child: Text('set form data')),
      ],
    );
    return buttons;
  }

  Widget createForm() {
    return FormBuilder(
      formManagement: formManagement,
      enableLayoutManagement: true,
      onChanged: (name, newValue) {
        print('$name\'s value changed, newValue:$newValue');
      },
    )
        //    .customize(crossAxisAlignment: CrossAxisAlignment.start)
        .textField(
          name: 'username',
          labelText: 'username',
          clearable: true,
          selectAllOnFocus: true,
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
        )
        .button(
          onPressed: () {
            username.readOnly = !username.readOnly;
          },
          childBuilder: (context) =>
              Text(username.readOnly ? 'editable' : 'readOnly'),
        )
        .switchInline(name: 'rememberMe')
        .newRow()
        .button(
            type: ButtonType.Text,
            onPressed: () {
              username.update1('labelText', 'username1');
            },
            childBuilder: (context) => Text('change username\'s label'),
            icon: Icon(Icons.edit))
        .newRow()
        .field(field: Builder(builder: (context) {
          return TextButton(
              onPressed: BuilderInfo.of(context).readOnly
                  ? null
                  : () {
                      j++;
                      int row = BuilderInfo.of(context).position.row;
                      formLayoutManagement.startEdit();
                      formLayoutManagement.insert(
                          field: Label("new row"), newRow: true, row: row);
                      formLayoutManagement.insert(
                          field: NumberFormField(
                            initialValue: j,
                            name: 'num$j',
                            flex: 2,
                          ),
                          row: row);
                      formLayoutManagement.insert(
                          field: Builder(builder: (context) {
                            int row = BuilderInfo.of(context).position.row;
                            return TextButton.icon(
                                onPressed: () {
                                  formLayoutManagement.startEdit();
                                  formLayoutManagement.remove(row);
                                  formLayoutManagement.apply();
                                },
                                icon: Icon(Icons.delete),
                                label: Text('delete'));
                          }),
                          row: row);
                      formLayoutManagement.apply();
                    },
              child: Text('insert a new row before this button'));
        }))
        .newRow()
        .textField(
            name: 'password',
            hintText: 'password',
            obscureText: true,
            passwordVisible: true,
            clearable: true,
            toolbarOptions: ToolbarOptions(copy: false, paste: false),
            flex: 1)
        .button(
          onPressed: () {
            formManagement
                .newFormFieldManagement('password')
                .textSelectionManagement
                .selectAll();
          },
          childBuilder: (context) => Text('select all'),
        )
        .newRow()
        .numberField(
          name: 'age',
          labelText: 'age',
          clearable: true,
          flex: 3,
          max: 99,
          decimal: 0,
          validator: (value) => value == null
              ? 'not empty'
              : value < 50
                  ? '50'
                  : null,
        )
        .button(
            onPressed: () {
              formManagement
                  .newFormFieldManagement('age')
                  .valueFieldManagement
                  .validate();
            },
            childBuilder: (context) => Text('validate me'))
        .button(
            onPressed: () {
              formManagement.newFormFieldManagement('age').focus = true;
            },
            childBuilder: (context) => Text('get  focus'))
        .newRow()
        .checkboxGroup(
          items: FormBuilderUtils.toCheckboxGroupItems(['male', 'female']),
          name: 'checkbox',
          split: 2,
          labelText: '123213',
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .newRow()
        .checkboxGroup(
          name: 'checkbox2',
          items: FormBuilderUtils.toCheckboxGroupItems(['male', 'female']),
          split: 1,
          labelText: 'checkboxlisttile',
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        )
        .newRow()
        .button(
            onPressed: () {
              formManagement.newFormFieldManagement('checkbox2').update1(
                  'items',
                  FormBuilderUtils.toCheckboxGroupItems(
                      ['new value1', 'new value2']));
            },
            childBuilder: (context) => Text('update items'))
        .newRow()
        .radioGroup(
          items: FormBuilderUtils.toRadioGroupItems(['1', '2']),
          name: 'radio',
          labelText: 'single choice',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .newRow()
        .radioGroup<String>(
          split: 1,
          items: FormBuilderUtils.toRadioGroupItems(['1', '2']),
          onChanged: (value) => print('radio value changed $value'),
          labelText: 'radiolisttile',
          validator: (value) => value == null ? 'select one !' : null,
        )
        .newRow()
        .datetimeField(
          name: 'startTime',
          useTime: true,
          hintText: 'startTime',
          validator: (value) => value == null ? 'not empty1' : null,
        )
        .datetimeField(
          name: 'endTime',
          useTime: true,
          hintText: 'endTime',
          validator: (value) => value == null ? 'not empty2' : null,
        )
        .newRow()
        .textField(
            name: 'remark',
            hintText: 'remark',
            maxLines: 5,
            flex: 1,
            clearable: true,
            maxLength: 500)
        .newRow()
        .selector<int>(
            name: 'selector',
            labelText: 'selector',
            multi: true,
            selectItemProvider: (page, params) {
              RangeValues filter = params['filter'];
              List<int> items = List<int>.generate(100, (i) => i + 1)
                  .where((element) =>
                      element >= filter.start.round() &&
                      element <= filter.end.round())
                  .toList();
              return Future.delayed(Duration(seconds: 1), () {
                return SelectItemPage<int>(
                    items.sublist((page - 1) * 20,
                        page * 20 > items.length ? items.length : page * 20),
                    items.length);
              });
            },
            queryFormBuilder: (builder, query) {
              builder
                  .rangeSlider(
                      name: 'filter',
                      min: 1,
                      max: 100,
                      rangeSubLabelRender: RangeSubLabelRender(
                          (start) => start.round().toString(),
                          (end) => end.round().toString()))
                  .button(
                      onPressed: query,
                      childBuilder: (context) => Text('query'));
            },
            onSelectDialogShow: (formManagement) {
              //use this formManagement to control query form on search dialog
              formManagement
                  .newFormFieldManagement('filter')
                  .valueFieldManagement
                  .setValue(RangeValues(20, 50));
              return true; //return true will set params before query
            },
            selectedItemLayoutType: SelectedItemLayoutType.scroll,
            validator: (value) => value.isEmpty ? 'select something !' : null)
        .newRow()
        .switchGroup(
            name: 'switchGroup',
            labelText: 'switch',
            validator: (value) => value.isEmpty ? 'select one pls !' : null,
            selectAllPadding: EdgeInsets.only(right: 8),
            items: List<SwitchGroupItem>.generate(
                3,
                (index) => SwitchGroupItem(index.toString(),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8))))
        .newRow()
        .slider(
          name: 'slider',
          min: 0,
          max: 100,
          labelText: 'age slider',
          validator: (value) =>
              value < 50 ? 'age slider must bigger than 50' : null,
          subLabelRender: (value) => value.toStringAsFixed(0),
        )
        .newRow()
        .button(
            name: 'validate',
            childBuilder: (context) => Text('validate form'),
            onPressed: formManagement.validate)
        .button(
            name: 'reset',
            childBuilder: (context) => Text('reset form'),
            onPressed: formManagement.reset)
        .newRow()
        .numberField(
            name: 'sliderInlineText',
            max: 100,
            labelText: 'inline slider',
            flex: 2,
            onChanged: (v) => formManagement
                .newFormFieldManagement('sliderInline')
                .valueFieldManagement
                .setValue(v == null ? 0.0 : v.toDouble(), trigger: false))
        .slider(
            name: 'sliderInline',
            min: 0,
            max: 100,
            onChanged: (v) {
              formManagement
                  .newFormFieldManagement('sliderInlineText')
                  .valueFieldManagement
                  .setValue(v.toDouble().toInt(), trigger: false);
            })
        .newRow()
        .rangeSlider(
          name: 'rangeSlider',
          min: 0,
          max: 100,
          labelText: 'range slider',
          rangeSubLabelRender: RangeSubLabelRender((start) {
            return start.toStringAsFixed(0);
          }, (end) {
            return end.toStringAsFixed(0);
          }),
        )
        .newRow()
        .filterChip<String>(
            labelText: 'Filter Chip',
            name: 'filterChip',
            count: 3,
            exceedCallback: () => print('max 3 items can be selected'),
            validator: (t) =>
                t.length < 3 ? 'at least three items  must be selected ' : null,
            items: FormBuilderUtils.toFilterChipItems([
              'java',
              'android',
              'flutter',
              'html',
              'css',
              'javascript',
              'C#',
              'swift',
              'object-c'
            ]))
        .newRow()
        .field(field: CustomField())

        /// widge tree
        ///
        /// ```
        /// Column
        ///   Row
        ///     Expanded --auto wrapped by BaseField
        ///       Container
        /// ```
        .field(
            field: BaseCommonField(
          {},
          padding: EdgeInsets.zero,
          builder: (state) {
            //width will not work,because it's wrapped by Expanded
            return Container(
              height: 100,
              width: 50,
              color: Colors.red,
              child: Text('BaseCommonField'),
            );
          },
        ));
  }
}

class Label extends BaseCommonField {
  final String label;
  Label(this.label, {int flex = 1})
      : super(
          {'label': StateValue<String>(label)},
          flex: flex,
          builder: (state) {
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.themeData;
            return Text(
              stateMap['label'],
              style: TextStyle(fontSize: 18, color: themeData.primaryColor),
            );
          },
        );
}

/// modify base field's widget
///
/// ```
/// Column
///   Row
///     Container
/// ```
class CustomField extends BaseCommonField {
  CustomField()
      : super(
          {},
          builder: (state) {
            return Container(
              height: 100,
              width: 50,
              color: Colors.yellow,
              child: Text('CustomCommonField'),
            );
          },
        );
  CustomFieldState createState() => CustomFieldState();
}

class CustomFieldState extends BaseCommonFieldState {
  @override
  void initFormManagement() {
    super.initFormManagement();
    (model as BaseFieldStateModel).addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}
