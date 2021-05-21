import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';
import 'package:form_builder/src/field/cupertino_picker.dart';
import 'package:form_builder/src/form_state_model.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int j = 1;

  final FormKey formKey = FormKey();
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
            LayoutFormManagement layoutFormManagement =
                formKey.currentManagement as LayoutFormManagement;
            return TextButton(
                onPressed: () {
                  layoutFormManagement.visible = !layoutFormManagement.visible;
                  (context as Element).markNeedsBuild();
                },
                child: Text(
                    !layoutFormManagement.visible ? 'show form' : 'hide form'));
          },
        ),
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
        Builder(
          builder: (context) {
            BaseLayoutFormFieldManagement management =
                formKey.currentManagement.newFormFieldManagement('username');
            bool visible = management.layoutParam?.visible ?? true;
            return TextButton(
                onPressed: () {
                  management.layoutParam = LayoutParam(visible: !visible);
                  (context as Element).markNeedsBuild();
                },
                child: Text(visible ? 'hide username' : 'show username'));
          },
        ),
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
              for (FormFieldManagementWithError error
                  in formKey.currentManagement.quietlyValidate()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.errorText),
                  backgroundColor: Colors.red,
                ));
                FormFieldManagement formFieldManagement =
                    error.formFieldManagement;
                formFieldManagement.ensureVisible().then((value) {
                  formFieldManagement.focus = true;
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
              formKey.currentManagement.setData({
                'picker': 10,
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
    return FormBuilder()
        .key(formKey)
        .onChanged((name, oldValue, newValue) {
          print(
              '$name\'s value changed, oldValue:$oldValue newValue:$newValue');
        })
        .layoutBuilder()
        .enableLayoutManagement(true)
        .oneRowField(CupertinoPickerFormField(
            initialValue: 0,
            name: 'picker',
            validator: (value) => value < 1 ? 'select ' : null,
            model: CupertinoPickerModel(
                labelText: '123',
                itemExtent: 50,
                children: List<Widget>.generate(
                    100, (index) => Center(child: Text(index.toString()))))))
        .oneRowField(ClearableTextFormField(
          name: 'username',
          onTap: () {
            print("??");
          },
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
          model: TextFieldModel(
            labelText: 'username',
            clearable: true,
            selectAllOnFocus: true,
          ),
        ))
        .append(Builder(builder: (context) {
          BaseLayoutFormFieldManagement username =
              formKey.currentManagement.newFormFieldManagement('username');
          return ButtonFormField(
              child: Text(username.readOnly ? 'editable' : 'readOnly'),
              onPressed: () {
                username.readOnly = !username.readOnly;
                (context as Element).markNeedsBuild();
              });
        }))
        .append(SingleSwitchFormField(
          model: SingleSwitchModel(),
          name: 'rememberMe',
          label: Text('remember'),
        ))
        .newRow()
        .append(ButtonFormField(
            type: ButtonType.Text,
            onPressed: () {
              formKey.currentManagement
                  .newFormFieldManagement('username')
                  .model = TextFieldModel(labelText: 'username1');
            },
            child: Text('change username\'s label'),
            icon: Icon(Icons.edit)))
        .oneRowField(Builder(builder: (context) {
          return ButtonFormField(
              onPressed: () {
                j++;
                int row = Position.of(context).row;
                LayoutFormManagement layoutFormManagement =
                    formKey.currentManagement as LayoutFormManagement;
                FormLayoutManagement formLayoutManagement =
                    layoutFormManagement.formLayoutManagement;

                formLayoutManagement.startEdit();
                formLayoutManagement.insert(
                    field: Label("new row"), newRow: true, row: row);
                formLayoutManagement.insert(
                    field: NumberFormField(
                      initialValue: j,
                      name: 'num$j',
                      flex: 2,
                      model: NumberFieldModel(),
                    ),
                    row: row);
                formLayoutManagement.insert(
                    field: Builder(builder: (context) {
                      int row = Position.of(context).row;
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
        .append(ClearableTextFormField(
          name: 'password',
          obscureText: true,
          passwordVisible: true,
          model: TextFieldModel(
            hintText: 'password',
            clearable: true,
            toolbarOptions: ToolbarOptions(copy: false, paste: false),
          ),
        ))
        .append(Builder(builder: (context) {
          return ButtonFormField(
              child: Text('remove'),
              onPressed: () {
                LayoutFormManagement layoutFormManagement =
                    formKey.currentManagement as LayoutFormManagement;
                FormLayoutManagement formLayoutManagement =
                    layoutFormManagement.formLayoutManagement;
                formLayoutManagement.startEdit();
                formLayoutManagement.remove(Position.of(context).row);
                formLayoutManagement.apply();
              });
        }))
        .append(ButtonFormField(
          onPressed: () async {
            formKey.currentManagement
                .newFormFieldManagement('password')
                .textSelectionManagement
                .selectAll();
          },
          child: Text('select all '),
        ))
        .newRow()
        .append(NumberFormField(
          name: 'age',
          flex: 1,
          model: NumberFieldModel(
            labelText: 'age',
            clearable: true,
            max: 99,
            decimal: 0,
          ),
          validator: (value) => value == null
              ? 'not empty'
              : value < 50
                  ? '50'
                  : null,
        ))
        .append(ButtonFormField(
            onPressed: () {
              formKey.currentManagement
                  .newFormFieldManagement('age')
                  .valueFieldManagement
                  .validate();
            },
            child: Text('validate me')))
        .append(ButtonFormField(
            onPressed: () {
              formKey.currentManagement.newFormFieldManagement('age').focus =
                  true;
            },
            child: Text('request focus')))
        .oneRowField(ListTileFormField<String>(
          name: 'checkbox',
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
          model: ListTileModel(
            items: FormBuilderUtils.toListTileItems(['male', 'female']),
            split: 2,
            labelText: 'sex',
          ),
        ))
        .oneRowField(ListTileFormField<String>(
          name: 'checkbox2',
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
          model: ListTileModel(
            items: FormBuilderUtils.toListTileItems(['male', 'female']),
            split: 1,
            labelText: 'sex',
          ),
        ))
        .append(ButtonFormField(
            onPressed: () {
              formKey.currentManagement
                      .newFormFieldManagement('checkbox2')
                      .model =
                  ListTileModel<String>(
                      items: FormBuilderUtils.toListTileItems(
                          ['new value1', 'new value2']));
            },
            child: Text('update items')))
        .oneRowField(ListTileFormField(
          model: ListTileModel(
            items: FormBuilderUtils.toListTileItems(
                ['switch1', 'switch2', 'switch3'],
                padding: const EdgeInsets.symmetric(horizontal: 5),
                controlAffinity: ListTileControlAffinity.trailing),
            split: 1,
            labelText: 'switch',
          ),
          type: ListTileItemType.Switch,
          name: 'switchGroup',
          validator: (value) => value.isEmpty ? 'select one pls !' : null,
        ))
        .oneRowField(ListTileFormField(
          name: 'radio',
          type: ListTileItemType.Radio,
          model: ListTileModel(
            items: FormBuilderUtils.toListTileItems(['1', '2']),
            labelText: 'single choice',
            split: 1,
          ),
        ))
        .append(DateTimeFormField(
          name: 'startTime',
          model: DateTimeFieldModel(
            type: DateTimeType.DateTime,
            hintText: 'startTime',
          ),
          validator: (value) => value == null ? 'not empty1' : null,
        ))
        .append(DateTimeFormField(
          name: 'endTime',
          model: DateTimeFieldModel(
            hintText: 'endTime',
          ),
          validator: (value) => value == null ? 'not empty2' : null,
        ))
        .oneRowField(ClearableTextFormField(
          name: 'remark',
          flex: 1,
          model: TextFieldModel(
            hintText: 'remark',
            maxLines: 5,
            clearable: true,
            maxLength: 500,
          ),
        ))
        .oneRowField(SelectorFormField(
            name: 'selector',
            model: SelectorModel(
              labelText: 'selector',
              multi: true,
              selectedItemLayoutType: SelectedItemLayoutType.scroll,
            ),
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
              return builder
                  .layoutBuilder()
                  .append(RangeSliderFormField(
                    name: 'filter',
                    model: SliderModel(min: 1, max: 100),
                  ))
                  .append(ButtonFormField(
                      onPressed: () {
                        query();
                      },
                      child: Text('query')))
                  .build();
            },
            onSelectDialogShow: (FormManagement currentManagement) {
              //use this formKey.currentManagement to control query form on search dialog
              currentManagement
                  .newFormFieldManagement('filter')
                  .valueFieldManagement
                  .value = RangeValues(20, 50);
              return true; //return true will set params before query
            },
            validator: (value) => value.isEmpty ? 'select something !' : null))
        .oneRowField(SliderFormField(
          name: 'slider',
          model: SliderModel(
            min: 0,
            max: 100,
            labelText: 'age slider',
          ),
          validator: (value) =>
              value < 50 ? 'age slider must bigger than 50' : null,
        ))
        .append(NumberFormField(
            model: NumberFieldModel(
              max: 100,
              labelText: 'inline slider',
            ),
            name: 'sliderInlineText',
            flex: 2,
            onChanged: (v) => formKey.currentManagement
                .newFormFieldManagement('sliderInline')
                .valueFieldManagement
                .setValue(v == null ? 0.0 : v.toDouble(), trigger: false)))
        .append(SliderFormField(
            name: 'sliderInline',
            model: SliderModel(
              min: 0,
              max: 100,
            ),
            onChanged: (v) {
              formKey.currentManagement
                  .newFormFieldManagement('sliderInlineText')
                  .valueFieldManagement
                  .setValue(v.toDouble().round(), trigger: false);
            }))
        .oneRowField(RangeSliderFormField(
          name: 'rangeSlider',
          model: SliderModel(min: 1, max: 100, labelText: 'range slider'),
        ))
        .oneRowField(FilterChipFormField(
          name: 'filterChip',
          exceedCallback: () => print('max 3 items can be selected'),
          validator: (t) =>
              t.length < 3 ? 'at least three items  must be selected ' : null,
          model: FilterChipModel(
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
              ]),
              count: 3,
              labelText: 'Filter Chip'),
        ))
        .oneRowField(RateFormField(
          name: 'rate',
          model: RateModel(
            labelText: 'Rate Me!',
          ),
          onChanged: (value) {
            String text = 'Rate Me!';
            if (value != null) text += 'current rate is $value';
            formKey.currentManagement.newFormFieldManagement('rate').model =
                RateModel(labelText: text);
          },
          validator: (value) => value == null ? 'give me a rate pls' : null,
        ))
        .build();
  }
}

class Label extends BaseCommonField<LabelModel> {
  Label(String label, {int flex = 1})
      : super(
          model: LabelModel(label: label),
          layoutParam: LayoutParam(flex: flex),
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
