# flutter_form_builder

## basic usage

``` dart
FormManagement formManagement = FormManagement();

Widget form = FormBuilder(
      {bool readOnly,//set form's readonly state
      bool visible, // set form's visible state
      FormThemeData? formThemeData, //set themedata of form 
      this.formManagement,
      bool enableLayoutManagement// when you really want to use FormLayoutManagement,you should set this property to true,otherwise set to false for performance improve})
	.textField(
          controlKey: 'username',
          labelText: 'username',
          clearable: true,
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
        )
        .switchInline(
          controlKey: 'switch1',
          onChanged: (value) => print('switch1 value changed $value'),
        )
        .nextLine()
        .textField(
            controlKey: 'password',
            hintText: 'password',
            obscureText: true,
            passwordVisible: true,
            clearable: true,
            toolbarOptions: ToolbarOptions(copy: false, paste: false),
            onChanged: (value) => print('password value changed $value'),
            flex: 1)
        .textButton(
            onPressed: () {
              formManagement
                  .getFormFieldManagement('password')
                  .textSelectionManagement
                  .selectAll();
            },
            label: 'button',
            controlKey: 'button')
        .nextLine()
        .numberField(
          controlKey: 'age',
          hintText: 'age',
          clearable: true,
          flex: 3,
          min: -18,
          max: 99,
          decimal: 0,
          onChanged: (value) => print('age value changed $value'),
          validator: (value) => value == null ? 'not empty' : null,
        )
        .checkboxGroup(
          items: FormBuilder.toCheckboxGroupItems(['male', 'female']),
          controlKey: 'checkbox',
          split: 2,
          label: 'sex',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        );
```

## form layout

Column 
  Row
    Flexible(FlexFit.tight)
      Padding 
       FormField 

## methods

### FormManagement

#### get FormThemeData

``` dart
FormThemeData formThemeData => formManagement.formThemeData
```

#### set FormThemeData

``` dart
formManagement.formThemeData = FormThemeData(themeData);// system theme
formManagement.formThemeData = DefaultFormTheme(); //default theme from  https://github.com/mitesh77/Best-Flutter-UI-Templates/blob/master/best_flutter_ui_templates/lib/hotel_booking/filters_screen.dart
```

#### has controlKey

``` dart
bool hasControlKey => formManagement.hasControlKey(String controlKey);
```

####  whether form is visible

``` dart
bool visible = formManagement.visible;
```

#### hide|show form

``` dart
formManagement.visible = true|false;
```

#### whether form is readOnly 

``` dart
bool readOnly = formManagement.readOnly;
```

#### set form readonly|editable

``` dart
formManagement.readOnly = true|false;
```

#### get rows of form

``` dart
int rows = formManagement.rows;
```

#### whether enableLayoutManagement 

``` dart
bool enableLayoutManagement = formManagement.enableLayoutManagement;
```

#### create FormFieldManagement

**if your field does not has a controlKey use newFormFieldManagementByPosition instead**

``` dart
FormFieldManagement formFieldManagement =  newFormFieldManagement(String controlKey);
```

#### create FormFieldManagement by position

**if field at position has a controlKey, you should use newFormFieldManagement rather than this method!**

``` dart
FormFieldManagement formFieldManagement =  newFormFieldManagementByPosition(int row,int column);
```

#### get form data

**only contains field which has a controlKey**

``` dart
Map<String,dynamic> dataMap = formManagement.data;
```

#### reset form

``` dart
formManagement.reset();
```

#### validate form

``` dart
formManagement.validate();
```

#### whether form is valid 

**unlike validate method, this method won't display error msg**

``` dart
formManagement.isValid
```

#### get error

``` dart
Map<FieldKey, String> errorMap = formManagement.error;
```

#### get focusable & invalid fields

**has been sorted by row & column**

``` dart
Iterable<FocusableInvalidField> fields = focusManagement.getFocusableInvalidFields();
```

#### create FormRowManagement

``` dart 
FormRowManagement formRowManagement = formManagement.newFormRowManagement(int row);
``` 

#### create FormLayoutManagement

``` dart
FormLayoutManagement formLayoutManagement = newFormLayoutManagement()
```

### FormFieldManagement

#### whether field is focusable

``` dart
bool focusable => formFieldManagement.focusable
```

#### whether field is focused

