# Forme

a powerful flutter form widget

## Simple Usage 

``` dart
FormeKey formKey = FormeKey(); // FormeKey is a GlobalKey and also is a FormeManagement
Forme(key:formKey,
	readOnly:true|false,
	onChanged:FormeValueChanged,
	child:Widget child,
	);
```

## Form Field

### Form Field types

``` 
FormeField
	- StatefulField
		- ValueField
			- NonnullValueField
		- CommonField
```

### attributes supported by all StatefulFields

| attribute | type |  description|
| --- | --- | --- | 
| name | String? | name of a field ,used to control field and get error and value from this field |
| builder |  FormContentBuilder | used to build field widget |
| model |  FormeModel | used to determine how to build a field widget |
| readOnly |  bool | whether field should be readOnly |

### ValueField

#### supported attributes

| attribute | type |  description|
| --- | --- | --- | 
| validator | FormFieldValidator? | validator|
| autovalidateMode |  AutovalidateMode? | when to perform autovalidate |
| initialValue |  T? | initialValue |
| enabled |  bool | whether field is enabled,if not enabled,autovalidate will not work |
| onSaved |  FormFieldSetter? | called when save form |

### NonnullValueField

#### supported attributes

**NonnullValueField extends ValueField,but some attributes are different**

| attribute | type |  description|
| --- | --- | --- | 
| validator | NonnullFieldValidator? | validator|
| initialValue |  T | initialValue |
| onSaved |  NonnullFormFieldSetter? | called when save form |

## methods

### FormeManagement

#### get FormeManagement

**FormeKey is a FormeManagement,but if you want to get underlying FormeManagement,you can use methods below**

``` dart
FormeManagement formeManagement = formKey.currentFormeManagement;// return a nonnull FormeManagement
FormeManagement? formeManagement = formKey.quietlyManagement;// return a FormeManagement , return null if not find
```

#### check whether form has a name field

``` dart
bool hasField = formeManagement.hasField(String name);
```

#### whether form is readOnly

``` dart
bool readOnly = formeManagement.readOnly;
```

#### set form readOnly|editable

``` dart
formeManagement.readOnly = true|false;
```

#### get form data

``` dart
Map<String, dynamic> data = formeManagement.data;
```

#### get form field validate errors

``` dart
List<FormeFieldManagementWithError> errors = formeManagement.errors;
```

#### quietly vaidate form

``` dart
List<FormeFieldManagementWithError> errors = formeManagement.quietlyValidate();
```

#### set form data

``` dart
formeManagement.data = data;// will trigger field's onChanged listener
formeManagement.setData(data,trigger:bool) // if trigger is false ,won't trigger field's onChanged listener
```

#### reset form

``` dart
formeManagement.reset();
```

#### validate form

**will display error text**

``` dart
bool isValid = formeManagement.validate();
```

#### whether form is valid

**won't display error text**

``` dart
bool isValid = formeManagement.isValid;
```

#### save form 

``` dart
formeManagement.save();
```

### FormeFieldManagement

#### create FormeFieldManagement by name

``` dart
FormeFieldManagement formeFieldManagement = formeManagement.field(String name);
```

#### get field's name

``` dart
String? name = formeFieldManagement.name;
```

#### whether field is readOnly

``` dart
bool readOnly = formeFieldManagement.readOnly;
```

#### set readOnly|editable on field

``` dart
formeFieldManagement.readOnly = true|false;
```

#### whether field is focusable

``` dart
bool focusable = formeFieldManagement.focusable;
```

#### whether field is focused

``` dart
bool hasFocus = formeFieldManagement.hasFocus;
```

#### focus|unfocus a form field

``` dart
formeFieldManagement.focus = true|false;
```

#### set focus listener on field

``` dart
formeFieldManagement.focusListener = (key,hasFocus){};
```

#### whether field is a value field

``` dart
bool isValueField = formeFieldManagement.isValueField;
```

#### set state model

``` dart
formeFieldManagement.model = FormeModel();
```

### update state model

``` dart
formeFieldManagement.update<T>(FormeModelUpdater<T> updater);
```

#### get state model

``` dart
FormeModel model = formeFieldManagement.model;
```

#### ensure form field visible

``` dart
formeFieldManagement.ensureVisible();
```

### FormeValueFieldManagement

**FormeValueFieldManagement extend FormeFieldManagement**

#### get FormeValueFieldManagement

**if field is not a value field , an error will be throw**

``` dart
FormeValueFieldManagement formeFieldManagement = formeManagement.valueField(String name);
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

## currently supported value fields

| field | return value | nullable|
| ---| ---| --- |
| FormeTextField|  string | false |
| FormeDateTimeTextField|  DateTime | true |
| FormeNumberTextField|  num | true |
| FormeTimeTextField | TimeOfDay | true | 
| FormeDateRangeTextField | DateTimeRange | true | 
| FormeSlider|  double | false |
| FormeRangeSlider|  RangeValues | false|
| FormeFilterChip|  List&lt; T&gt; | false |
| FormeChoiceChip|  T | true |
| FormeRate| dobule | true |
| FormeSingleCheckbox| bool | false |
| FormeSingleSwitch| bool | false |
| FormeCupertinoPicker | int | false | 
| FormeDropdownButton | T | true | 
| FormeListTile|  List&lt; T&gt; | false |


## currently supported other fields

| field | description|
| ---| --- |
| FormeButton|  button |
| FormeVisible|  make field visible\|invisible |
| FormeColumn|  a column support insert\|swap\|remove widgets |
| FormeRow|  a row support insert\|swap\|remove widgets |

## example for helping build a custom field

### build  a common field

https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_button.dart

### build a nonnull value field

https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_single_switch.dart

### build a value field

https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_rate.dart