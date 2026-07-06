import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The bottom edge shape used by [CurvedAppBar].
enum CurvedAppBarShape {
  /// Rounds the app bar's own bottom-left and bottom-right corners.
  rounded,

  /// Cuts a top-rounded surface out of the app bar's bottom edge.
  ///
  /// This is useful when the body background should appear to rise into the
  /// app bar with top-left and top-right rounded corners.
  invertedRounded,
}

/// Clips a rectangle into one of the curved app bar shapes.
///
/// The [radius] value controls the visible curve size. It is automatically
/// clamped to the available width and height so very small app bars still clip
/// safely.
class CurvedAppBarClipper extends CustomClipper<Path> {
  /// Creates a reusable clipper for curved app bar backgrounds.
  const CurvedAppBarClipper({
    this.shape = CurvedAppBarShape.rounded,
    this.radius = CurvedAppBar.defaultCurveRadius,
  });

  /// The curved bottom shape to create.
  final CurvedAppBarShape shape;

  /// The radius used for the bottom curves.
  final double radius;

  @override
  Path getClip(Size size) {
    final safeRadius = _safeRadius(size);

    return switch (shape) {
      CurvedAppBarShape.rounded => _roundedPath(size, safeRadius),
      CurvedAppBarShape.invertedRounded => _invertedRoundedPath(
        size,
        safeRadius,
      ),
    };
  }

  @override
  bool shouldReclip(covariant CurvedAppBarClipper oldClipper) {
    return oldClipper.shape != shape || oldClipper.radius != radius;
  }

  double _safeRadius(Size size) {
    if (radius <= 0 || size.isEmpty) {
      return 0;
    }

    return math.min(radius, math.min(size.width / 2, size.height));
  }

  Path _roundedPath(Size size, double safeRadius) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - safeRadius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - safeRadius,
        size.height,
      )
      ..lineTo(safeRadius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - safeRadius)
      ..close();
  }

  Path _invertedRoundedPath(Size size, double safeRadius) {
    final cutoutTop = size.height - safeRadius;

    final cutout = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, cutoutTop + safeRadius)
      ..quadraticBezierTo(0, cutoutTop, safeRadius, cutoutTop)
      ..lineTo(size.width - safeRadius, cutoutTop)
      ..quadraticBezierTo(
        size.width,
        cutoutTop,
        size.width,
        cutoutTop + safeRadius,
      )
      ..lineTo(size.width, size.height)
      ..close();

    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addPath(cutout, Offset.zero);
  }
}

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
  /// Defaults to `Theme.of(context).colorScheme.primary`.
  final Color? backgroundColor;

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
        _overlayStyleFor(
          backgroundColor: statusBarColor ?? resolvedBackgroundColor,
        );

    final appBar = AnnotatedRegion<SystemUiOverlayStyle>(
      value: resolvedOverlayStyle,
      child: ClipPath(
        clipper: CurvedAppBarClipper(shape: shape, radius: curveRadius),
        clipBehavior: clipBehavior,
        child: Material(
          color: resolvedBackgroundColor,
          child: SafeArea(
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
                          leading: _buildLeading(
                            context,
                            resolvedForegroundColor,
                          ),
                          middle: _buildTitleArea(
                            theme,
                            resolvedForegroundColor,
                          ),
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

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    final leadingWidget = leading ?? _buildDefaultLeading(context);

    if (leadingWidget == null) {
      return null;
    }

    return SizedBox(
      width: leadingWidth,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: IconTheme.merge(
          data: IconThemeData(color: foregroundColor),
          child: leadingWidget,
        ),
      ),
    );
  }

  Widget? _buildDefaultLeading(BuildContext context) {
    if (!automaticallyImplyLeading) {
      return null;
    }

    final route = ModalRoute.of(context);
    if (route == null || !route.canPop) {
      return null;
    }

    return const BackButton();
  }

  Widget? _buildTitleArea(ThemeData theme, Color foregroundColor) {
    if (title == null && subtitle == null) {
      return null;
    }

    final effectiveTitleStyle =
        titleTextStyle ??
        theme.textTheme.titleLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ??
        TextStyle(
          color: foregroundColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );
    final effectiveSubtitleStyle =
        subtitleTextStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: foregroundColor.withAlpha(209),
        ) ??
        TextStyle(color: foregroundColor.withAlpha(209), fontSize: 12);

    if (subtitle == null) {
      return DefaultTextStyle(
        style: effectiveTitleStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: title ?? const SizedBox.shrink(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null)
          DefaultTextStyle(
            style: effectiveTitleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: title!,
          ),
        DefaultTextStyle(
          style: effectiveSubtitleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: subtitle!,
        ),
      ],
    );
  }

  Widget? _buildActions() {
    final actionWidgets = actions;
    if (actionWidgets == null || actionWidgets.isEmpty) {
      return null;
    }

    return Row(mainAxisSize: MainAxisSize.min, children: actionWidgets);
  }

  SystemUiOverlayStyle _overlayStyleFor({required Color backgroundColor}) {
    final isDarkBackground = backgroundColor.computeLuminance() < 0.5;

    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarIconBrightness: isDarkBackground
          ? Brightness.light
          : Brightness.dark,
      statusBarBrightness: isDarkBackground
          ? Brightness.dark
          : Brightness.light,
    );
  }
}