``` dart
bool focused => formFieldManagement.hasFocus
```

#### focus|unfocus field

``` dart
formFieldManagement.focus = true|false
```

#### set focuslistener

**call this method in WidgetsBinding.instance!.addPostFrameCallback**

``` dart
formFieldManagement.focusListener = (key,hasFocus){
  // when key is null, root node focused
  // otherwise sub node focused
}
```

#### get ValueFieldManagement 

**field must be a valuefield ,otherwise an error will be throw**

``` dart
ValueFieldManagement ValueFieldManagement  = formFieldManagement.valueFieldManagement 
```

#### whether field is ValueField

``` dart
bool isValueField = formFieldManagement.isValueField;
```

#### whether field support textSelection

``` dart
bool supportTextSelection = formFieldManagement.supportTextSelection
```

#### get TextSelectionManagement

**if field don't support textSelection ,an error will be throw**

``` dart
TextSelectionManagement  textSelectionManagement = formFieldManagement.textSelectionManagement
```

#### whether field is readOnly

``` dart
bool readOnly = formFieldManagement.readOnly;
```

#### set readOnly 

``` dart
formFieldManagement.readOnly = true|false
```

#### whether field is visible

``` dart
bool visible = formFieldManagement.visible;
```

#### set visible

``` dart
formFieldManagement.visible = true|false
```

#### get padding

``` dart
EdgeInsets? padding = formFieldManagement.padding;
```

#### set padding

``` dart
formFieldManagement.padding = padding;
```

#### rebuild field's state

**see supported states for every field <a href="#field-states">here</a>**

``` dart
formFieldManagement.state = {};
```

#### update field's state

**see supported states for every field <a href="#field-states">here</a>**

``` dart
formFieldManagement.update({});
```

#### update one field state

**see supported states for every field <a href="#field-states">here</a>**

``` dart
formFieldManagement.update1(String key,dynamic value);
```

#### remove field's states

**see supported states for every field <a href="#field-states">here</a>**

``` dart
formFieldManagement.removeStateKey(Set<String> keys); 
```

### ValueFieldManagement

#### get value

``` dart
dynamic value => valueFieldManagement.value
```

#### set value

``` dart
valueFieldManagement.value = value;//will trigger onChanged
valueFieldManagement.setValue(dynamic value,{bool trigger})
```

#### whether field is valid

**this method won't display error msg**

``` dart
bool isValid = valueFieldManagement.isValid;
```

#### validate field

**this method will display error and return whether field is valid**

``` dart
bool isValid = valueFieldManagement.validate();
```

#### reset field

``` dart
valueFieldManagement.reset();
```

#### get error

``` dart
String? error = valueFieldManagement.error;
```

### FormRowManagement 

#### get columns

``` dart
int columns = formRowManagement.rows;
```

#### whether row is visible

``` dart
bool visible = formRowManagement.visible;
```

#### set visible

``` dart
formRowManagement.visible = true|false;
```

#### set readOnly

``` dart
formManagement.readOnly = true|false;
```

### FormLayoutManagement 

#### whether a layout is editing 

``` dart
bool isEditing = formLayoutManagement.isEditing;
```

#### get rows of currrent editing layout

``` dart
int rows = formLayoutManagement.rows;
```

#### get columns of a row in current editing layout

``` dart
int columns = formLayoutManagement.getColumns(int row);
```

#### remove a row|field in layout

``` dart
formLayoutManagement.remove(int row,{int column});
```

#### insert field at position

``` dart
void insert(
      {int? column,
      int? row,
      String? controlKey,
      int? flex,
      bool visible = true,
      EdgeInsets? padding,
      required AbstractFormField field,
      bool inline = true,
      bool insertRow = false})
```

#### swap two rows

``` dart
formLayoutManagement.swapRow(int oldRow, int newRow)
```

#### start edit current layout

``` dart
formLayoutManagement.startEdit();
```

#### apply edited layout

``` dart
formLayoutManagement.apply();
```

#### cancel editing layout

``` dart
formLayoutManagement.cancel();
```

## field states

### ClearableTextFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     hintText   |        String   |       true        |
|  keyboardType  |  TextInputType  |       true        |
|  autofocus  |  bool  |       false        |
|  maxLines  |  int  |       true        |
|  maxLength  |  int  |       true        |
|  clearable  |  bool  |       false        |
|  prefixIcon  |  Widget  |       true        |
|  inputFormatters  |  List&lt; TextInputFormatter&gt; |       true        |
|  style  |  TextStyle  |       true        |
|  toolbarOptions  |  ToolbarOptions  |       true        |
|  selectAllOnFocus  |  bool  |       false        |
|  suffixIcons  |  List&lt; Widget&gt; |       true        |
|  textInputAction  |  TextInputAction |       true        |
|  inputDecorationTheme  |  InputDecorationTheme |       true        |

### DateTimeFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     hintText   |        String   |       true        |
|  maxLines  |  int  |       false        |
|  useTime  |  bool  |       false        |
|  formatter  |  DateTimeFormatter  |       true        |
|  style  |  TextStyle  |       true        |
|  inputDecorationTheme  |  InputDecorationTheme |       true        |

### NumberFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     hintText   |        String   |       true        |
|  autofocus  |  bool  |       false        |
|  clearable  |  bool  |       false        |
|  prefixIcon  |  Widget  |       true        |
|  style  |  TextStyle  |       true        |
|  suffixIcons  |  List&lt; Widget&gt; |       true        |
|  textInputAction  |  TextInputAction |       true        |
|  inputDecorationTheme  |  InputDecorationTheme |       true        |
|  decimal  |  int |       false        |
|  max  |  max |       true        |
|  min  |  min |       true        |

### CheckboxGroupFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|  split  |  int  |       false        |
|  items  |  List&lt; CheckboxGroupItem&gt; |       false        |
|  errorTextPadding  | EdgeInsets   |       false        |

### RadioGroupFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|  split  |  int  |       false        |
|  items  |  List&lt; RadioGroupItem&gt; |       false        |
|  errorTextPadding  | EdgeInsets   |       false        |

### SelectorFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     hintText  |        String   |       true        |
|  multi  |  bool  |       false        |
|  clearable  |  bool  |       false        |
|  inputDecorationTheme  | InputDecorationTheme   |       true     |

### SliderFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     max  |        double   |       false        |
|  min  |  double  |       false        |
|  divisions  |  int  |       false        |
|  contentPadding  | EdgeInsets   |       false     |

### RangeSliderFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     max  |        double   |       false        |
|  min  |  double  |       false        |
|  divisions  |  int  |       false        |
|  contentPadding  | EdgeInsets   |       false     |

### SwitchGroupFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     items  |        List&lt; SwitchGroupItem&gt; |       false        |
|  hasSelectAllSwitch  |  bool  |       false        |
|  selectAllPadding  |  EdgeInsets  |       false        |
|  errorTextPadding  | EdgeInsets   |       false     |

### FilterChipFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     items  |        List&lt; FilterChipItem&lt;T&gt;&gt; |       false        |
|  pressElevation  |  double  |       true        |
|  errorTextPadding  | EdgeInsets   |       false     |


## currently support fields

| field | return value | nullable|
| ---| ---| --- |
| ClearableTextFormField|  string | false |
| CheckboxGroupFormField|  List&lt; int&gt; | false |
| RadioGroupFormField|  T | true |
| DateTimeFormField|  DateTime | true |
| SelectorFormField|  List&lt; T&gt; | false |
| SwitchGroupFormField|  List&lt; int&gt; | false |
| SwitchInlineFormField|  bool | false |
| NumberFormField|  num | true |
| SliderFormField|  double | false |
| RangeSliderFormField|  RangeValues | false|
| FilterChipFormField|  List&lt; T&gt; | false |

## build your own form field

### build a value field

if you want to build a nullable value field ,just extends ValueField

this is an example:

