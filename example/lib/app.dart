import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

/// Root widget for the local example application.
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
