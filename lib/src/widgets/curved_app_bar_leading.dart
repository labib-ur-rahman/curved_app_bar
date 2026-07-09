import 'package:flutter/material.dart';

/// Builds the leading area for [CurvedAppBar].
class CurvedAppBarLeading extends StatelessWidget {
  /// Creates the leading widget wrapper used by the app bar toolbar.
  const CurvedAppBarLeading({
    super.key,
    required this.foregroundColor,
    required this.leadingWidth,
    required this.automaticallyImplyLeading,
    this.leading,
    this.backButton,
    this.drawerButton,
  });

  /// A widget displayed before the title.
  final Widget? leading;

  /// Custom back button shown when the current route can pop.
  final Widget? backButton;

  /// Custom menu button shown when the nearest [Scaffold] has a drawer.
  final Widget? drawerButton;

  /// Whether to show a default back button when [leading] is null.
  final bool automaticallyImplyLeading;

  /// Width reserved for the leading widget.
  final double leadingWidth;

  /// Color applied to leading icons by default.
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final leadingWidget = leading ?? _buildImpliedLeading(context);

    if (leadingWidget == null) {
      return const SizedBox.shrink();
    }

    return IconTheme.merge(
      data: IconThemeData(color: foregroundColor),
      child: leadingWidget,
    );
  }

  Widget? _buildImpliedLeading(BuildContext context) {
    if (!automaticallyImplyLeading) {
      return null;
    }

    final route = ModalRoute.of(context);
    if (route != null && route.canPop) {
      return backButton ?? const BackButton();
    }

    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.hasDrawer) {
      return drawerButton ??
          IconButton(
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            icon: const Icon(Icons.menu),
            onPressed: scaffold.openDrawer,
          );
    }

    return null;
  }
}
