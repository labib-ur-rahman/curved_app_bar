import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../clippers/curved_app_bar_clipper.dart';
import '../enums/curved_app_bar_shape.dart';
import '../utils/system_overlay_style_resolver.dart';
import 'curved_app_bar_actions.dart';
import 'curved_app_bar_leading.dart';
import 'curved_app_bar_title.dart';

/// A Flutter-only curved app bar that works directly with [Scaffold.appBar].
///
/// By default, the bar reads its colors from [ThemeData.colorScheme], uses a
/// [CustomClipper] for the curved lower edge, and resolves status bar icon
/// brightness from the background color.
class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a curved app bar for use in [Scaffold.appBar].
  const CurvedAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subtitle,
    this.actions,
    this.bottom,
    this.centerTitle = false,
    this.height = defaultHeight,
    this.leadingWidth = kToolbarHeight,
    this.curveRadius = defaultCurveRadius,
    this.shape = CurvedAppBarShape.rounded,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.statusBarColor,
    this.systemOverlayStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.visible = true,
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeOutCubic,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The default app bar height, excluding the status bar.
  static const double defaultHeight = kToolbarHeight;

  /// The default bottom curve radius.
  static const double defaultCurveRadius = 32;

  /// A widget displayed before the title.
  ///
  /// When null and [automaticallyImplyLeading] is true, a [BackButton] is shown
  /// only when the current route can pop.
  final Widget? leading;

  /// Whether to show a default back button when [leading] is null.
  final bool automaticallyImplyLeading;

  /// The main title widget.
  final Widget? title;

  /// An optional widget displayed under [title].
  final Widget? subtitle;

  /// Widgets displayed after the title area.
  final List<Widget>? actions;

  /// An optional widget displayed below the toolbar row.
  final PreferredSizeWidget? bottom;

  /// Whether the title area should be centered.
  final bool centerTitle;

  /// The toolbar height, excluding status bar and [bottom].
  final double height;

  /// Width reserved for the leading widget.
  final double leadingWidth;

  /// Radius used by [CurvedAppBarClipper].
  final double curveRadius;

  /// The bottom shape drawn by the clipper.
  final CurvedAppBarShape shape;

  /// App bar background color.
  ///
  /// Defaults to `Theme.of(context).colorScheme.primary`. When
  /// [backgroundGradient] is provided, this color is still used as the fallback
  /// surface color and for status bar style resolution unless [statusBarColor]
  /// is also provided.
  final Color? backgroundColor;

  /// Optional gradient painted behind the toolbar and bottom content.
  ///
  /// When provided, the gradient visually replaces the solid [backgroundColor]
  /// while keeping the same clipping, animation, and status bar behavior.
  final Gradient? backgroundGradient;

  /// Default text and icon color.
  ///
  /// Defaults to `Theme.of(context).colorScheme.onPrimary`.
  final Color? foregroundColor;

  /// Status bar background color.
  ///
  /// Defaults to the resolved app bar [backgroundColor].
  final Color? statusBarColor;

  /// Optional full system overlay style override.
  ///
  /// When null, the status bar style is resolved from the app bar background
  /// brightness.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Padding applied around the toolbar content.
  final EdgeInsetsGeometry contentPadding;

  /// Text style applied to [title] through [DefaultTextStyle].
  final TextStyle? titleTextStyle;

  /// Text style applied to [subtitle] through [DefaultTextStyle].
  final TextStyle? subtitleTextStyle;

  /// Whether the app bar should be visible.
  ///
  /// When false, [preferredSize] becomes [Size.zero] so [Scaffold] can collapse
  /// the app bar area.
  final bool visible;

  /// Duration used by the built-in opacity and slide transition.
  final Duration animationDuration;

  /// Curve used by the built-in opacity and slide transition.
  final Curve animationCurve;

  /// Clip behavior passed to [ClipPath].
  final Clip clipBehavior;

  double get _bottomHeight => bottom?.preferredSize.height ?? 0;

  @override
  Size get preferredSize {
    if (!visible) {
      return Size.zero;
    }

    return Size.fromHeight(height + _bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final resolvedBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;
    final resolvedForegroundColor =
        foregroundColor ?? theme.colorScheme.onPrimary;
    final resolvedOverlayStyle =
        systemOverlayStyle ??
        resolveSystemOverlayStyle(
          backgroundColor: resolvedBackgroundColor,
          backgroundGradient: backgroundGradient,
          statusBarColor: statusBarColor,
        );

    final appBar = AnnotatedRegion<SystemUiOverlayStyle>(
      value: resolvedOverlayStyle,
      child: ClipPath(
        clipper: CurvedAppBarClipper(shape: shape, radius: curveRadius),
        clipBehavior: clipBehavior,
        child: _buildBackground(
          resolvedBackgroundColor,
          SafeArea(
            bottom: false,
            child: IconTheme.merge(
              data: IconThemeData(color: resolvedForegroundColor),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: resolvedForegroundColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: height,
                      child: Padding(
                        padding: contentPadding,
                        child: NavigationToolbar(
                          leading: _buildLeading(resolvedForegroundColor),
                          middle: _buildTitleArea(resolvedForegroundColor),
                          trailing: _buildActions(),
                          centerMiddle: centerTitle,
                          middleSpacing: 16,
                        ),
                      ),
                    ),
                    if (bottom != null)
                      IconTheme.merge(
                        data: IconThemeData(color: resolvedForegroundColor),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(color: resolvedForegroundColor),
                          child: SizedBox(height: _bottomHeight, child: bottom),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: animationDuration,
      curve: animationCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * -12),
            child: child,
          ),
        );
      },
      child: appBar,
    );
  }

  Widget _buildBackground(Color resolvedBackgroundColor, Widget child) {
    final gradient = backgroundGradient;

    if (gradient == null) {
      return Material(color: resolvedBackgroundColor, child: child);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        gradient: gradient,
      ),
      child: Material(color: Colors.transparent, child: child),
    );
  }

  Widget? _buildLeading(Color foregroundColor) {
    if (leading == null && !automaticallyImplyLeading) {
      return null;
    }

    return CurvedAppBarLeading(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      foregroundColor: foregroundColor,
    );
  }

  Widget? _buildTitleArea(Color foregroundColor) {
    if (title == null && subtitle == null) {
      return null;
    }

    return CurvedAppBarTitle(
      title: title,
      subtitle: subtitle,
      centerTitle: centerTitle,
      foregroundColor: foregroundColor,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
    );
  }

  Widget? _buildActions() {
    final actionWidgets = actions;
    if (actionWidgets == null || actionWidgets.isEmpty) {
      return null;
    }

    return CurvedAppBarActions(actions: actionWidgets);
  }
}
