import 'package:flutter/material.dart';

import '../forme_management.dart';

/// whether value is emtpty
typedef IsEmpty = bool Function(dynamic value);

/// a clear button for ValueField
class FormeClearButton extends StatelessWidget {
  final ValueChanged<FormeValueFieldManagement> onPressed;
  final bool visibleWhenUnfocus;
  final Widget clearIcon;
  final IsEmpty? isEmpty;

  const FormeClearButton({
    Key? key,
    required this.onPressed,
    this.visibleWhenUnfocus = false,
    this.clearIcon = const Icon(Icons.clear),
    this.isEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormeValueFieldManagement valueField =
        FormeValueFieldManagement.of(context);
    bool _isEmpty = (isEmpty ?? _defaultIsEmpty)(valueField.value);
    bool visible = !valueField.readOnly &&
        !_isEmpty &&
        !(!valueField.hasFocus && !visibleWhenUnfocus);
    return Visibility(
      visible: visible,
      child: buildIcon(clearIcon, valueField),
    );
  }

  @protected
  Widget buildIcon(Widget icon, FormeValueFieldManagement valueField) {
    return IconButton(
      icon: clearIcon,
      onPressed: valueField.readOnly ? null : () => onPressed(valueField),
    );
  }

  bool _defaultIsEmpty(value) {
    return value == null || value == '';
  }
}
