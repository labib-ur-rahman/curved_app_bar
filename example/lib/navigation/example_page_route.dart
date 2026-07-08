import 'package:flutter/material.dart';

/// Creates the example app's screen transition.
///
/// This keeps navigation visually obvious while remaining platform friendly:
/// the incoming page fades in and slides a short distance from the right.
PageRouteBuilder<void> buildExamplePageRoute(Widget screen) {
  return PageRouteBuilder<void>(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
