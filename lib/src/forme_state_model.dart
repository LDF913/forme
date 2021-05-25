import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// this model can be changed at runtime var[FormeFieldManagement.model]
@immutable
abstract class FormeModel {
  FormeModel copyWith();
}

class EmptyStateModel extends FormeModel {
  EmptyStateModel._();
  static final EmptyStateModel model = EmptyStateModel._();
  factory EmptyStateModel() => model;

  @override
  FormeModel copyWith() {
    return EmptyStateModel();
  }
}

/// this class is used to update state model
///
/// when we use ?? to set value ,we can't set null values any more!
class Optional<T> {
  const Optional.absent() : value = null;
  final T? value;
  Optional(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object o) => o is Optional<T> && o.value == value;

  static T? copyWith<T>(Optional<T>? current, T? old) {
    if (current == null) return old;
    return current.value;
  }
}
