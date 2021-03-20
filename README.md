# flutter form builder

 flutter form builder
 
 ## basic usage
 
```
import 'form/checkbox_group.dart';
import 'form/form_util.dart';
import 'form/radio_group.dart';

FormController formController = FormController();

FormBuilder builder = FormBuilder(formController: formController)
  ..textField(
	'用户名',
	controlKey: 'username',
	clearable: true,
	validator: (value) => (value ?? '').isEmpty ? '不为空' : null,
  )
  ..nextLine()
  ..textField('密码',
	  controlKey: '456',
	  obscureText: true,
	  passwordVisible: true,
	  clearable: true,
	  flex: 1)
  ..checkboxGroup([CheckboxButton('男'), CheckboxButton('女')],
	  label: '性别',
	  validator: (value) => (value ?? []).length == 0 ? '请选择性别' : null,
	  controlKey: 'checkbox')
  ..radioGroup(
	  [RadioButton('1', '1'), RadioButton('2', '2'), RadioButton('3', '3')],
	  label: '单选框', controlKey: 'radio', initialValue: 2);
return builder.build();
```


## form widget archetype
```
Form(
	child :
		Column(
			children : [
				Row(
					 Expanded(
						child : formField
					  )
				)
				...
			]
		)

)
```

## hide|show formfields 

hide:
```
formController.hideKeys = [controlKey1,controlKey2];
```

show:
```
formController.hideKeys = [];
```

## make formfields readonly|editable

readonly:
```
formController.readOnlyKeys = [controlKey1,controlKey2];
```

editable:
```
formController.readOnlyKeys = [];
```

## hide|show form

```
formController.hide = true|false;
```

## make form readonly|editable

```
formController.readOnly = true|false
```

## reset form

all form field will rebuild !
```
formController.reset();
```

## validate form

all form field will rebuild

```
if(formController.validate()) submit();
```


## listen form field value change

```
TextEditingController controller;

controller.addListener((){
	String value = controller.text;
	//do not change controller value here !!!
});
```

## currently support form fields

1. Simple Textfield (clearable)
2. Simple PasswordField (clearable & password visiable)
3. RadioGroup
4. CheckboxGroup

