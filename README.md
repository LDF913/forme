## Screenshot

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
|onWillPop | false | `WillPopCallback` | Signature for a callback that verifies that it's OK to call Navigator.pop |
| quietlyValidate | false | bool | if this attribute is true , will not display default error text|

## Differences Between Form and Forme

Forme is a form widget, but forme is not wrapped in a `Form`  , because I don't want to  refresh whole form after field's value changed or a validate performed , so it is a bit more complexable than `Form`.

|    Difference      |   Form   |  Forme   |
|  ----- |  ----- | ----- |
| AutovalidateMode | support both Form and field| only support field   |
| onChanged |   won't fired if value changed via `state.didChange` or `state.setValue`  | fired whenever field's value changed |
|   rebuild strategy      |  when field value changed or perform a validation on  field , all form fields will be rebuilded   |  only rebuild field that value changed or validated |

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


## Forme Model

you can update a widget easily with `FormeModel`

eg: if you want to update labelText of a FormeTextField, you can do this :

``` Dart
FormeFieldController controller = formKey.field(fieldName);
controller.update(FormeTextFieldModel(decoration:InputDecoration(labelText:'New Label')));
```

if you want to update items of FormeDropdownButton:

``` Dart
controller.updateModel(FormeDropdownButtonModel<String>(
	icon: SizedBox(
	width: 14,
	height: 14,
	child: CircularProgressIndicator(),
)));
Future<List<DropdownMenuItem<String>>> future =
	Future.delayed(Duration(seconds: 2), () {
	return FormeUtils.toDropdownMenuItems(
		['java', 'dart', 'c#', 'python', 'flutter']);
	});
future.then((value) {
controller.updateModel(FormeDropdownButtonModel<String>(
	icon: Icon(Icons.arrow_drop_down), items: value));
});
```

**update model will auto copywith old model's attribute**


## Custom way display error text

if default error text display can not fit your needs , you can implementing a custom error display via `ValueField`'s `validateErrorListener` or `FormeValueFieldController`'s  `errorTextListenable`

**don't forget to set Forme's quieltyValidate attribute to true**

### via validateErrorListener

`validateErrorListener` will triggered whenever errorText of field changes , it is suitable when you want to update a stateful field according to error state of field 

eg: change border color when error state changes

``` Dart
FormeTextField(
	validator: validator,
	validateErrorListener: (m, a) {
		InputBorder border = OutlineInputBorder(
				borderRadius: BorderRadius.circular(30.0),
				borderSide: BorderSide(color: a == null ? Colors.green : Colors.red, width: 1));
		m.updateModel(FormeTextFieldModel(
			decoration: InputDecoration(
				focusedBorder: border, enabledBorder: border)));
	},
),
```

### via errorTextListenable

`errorTextListenable` is more convenient than `validateErrorListener` sometimes.

eg: when your want to display an valid or invalid suffix icon according to error state of field, in `validateErrorListener` , update model will rebuild whole field,
but with `errorTextListenable`, you can only rebuild the suffix icon, below is an example to do this:

``` dart
suffixicon: Builder(
	builder: (context) {
		FormeValueFieldController<String, FormeModel>
			controller = FormeFieldController.of(context);
		return ValueListenableBuilder<Optional<String>?>(
			valueListenable: controller.errorTextListenable,
			child: const IconButton(
				onPressed: null,
				icon: const Icon(
				Icons.check,
				color: Colors.green,
				)),
			builder: (context, errorText, child) {
			if (errorText == null)
				return SizedBox();
			else
				return errorText.isPresent
					? const IconButton(
						onPressed: null,
						icon: const Icon(
						Icons.error,
						color: Colors.red,
						))
					: child!;
			});
	},
),
```

**you shouldn't use FormeValueFieldController's errorTextListenable  out of field ,use `FormFieldNotifier.errorTextListenable` instead**

lifecycle of FormeValueFieldController's errorTextListenable  is same as field,when used it on another widget , `errorTextListenable` will disposed before removeListener , which will cause an error in debug mode

`FormFieldNotifier` is from `formKey.fieldNotifier(fieldName)`,it's lifecycle is same as `Forme`,  typically used to build a widget which is not a stateful field but relies on state  of field , eg: you want to display error of a field on a Text Widget

``` Dart
Column(
	children:[
		FormeTextField(validator:validator,name:name),
		ValueListenableBuilder<Optional<String>?>(
			valueListenable: formeKey.fieldNotifier(name).errorTextListenable,
			build: (context,errorText,child){
				return errorText == null || errorText.isNotPresent ? SizedBox() : Text(errorText.value!);
			},
		),
])
```

## Forme Field Decorator 

unlike `FormeTextField` , some widgets , such as `FormeSlider`, don't have a InputDecorator , you must 
specific a `FormeDecorator` for them.

**`FormeDecorator`'s name attribute must same as field's name attribute**

eg:

``` Dart
FormeInputDecorator(
  name: name,
  decoration: InputDecoration(labelText: 'Slider'),
  child: FormeSlider(
	min: 1,
	max: 100,
	autovalidateMode: AutovalidateMode.onUserInteraction,
	name: name,
	model: FormeSliderModel(),
	validator: (value) => value < 50
		? 'value must bigger than 50 ,current is $value'
		: null,
  ),
),
```

default `FormeDecorator` is `FormeInputDecorator`.

### Custom Decorator

it's easily to implementing a custom decorator, below is an example:

``` Dart
FormeDecorator<EmptyStateModel>(
	model: EmptyStateModel(),
	name: name,
	builder: (context, a, b, c, model) {
	return Column(
		children: [
		ValueListenableBuilder<bool>(
			valueListenable: a,
			builder: (context, focus, child) {
				return Text(
				'Slider',
				style: TextStyle(
					fontSize: 30,
					color: focus
						? Colors.greenAccent
						: Colors.yellowAccent),
				);
			}),
		FormeSlider(
			min: 1,
			max: 100,
			autovalidateMode: AutovalidateMode.onUserInteraction,
			name: name,
			model: FormeSliderModel(),
			validator: (value) => value < 50
				? 'value must bigger than 50 ,current is $value'
				: null,
		),
		ValueListenableBuilder<Optional<String>?>(
			valueListenable: c,
			builder: (context, errorText, child) {
				return errorText == null || errorText.isNotPresent
					? const SizedBox()
					: Text(
						errorText.value!,
						style: TextStyle(color: Colors.red, fontSize: 30),
					);
			}),
		],
	);
	},
),
```

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

### validate

**validate form quietly and return fields with a error**

``` Dart
List<FormeFieldControllerWithError> errors = formKey.validate();
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

### whether form is valid

``` Dart
bool isValid = formeKey.isValid;
```

### save form

``` Dart
formeKey.save();
```

### whether validate is quietly

``` Dart
bool quietlyValidate = formKey.quietlyValidate;
```

### set quietlyValidate

``` Dart
formeKey.quieltyValidate = bool quietlyValidate;
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

### get focusListenable

``` Dart
FormeValueListenable<bool> focusListenable = field.focusListenable;
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

### get decorator controller

``` Dart
FormeDecoratorController<T>? decoratorController = 
      valueField.getFormeDecoratorController<T extends FormeModel>();
```

### get errorTextListenable

``` Dart
FormeValueListenable<Optional<String>?>  errorTextListenable = valueField.errorTextListenable;
```

### get valueListenable

``` Dart
FormeValueListenable<dynamic> errorTextListenable = valueField.errorTextListenable;
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