``` dart
class CustomNullableValueField<T> extends ValueField<T> {
  CustomNullableValueField({
    required T value,
    String? label,
    TextStyle? textStyle,
    T? initialValue,
    ValueChanged<T?>? onChanged,
    FormFieldValidator<T>? validator,
  }) : super(
          {
            'label': TypedValue<String?>(label),
            'textStyle': TypedValue<TextStyle?>(textStyle),
          }, //this is a initStateMap
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          builder: (state, stateMap, readOnly, formThemeData) {
            // state is ValueFieldState<T>,if you override ValueFieldState,you can cast it as your custom ValueFieldState,in this example you can cast it to _CustomNullableValueFieldState,you can get controlKey via state.controlKey(nullable),you can also get row|column|flex|inline to help you building your widget
            // readOnly : this field should readOnly
            // stateMap : can be regarded as the lastest initStateMap , user can change stateMap var FormFieldManagement's update|removeState|directly set state, in this example ,you should get label&textStyle form stateMap rather than directly use them
            // formThemeData : FormThemeData
            return Row(
              children: [
                Text(
                  stateMap['label'] ??
                      'radio', //don't use just label here,you should get lastest label from stateMap,the key is initStateMap's label key
                  style: stateMap['textStye'],
                ),
                Radio<T>(
                  focusNode: state
                      .focusNode, //state has prepared a focusnode for you,just use it rather than create a new one
                  activeColor: formThemeData.themeData.primaryColor,
                  groupValue: state.value,
                  value: value,
                  onChanged:
                      readOnly ? null : (value) => state.didChange(value),
                )
              ],
            );
          },
        );

  @override
  _CustomNullableValueFieldState<T> createState() =>
      _CustomNullableValueFieldState();
}
```

if you also want to build custom ValueFieldState,extends it !

``` dart
class _CustomNullableValueFieldState<T> extends ValueFieldState<T>
    with TextSelectionManagement // if you form field support textselection
{
  late final TextEditingController
      textEditingController; //just an example here !

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
        text:
            widget.initialValue == null ? '' : widget.initialValue.toString());
  }

  @override
  void reset() {
    super.reset();
    textEditingController.text =
        widget.initialValue == null ? '' : widget.initialValue.toString();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void selectAll() {
    setSelection(0, textEditingController.text.length);
  }

  @override
  void setSelection(int start, int end) {
    TextSelectionManagement.setSelectionWithTextEditingController(
        start, end, textEditingController);
  }
}
```

the last step is insert your field 

``` dart
.field(
    controlKey:'test',//important !,used to maintain state and used as a key when you get data via FormManagement.data
    field: CustomNullableValueField<String>(
        onChanged: (value) => print(value), value: '123'),
    flex: 1,
    inline: true),//if inline is false,the field will hole whole column,otherwise flex will work
```

build a nonnull value field is almost the same,just extends NonnullValueField

this is an example:

``` dart
class CustomNonnullableValueField extends NonnullValueField<bool> {
  CustomNonnullableValueField({
    String? label,
    TextStyle? textStyle,
    required bool initialValue,
    ValueChanged<bool>? onChanged,
    NonnullFieldValidator<bool>? validator,
  }) : super(
          {
            'label': TypedValue<String?>(label),
            'textStyle': TypedValue<TextStyle?>(textStyle),
          },
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          builder: (state, stateMap, readOnly, formThemeData) {
            return Row(
              children: [
                Text(
                  stateMap['label'] ?? 'checkbox',
                  style: stateMap['textStye'],
                ),
                Checkbox(
                  activeColor: formThemeData.themeData.primaryColor,
                  value: state.value,
                  onChanged: (value) => state.didChange(value),
                )
              ],
            );
          },
        );
}
```

### build a commonfield

``` dart
class Label extends CommonField {
  final String label;
  Label(this.label)
      : super(
          {'label': TypedValue<String>(label)},
          builder: (state, stateMap, readOnly, formThemeData) {
            return Text(
              stateMap['label'],
              style: TextStyle(
                  fontSize: 18, color: formThemeData.themeData.primaryColor),
            );
          },
        );
}
```

### build a StatelessField

``` dart
StatelessField field = StatelessField(builder: (context) {
    BuilderInfo info = BuilderInfo.of(context);
    FieldKey fieldKey = info.fieldKey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I\'m a custom field',
          style: TextStyle(fontSize: 20),
        ),
        Container(
          color: info.formThemeData.themeData.primaryColor
              .withOpacity(0.3),
          child: ListView(
            shrinkWrap: true,
            children: [
              createRow('row', '${fieldKey.row}'),
              createRow('column', '${fieldKey.column}'),
              createRow('controlKey', '${fieldKey.controlKey ?? ''}'),
              createRow('flex', '${info.flex}'),
              createRow('inline', '${info.inline}'),
              createRow('readOnly', '${info.readOnly}'),
            ],
          ),
        )
      ],
    );
  });
```

## project status

beta

## develop plan

1. performance test 
2. support more fields
