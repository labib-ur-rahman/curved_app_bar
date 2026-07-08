import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../enums/curved_app_bar_shape.dart';

/// Clips a rectangle into one of the supported curved app bar shapes.
///
/// The [radius] value controls the visible curve size. It is automatically
/// clamped to the available width and height so very small app bars still clip
/// safely.
class CurvedAppBarClipper extends CustomClipper<Path> {
  /// Creates a reusable clipper for curved app bar backgrounds.
  const CurvedAppBarClipper({
    this.shape = CurvedAppBarShape.rounded,
    this.radius = 32,
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
