# flutter_form_builder

## basic usage

``` dart
FormManagement formManagement = FormManagement();

Widget form = FormBuilder(
      {bool readOnly,//set form's readonly state
      bool visible, // set form's visible state
      FormThemeData? formThemeData, //set themedata of form 
      this.formManagement,
      FormInitCallback? initCallback})
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

## methods

### FormManagement

#### check whether form is initialled or not

``` dart
bool initialled = formManagement.initialled;
```

#### check whether form is visible or not 

``` dart
bool visible = formManagement.visible;
```

#### hide|show form

``` dart
formManagement.visible = true|false;
```

#### check whether form is readOnly or not 

``` dart
bool readOnly = formManagement.readOnly;
```

#### set form readonly|editable

``` dart
formManagement.readOnly = true|false;
```

#### get current form themedata

``` dart
FormThemeData formThemeData = formManagement.formThemeData;
```

#### set form theme

``` dart
formManagement.formThemeData = FormThemeData(themeData);// system theme
formManagement.formThemeData = DefaultFormTheme(); //default theme from  https://github.com/mitesh77/Best-Flutter-UI-Templates/blob/master/best_flutter_ui_templates/lib/hotel_booking/filters_screen.dart
```

#### get form data

``` dart
formManagement.data; // auto remove null
formManagement.getData({bool removeNull = false});
```

#### reset form

``` dart
formManagement.reset();
```

#### validate form

``` dart
formManagement.validate();
```

#### request focus on first invalid field

``` dart
formManagement.focusOnFirstInvalidField()
```

#### check whether form is valid or not 

**unlike validate method, this method won't display error msg**

``` dart
formManagement.isValid
```

#### check whether form has a controlKey or not

``` dart
bool exists = formManagement.hasControlKey(String controlKey);
```

#### get FormFieldManagement

``` dart
FormFieldManagement formFieldManagement = formManagement.getFormFieldManagement(String controlKey)
```

#### get FormLayoutManagement

``` dart
FormLayoutManagement formLayoutManagement = formManagement.formLayoutManagement;
```

#### get FormWidgetTreeManagement

``` dart 
FormWidgetTreeManagement formWidgetTreeManagement = formManagement.formWidgetTreeManagement

``` 

### FormFieldManagement

#### check whether a field is ValueField or not

``` dart
bool isValueField = formFieldManagement.isValueField;
```

#### check whether a field is readOnly or not

``` dart
bool readOnly = formFieldManagement.readOnly;
```

#### set readOnly on formFieldManagement

``` dart
formFieldManagement.readOnly = true|false
```

#### check whether a field is removed or not

``` dart
bool removed = formFieldManagement.removed;
```

#### remove|unremove a form field

``` dart
formFieldManagement.remove = true|false
```

#### check whether a field is visible or not

``` dart
bool visible = formFieldManagement.visible;
```

#### set visible on form field

``` dart
formFieldManagement.visible = true|false
```

#### set autovalidateMode on value field

``` 

formFieldManagement.autovalidateMode = AutovalidateMode;
```

#### set initialValue on value field

``` dart
formFieldManagement.initialValue = value;
```

  

#### validate a value field

``` 

bool isValid = formFieldManagement.validate();
```

#### check whether a value field is valid or not 

**unlike validate method, this method won't display error msg**

``` dart
bool isValid = formFieldManagement.isValid;
```

#### reset value field

``` dart
formFieldManagement.reset();
```

#### get padding of a form field

``` dart
EdgeInsets padding = formFieldManagement.padding;
```

#### set padding of a form field

``` 

formFieldManagement.padding = padding;
```

#### check whether a value field is focused or not

``` dart
bool hasFocus = formFieldManagement.focus;
```

#### Focus|unfocus a form field

``` dart
formFieldManagement.focus = true|false
```

#### get value of a value field

``` dart
dynamic value = formFieldManagement.value;
```

#### set value on a value field

``` dart
formFieldManagement.setValue(dynamic value,{bool trigger = true});
```

**trigger** whether trigger  field's onChange callback or not
 

#### rebuild a form field's state

**see supported states for every field <a href="#field-states">here</a>**

``` dart
formFieldManagement.state = {};
```

#### update a form field's state

**see supported states for every field <a href="#field-states">here</a>**

``` dart
formFieldManagement.update({});
```

#### remove form field's states

**see supported states for every field <a href="#field-states">here</a>**

``` dart
formFieldManagement.removeState(Set<String> keys); 
```

#### get TextSelectionManagement

``` dart
TextSelectionManagement textSelectionManagement = formFieldManagement.textSelectionManagement;
```

#### set focuslistener on a form field`

