# flutter_form_builder


## basic usage

``` dart
FormManagement formManagement

Widget form = FormBuilder(formManagement)
	.textField(
	  'username',//control key ,used to get|set value and control readonly|visible  state
	  labelText: 'username',
	  clearable: true,
	  flex: 3,
	  validator: (value) => value.isEmpty ? 'can not be empty !' : null,
	);
```

## form method

### hide|show form

``` dart
formManagement.visible = !formManagement.visible;
```

### set form readonly|editable

``` dart
formManagement.readOnly = !formManagement.readOnly;
```

### hide|show form field

``` dart
bool isVisible = formManagement.isVisible(controlKey);
formManagement.setVisible(controlKey,!isVisible)
```

### set form field readonly|editable

``` dart
bool isReadOnly = formManagement.isReadOnly(controlKey);
formManagement.setReadOnly(controlKey,!isReadOnly)
```

### sub controller

if you want to control sub item's state (like radiogroup's radio item) ,you can use this method

``` dart
SubControllerDelegate subController = formManagement.getSubController(controlKey);
subController.update1(String itemControlKey, Map<String, dynamic> state); //update sub item's state
subController.update(Map<String, Map<String, dynamic>> states);//udpate multi sub items's state , for better performance,you should use this method to update multi items
subController.getState(String itemControlKey, String key);//get sub item's state value
subController.setVisible(String itemControlKey, bool visible);//equals to update(itemControlKey,{'visible':visible})
subController.setReadOnly(String itemControlKey, bool readOnly);//equals to update(itemControlKey,{'readOnly':readOnly})
bool subController.isVisible(String itemControlKey);//equals to getState(itemControlKey,'visible')
bool subController.isReadOnly(String itemControlKey);//equals to getState(itemControlKey,'readOnly')
bool subController.hasState(String itemControlKey);//check itemControlKey exists
```

**only SwitchGroup|RadioGroup|CheckboxGroup support these method **

### validate form

``` dart
formManagement.validate();
```

### validate one field

``` dart
formManagement.validate1(controlKey);
```

### check form is valid

**unlike validate method,this method won't display error msg**

``` dart
formManagement.isValid
```

### check field is valid

**unlike validate1 method,this method won't display error msg**

``` dart
formManagement.isValid1(controlkey);
```

### reset form

``` dart
formManagement.reset();
```

### reset one field

``` dart
formManagement.reset1(controlKey);
```


### set autovalidatemode

``` dart
formManagement.setAutovalidateMode(controlKey,autovalidateMode);
```

### set initialValue

``` dart
formManagement.setInitialValue(controlKey,initialValue);
```

### focus form field
```
formManagement.requestFocus(controlKey);
```

### unfocus form field
```
formManagement.unFocus(controlKey);
```

### listen focus change

``` dart
onFocusChange(bool value){
	print('username focused: $value');
}

FormManagement(initCallback:(){
	formManagement.onFocusChange('username',onFocusChange);
});
```

### stop listen focus change

``` dart
formManagement.offFocusChange('username',onFocusChange);
```

### update form field

``` dart
//update username's label
formManagement.update(controlKey, {
	'labelText': DateTime.now().toString(),
});
```

``` dart
//update selector's items
formManagement.setValue('selector', null);
formManagement.update('selector', {
	'items': FormBuilder.toSelectorItems(
		[Random().nextDouble().toString()])
});
```

### rebuild form field's state

``` dart
formManagement.rebuild(controlKey,{});
```

### set form field's padding
``` dart
formManagement.setPadding(controlKey,padding);
```

### set form field's selection

``` dart
formManagement.setSelection(controlKey,start,end);
formManagement.selectAll(controlKey);
```

only works on textfield|numberfield

### set form field's value
 
``` dart
formManagement.setValue('controlKey',value,trigger:false);
```

trigger: whether  trigger onChanged or not

### get form field's value

``` dart
formManagement.getValue('controlKey');
```

### get form data

``` dart
formManagement.data; // auto remove null
formManagement.getData({bool removeNull = false});
```

### completely remove a from field

``` dart
formManagement.remove(controlKey);
```

### set form theme

``` dart
formManagement.formThemeData = FormThemeData(themeData);// system theme
formManagement.formThemeData = DefaultFormTheme(); //default theme from  https://github.com/mitesh77/Best-Flutter-UI-Templates/blob/master/best_flutter_ui_templates/lib/hotel_booking/filters_screen.dart
```

## currently support field

| field | return value | nullable|
| ---| ---| --- |
| TextField|  string | false |
| CheckboxGroup|  List&lt;int&gt; | false |
| RadioGroup|  dynamic | true |
| DateTimeField|  DateTime | true |
| Selector|  List | false |
| SwitchGroup|  List&lt;int&gt; | false |
| SwitchInline|  bool | false |
| NumberField|  num | true |
| Slider|  double | false |
| RangeSlider|  RangeValues | false|

## project status

developing

## develop plan

1. support insert field
2. performance test 
3. support more fields