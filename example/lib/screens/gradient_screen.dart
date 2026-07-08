import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/screen_body.dart';

/// Demonstrates a dark gradient app bar with automatic status bar contrast.
class GradientScreen extends StatelessWidget {
  const GradientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurvedAppBar(
        title: Text('Gradient'),
        animate: true,
        subtitle: Text('Status bar follows brightness'),
        backgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07111F), Color(0xFF16395F)],
        ),
      ),
      body: ScreenBody(
        title: 'Dark gradient',
        description: 'The status bar icons should be light on this screen.',
      ),
    );
  }
}
