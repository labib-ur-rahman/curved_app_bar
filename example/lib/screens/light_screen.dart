import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/screen_body.dart';

/// Demonstrates a light app bar with dark foreground and status bar icons.
class LightScreen extends StatelessWidget {
  const LightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurvedAppBar(
        title: Text('Light Color'),
        subtitle: Text('Dark status bar icons'),
        backgroundColor: Color(0xFFF7FAFF),
        foregroundColor: Color(0xFF132238),
      ),
      body: ScreenBody(
        title: 'Light background',
        description: 'The status bar icons should be dark on this screen.',
      ),
    );
  }
}
