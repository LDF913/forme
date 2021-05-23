import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// this model can be changed at runtime var[FormeFieldManagement.model]
@immutable
abstract class AbstractFormeModel {
  AbstractFormeModel merge(AbstractFormeModel old);
}

class EmptyStateModel extends AbstractFormeModel {
  EmptyStateModel._();
  static final EmptyStateModel model = EmptyStateModel._();
  factory EmptyStateModel() => model;

  @override
  AbstractFormeModel merge(AbstractFormeModel old) {
    return EmptyStateModel();
  }
}
