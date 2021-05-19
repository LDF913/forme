# flutter_form_builder

## basic usage

``` dart
FormKey formKey = FormKey();// formkey is a global key

//if you want to create a simple formbuilder
Widget form = FormBuilder()
         .key(formKey)
        .onChanged((name, oldValue, newValue) {
          print(
              '$name\'s value changed, oldValue:$oldValue newValue:$newValue');
        }).build(child:Widget);

// if you want to create a row-column based formbuilder
Widget form = FormBuilder()
        .key(formKey)
        .onChanged((name, oldValue, newValue) {
          print(
              '$name\'s value changed, oldValue:$oldValue newValue:$newValue');
        })
        .layoutBuilder()
        .enableLayoutManagement(true)
        .oneRowField(ClearableTextFormField(
          name: 'username',
          labelText: 'username',
          clearable: true,
          onTap: () {
            print("??");
          },
          selectAllOnFocus: true,
          validator: (value) =>
              value.isEmpty ? 'username can not be empty !' : null,
        )).build();
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

### FormBuilder

#### create a new row

**if form layout's last row is not empty,will creat a new row**

``` dart
FormBuilder builder = formBuilder.newRow();
```

#### customize last row

``` dart
FormBuilder builder = formBuilder.customize({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
  })
```

#### append a field

**append a field to last row**

``` dart
FormBuilder builder = formBuilder.append(Widget field);
```

#### append a builder field

``` dart
FormBuilder builder = formBuilder.appendBuilder(FieldBuilder builder);
```

#### append a field take up one row

``` dart
FormBuilder builder = formBuilder.oneRowField(Widget field);
```

#### append a builder field take up one row

``` dart
FormBuilder builder = formBuilder.oneRowBuilder(FieldBuilder builder);
```

### FormManagement

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

#### get column of row

``` dart
int column = formManagement.getColumn(row);
```

#### create FormFieldManagement

``` dart
FormFieldManagement formFieldManagement = formManagement.newFormFieldManagement(String name);
```

#### create FormPositionManagement

``` dart
FormPositionManagement formPositionManagement = formManagement.newFormPositionManagement(int row,{int? column});
```

#### create FormLayoutManagement(experimental)

``` dart
FormLayoutManagement formLayoutManagement = formManagement.newFormLayoutManagement()
```

#### get form data

**only contains field which has a name**

``` dart
Map<String,dynamic> dataMap = formManagement.data;
```

#### set form data

``` dart
Map<String,dynamic> formData = {};
formManagement.data = formData;//will trigger field's onChanged
formManagement.setData(formData,{trigger:trigger});
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

**get all errors after validate**

``` dart
Map<String, FormFieldManagement> errorMap = formManagement.error;
```

#### quietly validate

**validate all field and get error , this method will not display error msg**

``` dart
List<FormFieldManagementError> errors = formManagement.quietlyValidate();
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

#### make field visible in viewport

**not work if field or form is invisible**

``` dart
  Future<void> future = formFieldManagement.ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment})
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

### FormLayoutManagement (experimental)

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
|  minLines  |  int  |       true        |
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
| textCapitalization | TextCapitalization| true|

### DateTimeFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     hintText   |        String   |       true        |
|  maxLines  |  int  |       false        |
|  type  |  DateTimeType  |       false        |
|  formatter  |  DateTimeFormatter  |       true        |
|  style  |  TextStyle  |       true        |
|  inputDecorationTheme  |  InputDecorationTheme |       true        |
|  firstDate  |  DateTime  |       false        |
|  lastDate  |  DateTime  |       false        |

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
|  max  |  double |       true        |
|  allowNegative  |  bool |       false        |


### SelectorFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     hintText  |        String   |       true        |
|  multi  |  bool  |       false        |
|  clearable  |  bool  |       false        |
|  selectorThemeData  | SelectorThemeData   |       false     |
|  selectedItemLayoutType  | SelectedItemLayoutType   |       false     |

### SliderFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     max  |        double   |       false        |
|  min  |  double  |       false        |
|  divisions  |  int  |       false        |
|  activeColor  | Color   |       true     |
|  inactiveColor  | Color   |       true     |

### RangeSliderFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     max  |        double   |       false        |
|  min  |  double  |       false        |
|  divisions  |  int  |       false        |
|  activeColor  | Color   |       true     |
|  inactiveColor  | Color   |       true     |

### ListTileFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     split  |        int   |       false        |
|     items  |        List&lt; ListTileItem&lt;T&gt;&gt; |       false        |
|  hasSelectAll  |  bool  |       false        |
|  checkboxRenderData  |  CheckboxRenderData  |       true        |
|  radioRenderData  |  RadioRenderData  |       true        |
|  switchRenderData  |  SwitchRenderData  |       true        |
|  listTileThemeData  | ListTileThemeData   |       true     |

### FilterChipFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|     items  |        List&lt; FilterChipItem&lt;T&gt;&gt; |       false        |
|  pressElevation  |  double  |       true        |
|  count  | int   |       true        |
|  layoutType  | ChipLayoutType   |       false        |
|  chipThemeData  | ChipThemeData   |       true        |

### RateFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     labelText  |        String   |       true        |
|  rateThemeData  | RateThemeData   |       true        |


### SingleSwitchFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        Widget   |       true        |
|  switchRenderData  | SwitchRenderData   |       true        |


### SingleCheckboxFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     label  |        Widget   |       true        |
|  checkboxRenderData  | CheckboxRenderData   |       true        |


### ButtonFormField

|     name       |        Type     |       nullable    |
|     --         |        --       |       ---         |
|     icon  |        Widget   |       true        |
|  child  | Widget   |       false        |

## currently support fields

| field | return value | nullable|
| ---| ---| --- |
| ClearableTextFormField|  string | false |
| DateTimeFormField|  DateTime | true |
| SelectorFormField|  List&lt; T&gt; | false |
| ListTileFormField|  List&lt; T&gt; | false |
| InlineFormField|  bool | false |
| NumberFormField|  num | true |
| SliderFormField|  double | false |
| RangeSliderFormField|  RangeValues | false|
| FilterChipFormField|  List&lt; T&gt; | false |
| RateFormField| dobule | true |
| SingleSwitchFormField| bool | false |
| SingleCheckboxFormField| bool | false |
|ButtonFormField|-|-|

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
            ThemeData themeData = Theme.of(context);
            // state is ValueFieldState<T>,if you override ValueFieldState,you can cast it as your custom ValueFieldState,in this example you can cast it to _CustomNullableValueFieldState,you can get name via state.name(nullable)
            // readOnly : whether this field should readOnly
            // stateMap : can be regarded as the lastest initStateMap , user can change stateMap var FormFieldManagement's update,
            // in this example ,you should get label&textStyle form stateMap rather than directly use them
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
FormBuilder.append(CustomNullableValueField<String>(
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
            ThemeData themeData = Theme.of(state.context);
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
  Label(this.label, {int flex = 1})
      : super(
          {'label': StateValue<String>(label)},
          flex: flex,
          builder: (state) {
            Map<String, dynamic> stateMap = state.currentMap;
            ThemeData themeData = Theme.of(state.context);
            return Text(
              stateMap['label'],
              style: TextStyle(fontSize: 18, color: themeData.primaryColor),
            );
          },
        );
}
```

### build a Stateless Field

``` dart
FormBuilder.append(Builder(builder: (context) {
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
                  color: info.themeData.primaryColor.withOpacity(0.3),
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

1.0.0 release