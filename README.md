# flutter_form_builder


## basic usage

``` dart
FormControllerDelegate formController = FormControllerDelegate();

Widget form = FormBuilder(formController)
	.readOnly(readOnly)
	.visible(visible)
	.themeData(themeData)
	.textField(
	  'username',//control key ,used to get|set value and control readonly|visible  state
	  labelText: 'username',
	  clearable: true,
	  flex: 3,
	  validator: (value) => (value ?? '').isEmpty ? 'can not be empty !' : null,
	);
```

## form method

### hide|show form

``` dart
formController.visible = !formController.visible;
```

### set form readonly|editable

``` dart
formController.readOnly = !formController.readOnly;
```

### hide|show form field

``` dart
bool isVisible = formController.isVisible('form field\'s controlKey');
formController.setVisible('form field\'s controlKey',!isVisible)
```

### set form field readonly|editable

``` dart
bool isReadOnly = formController.isReadOnly('form field\'s controlKey');
formController.setReadOnly('form field\'s controlKey',!isReadOnly)
```

### sub controller

if you want to control sub item's state (like radiogroup's radio item) ,you can use this method

``` dart
SubControllerDelegate subController = formController.getSubController(controlKey);
subController.update1(String itemControlKey, Map<String, dynamic> state); //update sub item's state
subController.update(Map<String, Map<String, dynamic>> states);//udpate multi sub items's state
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
formController.validate();
```

### validate one field

``` dart
formController.validate1(controlKey);
```

### reset form

``` dart
formController.reset();
```

### reset one field

``` dart
formController.reset1(controlKey);
```

### focus form field
```
formController.requestFocus('form field\'s controlKey');
```

### unfocus form field
```
formController.unFocus('form field\'s controlKey');
```

### listen focus change

``` dart
onFocusChange(bool value){
	print('username focused: $value');
}

formController.onFocusChange('username',onFocusChange);
```

### stop listen focus change

``` dart
formController.offFocusChange('username',onFocusChange);
```

### update form field

``` dart
//update username's label
formController.update('form field\'s controlKey', {
	'labelText': DateTime.now().toString(),
});
```

``` dart
//update selector's items
formController.setValue('selector', null);
formController.rebuild('selector', {
	'items': FormBuilder.toSelectorItems(
		[Random().nextDouble().toString()])
});
```

### set form field's selection

``` dart
formController.setSelection(controlKey,start,end);
```

only works on textfield|numberfield

### set form field's value
 
``` dart
formController.setValue('controlKey',value,trigger:false);
```

trigger: whether  trigger onChanged or not

### get form field's value

``` dart
formController.getValue('controlKey');
```

### get form data

``` dart
formController.getData(removeNull:false); //return a map if removeNull is true ,map will not contain null value items
```

### set form theme

``` dart
formController.themeData = FormThemeData(themeData);// system theme
formController.themeData = DefaultFormTheme(context);//default theme from  https://github.com/mitesh77/Best-Flutter-UI-Templates/blob/master/best_flutter_ui_templates/lib/hotel_booking/filters_screen.dart
```

## currently support field

| field | return value |
| ---| ---|
| TextField|  string |
| CheckboxGroup|  List&lt;int&gt; |
| RadioGroup|  dynamic |
| DateTimeField|  DateTime |
| Selector|  List |
| SwitchGroup|  List&lt;int&gt; |
| SwitchInline|  bool |
| NumberField|  num |
| Slider|  double |
| RangeSlider|  RangeValues |

## project status

developing