import 'package:flutter/material.dart';

import 'package:form_builder/form_builder.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int j = 1;

  FormManagement formManagement = FormManagement();
  late CastableFormFieldManagement username;
  late FormLayoutManagement formLayoutManagement;

  @override
  void initState() {
    super.initState();
    username = formManagement.newFormFieldManagement('username');
    formLayoutManagement = formManagement.formLayoutManagement;
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
              child: Text(
                'form1',
                style: TextStyle(fontSize: 30),
              ),
            ),
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
            BaseFormFieldManagement management = username.cast();
            return TextButton(
                onPressed: () async {
                  management.visible = !management.visible;
                  (context as Element).markNeedsBuild();
                },
                child: Text(
                    management.visible ? 'hide username' : 'show username'));
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
              for (FormFieldManagementWithError error
                  in formManagement.quietlyValidate()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.errorText),
                  backgroundColor: Colors.red,
                ));
                CastableFormFieldManagement formFieldManagement =
                    error.formFieldManagement;
                formFieldManagement.ensureVisible().then((value) {
                  //base value field support shaker
                  if (formFieldManagement
                      .canCast<BaseFormValueFieldManagement>()) {
                    formFieldManagement
                        .cast<BaseFormValueFieldManagement>()
                        .shake(shaker: Shaker(onEnd: () {
                      if (formFieldManagement.focusable)
                        formFieldManagement.focus = true;
                    }));
                  }
                });
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
              formManagement.reset();
            },
            child: Text('reset')),
        TextButton(
          onPressed: () {
            print(formManagement.data);
          },
          child: Text('get form data'),
        ),
        TextButton(
            onPressed: () {
              formManagement.setData({
                'username': 'user name',
                'password': 'password',
                'checkbox': ['male'],
                'age': 38,
                'radio': ['1'],
                'startTime': DateTime.now(),
                'switchGroup': ['switch1'],
                'sliderInline': 50,
                'filterChip': ['java', 'C#', 'flutter'],
                'rangeSlider': RangeValues(10, 100),
                'rate': 4.5
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
      onChanged: (name, oldValue, newValue) {
        print('$name\'s value changed, oldValue:$oldValue newValue:$newValue');
      },
    )
        .append(ClearableTextFormField(
          name: 'username',
          labelText: 'username',
          clearable: true,
          selectAllOnFocus: true,
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
        ))
        .append(Builder(builder: (context) {
          return ButtonFormField(
              child: Text(username.readOnly ? 'editable' : 'readOnly'),
              onPressed: (info) {
                username.readOnly = !username.readOnly;
                (context as Element).markNeedsBuild();
              });
        }))
        .append(SingleSwitchFormField(
          name: 'rememberMe',
          label: Text('remember'),
        ))
        .newRow()
        .append(ButtonFormField(
            type: ButtonType.Text,
            onPressed: (info) {
              username.model = TextFieldModel(labelText: 'username1');
            },
            child: Text('change username\'s label'),
            icon: Icon(Icons.edit)))
        .oneRowField(ButtonFormField(
            onPressed: (info) {
              j++;
              int row = info.position.row;
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
            child: Text('insert a new row before this button')))
        .append(ClearableTextFormField(
          name: 'password',
          hintText: 'password',
          obscureText: true,
          passwordVisible: true,
          clearable: true,
          toolbarOptions: ToolbarOptions(copy: false, paste: false),
        ))
        .append(ButtonFormField(
            child: Text('remove'),
            onPressed: (info) {
              formLayoutManagement.startEdit();
              formLayoutManagement.remove(info.position.row);
              formLayoutManagement.apply();
            }))
        .append(ButtonFormField(
          onPressed: (info) async {
            formManagement
                .newFormFieldManagement('password')
                .textSelectionManagement
                .selectAll();
          },
          child: Text('select all '),
        ))
        .newRow()
        .append(NumberFormField(
          name: 'age',
          labelText: 'age',
          clearable: true,
          flex: 1,
          max: 99,
          decimal: 0,
          validator: (value) => value == null
              ? 'not empty'
              : value < 50
                  ? '50'
                  : null,
        ))
        .append(ButtonFormField(
            onPressed: (info) {
              formManagement
                  .newFormFieldManagement('age')
                  .valueFieldManagement
                  .validate();
            },
            child: Text('validate me')))
        .append(ButtonFormField(
            onPressed: (info) {
              formManagement.newFormFieldManagement('age').focus = true;
            },
            child: Text('request focus')))
        .oneRowField(ListTileFormField<String>(
          items: FormBuilderUtils.toListTileItems(['male', 'female']),
          name: 'checkbox',
          split: 2,
          labelText: 'sex',
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        ))
        .oneRowField(ListTileFormField<String>(
          items: FormBuilderUtils.toListTileItems(['male', 'female']),
          name: 'checkbox2',
          split: 1,
          labelText: 'sex',
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        ))
        .append(ButtonFormField(
            onPressed: (info) {
              formManagement.newFormFieldManagement('checkbox2').model =
                  ListTileModel<String>(
                      items: FormBuilderUtils.toListTileItems(
                          ['new value1', 'new value2']));
            },
            child: Text('update items')))
        .oneRowField(ListTileFormField(
            split: 1,
            type: ListTileItemType.Switch,
            name: 'switchGroup',
            labelText: 'switch',
            validator: (value) => value.isEmpty ? 'select one pls !' : null,
            items: FormBuilderUtils.toListTileItems(
                ['switch1', 'switch2', 'switch3'],
                padding: const EdgeInsets.symmetric(horizontal: 5),
                controlAffinity: ListTileControlAffinity.trailing)))
        .oneRowField(ListTileFormField(
          split: 1,
          type: ListTileItemType.Radio,
          items: FormBuilderUtils.toListTileItems(['1', '2']),
          name: 'radio',
          labelText: 'single choice',
        ))
        .append(DateTimeFormField(
          name: 'startTime',
          type: DateTimeType.DateTime,
          hintText: 'startTime',
          validator: (value) => value == null ? 'not empty1' : null,
        ))
        .append(DateTimeFormField(
          name: 'endTime',
          hintText: 'endTime',
          validator: (value) => value == null ? 'not empty2' : null,
        ))
        .oneRowField(ClearableTextFormField(
            name: 'remark',
            hintText: 'remark',
            maxLines: 5,
            flex: 1,
            clearable: true,
            maxLength: 500))
        .oneRowField(SelectorFormField(
            name: 'selector',
            labelText: 'selector',
            multi: false,
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
                  .append(
                      RangeSliderFormField(name: 'filter', min: 1, max: 100))
                  .append(ButtonFormField(
                      onPressed: (info) {
                        query();
                      },
                      child: Text('query')));
            },
            onSelectDialogShow: (formManagement) {
              //use this formManagement to control query form on search dialog
              formManagement
                  .newFormFieldManagement('filter')
                  .valueFieldManagement
                  .value = RangeValues(20, 50);
              return true; //return true will set params before query
            },
            selectedItemLayoutType: SelectedItemLayoutType.scroll,
            validator: (value) => value.isEmpty ? 'select something !' : null))
        .oneRowField(SliderFormField(
          name: 'slider',
          min: 0,
          max: 100,
          labelText: 'age slider',
          validator: (value) =>
              value < 50 ? 'age slider must bigger than 50' : null,
        ))
        .append(NumberFormField(
            max: 100,
            name: 'sliderInlineText',
            labelText: 'inline slider',
            flex: 2,
            onChanged: (v) => formManagement
                .newFormFieldManagement('sliderInline')
                .valueFieldManagement
                .setValue(v == null ? 0.0 : v.toDouble(), trigger: false)))
        .append(SliderFormField(
            name: 'sliderInline',
            min: 0,
            max: 100,
            onChanged: (v) {
              formManagement
                  .newFormFieldManagement('sliderInlineText')
                  .valueFieldManagement
                  .setValue(v.toDouble().round(), trigger: false);
            }))
        .oneRowField(RangeSliderFormField(
          name: 'rangeSlider',
          min: 0,
          max: 100,
          labelText: 'range slider',
        ))
        .oneRowField(FilterChipFormField(
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
            ])))
        .oneRowField(RateFormField(
          name: 'rate',
          labelText: 'Rate Me!',
          onChanged: (value) {
            String text = 'Rate Me!';
            if (value != null) text += 'current rate is $value';
            formManagement.newFormFieldManagement('rate').model =
                RateModel(labelText: text);
          },
          validator: (value) => value == null ? 'give me a rate pls' : null,
        ));
  }
}

class Label extends BaseCommonField<LabelModel> {
  Label(String label, {int flex = 1})
      : super(
          model: LabelModel(label: label),
          flex: flex,
          builder: (state) {
            ThemeData themeData = Theme.of(state.context);
            return Text(
              state.model.label!,
              style: TextStyle(fontSize: 18, color: themeData.primaryColor),
            );
          },
        );
}

class LabelModel extends AbstractFieldStateModel {
  final String? label;
  LabelModel({this.label});
  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    LabelModel oldModel = old as LabelModel;
    return LabelModel(label: label ?? oldModel.label);
  }
}
