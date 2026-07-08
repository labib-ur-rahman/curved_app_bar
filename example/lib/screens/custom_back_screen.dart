import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/circle_icon_button.dart';
import '../widgets/screen_body.dart';

/// Demonstrates replacing the automatically implied back button.
class CustomBackScreen extends StatelessWidget {
  const CustomBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(
        title: const Text('Custom Back'),
        subtitle: const Text('automaticallyImplyLeading is true'),
        backgroundColor: const Color(0xFF0F766E),
        backButton: CircleIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: const ScreenBody(
        title: 'Custom leading design',
        description:
            'The custom back button appears because this route can pop.',
      ),
    );
  }
}
