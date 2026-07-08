import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';

import '../navigation/example_page_route.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/example_drawer.dart';
import '../widgets/example_tile.dart';
import 'custom_back_screen.dart';
import 'gradient_screen.dart';
import 'inverted_shape_screen.dart';
import 'light_screen.dart';

/// Home screen that demonstrates the package's main integration points.
class ExampleHomeScreen extends StatelessWidget {
  const ExampleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ExampleDrawer(),
      extendBodyBehindAppBar: true,
      appBar: CurvedAppBar(
        animate: false,
        shape: CurvedAppBarShape.invertedRounded,
        title: const Text('Curved App Bar'),
        backgroundGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF00ACC1)],
        ),
        drawerButton: Builder(
          builder: (context) => CircleIconButton(
            icon: Icons.menu_rounded,
            tooltip: 'Open menu',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        maxVisibleActionItems: 1,
        actionItems: [
          CurvedAppBarAction(
            label: 'Search',
            icon: Icons.search_rounded,
            onPressed: () => _showMessage(context, 'Search selected'),
          ),
          CurvedAppBarAction(
            label: 'Copy',
            icon: Icons.copy_rounded,
            onPressed: () => _showMessage(context, 'Copy selected'),
          ),
          CurvedAppBarAction(
            label: 'Notifications',
            icon: Icons.notifications_none_rounded,
            onPressed: () => _showMessage(context, 'Notifications selected'),
          ),
          CurvedAppBarAction(
            label: 'Settings',
            icon: Icons.settings_outlined,
            onPressed: () => _showMessage(context, 'Settings selected'),
          ),
          CurvedAppBarAction(
            label: 'Share',
            icon: Icons.share_outlined,
            onPressed: () => _showMessage(context, 'Share selected'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _HomeContent(),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final destinations = [
      _Destination(
        title: 'Gradient AppBar',
        subtitle: 'Dark gradient with automatic light status bar icons.',
        screen: const GradientScreen(),
      ),
      _Destination(
        title: 'Light AppBar',
        subtitle: 'Light background with automatic dark status bar icons.',
        screen: const LightScreen(),
      ),
      _Destination(
        title: 'Inverted Rounded Shape',
        subtitle: 'Body background rises into the app bar.',
        screen: const InvertedShapeScreen(),
      ),
      _Destination(
        title: 'Custom Back Button',
        subtitle: 'Route stack shows your custom back design.',
        screen: const CustomBackScreen(),
      ),
      _Destination(
        title: 'Gradient AppBar',
        subtitle: 'Dark gradient with automatic light status bar icons.',
        screen: const GradientScreen(),
      ),
      _Destination(
        title: 'Light AppBar',
        subtitle: 'Light background with automatic dark status bar icons.',
        screen: const LightScreen(),
      ),
      _Destination(
        title: 'Inverted Rounded Shape',
        subtitle: 'Body background rises into the app bar.',
        screen: const InvertedShapeScreen(),
      ),
      _Destination(
        title: 'Custom Back Button',
        subtitle: 'Route stack shows your custom back design.',
        screen: const CustomBackScreen(),
      ),
      _Destination(
        title: 'Gradient AppBar',
        subtitle: 'Dark gradient with automatic light status bar icons.',
        screen: const GradientScreen(),
      ),
      _Destination(
        title: 'Light AppBar',
        subtitle: 'Light background with automatic dark status bar icons.',
        screen: const LightScreen(),
      ),
      _Destination(
        title: 'Inverted Rounded Shape',
        subtitle: 'Body background rises into the app bar.',
        screen: const InvertedShapeScreen(),
      ),
      _Destination(
        title: 'Custom Back Button',
        subtitle: 'Route stack shows your custom back design.',
        screen: const CustomBackScreen(),
      ),
      _Destination(
        title: 'Gradient AppBar',
        subtitle: 'Dark gradient with automatic light status bar icons.',
        screen: const GradientScreen(),
      ),
      _Destination(
        title: 'Light AppBar',
        subtitle: 'Light background with automatic dark status bar icons.',
        screen: const LightScreen(),
      ),
      _Destination(
        title: 'Inverted Rounded Shape',
        subtitle: 'Body background rises into the app bar.',
        screen: const InvertedShapeScreen(),
      ),
      _Destination(
        title: 'Custom Back Button',
        subtitle: 'Route stack shows your custom back design.',
        screen: const CustomBackScreen(),
      ),
    ];

    return ListView.separated(
      // padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemCount: destinations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final destination = destinations[index];

        return ExampleTile(
          title: destination.title,
          subtitle: destination.subtitle,
          onTap: () {
            Navigator.of(
              context,
            ).push(buildExamplePageRoute(destination.screen));
          },
        );
      },
    );
  }
}

class _Destination {
  const _Destination({
    required this.title,
    required this.subtitle,
    required this.screen,
  });

  final String title;
  final String subtitle;
  final Widget screen;
}
