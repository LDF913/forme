# Forme

a powerful flutter form widget

## Simple Usage 

``` dart
FormeKey formKey = FormeKey(); // FormeKey is a GlobalKey, used to get  a FormeManagement
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
| name | String? | name of a field ,used to control field and get error\|value from this field |
| builder |  FormContentBuilder | used to build field widget |
| model |  AbstractFormeModel | used to determine how to build a field widget |
| readOnly |  bool | whether field should be readOnly |

### ValueField

#### supported attributes

| attribute | type |  description|
| --- | --- | --- | 
| validator | FormFieldValidator? | validator|
| autovalidateMode |  AutovalidateMode? | -  |
| initialValue |  T? | -  |
| enabled |  bool | - |
| onSaved |  FormFieldSetter? | called when save form |

### NonnullValueField

#### supported attributes

| attribute | type |  description|
| --- | --- | --- | 
| validator | NonnullFieldValidator? | validator|
| autovalidateMode |  AutovalidateMode? |-  |
| initialValue |  T |-  |
| enabled |  bool |-  |
| onSaved |  NonnullFormFieldSetter? | called when save form |

## methods

### FormeManagement

#### get FormeManagement

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
FormeFieldManagement formeFieldManagement = formeManagement.newFormeFieldManagement(String name);
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

#### whether field support TextSelection

``` dart
bool supportTextSelection = formeFieldManagement.supportTextSelection;
``` 

#### set state model

``` dart
formeFieldManagement.model = AbstractFormeModel();
```

#### get state model

``` dart
AbstractFormeModel model = formeFieldManagement.model;
```

#### ensure form field visible

``` dart
formeFieldManagement.ensureVisible();
```

### FormeValueFieldManagement

#### get FormeValueFieldManagement

**if field is not a value field , an error will be throw**

``` dart
FormeValueFieldManagement valueFieldManagement = formeFieldManagement.valueFieldManagement;
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
| FormeDateTime|  DateTime | true |
| FormeSelector|  List&lt; T&gt; | false |
| FormeListTile|  List&lt; T&gt; | false |
| FormeNumberTextField|  num | true |
| FormeSlider|  double | false |
| FormeRangeSlider|  RangeValues | false|
| FormeFilterChip|  List&lt; T&gt; | false |
| FormeChoiceChip|  T | true |
| FormeRate| dobule | true |
| FormeSingleCheckbox| bool | false |
| FormeSingleSwitch| bool | false |
| FormeCupertinoPicker | int | false | 


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