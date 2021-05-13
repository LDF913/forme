import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'form_builder_utils.dart';

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
}

/// an base state model implement [AbstractStateModel]
///
/// initStateMap should be regarded as property from Widget
/// and state should be regarded as property from State
///
/// state are allowed null values which determined by StateValue
///
/// **do not change initStateMap at runtime! they should be regarded as immutable!
/// the only time you should change it is in didUpdateWidget, call didUpdateModel**
class BaseStateModel with AbstractStateModel, ChangeNotifier {
  final Map<String, StateValue> _initStateMap;
  final Map<String, dynamic> _state = {};

  int _gen = 0;

  BaseStateModel(Map<String, StateValue> initStateMap)
      : this._initStateMap = Map.of(initStateMap);

  /// used to check whether model's state has been changed
  int get gen => _gen;

  /// get state value
  ///
  /// it's equals to  currentMap\[stateKey\]
  T? getState<T>(String stateKey) {
    _enableKeyExists(stateKey);
    return _state.containsKey(stateKey)
        ? _state[stateKey]
        : _initStateMap[stateKey]!.value;
  }

  ///get init state value
  T? getInitState<T>(String key) {
    _enableKeyExists(key);
    return _initStateMap[key]!.value;
  }

  Map<String, dynamic> get currentMap {
    Map<String, dynamic> map = {};
    _initStateMap.forEach((key, value) {
      map[key] = _state.containsKey(key) ? _state[key] : value.value;
    });
    return Map.unmodifiable(map);
  }

  @override
  void update(Map<String, dynamic> state) {
    checkState(state);
    Map<String, dynamic> changeMap = {};
    state.forEach((key, value) {
      dynamic currentValue = _state[key];
      if (!compare(key, value, currentValue)) {
        _state[key] = value;
        changeMap[key] = currentValue;
      }
    });
    if (changeMap.isEmpty) return;
    try {
      changeMap.forEach((key, value) {
        afterStateValueChanged(key, value, _state[key]);
      });
      beforeNotifyListeners(changeMap.keys);
    } finally {
      _gen++;
      notifyListeners();
    }
  }

  void update1(String key, dynamic value) {
    update({key: value});
  }

  /// can this method in [didUpdateWidget]
  ///
  /// **this method will remove old's initStateMap and add new initStatMap,
  /// if old state not exists in new initState or it's value can't be checked by new initState,
  /// will also be removed**
  ///
  /// [old] from oldWidget
  ///
  /// [current] from current widget
  void didUpdateModel(
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

  void _enableKeyExists(String stateKey) {
    if (!_initStateMap.containsKey(stateKey))
      throw 'did you put key :$stateKey into your initMap';
  }

  @protected
  void checkState(Map<String, dynamic> map) {
    map.forEach((key, value) {
      _enableKeyExists(key);
      StateValue stateValue = _initStateMap[key]!;
      String? error = stateValue._check(value);
      if (error != null) throw 'key: $key\'s value error :' + error;
    });
  }

  @override
  void dispose() {
    _initStateMap.clear();
    _state.clear();
    super.dispose();
  }

  /// you can do something logic that before notify listeners,in this step,the value in state has been changed !
  ///
  /// **notifyListeners will be always executed even though errors threw by beforeNotifyListeners**
  ///
  /// [keys] updated|removed keys
  @protected
  void beforeNotifyListeners(Iterable<String> keys) {}

  /// used to listen state value changed
  ///
  /// this method will called before [beforeNotifyListeners]
  @protected
  void afterStateValueChanged(String key, old, current) {}

  /// used to compare state value
  ///
  /// if [FormBuilderUtils.compare] can't meet your needs,
  /// override this method
  @protected
  bool compare(String key, value1, value2) {
    return FormBuilderUtils.compare(value1, value2);
  }
}

/// when you want to create a stateful field,your custom field state must
/// create an AbstractFieldStateModel,which used to control field's state
mixin AbstractFieldStateModel on AbstractStateModel {
  /// get readOnly state
  bool get readOnly;

  /// set readOnly on field
  ///
  /// **maybe won't work if field not implement !**
  set readOnly(bool readOnly);

  /// get visible state
  bool get visible;

  /// set visible on field
  ///
  /// **maybe won't work if field not implement !**
  set visible(bool visible);
}

/// a base field state model created by BaseFormField
class BaseFieldStateModel extends BaseStateModel with AbstractFieldStateModel {
  BaseFieldStateModel(Map<String, StateValue> initStateMap)
      : super(initStateMap);

  /// get padding state
  EdgeInsets? get padding => getState('padding');

  /// set padding
  set padding(EdgeInsets? padding) => update1('padding', padding);

  /// get flex state
  int get flex => getState('flex');

  ///set flex
  set flex(int flex) => update1('flex', padding);

  @override
  bool get readOnly => getState('readOnly');
  @override
  set readOnly(bool readOnly) => update1('readOnly', readOnly);
  @override
  bool get visible => getState('visible');
  @override
  set visible(bool visible) => update1('visible', visible);
}
