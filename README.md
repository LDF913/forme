# Form Builder

a flutter row-column based form builder ! build form quickly,create field fast,less code,more powerful

## Simple Usage 

``` dart
FormKey formKey = FormKey(); // FormKey is a GlobalKey, used to get  a FormManagement
FormBuilder(key:formKey,
	readOnly:true|false,
	onChanged:FormValueChanged,
	child:Widget child,
	);
```

## Form Field

### Form Field types

``` 
FormField
	- StatefulField
		- ValueField
			- NonnullValueField
		- CommonField
```

### attributes supported by all StatefulFields

| attribute | type |  description|
| -- | -- | -- | 
| name | String? | name of a field ,used to control field and get error|value from this field |
| builder |  FormContentBuilder | used to build field widget |
| model |  AbstractFieldStateModel | used to determine how to build a field widget |
| readOnly |  bool | whether field should be readOnly |

### ValueField

#### supported attributes

| attribute | type |  description|
| -- | -- | -- | 
| validator | FormFieldValidator? | validator|
| autovalidateMode |  AutovalidateMode? | |
| initialValue |  T? | |
| enabled |  bool | |
| onSaved |  FormFieldSetter? | called when save form |

### NonnullValueField

#### supported attributes

| attribute | type |  description|
| -- | -- | -- | 
| validator | NonnullFieldValidator? | validator|
| autovalidateMode |  AutovalidateMode? | |
| initialValue |  T | |
| enabled |  bool | |
| onSaved |  NonnullFormFieldSetter? | called when save form |

## methods

### FormManagement

#### get FormManagement

``` dart
FormManagement formManagement = formKey.currentFormManagement;// return a nonnull FormManagement
FormManagement? formManagement = formKey.quietlyManagement;// return a FormManagement , return null if not find
```

#### check whether form has a name field

``` dart
bool hasField = formManagement.hasField(String name);
```

#### whether form is readOnly

``` dart
bool readOnly = formManagement.readOnly;
```

#### set form readOnly|editable

``` dart
formManagement.readOnly = true|false;
```

#### get form data

``` dart
Map<String, dynamic> data = formManagement.data;
```

#### get form field validate errors

``` dart
List<FormFieldManagementWithError> errors = formManagement.errors;
```

#### quietly vaidate form

``` dart
List<FormFieldManagementWithError> errors = formManagement.quietlyValidate();
```

#### set form data

``` dart
formManagement.data = data;// will trigger field's onChanged listener
formManagement.setData(data,trigger:bool) // if trigger is false ,won't trigger field's onChanged listener
```

#### reset form

``` dart
formManagement.reset();
```

#### validate form

**will display error text**

``` dart
bool isValid = formManagement.validate();
```

#### whether form is valid

**won't display error text**

``` dart
bool isValid = formManagement.isValid;
```

#### save form 

``` dart
formManagement.save();
```

### FormFieldManagement

#### create FormFieldManagement by name

``` dart
FormFieldManagement formFieldManagement = formManagement.newFormFieldManagement(String name);
```

#### get field's name

``` dart
String? name = formFieldManagement.name;
```

#### whether field is readOnly

``` dart
bool readOnly = formFieldManagement.readOnly;
```

#### set readOnly|editable on field

``` dart
formFieldManagement.readOnly = true|false;
```

#### whether field is focusable

``` dart
bool focusable = formFieldManagement.focusable;
```

#### whether field is focused

``` dart
bool hasFocus = formFieldManagement.hasFocus;
```

#### focus|unfocus a form field

``` dart
formFieldManagement.focus = true|false;
```

#### set focus listener on field

``` dart
formFieldManagement.focusListener = (key,hasFocus){};
```

#### whether field is a value field

``` dart
bool isValueField = formFieldManagement.isValueField;
```

#### whether field support TextSelection

``` dart
bool supportTextSelection = formFieldManagement.supportTextSelection;
``` 

#### set state model

``` dart
formFieldManagement.model = AbstractFieldStateModel();
```

#### get state model

``` dart
AbstractFieldStateModel model = formFieldManagement.model;
```

#### ensure form field visible

``` dart
formFieldManagement.ensureVisible();
```

### TextSelectionManagement

#### get TextSelectionManagement

``` dart
TextSelectionManagement textSelectionManagement = formFieldManagement.textSelectionManagement;
```

#### select all 

``` dart
textSelectionManagement.selectAll();
```

#### select selection

``` dart
textSelectionManagement.setSelection(int start,int end);
```

### ValueFieldManagement

#### get ValueFieldManagement

**if field is not a value field , an error will be throw**

``` dart
ValueFieldManagement valueFieldManagement = formFieldManagement.valueFieldManagement;
```

#### get field's value

``` dart
dynamic value = valueFieldManagement.value;
```

#### set field value

``` dart
valueFieldManagement.value = value; // set field value , will trigger onChanged listener
textSelectionManagement.setValue(value,trigger:bool); // if trigger is false ,won't trigger onChanged listener
```

#### whether field is valid

**won't display error text**

``` dart
bool isValid = valueFieldManagement.isValid;
```

#### validate field

**will display error text**

``` dart
bool isValid = valueFieldManagement.validate();
```

#### get error text

``` dart
String? errorText = valueFieldManagement.errorText;
```

#### quietlyValidate field

**won't display error text**

``` dart
String? errorText = valueFieldManagement.quietlyValidate();
```

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
| SingleCheckBoxFormField| bool | false |
| SingleSwitchFormField| bool | false |
| CupertinoPickerFormField | int | false | 

## example for helping build a custom field

### build  a common field

https://github.com/wwwqyhme/flutter-form-builder/blob/main/lib/src/field/button.dart

### build a nonnull value field

https://github.com/wwwqyhme/flutter-form-builder/blob/main/lib/src/field/single_switch.dart

### build a value field

https://github.com/wwwqyhme/flutter-form-builder/blob/main/lib/src/field/rate.dart