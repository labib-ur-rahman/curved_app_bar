# Curved App Bar

[![pub package](https://img.shields.io/pub/v/curved_app_bar.svg)](https://pub.dev/packages/curved_app_bar)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-brightgreen.svg)](#supported-platforms)
[![Flutter](https://img.shields.io/badge/Flutter-package-02569B.svg)](https://flutter.dev)

A lightweight Flutter package for building customizable curved app bars that
work directly with `Scaffold.appBar`.

`curved_app_bar` is designed for clean Flutter UI work: rounded or inverted
curved app bars, theme-aware colors, gradient backgrounds, automatic status bar
contrast, and familiar AppBar slots like leading, title, actions, and bottom
content.

## Features

- Works directly with `Scaffold.appBar`
- Supports solid colors and `Gradient` backgrounds
- Automatically resolves status bar icon/text contrast for light and dark
  backgrounds
- Supports rounded and inverted rounded bottom shapes
- Supports leading, title, subtitle, actions, and bottom widgets
- Includes a simple `visible` flag for dynamic show/hide behavior
- No state management dependency
- Clean package structure with documented public API

## Supported Platforms

This is a Flutter UI package and supports all standard Flutter app platforms:

| Android | iOS | Web | macOS | Windows | Linux |
| --- | --- | --- | --- | --- | --- |
| Supported | Supported | Supported | Supported | Supported | Supported |

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  curved_app_bar: ^1.0.1
```

Then import it:

```dart
import 'package:curved_app_bar/curved_app_bar.dart';
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

## Gradient Background

Use `backgroundGradient` when you want the curved app bar to render a gradient.
The status bar icon/text color is resolved automatically from the gradient
brightness.

```dart
CurvedAppBar(
  title: const Text('Dashboard'),
  backgroundGradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1565C0),
      Color(0xFF00ACC1),
    ],
  ),
);
```

## Status Bar Contrast

The package resolves status bar styling for Android and iOS:

- Light app bar background -> dark status bar icons/text
- Dark app bar background -> light status bar icons/text
- Gradient background -> samples the gradient brightness automatically
- `statusBarColor` and `systemOverlayStyle` remain available when you need full
  manual control

```dart
CurvedAppBar(
  title: const Text('Profile'),
  backgroundColor: const Color(0xFFF7FAFF),
);
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

## Bottom Widget

Use a `PreferredSize` when adding tabs, filters, or custom bottom content.

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

## Public API

- `CurvedAppBar`
- `CurvedAppBarClipper`
- `CurvedAppBarShape.rounded`
- `CurvedAppBarShape.invertedRounded`

## Developer

Developed and maintained by **Md Labibur Rahman**, Flutter Developer from
Bangladesh.

- GitHub: [labib-ur-rahman](https://github.com/labib-ur-rahman)
- Package repository:
  [curved_app_bar](https://github.com/labib-ur-rahman/curved_app_bar)

## Contributing

This package is part of my open-source learning journey. Contributions,
suggestions, bug reports, and documentation improvements are welcome.

Before opening a pull request, please run:

```bash
dart format lib test
flutter analyze
flutter test
dart pub publish --dry-run
```

## License

This package is released under the [MIT License](LICENSE).
