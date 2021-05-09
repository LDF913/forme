# flutter_form_builder

## basic usage

``` dart
FormManagement formManagement = FormManagement();

Widget form = FormBuilder(
      {bool readOnly,//set form's readonly state
      bool visible, // set form's visible state
      FormThemeData? formThemeData, //set themedata of form 
      MainAxisAlignment? mainAxisAlignment, // customize column 
      MainAxisSize? mainAxisSize,
      CrossAxisAlignment? crossAxisAlignment,
      TextDirection? textDirection,
      VerticalDirection? verticalDirection,
      TextBaseline? textBaseline,
      /// whether enableLayoutManagement
      ///
      /// if enabled , global key will be used for every field (root of form field)
      ///
      /// **enable it when you really need modify form layout at runtime,otherwise disable it for performance improve,
      /// this flag should not be changed at runtime**
      ///
      /// **experimental**
      bool enableLayoutFormManagement = false,
      this.formManagement,
	.textField(
          name: 'username',
          labelText: 'username',
          clearable: true,
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
        )
        .switchInline(
          name: 'switch1',
          onChanged: (value) => print('switch1 value changed $value'),
        )
        .nextLine()
        .textField(
            name: 'password',
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
            name: 'button')
        .nextLine()
        .numberField(
          name: 'age',
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
          name: 'checkbox',
          split: 2,
          label: 'sex',
          onChanged: (value) => print('checkbox value changed $value'),
          validator: (value) => value.isEmpty ? 'pls select sex' : null,
        );
```

## form widget tree

```
Column 
  Row
    FormField 
```

### base field widget tree

base field is default form field

```
Flexible(
  fit: state.visible ? FlexFit.tight : FlexFit.loose,
  child: Padding(
    padding: state.padding ?? const EdgeInsets.all(5),
    child: Visibility(
      maintainState: true,
      child: BaseFormField,
      visible: state.visible,
    ),
  ),
  flex: state.flex,
)
```

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

#### whether has a name field

``` dart
bool hasField => formManagement.hasField(String name);
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
#### create FormFieldManagement

``` dart
FormFieldManagement formFieldManagement = formManagement.newFormFieldManagement(String name);
```

#### create FormPositionManagement

``` dart
FormPositionManagement formPositionManagement = formManagement.newFormPositionManagement(int row,{int? column});
```

#### create FormLayoutManagement

``` dart
FormLayoutManagement formLayoutManagement = formManagement.newFormLayoutManagement()
```

#### get form data

**only contains field which has a name**

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
bool isValid = formManagement.isValid
```

#### get error

``` dart
Map<String, String> errorMap = formManagement.error;
```
#### create FormRowManagement

``` dart 
FormRowManagement formRowManagement = formManagement.newFormRowManagement(int row);
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

#### get field's state value

``` dart
T? value => formFieldManagement.getState<T>(String stateKey);
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

### FormPositionManagement

#### whether all fields is readOnly

``` dart
bool get readOnly => formPositionManagement.readOnly;
```

#### set readOnly on all fields

``` dart
formPositionManagement.readOnly = true|false;
```

#### whether at least one field is visible

``` dart
bool visible = formPositionManagement.visible;
```

#### set visible on all fields

``` dart
formPositionManagement.visible = true|false;
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

#### customize column

``` dart
void customizeColumn({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  })
```

#### customize row

``` dart
void customizeRow({
    int? row,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  })
```

#### remove in layout

``` dart
formLayoutManagement.remove(int row,{int column});
```

#### insert field at position

``` dart
void insert(
    {int? column,
    int? row, //if row is null,append after last row
    required Widget field, 
    bool newRow = false,//whether create a new row
    })
