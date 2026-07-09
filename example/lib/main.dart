import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';

import 'navigation/example_page_route.dart';
import 'screens/custom_back_screen.dart';
import 'screens/gradient_screen.dart';
import 'screens/inverted_shape_screen.dart';
import 'screens/light_screen.dart';
import 'widgets/circle_icon_button.dart';
import 'widgets/example_drawer.dart';
import 'widgets/example_tile.dart';

void main() {
  runApp(const CurvedAppBarExampleApp());
}

/// Root widget for the package example shown on pub.dev.
///
/// The home screen lives in this file so pub.dev displays a useful
/// implementation example. Secondary screens, reusable widgets, and the custom
/// route transition stay separated under `screens/`, `widgets/`, and
/// `navigation/`.
class CurvedAppBarExampleApp extends StatelessWidget {
  const CurvedAppBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curved App Bar Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const ExampleHomeScreen(),
    );
  }
}

/// Main example screen that demonstrates the app bar's primary features.
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
            label: 'Notifications',
            icon: Icons.notifications_none_rounded,
            onPressed: () => _showMessage(context, 'Notifications selected'),
          ),
          CurvedAppBarAction(
            label: 'Settings',
            icon: Icons.settings_outlined,
            onPressed: () => _showMessage(context, 'Settings selected'),
          ),
        ],
      ),
      body: _HomeContent().withCurvedBody(),
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
    ];

    return ListView.separated(
      itemCount: destinations.length,
      padding: EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final destination = destinations[index];

        if (index == destinations.length - 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 700),
            child: ExampleTile(
              title: destination.title,
              subtitle: destination.subtitle,
              onTap: () {
                Navigator.of(
                  context,
                ).push(buildExamplePageRoute(destination.screen));
              },
            ),
          );
        }

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
