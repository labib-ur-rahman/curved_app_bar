# Curved App Bar

A lightweight Flutter package for building customizable curved app bars with a
`CustomClipper<Path>`.

## Features

- Works directly with `Scaffold.appBar`
- Uses Flutter's built-in theme colors by default
- Supports rounded and inverted/opposite rounded bottom shapes
- Resolves status bar color and icon brightness automatically
- Supports leading, title, subtitle, actions, and bottom widgets
- Includes a simple `visible` flag for dynamic show/hide behavior
- No state management dependency

## Installation

```yaml
dependencies:
  curved_app_bar: ^1.0.0
```

## Simple Usage

```dart
import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurvedAppBar(
        title: Text('Home'),
      ),
      body: Center(child: Text('Hello')),
    );
  }
}
```

## Inverted Rounded Shape

Use `CurvedAppBarShape.invertedRounded` when the body background should appear
to rise into the app bar with top-left and top-right rounded corners.

```dart
Scaffold(
  backgroundColor: Colors.white,
  appBar: const CurvedAppBar(
    title: Text('Profile'),
    subtitle: Text('Welcome back'),
    height: 96,
    curveRadius: 48,
    shape: CurvedAppBarShape.invertedRounded,
  ),
  body: const SizedBox.expand(),
);
```

## Custom Colors and Actions

```dart
CurvedAppBar(
  backgroundColor: const Color(0xFF23479A),
  foregroundColor: Colors.white,
  statusBarColor: const Color(0xFF23479A),
  leading: IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () {},
  ),
  title: const Text('Orders'),
  subtitle: const Text('Today'),
  actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    ),
  ],
);
```

## Dynamic Visibility

`visible: false` collapses the preferred app bar height to zero, so it can be
controlled by your own state management, `setState`, `ValueListenableBuilder`,
`BlocBuilder`, Riverpod, GetX, or any other approach.

```dart
CurvedAppBar(
  visible: showAppBar,
  animationDuration: const Duration(milliseconds: 250),
  title: const Text('Dynamic'),
);
```

## Bottom Widget

Use a `PreferredSize` when adding tabs, filters, or any custom bottom content.

```dart
CurvedAppBar(
  title: const Text('Explore'),
  bottom: const PreferredSize(
    preferredSize: Size.fromHeight(44),
    child: TabBar(
      tabs: [
        Tab(text: 'Latest'),
        Tab(text: 'Popular'),
      ],
    ),
  ),
);
```
