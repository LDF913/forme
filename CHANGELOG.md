## 2.0.0-alpha

1. use `formManagement.formLayoutManagement` instead of `formManagement.newFormLayoutManagement()`
2. remove `FormPositionManagement`
3. `BaseField` support `WidgetWrapper` ,used to wrap BaseField widget to what you want
4. `AbstractFieldState` support wrap default FormFieldManagement to yours, `BaseCommonField` will wrap default to `BaseFormFieldManagement`,`BaseValueField` will wrap default to `BaseFormValueFieldManagement`
5. remove getter|setter visible from `FormFieldManagement`
6. `formManagement.newFormFieldManagement()` will return a `CastableFormFieldManagement` ,used to cast your FormFieldManagement
7. `BaseFormFieldManagement` support getter|setter readOnly&padding&flex
8. `BaseFormValueFieldManagement` support shake()
9. `FormFieldManagement` remove update&update1,use `formFieldManagement.model = fieldModel` instead

## 1.0.0
1. BaseValueField support shake , use `formFieldManagement.update1('shaker',Shaker())` to shake it
2. add some render data to control field render
3. `FormFieldManagement` add supportState(String key) method
4. bug fix

## 1.0.0-beta.4

1. add FormLayoutManagement (experimental)
2. FormBuilder.textButton => FormBuilder.button
3. remove form theme ,use current theme instead
4. support onChanged on FormBuilder,used to listen field's value change
5. bug fix

## 1.0.0-beta.3

1. remove FormRowManagement
2. remove FormLayoutManagement
3. add FormPositionManagement
4. add BaseCommonField,BaseValueField and BaseNonnullValueField

## 1.0.0-beta.2

1. bug fix
2. remove StatelessFied

## 0.1.1

1. bug fix

## 0.1.0

1. support StatelessField

## 0.0.5

1. add NonnullValueField
2. Simplify value field
3. CheckboxGroup will rendered as CheckboxListTile when split = 1
4. RadioGroup will rendered as RadioListTile when split = 1

## 0.0.4 

1. check state type

## 0.0.3

1. add WorkSans font
2. provide an example