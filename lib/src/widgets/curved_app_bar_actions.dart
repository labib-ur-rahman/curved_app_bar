import 'package:flutter/material.dart';

/// Lays out trailing action widgets for [CurvedAppBar].
class CurvedAppBarActions extends StatelessWidget {
  /// Creates a compact row of trailing app bar actions.
  const CurvedAppBarActions({super.key, required this.actions});

  /// Widgets displayed after the title area.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: actions);
  }
}
