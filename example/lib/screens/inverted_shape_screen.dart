import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/screen_body.dart';

/// Demonstrates the inverted rounded app bar shape.
class InvertedShapeScreen extends StatelessWidget {
  const InvertedShapeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF4F8FF),
      appBar: const CurvedAppBar(
        title: Text('Inverted Shape'),
        subtitle: Text('Rounded body cutout'),
        curveRadius: 42,
        animate: false,
        shape: CurvedAppBarShape.invertedRounded,
        backgroundColor: Color(0xFF23479A),
      ),
      body: ScreenBody(
        title: 'Inverted rounded',
        description: 'The body rises into the white cutout, not the toolbar.',
      ),
    );
  }
}
