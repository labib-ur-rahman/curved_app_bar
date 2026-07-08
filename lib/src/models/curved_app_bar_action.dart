import 'package:flutter/material.dart';

/// Describes an action that can be rendered in the app bar or overflow menu.
///
/// Use [CurvedAppBarAction] when you want the package to automatically keep a
/// limited number of actions visible and move the rest into a Material overflow
/// menu.
class CurvedAppBarAction {
  /// Creates an app bar action that can appear as an icon button or menu item.
  const CurvedAppBarAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.menuIconColor,
    this.menuTextStyle,
    this.enabled = true,
  });

  /// Text shown in the overflow menu.
  final String label;

  /// Icon shown in the toolbar and overflow menu.
  final IconData icon;

  /// Called when the action is selected.
  final VoidCallback? onPressed;

  /// Optional tooltip for the toolbar icon button.
  final String? tooltip;

  /// Optional icon color used only inside the overflow menu.
  ///
  /// Toolbar icons continue to inherit the app bar foreground color.
  final Color? menuIconColor;

  /// Optional text style used only inside the overflow menu.
  final TextStyle? menuTextStyle;

  /// Whether this action is interactive.
  final bool enabled;
}
