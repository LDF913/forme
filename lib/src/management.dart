import 'package:flutter/widgets.dart';

import 'focus_node.dart';
import 'form_layout.dart';
import 'text_selection.dart';

/// used to control form field
abstract class FormFieldManagement {
  ///get field's name
  String? get name;

  /// get field's position
  Position get position;

  /// get  field's visible state
  bool get visible;

  /// set visible of field,it's equals to update1('visible',visible)
  set visible(bool visible);

  /// get  field's readOnly state,equals to getState<bool>('readOnly')!
  bool get readOnly;

  /// set readOnly on field,it's equals to update1('readOnly',readOnly)
  set readOnly(bool readOnly);

  // whether field support focus
  bool get focusable;

  // whether field is focused
  bool get hasFocus;

  /// focus|unfocus field
  ///
  /// if field is not focusable ,an error will be throw
  set focus(bool focus);

  /// set focus listener on field
  ///
  /// if field does not has a focusnode ,an error will be throw
  set focusListener(FocusListener? listener);

  /// if current value is valuefield return a [ValueFormFieldManagement] otherwise throw a exception
  ValueFieldManagement get valueFieldManagement;

  /// whether field is value field
  bool get isValueField;

  /// whether field support textselection
  bool get supportTextSelection;

  /// if field support textselection return management,
  /// otherwise throw an exception
  TextSelectionManagement get textSelectionManagement;

  /// update state for a field
  void update(Map<String, dynamic> state);

  /// update one state for a field,equals to update({key:value})
  void update1(String key, dynamic value) => update({key: value});

  /// make current field visible in viewport
  ///
  /// if current field|form is invisible , nothing happened
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment});

  /// whether support state
  bool supportState(String key);
}

abstract class ValueFieldManagement<T> {
  /// get current value of valuefield
  T? get value;

  /// set newValue on valuefield,this method will trigger onChanged listener
  /// if you do not trigger it,you can use setValue method
  set value(T? value) => setValue(value, trigger: true);

  /// set newValue on valuefield,if trigger is false,won't trigger onChanged listener
  setValue(T? value, {bool trigger: true});

  /// whether value field is valid,this method won't display error msg
  /// if you want to show error msg,use validate instead
  bool get isValid;

  /// validate value field ,return whether field is valid or not
  /// this message will show error msg,you can use isValid instead if you don't want show error msg
  bool validate();

  /// reset valuefield,will set value to initialValue
  /// also clear error msg
  void reset();

  /// get error message
  String? get errorText;
}