```

#### swap two rows

``` dart
formLayoutManagement.swapRow(int oldRow, int newRow)
```

#### start edit current layout

**you should enableLayoutFormManagement**

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
|  labelPadding  | EdgeInsets   |       false        |

### RadioGroupFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|  split  |  int  |       false        |
|  items  |  List&lt; RadioGroupItem&gt; |       false        |
|  errorTextPadding  | EdgeInsets   |       false        |
|  labelPadding  | EdgeInsets   |       false        |

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
|  labelPadding  | EdgeInsets   |       false        |

### RangeSliderFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     max  |        double   |       false        |
|  min  |  double  |       false        |
|  divisions  |  int  |       false        |
|  contentPadding  | EdgeInsets   |       false     |
|  labelPadding  | EdgeInsets   |       false        |

### SwitchGroupFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     items  |        List&lt; SwitchGroupItem&gt; |       false        |
|  hasSelectAllSwitch  |  bool  |       false        |
|  selectAllPadding  |  EdgeInsets  |       false        |
|  errorTextPadding  | EdgeInsets   |       false     |
|  labelPadding  | EdgeInsets   |       false        |

### FilterChipFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        String   |       true        |
|     items  |        List&lt; FilterChipItem&lt;T&gt;&gt; |       false        |
|  pressElevation  |  double  |       true        |
|  errorTextPadding  | EdgeInsets   |       false     |
|  labelPadding  | EdgeInsets   |       false        |
|  count  | int   |       true        |


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

if you want to build a nullable value field ,just extends BaseValueField

this is an example:

``` dart
class CustomNullableValueField<T> extends BaseValueField<T> {
  CustomNullableValueField({
    String? name,//important !,used to maintain state and used as a key when you get data via FormManagement.data
    required T value,
    String? label,
    TextStyle? textStyle,
    T? initialValue,
    ValueChanged<T?>? onChanged,
    FormFieldValidator<T>? validator,
  }) : super(
          {
            'label': StateValue<String?>(label),
            'textStyle': StateValue<TextStyle?>(textStyle),
          }, //this is a initStateMap
          name:name,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.formThemeData;
            // state is ValueFieldState<T>,if you override ValueFieldState,you can cast it as your custom ValueFieldState,in this example you can cast it to _CustomNullableValueFieldState,you can get name via state.name(nullable),you can also get row|column|flex|inline to help you building your widget
            // readOnly : whether this field should readOnly
            // stateMap : can be regarded as the lastest initStateMap , user can change stateMap var FormFieldManagement's update|removeState|directly set state, in this example ,you should get label&textStyle form stateMap rather than directly use them
            // themeData : ThemeData
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
                  activeColor: themeData.primaryColor,
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
class _CustomNullableValueFieldState<T> extends BaseValueFieldState<T>
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
FormBuilder.field(
    field: CustomNullableValueField<String>(
        onChanged: (value) => print(value), value: '123')),
```

build a nonnull value field is almost the same,just extends BaseNonnullValueField

this is an example:

``` dart

class CustomNonnullableValueField extends BaseNonnullValueField<bool> {
  CustomNonnullableValueField({
    String? label,
    TextStyle? textStyle,
    required bool initialValue,
    ValueChanged<bool>? onChanged,
    NonnullFieldValidator<bool>? validator,
  }) : super(
          {
            'label': StateValue<String?>(label),
            'textStyle': StateValue<TextStyle?>(textStyle),
          },
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          builder: (state) {
            bool readOnly = state.readOnly;
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.formThemeData;
            return Row(
              children: [
                Text(
                  stateMap['label'] ?? 'checkbox',
                  style: stateMap['textStye'],
                ),
                Checkbox(
                  activeColor: themeData.primaryColor,
                  value: state.value,
                  onChanged: readOnly ? null : (value) => state.didChange(value),
                )
              ],
            );
          },
        );
}
```

### build a commonfield

``` dart
class Label extends BaseCommonField {
  final String label;
  Label(this.label)
      : super(
          {'label': StateValue<String>(label)},
          builder: (state) {
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = state.formThemeData;
            return Text(
              stateMap['label'],
              style: TextStyle(
                  fontSize: 18, color: themeData.primaryColor),
            );
          },
        );
}
```

### build a Stateless Field

``` dart
FormBuilder.field(field: Builder(builder: (context) {
          BuilderInfo info = BuilderInfo.of(context);
          Position position = info.position;
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I\'m a stateless field',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  color: info.formThemeData.primaryColor.withOpacity(0.3),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      createRow('row', '${position.row}'),
                      createRow('column', '${position.column}'),
                      createRow('inline', '${info.inline}'),
                    ],
                  ),
                )
              ],
            ),
            flex: 1,
          );
        }))
```

## project status

beta

## develop plan

1. performance test 
2. support more fields