``` dart
formFieldManagement.focusListener = FocusListener();
```

**you should call this method in FormBuilder's initCallback**

### FormLayoutManagement 

#### get rows of form

``` 

int rows = formLayoutManagement.rows;
```

#### get FormLayoutRowManagement

``` dart
FormLayoutRowManagement formLayoutRowManagement = formLayoutManagement.getFormLayoutRowManagement(int row);
```

#### get FormFieldManagement

``` dart
FormFieldManagement formFieldManagement = formLayoutManagement.getFormFieldManagement(int row,int column);
```

### FormLayoutRowManagement

#### get columns of a row

``` dart
int columns = formLayoutRowManagement.columns;
```

#### check whether a row is visible or not

``` dart
bool visible = formLayoutRowManagement.visible;
```

#### set visiable on a row

``` dart
formLayoutRowManagement.visible = true|false;
```

#### set readOnly on a row

``` dart
formLayoutRowManagement.readOnly = true|false;
```

#### remove|unremove a row

``` 

formLayoutRowManagement.remove = true|false;
```

### FormWidgetTreeManagement 

#### check whether a layout is editing or not 

``` dart
bool isEditing = formWidgetTreeManagement.isEditing;
```

#### get rows of currrent editing layout

``` dart
int rows = formWidgetTreeManagement.rows;
```

#### get columns of a row in current editing layout

``` dart
int columns = formWidgetTreeManagement.getColumns(int row);
```

#### remove a field in widget tree

``` dart
formWidgetTreeManagement.remove(String controlKey);
```

#### remove a row|field in widget tree

``` dart
formWidgetTreeManagement.removeAtPosition(int row,{int column});
```

#### insert a row at position

``` dart
void insert(
      {int column,
      int row,
      String controlKey,
      int flex = 1,
      bool visible = true,
      EdgeInsets padding,
      @required Widget field,
      bool inline = true,
      bool insertRow = false})
```

#### swap two rows

``` dart
formWidgetTreeManagement.swapRow(int oldRow, int newRow)
```

#### start edit current layout

``` dart
formWidgetTreeManagement.startEdit();
```

#### apply edited layout

``` dart
formWidgetTreeManagement.apply();
```

#### cancel editing layout

``` dart
formWidgetTreeManagement.cancel();
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

### CheckboxGroup

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|  split  |  int  |       false        |
|  items  |  List&lt; CheckboxGroupItem&gt; |       false        |
|  errorTextPadding  | EdgeInsets   |       false        |

### RadioGroup

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|  split  |  int  |       false        |
|  items  |  List&lt; RadioGroupItem&gt; |       false        |
|  errorTextPadding  | EdgeInsets   |       false        |

### Selector

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     hintText  |        String   |       true        |
|  multi  |  bool  |       false        |
|  clearable  |  bool  |       false        |
|  inputDecorationTheme  | InputDecorationTheme   |       true     |

### Slider

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     max  |        double   |       false        |
|  min  |  double  |       false        |
|  divisions  |  int  |       false        |
|  contentPadding  | EdgeInsets   |       false     |

### RangeSlider

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     max  |        double   |       false        |
|  min  |  double  |       false        |
|  divisions  |  int  |       false        |
|  contentPadding  | EdgeInsets   |       false     |

### SwitchGroup

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     items  |        List&lt; SwitchGroupItem&gt; |       false        |
|  hasSelectAllSwitch  |  bool  |       false        |
|  selectAllPadding  |  EdgeInsets  |       false        |
|  errorTextPadding  | EdgeInsets   |       false     |

## currently support fields

| field | return value | nullable|
| ---| ---| --- |
| TextField|  string | false |
| CheckboxGroup|  List&lt; int&gt; | false |
| RadioGroup&lt; T&gt; |  &lt; T&gt; | true |
| DateTimeField|  DateTime | true |
| Selector|  List | false |
| SwitchGroup|  List&lt; int&gt; | false |
| SwitchInline|  bool | false |
| NumberField|  num | true |
| Slider|  double | false |
| RangeSlider|  RangeValues | false|

## build your own form field

TODO

developing

## develop plan

1. performance test 
2. support more fields
