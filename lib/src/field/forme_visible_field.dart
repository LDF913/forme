import 'package:flutter/material.dart';

import '../forme_field.dart';
import '../forme_state_model.dart';

/// a form field which can control visible of child
///
/// ``` dart
/// formeManagement.newFormeFieldManagement(nameOfVisibleField).model = FormeVisibleModel(visible:true|false);
/// ```
class FormeVisible extends CommonField<FormeVisibleModel> {
  FormeVisible({
    required String name,
    required Widget child,
    FormeVisibleModel? model,
    Key? key,
  }) : super(
          key: key,
          name: name,
          model: model ?? FormeVisibleModel(),
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

class FormeVisibleModel extends AbstractFormeModel {
  final bool? visible;
  FormeVisibleModel({this.visible});
  @override
  FormeVisibleModel merge(AbstractFormeModel old) {
    FormeVisibleModel oldModel = old as FormeVisibleModel;
    return FormeVisibleModel(visible: visible ?? oldModel.visible);
  }
}
