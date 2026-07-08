import 'package:flutter/material.dart';

/// Drawer used to demonstrate automatic drawer-button support.
class ExampleDrawer extends StatelessWidget {
  const ExampleDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('Curved App Bar Menu'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
