import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

/// Resolves a status bar overlay style that remains legible on the app bar.
///
/// On Android, [SystemUiOverlayStyle.statusBarIconBrightness] controls status
/// bar icon color. On iOS, [SystemUiOverlayStyle.statusBarBrightness] describes
/// the status bar background brightness, so it intentionally uses the opposite
/// value from the icon brightness.
SystemUiOverlayStyle resolveSystemOverlayStyle({
  required Color backgroundColor,
  Gradient? backgroundGradient,
  Color? statusBarColor,
}) {
  final brightnessColor =
      statusBarColor ??
      _representativeGradientColor(backgroundGradient) ??
      backgroundColor;
  final statusBarBackgroundColor =
      statusBarColor ??
      (backgroundGradient == null ? backgroundColor : const Color(0x00000000));
  final isDarkBackground = brightnessColor.computeLuminance() < 0.5;

  return SystemUiOverlayStyle(
    statusBarColor: statusBarBackgroundColor,
    statusBarIconBrightness: isDarkBackground
        ? Brightness.light
        : Brightness.dark,
    statusBarBrightness: isDarkBackground ? Brightness.dark : Brightness.light,
  );
}

Color? _representativeGradientColor(Gradient? gradient) {
  if (gradient == null || gradient.colors.isEmpty) {
    return null;
  }

  if (gradient.colors.length == 1) {
    return gradient.colors.first;
  }

  final stops = gradient.stops;
  var red = 0.0;
  var green = 0.0;
  var blue = 0.0;
  var alpha = 0.0;
  var totalWeight = 0.0;

  for (var index = 0; index < gradient.colors.length; index += 1) {
    final color = gradient.colors[index];
    final weight = _gradientColorWeight(stops, index, gradient.colors.length);

    red += color.r * weight;
    green += color.g * weight;
    blue += color.b * weight;
    alpha += color.a * weight;
    totalWeight += weight;
  }

  if (totalWeight == 0) {
    return gradient.colors.first;
  }

  return Color.from(
    alpha: alpha / totalWeight,
    red: red / totalWeight,
    green: green / totalWeight,
    blue: blue / totalWeight,
  );
}

double _gradientColorWeight(List<double>? stops, int index, int colorCount) {
  if (stops == null || stops.length != colorCount) {
    return 1;
  }

  if (index == 0) {
    return stops[1] - stops[0];
  }

  if (index == colorCount - 1) {
    return stops[index] - stops[index - 1];
  }

  return (stops[index + 1] - stops[index - 1]) / 2;
}
