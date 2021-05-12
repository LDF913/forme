import 'package:flutter/widgets.dart';

/// listen  focusnode change
///
/// key maybe null ,key is null means root node focuschanged,otherwise sub node focused
/// see [FocusNodes]
typedef FocusListener = void Function(String? key, bool hasFocus);

class FocusNodes extends FocusNode {
  final String? name;
  final Map<String, FocusNode> _nodes = {};
  FocusListener? focusListener;

  FocusNodes(this.name) {
    this.addListener(() {
      if (focusListener != null) focusListener!(null, this.hasFocus);
    });
  }

  /// create a new focus node if not exists
  ///
  /// return old FocusNode if it is exists
  ///
  /// **do not dispose it by yourself,it will auto dispose **
  FocusNode newFocusNode(String key) {
    FocusNode? focusNode = _nodes[key];
    if (focusNode == null) {
      focusNode = new FocusNode();
      focusNode.addListener(() {
        if (focusListener != null) focusListener!(key, focusNode!.hasFocus);
      });
      _nodes[key] = focusNode;
    }
    return focusNode;
  }

  @override
  void dispose() {
    _nodes.values.forEach((element) {
      element.dispose();
    });
    _nodes.clear();
    focusListener = null;
    super.dispose();
  }
}
