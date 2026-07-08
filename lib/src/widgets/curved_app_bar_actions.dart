import 'package:flutter/material.dart';

import '../models/curved_app_bar_action.dart';

/// Lays out trailing action widgets for [CurvedAppBar].
class CurvedAppBarActions extends StatelessWidget {
  /// Creates a compact row of trailing app bar actions.
  const CurvedAppBarActions({
    super.key,
    required this.maxWidth,
    this.actions,
    this.actionItems,
    this.maxVisibleActionItems = 2,
    this.overflowMenuIcon,
    this.overflowMenuTooltip,
    this.overflowMenuColor,
    this.overflowMenuIconColor,
    this.overflowMenuTextStyle,
  });

  /// Widgets displayed after the title area.
  final List<Widget>? actions;

  /// Typed actions that can automatically move into an overflow menu.
  final List<CurvedAppBarAction>? actionItems;

  /// Maximum number of [actionItems] shown as toolbar icon buttons.
  final int maxVisibleActionItems;

  /// Optional icon used for the overflow menu button.
  final Widget? overflowMenuIcon;

  /// Tooltip used for the overflow menu button.
  final String? overflowMenuTooltip;

  /// Background color used by the overflow menu surface.
  final Color? overflowMenuColor;

  /// Default icon color for overflow menu items.
  ///
  /// Defaults to [PopupMenuThemeData.iconColor], then
  /// `Theme.of(context).colorScheme.onSurface`.
  final Color? overflowMenuIconColor;

  /// Default text style for overflow menu items.
  ///
  /// Defaults to [PopupMenuThemeData.textStyle], then the theme body text color.
  final TextStyle? overflowMenuTextStyle;

  /// Maximum horizontal space reserved for the action area.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final actionWidgets = <Widget>[
      ...?actions,
      ..._visibleActionButtons(),
      if (_overflowActionItems.isNotEmpty) _buildOverflowMenu(context),
    ];

    if (actionWidgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(mainAxisSize: MainAxisSize.min, children: actionWidgets),
      ),
    );
  }

  List<CurvedAppBarAction> get _safeActionItems => actionItems ?? const [];

  int get _visibleActionCount {
    if (maxVisibleActionItems < 0) {
      return 0;
    }

    return maxVisibleActionItems;
  }

  List<CurvedAppBarAction> get _visibleActionItems {
    return _safeActionItems.take(_visibleActionCount).toList();
  }

  List<CurvedAppBarAction> get _overflowActionItems {
    return _safeActionItems.skip(_visibleActionCount).toList();
  }

  List<Widget> _visibleActionButtons() {
    return _visibleActionItems.map((action) {
      return IconButton(
        tooltip: action.tooltip ?? action.label,
        icon: Icon(action.icon),
        onPressed: action.enabled ? action.onPressed : null,
      );
    }).toList();
  }

  Widget _buildOverflowMenu(BuildContext context) {
    final theme = Theme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    final resolvedIconColor =
        overflowMenuIconColor ??
        popupMenuTheme.iconColor ??
        theme.colorScheme.onSurface;
    final resolvedTextStyle =
        overflowMenuTextStyle ??
        popupMenuTheme.textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        );

    return PopupMenuButton<CurvedAppBarAction>(
      tooltip:
          overflowMenuTooltip ??
          MaterialLocalizations.of(context).moreButtonTooltip,
      icon: overflowMenuIcon ?? const Icon(Icons.more_vert_rounded),
      color: overflowMenuColor ?? popupMenuTheme.color,
      onSelected: (action) => action.onPressed?.call(),
      itemBuilder: (context) {
        return _overflowActionItems.map((action) {
          final enabled = action.enabled && action.onPressed != null;
          final iconColor = enabled
              ? action.menuIconColor ?? resolvedIconColor
              : theme.disabledColor;
          final textStyle = action.menuTextStyle ?? resolvedTextStyle;

          return PopupMenuItem<CurvedAppBarAction>(
            value: action,
            enabled: enabled,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(action.icon, color: iconColor),
                const SizedBox(width: 12),
                Flexible(child: Text(action.label, style: textStyle)),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
