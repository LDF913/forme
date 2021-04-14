# flutter_form_builder


## basic usage

``` dart
FormControllerDelegate formController = FormControllerDelegate();

Widget form = FormBuilder(formController)
	.textField(
	  'username',//control key ,used to get|set value and control readonly|visible  state
	  labelText: 'username',
	  clearable: true,
	  flex: 3,
	  validator: (value) => (value ?? '').isEmpty ? 'can not be empty !' : null,
	).build();
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
formController.getData(); //return a map
```

### set form theme

``` dart
formController.themeData = FormThemeData();//set original theme
formController.themeData = FormThemeData.defaultThemeData;//a theme from  https://github.com/mitesh77/Best-Flutter-UI-Templates/blob/master/best_flutter_ui_templates/lib/hotel_booking/filters_screen.dart
```

## currently support field

1. TextField
2. CheckboxGroup
3. RadioGroup
4. DateTimeField
5. Selector(Dropdown like)
6. SwitchGroup
7. NumberField
8. Slider