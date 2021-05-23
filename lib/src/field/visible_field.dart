import 'package:flutter/material.dart';

import '../form_field.dart';
import '../form_state_model.dart';

/// a form field which can control visible of child
///
/// ``` dart
/// formManagement.newFormFieldManagement(nameOfVisibleField).model = VisibleModel(visible:true|false);
/// ```
class VisibleFormField extends CommonField<VisibleModel> {
  VisibleFormField({
    required String name,
    required Widget child,
    VisibleModel? model,
  }) : super(
          name: name,
          model: model ?? VisibleModel(),
          builder: (state) {
            bool visible = state.model.visible ?? true;
            return Visibility(
              child: child,
              maintainState: true,
              visible: visible,
            );
          },
        );
}

class VisibleModel extends AbstractFieldStateModel {
  final bool? visible;
  VisibleModel({this.visible});
  @override
  VisibleModel merge(AbstractFieldStateModel old) {
    VisibleModel oldModel = old as VisibleModel;
    return VisibleModel(visible: visible ?? oldModel.visible);
  }
}
