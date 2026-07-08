import 'package:flutter/material.dart';

/// Builds the title and optional subtitle area for [CurvedAppBar].
class CurvedAppBarTitle extends StatelessWidget {
  /// Creates a title area with the package's default text styling behavior.
  const CurvedAppBarTitle({
    super.key,
    required this.foregroundColor,
    required this.centerTitle,
    this.title,
    this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  /// The main title widget.
  final Widget? title;

  /// An optional widget displayed under [title].
  final Widget? subtitle;

  /// Whether the title area should be centered.
  final bool centerTitle;

  /// Default text and icon color.
  final Color foregroundColor;

  /// Text style applied to [title] through [DefaultTextStyle].
  final TextStyle? titleTextStyle;

  /// Text style applied to [subtitle] through [DefaultTextStyle].
  final TextStyle? subtitleTextStyle;

  @override
  Widget build(BuildContext context) {
    if (title == null && subtitle == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
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
}
