import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'curved_app_bar.dart';

/// Adds layout-aware spacing for bodies used behind a [CurvedAppBar].
///
/// This helper is useful with `Scaffold.extendBodyBehindAppBar: true`, where
/// the body is allowed to start behind the app bar. [CurvedBody] adds a small
/// amount of real top layout space only when the device status bar needs it, so
/// scroll views, hit testing, stacks, safe areas, and nested layouts behave
/// predictably.
///
/// The [overlap] value describes how much the body should visually rise into
/// the curved app bar area. The default overlap of `32` usually lets the body
/// sit directly under the app bar curve without creating a large blank gap.
///
/// Unlike a visual-only `Transform.translate`, this widget uses [Padding] to
/// participate in layout. By default it also removes inherited top
/// [MediaQuery] padding from [child], which prevents scroll views such as
/// [ListView] from adding a second top safe-area gap.
class CurvedBody extends StatelessWidget {
  /// Creates layout-aware spacing for a body placed behind a curved app bar.
  const CurvedBody({
    super.key,
    this.overlap = 32,
    this.includeStatusBar = true,
    this.removeTopMediaQueryPadding = true,
    required this.child,
  }) : assert(overlap >= 0, 'overlap must be greater than or equal to 0');

  /// How much the body should visually rise into the curved app bar area.
  ///
  /// This value is subtracted from the status bar height when
  /// [includeStatusBar] is true.
  final double overlap;

  /// Whether to use the device status bar height when calculating top spacing.
  final bool includeStatusBar;

  /// Whether to remove inherited top [MediaQuery] padding from [child].
  ///
  /// This is useful because Flutter scroll views can automatically apply top
  /// safe-area padding from [MediaQuery]. Since [CurvedBody] already handles
  /// the optional status bar offset with real layout padding, removing that
  /// inherited top padding avoids excessive blank space.
  final bool removeTopMediaQueryPadding;

  /// The body content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = includeStatusBar
        ? MediaQuery.paddingOf(context).top
        : 0.0;
    final topSpacing = math.max(0.0, statusBarHeight - overlap);

    final body = removeTopMediaQueryPadding
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          )
        : child;

    return Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: body,
    );
  }
}

/// Convenience extension for wrapping any widget in a [CurvedBody].
extension CurvedBodyX on Widget {
  /// Wraps this widget with layout-aware curved app bar body spacing.
  Widget withCurvedBody({
    double overlap = 32,
    bool includeStatusBar = true,
    bool removeTopMediaQueryPadding = true,
  }) {
    return CurvedBody(
      overlap: overlap,
      includeStatusBar: includeStatusBar,
      removeTopMediaQueryPadding: removeTopMediaQueryPadding,
      child: this,
    );
  }
}
