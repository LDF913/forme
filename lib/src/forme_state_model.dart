import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// this model can be changed at runtime var[FormeFieldManagement.model]
@immutable
abstract class FormeModel {
  FormeModel copyWith(FormeModel old);
}

class EmptyStateModel extends FormeModel {
  EmptyStateModel._();
  static final EmptyStateModel model = EmptyStateModel._();
  factory EmptyStateModel() => model;

  @override
  FormeModel copyWith(FormeModel old) {
    return EmptyStateModel();
  }
}