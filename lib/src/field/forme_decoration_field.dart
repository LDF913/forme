import 'package:flutter/material.dart';
import '../render/forme_render_data.dart';

const Duration _kTransitionDuration = Duration(milliseconds: 200);

/// used to wrap form field which not support inputdecoration
class FormeDecoration extends StatelessWidget {
  const FormeDecoration({
    Key? key,
    this.labelText,
    required this.child,
    this.errorText,
    required this.focusNode,
    this.icon,
    this.helperText,
    this.formeDecorationFieldRenderData,
  }) : super(key: key);

  final String? labelText;
  final String? errorText;
  final String? helperText;
  final Widget child;
  final FocusNode focusNode;
  final Widget? icon;
  final FormeDecorationRenderData? formeDecorationFieldRenderData;

  @override
  Widget build(BuildContext context) {
    Widget builder = Builder(builder: (context) {
      bool hasFocus = Focus.of(context).hasFocus;

      ThemeData themeData = Theme.of(context);
      TextStyle? helperStyle = themeData.textTheme.caption!
          .copyWith(color: themeData.hintColor)
          .merge(formeDecorationFieldRenderData?.errorStyle);
      TextStyle? errorStyle = themeData.textTheme.caption!
          .copyWith(color: themeData.errorColor)
          .merge(formeDecorationFieldRenderData?.errorStyle);
      TextStyle? labelStyle = themeData.textTheme.subtitle1
          ?.copyWith(
              color: hasFocus ? themeData.primaryColor : themeData.hintColor)
          .merge(formeDecorationFieldRenderData?.labelStyle);

      List<Widget> rows = [];

      if (labelText != null || icon != null) {
        List<Widget> children = [];
        if (labelText != null) {
          children.add(Text(
            labelText!,
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
          ));
        }

        if (icon != null) {
          Color? iconColor = hasFocus
              ? themeData.primaryColor
              : _getDefaultIconColor(themeData);
          children.add(Spacer());
          children.add(IconTheme(
            data: IconTheme.of(context).copyWith(color: iconColor),
            child: icon!,
          ));
        }
        rows.add(Padding(
          padding:
              formeDecorationFieldRenderData?.headPadding ?? EdgeInsets.zero,
          child: Row(
            children: children,
          ),
        ));
      }
      rows.add(child);
      if (errorText != null || helperText != null) {
        rows.add(Padding(
          padding:
              formeDecorationFieldRenderData?.bottomPadding ?? EdgeInsets.zero,
          child: _HelperError(
            errorStyle: errorStyle,
            helperStyle: helperStyle,
            errorText: errorText,
            helperText: helperText,
            errorMaxLines: formeDecorationFieldRenderData?.errorMaxLines,
            helperMaxLines: formeDecorationFieldRenderData?.helperMaxLines,
          ),
        ));
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      );
    });

    return Focus(
      focusNode: focusNode,
      canRequestFocus: focusNode.canRequestFocus,
      skipTraversal: true,
      child: builder,
    );
  }

  Color? _getDefaultIconColor(ThemeData themeData) {
    switch (themeData.brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
    }
  }
}

// Display the helper and error text. When the error text appears
// it fades and the helper text fades out. The error text also
// slides upwards a little when it first appears.
class _HelperError extends StatefulWidget {
  const _HelperError({
    Key? key,
    this.textAlign,
    this.errorText,
    this.helperText,
    this.errorStyle,
    this.helperStyle,
    this.errorMaxLines,
    this.helperMaxLines,
  }) : super(key: key);

  final TextAlign? textAlign;
  final String? errorText;
  final String? helperText;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final int? errorMaxLines;
  final int? helperMaxLines;

  @override
  _HelperErrorState createState() => _HelperErrorState();
}

class _HelperErrorState extends State<_HelperError>
    with SingleTickerProviderStateMixin {
  // If the height of this widget and the counter are zero ("empty") at
  // layout time, no space is allocated for the subtext.
  static const Widget empty = SizedBox();

  late AnimationController _controller;
  Widget? _helper;
  Widget? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
    );
    if (widget.errorText != null) {
      _error = _buildError();
      _controller.value = 1.0;
    } else if (widget.helperText != null) {
      _helper = _buildHelper();
    }
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // The _controller's value has changed.
    });
  }

  @override
  void didUpdateWidget(_HelperError old) {
    super.didUpdateWidget(old);

    final String? newErrorText = widget.errorText;
    final String? newHelperText = widget.helperText;
    final String? oldErrorText = old.errorText;
    final String? oldHelperText = old.helperText;

    final bool errorTextStateChanged =
        (newErrorText != null) != (oldErrorText != null);
    final bool helperTextStateChanged = newErrorText == null &&
        (newHelperText != null) != (oldHelperText != null);

    if (errorTextStateChanged || helperTextStateChanged) {
      if (newErrorText != null) {
        _error = _buildError();
        _controller.forward();
      } else if (newHelperText != null) {
        _helper = _buildHelper();
        _controller.reverse();
      } else {
        _controller.reverse();
      }
    }
  }

  Widget _buildHelper() {
    assert(widget.helperText != null);
    return Semantics(
      container: true,
      child: Opacity(
        opacity: 1.0 - _controller.value,
        child: Text(
          widget.helperText!,
          style: widget.helperStyle,
          textAlign: widget.textAlign,
          overflow: TextOverflow.ellipsis,
          maxLines: widget.helperMaxLines,
        ),
      ),
    );
  }

  Widget _buildError() {
    assert(widget.errorText != null);
    return Semantics(
      container: true,
      liveRegion: true,
      child: Opacity(
        opacity: _controller.value,
        child: FractionalTranslation(
          translation: Tween<Offset>(
            begin: const Offset(0.0, -0.25),
            end: Offset.zero,
          ).evaluate(_controller.view),
          child: Text(
            widget.errorText!,
            style: widget.errorStyle,
            textAlign: widget.textAlign,
            overflow: TextOverflow.ellipsis,
            maxLines: widget.errorMaxLines,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isDismissed) {
      _error = null;
      if (widget.helperText != null) {
        return _helper = _buildHelper();
      } else {
        _helper = null;
        return empty;
      }
    }

    if (_controller.isCompleted) {
      _helper = null;
      if (widget.errorText != null) {
        return _error = _buildError();
      } else {
        _error = null;
        return empty;
      }
    }

    if (_helper == null && widget.errorText != null) return _buildError();

    if (_error == null && widget.helperText != null) return _buildHelper();

    if (widget.errorText != null) {
      return Stack(
        children: <Widget>[
          Opacity(
            opacity: 1.0 - _controller.value,
            child: _helper,
          ),
          _buildError(),
        ],
      );
    }

    if (widget.helperText != null) {
      return Stack(
        children: <Widget>[
          _buildHelper(),
          Opacity(
            opacity: _controller.value,
            child: _error,
          ),
        ],
      );
    }
    return empty;
  }
}
