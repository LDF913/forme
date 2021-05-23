import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

class Demo2Page extends StatefulWidget {
  @override
  _Demo2PageState createState() => _Demo2PageState();
}

class _Demo2PageState extends State<Demo2Page> {
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
          FormFieldManagement management =
              formKey.currentManagement.newFormFieldManagement('sliderVisible');
          bool visible = (management.model as VisibleModel).visible ?? true;
          return TextButton(
              onPressed: () {
                management.model = VisibleModel(visible: !visible);
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
              for (FormFieldManagementWithError error
                  in formKey.currentManagement.quietlyValidate()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.errorText),
                  backgroundColor: Colors.red,
                ));
                FormFieldManagement formFieldManagement =
                    error.formFieldManagement;
                formFieldManagement.ensureVisible().then((value) {});
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
                  child: ClearableTextFormField(
                    model: TextFieldModel(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
        VisibleFormField(
          name: 'sliderVisible',
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: "slider",
              border: InputBorder.none,
            ),
            child: SliderFormField(
              name: 'slider',
              min: 0,
              max: 100,
            ),
          ),
        ),
        InputDecorator(
          decoration: InputDecoration(
            labelText: "range slider",
            border: InputBorder.none,
          ),
          child: RangeSliderFormField(
            name: 'rangeSlider',
            min: 1,
            max: 100,
          ),
        ),
        InputDecorator(
          decoration: InputDecoration(
            labelText: "radio list tile",
            border: InputBorder.none,
          ),
          child: ListTileFormField(
            items: FormBuilderUtils.toListTileItems(['1', '2']),
            name: 'radioTile',
            type: ListTileItemType.Radio,
            model: ListTileModel(
              hasSelectAll: false,
              split: 1,
            ),
          ),
        ),
        InputDecorator(
          decoration: InputDecoration(
            labelText: "checkbox list tile",
            border: InputBorder.none,
          ),
          child: ListTileFormField(
            items: FormBuilderUtils.toListTileItems(['1', '2']),
            name: 'checkboxTile',
            type: ListTileItemType.Checkbox,
            model: ListTileModel(
              hasSelectAll: false,
              split: 1,
            ),
          ),
        ),
        InputDecorator(
          decoration: InputDecoration(
            labelText: "switch list tile",
            border: InputBorder.none,
          ),
          child: ListTileFormField(
            name: 'switchTile',
            type: ListTileItemType.Switch,
            items: FormBuilderUtils.toListTileItems(['1', '2'],
                controlAffinity: ListTileControlAffinity.trailing),
            model: ListTileModel(
              hasSelectAll: false,
              split: 1,
            ),
          ),
        ),
      ],
    );
    return FormBuilder(
      child: child,
      key: formKey,
    );
  }
}
