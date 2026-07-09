import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../clippers/curved_app_bar_clipper.dart';
import '../enums/curved_app_bar_shape.dart';
import '../models/curved_app_bar_action.dart';
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
    this.backButton,
    this.drawerButton,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subtitle,
    this.actions,
    this.actionItems,
    this.maxVisibleActionItems = 2,
    this.overflowMenuIcon,
    this.overflowMenuTooltip,
    this.overflowMenuColor,
    this.overflowMenuIconColor,
    this.overflowMenuTextStyle,
    this.bottom,
    this.centerTitle = false,
    this.height,
    this.leadingWidth = kToolbarHeight,
    this.actionsMaxWidthFactor = 0.45,
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
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeOutCubic,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The default app bar height, excluding the status bar.
  static const double defaultHeight = kToolbarHeight;

  /// The default app bar height for non-rounded shapes.
  static const double defaultExpandedHeight = kToolbarHeight + 40;

  /// The default bottom curve radius.
  static const double defaultCurveRadius = 32;

  /// A widget displayed before the title.
  ///
  /// When null and [automaticallyImplyLeading] is true, a [BackButton] is shown
  /// only when the current route can pop.
  final Widget? leading;

  /// Custom back button shown when [leading] is null, [automaticallyImplyLeading]
  /// is true, and the current route can pop.
  ///
  /// Defaults to Flutter's [BackButton].
  final Widget? backButton;

  /// Custom drawer menu button shown when [leading] is null,
  /// [automaticallyImplyLeading] is true, the current route cannot pop, and the
  /// nearest [Scaffold] has a drawer.
  ///
  /// Defaults to a menu [IconButton] that opens the drawer.
  final Widget? drawerButton;

  /// Whether to show an implied leading widget when [leading] is null.
  ///
  /// When true, the app bar shows a back button if the current route can pop.
  /// If the current route cannot pop but the nearest [Scaffold] has a drawer,
  /// it shows a drawer menu button. Otherwise, no leading widget is shown.
  final bool automaticallyImplyLeading;

  /// The main title widget.
  final Widget? title;

  /// An optional widget displayed under [title].
  final Widget? subtitle;

  /// Widgets displayed after the title area.
  final List<Widget>? actions;

  /// Typed actions that can automatically move into an overflow menu.
  ///
  /// Use this when you want common actions visible as icon buttons and
  /// additional actions automatically placed under the three-dot menu.
  final List<CurvedAppBarAction>? actionItems;

  /// Maximum number of [actionItems] shown directly in the toolbar.
  ///
  /// Remaining items are moved into the overflow menu.
  final int maxVisibleActionItems;

  /// Optional icon used for the overflow menu button.
  final Widget? overflowMenuIcon;

  /// Tooltip used for the overflow menu button.
  final String? overflowMenuTooltip;

  /// Background color used by the overflow menu surface.
  final Color? overflowMenuColor;

  /// Default icon color for overflow menu items.
  ///
  /// Toolbar action icons still inherit the app bar foreground color.
  final Color? overflowMenuIconColor;

  /// Default text style for overflow menu items.
  final TextStyle? overflowMenuTextStyle;

  /// An optional widget displayed below the toolbar row.
  final PreferredSizeWidget? bottom;

  /// Whether the title area should be centered.
  final bool centerTitle;

  /// The toolbar height, excluding status bar and [bottom].
  ///
  /// When null, [CurvedAppBarShape.rounded] uses [defaultHeight] and other
  /// shapes use [defaultExpandedHeight].
  final double? height;

  /// Width reserved for the leading widget.
  final double leadingWidth;

  /// Maximum toolbar width fraction reserved for trailing [actions].
  ///
  /// This prevents crowded action rows from hiding the title or overflowing the
  /// toolbar. Extra actions become horizontally scrollable inside this width.
  final double actionsMaxWidthFactor;

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

  /// Whether to play the built-in fade and slide entrance animation.
  ///
  /// Set this to false when the app bar should render immediately without any
  /// transition.
  final bool animate;

  /// Duration used by the built-in opacity and slide transition.
  final Duration animationDuration;

  /// Curve used by the built-in opacity and slide transition.
  final Curve animationCurve;

  /// Clip behavior passed to [ClipPath].
  final Clip clipBehavior;

  double get _bottomHeight => bottom?.preferredSize.height ?? 0;

  double get _effectiveHeight {
    final customHeight = height;
    if (customHeight != null) {
      return customHeight;
    }

    return switch (shape) {
      CurvedAppBarShape.rounded => defaultHeight,
      _ => defaultExpandedHeight,
    };
  }

  double get _toolbarContentHeight {
    final resolvedHeight = _effectiveHeight;
    if (resolvedHeight < defaultHeight) {
      return resolvedHeight;
    }

    return defaultHeight;
  }

  @override
  Size get preferredSize {
    if (!visible) {
      return Size.zero;
    }

    return Size.fromHeight(_effectiveHeight + _bottomHeight);
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
                      height: _effectiveHeight,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: _toolbarContentHeight,
                          child: Padding(
                            padding: contentPadding,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final leading = _buildLeading(
                                  context,
                                  resolvedForegroundColor,
                                );
                                final titleArea = _buildTitleArea(
                                  resolvedForegroundColor,
                                );
                                final actions = _buildActions(
                                  constraints.maxWidth,
                                );

                                return Row(
                                  children: [
                                    ?leading,
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Align(
                                          alignment: centerTitle
                                              ? Alignment.center
                                              : Alignment.centerLeft,
                                          child: titleArea,
                                        ),
                                      ),
                                    ),
                                    ?actions,
                                  ],
                                );
                              },
                            ),
                          ),
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

    if (!animate) {
      return appBar;
    }

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

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading == null && !_shouldBuildImpliedLeading(context)) {
      return null;
    }

    return CurvedAppBarLeading(
      leading: leading,
      backButton: backButton,
      drawerButton: drawerButton,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      foregroundColor: foregroundColor,
    );
  }

  bool _shouldBuildImpliedLeading(BuildContext context) {
    if (!automaticallyImplyLeading) {
      return false;
    }

    final route = ModalRoute.of(context);
    if (route != null && route.canPop) {
      return true;
    }

    return Scaffold.maybeOf(context)?.hasDrawer ?? false;
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

  Widget? _buildActions(double toolbarWidth) {
    final actionWidgets = actions;
    final typedActions = actionItems;
    final hasWidgetActions = actionWidgets != null && actionWidgets.isNotEmpty;
    final hasTypedActions = typedActions != null && typedActions.isNotEmpty;

    if (!hasWidgetActions && !hasTypedActions) {
      return null;
    }

    final safeFactor = actionsMaxWidthFactor.clamp(0.2, 0.8);

    return CurvedAppBarActions(
      actions: actionWidgets,
      actionItems: typedActions,
      maxVisibleActionItems: maxVisibleActionItems,
      overflowMenuIcon: overflowMenuIcon,
      overflowMenuTooltip: overflowMenuTooltip,
      overflowMenuColor: overflowMenuColor,
      overflowMenuIconColor: overflowMenuIconColor,
      overflowMenuTextStyle: overflowMenuTextStyle,
      maxWidth: toolbarWidth * safeFactor,
    );
  }
}
