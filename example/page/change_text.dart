import 'package:flutter/material.dart';
import 'package:form_builder/form_builder.dart';

class ChangeText extends BaseCommonField<ChangeTextModel> {
  ChangeText({LayoutParam? layoutParam})
      : super(
          layoutParam: layoutParam,
          name: 'text',
          model: ChangeTextModel(text: ''),
          builder: (state) {
            return Text(state.model.text!);
          },
        );
}

class ChangeTextModel extends AbstractFieldStateModel {
  final String? text;

  ChangeTextModel({this.text});
  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    ChangeTextModel oldModel = old as ChangeTextModel;
    return ChangeTextModel(text: text ?? oldModel.text);
  }
}
