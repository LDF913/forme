import 'package:flutter/material.dart';

import '../forme_field.dart';
import '../forme_state_model.dart';

class FormeColumn extends _FormeFlex {
  FormeColumn({
    required List<Widget> children,
    FormeFlexRenderData? formeFlexRenderData,
    required String name,
  }) : super(
          name: name,
          children: children,
          formeFlexRenderData: formeFlexRenderData,
          builder: (field) {
            _FormeFlexState state = field as _FormeFlexState;
            FormeFlexRenderData? renderData = state.model.formeFlexRenderData;
            return Column(
              children: state.model._widgets,
              mainAxisAlignment:
                  renderData?.mainAxisAlignment ?? MainAxisAlignment.start,
              mainAxisSize: renderData?.mainAxisSize ?? MainAxisSize.max,
              crossAxisAlignment:
                  renderData?.crossAxisAlignment ?? CrossAxisAlignment.center,
              verticalDirection:
                  renderData?.verticalDirection ?? VerticalDirection.down,
              textDirection: renderData?.textDirection,
              textBaseline: renderData?.textBaseline,
            );
          },
        );
}

class FormeRow extends _FormeFlex {
  FormeRow({
    required List<Widget> children,
    FormeFlexRenderData? formeFlexRenderData,
    required String name,
  }) : super(
          name: name,
          children: children,
          formeFlexRenderData: formeFlexRenderData,
          builder: (field) {
            _FormeFlexState state = field as _FormeFlexState;
            FormeFlexRenderData? renderData = state.model.formeFlexRenderData;
            return Row(
              children: state.model._widgets,
              mainAxisAlignment:
                  renderData?.mainAxisAlignment ?? MainAxisAlignment.start,
              mainAxisSize: renderData?.mainAxisSize ?? MainAxisSize.max,
              crossAxisAlignment:
                  renderData?.crossAxisAlignment ?? CrossAxisAlignment.center,
              verticalDirection:
                  renderData?.verticalDirection ?? VerticalDirection.down,
              textDirection: renderData?.textDirection,
              textBaseline: renderData?.textBaseline,
            );
          },
        );
}

abstract class _FormeFlex extends CommonField<FormeFlexModel> {
  final List<Widget> children;

  _FormeFlex({
    required String name,
    FormeFlexRenderData? formeFlexRenderData,
    required this.children,
    required FieldContentBuilder<CommonFieldState<FormeFlexModel>> builder,
  }) : super(
            name: name,
            builder: builder,
            model:
                FormeFlexModel._([], formeFlexRenderData: formeFlexRenderData));

  @override
  _FormeFlexState createState() => _FormeFlexState();
}

class _FormeFlexState extends CommonFieldState<FormeFlexModel> {
  late List<_FormeFlexWidget> widgets;

  @override
  void initState() {
    super.initState();
    widgets = (widget as _FormeFlex).children.map((e) {
      return _FormeFlexWidget(e, GlobalKey());
    }).toList();
  }

  @override
  FormeFlexModel get model {
    return FormeFlexModel._(List.of(widgets));
  }

  @override
  void beforeMerge(FormeFlexModel old, FormeFlexModel current) {
    widgets.clear();
    widgets.addAll(current._widgets);
  }
}

class _FormeFlexWidget extends StatelessWidget {
  final Widget child;
  const _FormeFlexWidget(this.child, GlobalKey key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class FormeFlexModel extends AbstractFormeModel {
  final List<_FormeFlexWidget> _widgets;
  final FormeFlexRenderData? formeFlexRenderData;

  FormeFlexModel._(this._widgets, {this.formeFlexRenderData});

  FormeFlexModel prepend(Widget widget) {
    _widgets.insert(0, _FormeFlexWidget(widget, GlobalKey()));
    return this;
  }

  FormeFlexModel renderData(FormeFlexRenderData formeFlexRenderData) {
    return FormeFlexModel._(_widgets, formeFlexRenderData: formeFlexRenderData);
  }

  FormeFlexModel append(Widget widget) {
    _widgets.add(_FormeFlexWidget(widget, GlobalKey()));
    return this;
  }

  FormeFlexModel remove(int index) {
    _rangeCheck(index);
    _widgets.removeAt(index);
    return this;
  }

  FormeFlexModel insert(int index, Widget widget) {
    if (index == 0) {
      return prepend(widget);
    }
    if (index == _widgets.length) {
      return append(widget);
    }
    if (index < 1 || index > _widgets.length - 1) {
      throw 'index out of range , range is [0,${_widgets.length}]';
    }
    _widgets.insert(index, _FormeFlexWidget(widget, GlobalKey()));
    return this;
  }

  FormeFlexModel swap(int oldIndex, int newIndex) {
    _rangeCheck(oldIndex);
    _rangeCheck(newIndex);
    if (oldIndex == newIndex) throw 'oldIndex must not equals newIndex';
    _FormeFlexWidget oldWidget = _widgets.removeAt(oldIndex);
    _widgets.insert(newIndex, oldWidget);
    return this;
  }

  _rangeCheck(int index) {
    if (index < 0 || index > _widgets.length - 1) {
      throw 'index out of range , range is [0,${_widgets.length - 1}]';
    }
  }

  @override
  AbstractFormeModel merge(AbstractFormeModel old) {
    FormeFlexModel oldModel = old as FormeFlexModel;
    FormeFlexRenderData? oldRenderData = oldModel.formeFlexRenderData;
    if (formeFlexRenderData == null)
      return FormeFlexModel._(_widgets, formeFlexRenderData: oldRenderData);
    else {
      if (oldRenderData == null) return this;
      return FormeFlexModel._(_widgets,
          formeFlexRenderData: FormeFlexRenderData(
            crossAxisAlignment: formeFlexRenderData?.crossAxisAlignment ??
                oldRenderData.crossAxisAlignment,
            mainAxisSize:
                formeFlexRenderData?.mainAxisSize ?? oldRenderData.mainAxisSize,
            mainAxisAlignment: formeFlexRenderData?.mainAxisAlignment ??
                oldRenderData.mainAxisAlignment,
            textDirection: formeFlexRenderData?.textDirection ??
                oldRenderData.textDirection,
            verticalDirection: formeFlexRenderData?.verticalDirection ??
                oldRenderData.verticalDirection,
            textBaseline:
                formeFlexRenderData?.textBaseline ?? oldRenderData.textBaseline,
          ));
    }
  }
}

class FormeFlexRenderData {
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final TextBaseline? textBaseline;

  const FormeFlexRenderData({
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.textBaseline,
  });
}
