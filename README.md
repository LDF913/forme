
## screenshot

![screenshot](https://raw.githubusercontent.com/wwwqyhme/forme/main/ezgif-2-4c5414cc2d89.gif)

![screenshot2](https://raw.githubusercontent.com/wwwqyhme/forme/main/ezgif-3-fe95b1d8ade9.gif)

## Simple Usage

### add dependency

```
flutter pub add forme
```

### create forme

``` dart
FormeKey key = FormeKey();// formekey is a global key , also can be used to control form
Widget child = formContent;
Widget forme = Forme(
	key:key,
	child:child,
)
```

## Forme Attributes

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| key | false | `FormeKey` | a global key, also used to control form |
| child | true | `Widget` | form content widget|
| readOnly | false | `bool` | whether form should be readOnly,default is `false` |
| onChanged | false | `FormeValueChanged` | listen form field's value change |
| initialValue | false | `Map<String,dynamic>` | initialValue , **will override FormField's initialValue** |
| validateErrorListener  | false | `ValidateErrorListener` | listen form field's errorText change  |


## Forme Fields

### field type

```
	-StatefulField
		- ValueField
			- NonnullValueField
		- CommonField
```

### attributes supported by all statefule fields

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| name | false | `String` | field's id,**should be unique in form** |
| builder | true | `FieldContentBuilder` | build field content|
| readOnly | false | `bool` | whether field should be readOnly,default is `false` |
| focusListener | false | `FocusListener` | listen field's focus change |
| model | true | `FormeModel` | `FormeModel` used to provider widget render data |

### attributes supported by all value fields

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| onChanged | false | `FormeFieldValueChanged` | listen field's value change |
| validateErrorListener | false | `ValidateErrorListener` | listen field's errorText change |
| validator | false | `FormFieldValidator` | validate field's value |
| autovalidateMode | false | `AutovalidateMode` | auto validate mode , default is `AutovalidateMode.disabled`|
| initialValue | false | `dynamic` | initialValue,**can be overwritten by forme's initialValue**|
| onSaved | false | `FormFieldSetter` | triggered when call forme or field's save method|

### attributes supported by all nonnull value fields

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| onChanged | false | `NonnullFormeFieldValueChanged` | listen field's value change |
| validateErrorListener | false | `ValidateErrorListener` | listen field's errorText change |
| validator | false | `NonnullFieldValidator` | validate field's value |
| autovalidateMode | false | `AutovalidateMode` | auto validate mode , default is `AutovalidateMode.disabled`|
| initialValue | true | `dynamic` | initialValue,**can be overwritten by forme's initialValue**|
| onSaved | false | `NonnullFormFieldSetter` | triggered when call forme or field's save method|


### currently supported fields

| Name | Return Value | Nullable|
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
| FormeSingleCheckbox| bool | false |
| FormeSingleSwitch| bool | false |
| FormeDropdownButton | T | true | 
| FormeListTile|  List&lt; T&gt; | false |
| FormeRadioGroup|  T | true |
| FormeCupertinoPicker|  int | false |
| FormeCupertinoTimerField|  Duration | true |
| FormeCupertinoDateField| DateTime | true |


## FormeKey Methods

### whether form has a name field

``` Dart
bool has = formeKey.hasField(String name);
```

### whether current form is readOnly

``` Dart
bool readOnly = formeKey.readOnly;
```

### set readOnly 

``` Dart
formeKey.readOnly = bool readOnly;
```

### get field's controller

``` Dart
T controller = formeKey.field<T extends FormeFieldController>(String name);
```

### get value field's controller

``` Dart
T controller = formeKey.valueField<T extends FormeValueFieldController>(String name);
```

### get form data

``` Dart
Map<String, dynamic> data = formeKey.data;
```

### get form validate errors

**should call this method after valdiate form**

``` Dart
List<FormeFieldControllerWithError> errors = formeKey.errors;
```

### quiety validate

**validate form quietly and return fields with a error**

``` Dart
List<FormeFieldControllerWithError> errors = formKey.quietlyValidate();
```

### set form data

``` Dart
formeKey.data = Map<String,dynamic> data;// equals to formeKey.setData(data,trigger:true)
formKey.setData(Map<String,dynamic> data,{bool trigger}) // if trigger is true,will trigger fields' onChanged listener
```

### reset form

``` Dart
formeKey.reset();
```

### validate form

``` Dart
bool isValid = formeKey.validate();
```

### whether form is valid

``` Dart
bool isValid = formeKey.isValid;
```

### save form

``` Dart
formeKey.save();
```

## Forme Field Methods

### get forme controller

``` Dart
FormeController formeController = field.controller;
```

### get field's name

``` Dart
String? name = field.name
```

### whether current field is readOnly

``` Dart
bool readOnly = field.readOnly;
```

### set readOnly on field

``` Dart
field.readOnly = bool readOnly;
```

### whether current field is focusable

``` Dart
bool focusable = field.focusable;
```

### whether current field is focusd

``` Dart
bool hasFocus = field.hasFocus;
```

### focus|unfocus current Field

``` Dart
field.focus = bool focus;
```

### whether current field is a value field

``` Dart
bool isValueField = field.isValueField;
```

### set field model

``` Dart
field.model = FormeModel model;
```

### update field model

``` Dart
field.updateModel(FormeModel model);
```

### get field model

``` Dart
FormeModel model = field.model;
```

### ensure field is visible in viewport

``` Dart
Future<void> result = field.ensureVisibe({Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment});
```

## Forme Value Field Methods

**FormeValueFieldController is extended FormeFieldController**

### get field value

``` Dart
dynamic value = valueField.value;
```

### set field value

``` Dart
valueField.value = dynamic data;// equals to formeKey.setData(data,trigger:true)
valueField.setValue(dynamic data,{bool trigger}) // if trigger is true,will trigger fields' onChanged listener
```

### reset field

``` Dart
valueField.reset();
```

### validate field

``` Dart
bool isValid = valueField.validate();
```

### whether field is valid

``` Dart
bool isValid = valueField.isValid;
```

### get errorText

``` Dart
String? errorText = valueField.errorText;
```

### quiety validate

``` Dart
String? errorText = valueField.quietlyValidate();
```

### save field

``` Dart
valueField.save();
```

### get decorator model

``` Dart
FormeModel? decoratorModel = valueField.currentDecoratorModel;
```

### update decorator model

``` Dart
valueField.updateDecoratorModel(FormeModel model);
```

### set decorator model

``` Dart
valueField.decoratorModel = FormModel model;
```

## build your field

1. create your `FormeModel` , if you don't need it , use `FormeEmptyModel` instead
2. create your `ValueField<T,E>|NonnullValueField<T,E>` ,  T is your field return value's type, E is your `FormeModel`'s type
3. if you want to create your custom `State`,extends `ValueFieldState|NonnullValueFieldState`

links below is some examples to help you to build your field

### common field

1. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_visible.dart
2. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_flex.dart

### value field

1. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_filter_chip.dart
2. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_radio_group.dart

### nonnull value field

1. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_list_tile.dart
2. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_slider.dart