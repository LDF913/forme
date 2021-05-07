import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../form_builder.dart';
import 'form_builder_utils.dart';
import 'form_layout.dart';

class StateValue<T> {
  final T value;

  String? _check(dynamic value) {
    if (null is T && value == null) return null;
    if (value == null) return 'value can not be null';
    if (value is! T) {
      return 'value must be type $T but current type is ${value.runtimeType}';
    }
  }

  const StateValue(this.value);
}

/// used to update state
mixin AbstractStateModel {
  void update(Map<String, dynamic> stateMap);
  void dispose();
}

/// an base state model implement [AbstractStateModel]
///
/// initStateMap should be regarded as property from Widget
/// and state should be regarded as property from State
///
/// state are allowed null values which determined by StateValue
///
/// **do not change initStateMap at runtime! they should be regarded as immutable!
/// the only time you should change it is in didUpdateWidget, call updateInitStateMap**
class BaseStateModel with AbstractStateModel, ChangeNotifier {
  final Map<String, StateValue> _initStateMap;
  final Map<String, dynamic> _state = {};

  int gen = 0;

  BaseStateModel(Map<String, StateValue> initStateMap)
      : this._initStateMap = Map.of(initStateMap);

  /// get state value
  ///
  /// it's equals to build method's stateMap\[stateKey\]
  getState(String stateKey) {
    enableKeyExists(stateKey);
    return _state.containsKey(stateKey)
        ? _state[stateKey]
        : _initStateMap[stateKey]!.value;
  }

  Map<String, dynamic> get currentMap {
    Map<String, dynamic> map = {};
    _initStateMap.forEach((key, value) {
      map[key] = _state.containsKey(key) ? _state[key] : value.value;
    });
    return Map.unmodifiable(map);
  }

  void rebuild(Map<String, dynamic> state) {
    checkState(state);
    if (mapEquals(state, _state)) return;
    _state
      ..clear()
      ..addAll(state);
    gen++;
    beforeNotifyListeners(state.keys);
    notifyListeners();
  }

  void update(Map<String, dynamic> state) {
    checkState(state);
    List<String> keys = [];
    state.forEach((key, value) {
      dynamic currentValue = _state[key];
      if (!FormBuilderUtils.compare(value, currentValue)) {
        _state[key] = value;
        keys.add(key);
      }
    });
    doNotifyListeners(keys);
  }

  void update1(String key, dynamic value) {
    update({key: value});
  }

  void remove(Set<String> stateKeys) {
    if (stateKeys.isEmpty) return;
    Set<String> keys = {};
    stateKeys.forEach((element) {
      if (_state.containsKey(element)) {
        keys.add(element);
        _state.remove(element);
      }
    });
    doNotifyListeners(keys);
  }

  /// can this method in [didUpdateWidget]
  ///
  /// [old] from oldWidget
  ///
  /// [current] from current widget
  void updateInitStateMap(
      Map<String, StateValue>? old, Map<String, StateValue>? current) {
    if (old != null) {
      Iterable<String> keys = old.keys;
      _initStateMap.removeWhere((key, value) => keys.contains(key));
    }
    if (current != null) {
      _initStateMap.addAll(Map.of(current));
    }
    _state.removeWhere((key, value) {
      if (!_initStateMap.containsKey(key)) return true;
      StateValue stateValue = _initStateMap[key]!;
      if (stateValue._check(value) != null) return true;
      return false;
    });
  }

  @protected
  void enableKeyExists(String stateKey) {
    if (!_initStateMap.containsKey(stateKey))
      throw 'did you put key :$stateKey into your initMap';
  }

  @protected
  void checkState(Map<String, dynamic> map) {
    map.forEach((key, value) {
      enableKeyExists(key);
      StateValue stateValue = _initStateMap[key]!;
      String? error = stateValue._check(value);
      if (error != null) throw 'key: $key\'s value error :' + error;
    });
  }

  @mustCallSuper
  void dispose() {
    _initStateMap.clear();
    _state.clear();
    super.dispose();
  }

  @protected
  void doNotifyListeners(Iterable<String> keys) {
    if (keys.isEmpty) return;
    try {
      beforeNotifyListeners(keys);
    } finally {
      gen++;
      notifyListeners();
    }
  }

  /// you can do something logic that before notify listeners
  ///
  /// **notifyListeners will be always executed even though errors threw by beforeNotifyListeners**
  ///
  /// [keys] updated|removed keys
  @protected
  void beforeNotifyListeners(Iterable<String> keys) {}
}

mixin AbstractFieldStateModel on AbstractStateModel {
  FieldKey get fieldKey;
}

class BaseFieldStateModel extends BaseStateModel with AbstractFieldStateModel {
  final FieldKey fieldKey;
  BaseFieldStateModel(Map<String, StateValue> initStateMap,
      {required this.fieldKey})
      : super(initStateMap);
}

class FormModel extends BaseStateModel {
  final bool enableLayoutManagement;
  FormModel(Map<String, StateValue> value, this.enableLayoutManagement)
      : super(value);

  bool rebuildLayout = false;

  FormLayout get formLayout => getState('formLayout');
  set formLayout(FormLayout formLayout) => update1('formLayout', formLayout);

  FormThemeData get formThemeData => getState('formThemeData');
  set formThemeData(FormThemeData formThemeData) =>
      update1('formThemeData', formThemeData);

  bool get visible => getState('visible');
  set visible(bool visible) => update1('visible', visible);

  bool get readOnly => getState('readOnly');
  set readOnly(bool readOnly) => update1('readOnly', readOnly);

  @override
  void beforeNotifyListeners(Iterable<String> keys) {
    if (keys.contains('formLayout')) rebuildLayout = true;
  }
}

class FormBuilderFieldModel extends BaseStateModel {
  final FieldKey fieldKey;
  FormBuilderFieldModel(this.fieldKey, Map<String, StateValue> value)
      : super(value);

  String? get name => fieldKey.name;

  bool get visible => getState('visible');
  set visible(bool visible) => update1('visible', visible);

  int get flex => getState('flex');
  set flex(int flex) => update1('flex', flex);

  EdgeInsets? get padding => getState('padding');
  set padding(EdgeInsets? padding) => update1('padding', padding);

  bool get readOnly => getState('readOnly');
  set readOnly(bool readOnly) => update1('readOnly', readOnly);
}
