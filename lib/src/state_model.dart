import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AbstractFieldStateModel {
  AbstractFieldStateModel merge(AbstractFieldStateModel old);
}

class EmptyStateModel extends AbstractFieldStateModel {
  EmptyStateModel._();
  static final EmptyStateModel model = EmptyStateModel._();
  factory EmptyStateModel() => model;

  @override
  AbstractFieldStateModel merge(AbstractFieldStateModel old) {
    return EmptyStateModel();
  }
}
