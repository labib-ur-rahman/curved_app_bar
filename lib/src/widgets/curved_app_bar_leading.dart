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
  });

  /// A widget displayed before the title.
  final Widget? leading;

  /// Whether to show a default back button when [leading] is null.
  final bool automaticallyImplyLeading;

  /// Width reserved for the leading widget.
  final double leadingWidth;

  /// Color applied to leading icons by default.
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final leadingWidget = leading ?? _buildDefaultLeading(context);

    if (leadingWidget == null) {
      return const SizedBox.shrink();
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
}
