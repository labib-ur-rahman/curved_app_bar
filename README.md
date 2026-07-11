# Curved App Bar

[![pub package](https://img.shields.io/pub/v/curved_app_bar.svg)](https://pub.dev/packages/curved_app_bar)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-brightgreen.svg)](#supported-platforms)
[![Flutter](https://img.shields.io/badge/Flutter-package-02569B.svg)](https://flutter.dev)

A lightweight Flutter package for building professional curved app bars that
work directly with `Scaffold.appBar`.

`curved_app_bar` supports rounded and inverted-rounded shapes, gradient
backgrounds, automatic status bar contrast, custom back and drawer buttons,
typed overflow actions, and bottom widgets.

## Features

- Drop-in `Scaffold.appBar` support
- Solid color and `Gradient` backgrounds
- Automatic Android and iOS status bar contrast
- Rounded and inverted-rounded bottom shapes
- Custom leading, back, and drawer menu buttons
- Typed action items with automatic three-dot overflow menu
- Separate overflow menu color, icon color, and text style controls
- Optional built-in fade/slide entrance animation
- No state management dependency

## Supported Platforms

| Android | iOS | Web | macOS | Windows | Linux |
| --- | --- | --- | --- | --- | --- |
| Supported | Supported | Supported | Supported | Supported | Supported |

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  curved_app_bar: ^1.0.6
```

Import the package:

```dart
import 'package:curved_app_bar/curved_app_bar.dart';
```

## Quick Start

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

## Implementation Guide

### Solid Color App Bar

Use `backgroundColor` and `foregroundColor` when you want full control over the
toolbar surface and icons.

![Solid Color App Bar](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/1-Solid-Color-App-Bar.png)

```dart
CurvedAppBar(
  title: const Text('Orders'),
  subtitle: const Text('Today'),
  backgroundColor: const Color(0xFF4079FF),
  foregroundColor: Colors.white,
);
```

### Gradient App Bar

Use `backgroundGradient` for gradient surfaces. Status bar icon/text contrast is
resolved from the gradient brightness automatically.

![Gradient App Bar](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/2-Gradient-App-Bar.png)

```dart
CurvedAppBar(
  title: const Text('Dashboard'),
  backgroundGradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFfc00ff),
      Color(0xFF00dbde),
    ],
  ),
);
```

### Inverted Rounded Shape

Use `CurvedAppBarShape.invertedRounded` when the body background should rise
into the app bar with top-left and top-right rounded corners.

![Inverted Rounded Shape](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/3-Inverted-Rounded-Shape.png)

```dart
Scaffold(
  appBar: const CurvedAppBar(
    title: Text('Profile'),
    subtitle: Text('Welcome back'),
    shape: CurvedAppBarShape.invertedRounded,
    curveRadius: 42,
  ),
  body: const SizedBox.expand(),
);
```

### AppBar Overlay On Body

Use `Scaffold.extendBodyBehindAppBar` when the body should render behind the
curved app bar area. Wrap the body with `CurvedBody` when you want layout-aware
spacing that works cleanly with scroll views and complex body widgets.

![AppBar Overlay On Body](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/4-AppBar-Overlay-On-Body.gif)

```dart
Scaffold(
  extendBodyBehindAppBar: true,
  appBar: const CurvedAppBar(
    title: Text('Home'),
    shape: CurvedAppBarShape.invertedRounded,
  ),
  body: CurvedBody(
    overlap: 32,
    child: ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) => Text(items[index]),
    ),
  ),
);
```

For compact code, use the `withCurvedBody` extension on any widget:

```dart
Scaffold(
  extendBodyBehindAppBar: true,
  appBar: const CurvedAppBar(
    title: Text('Home'),
    shape: CurvedAppBarShape.invertedRounded,
  ),
  body: Center(child: Text('Hello')).withCurvedBody(),
);
```

`CurvedBody` uses real layout padding instead of visual translation. This keeps
hit testing and scroll behavior predictable, and it removes inherited top
`MediaQuery` padding from the child by default so `ListView`, `GridView`, and
other scroll views do not add an extra safe-area gap.

### Custom Back and Drawer Buttons

`automaticallyImplyLeading` follows familiar app bar behavior:

- `leading` wins when provided.
- If the current route can pop, a back button is shown.
- If the route cannot pop but the nearest `Scaffold` has a drawer, a drawer
  button is shown.
- If neither condition is true, no leading widget is shown.

![Custom Back and Drawer Buttons](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/5-Custom-Back-and-Drawer-Buttons.gif)

```dart
Scaffold(
  drawer: const Drawer(child: Text('Menu')),
  appBar: CurvedAppBar(
    title: const Text('Home'),
    drawerButton: Builder(
      builder: (context) {
        return IconButton.filledTonal(
          tooltip: 'Open menu',
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      },
    ),
  ),
);
```

For pushed screens:

```dart
CurvedAppBar(
  title: const Text('Details'),
  backButton: IconButton.filledTonal(
    tooltip: 'Back',
    icon: const Icon(Icons.arrow_back_rounded),
    onPressed: () => Navigator.of(context).maybePop(),
  ),
);
```

### Actions and Overflow Menu

Use `actionItems` for professional action overflow. The first
`maxVisibleActionItems` are shown as toolbar icons. Remaining actions are moved
into a Material three-dot menu.

![Actions and Overflow Menu](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/6-Actions-and-Overflow-Menu.gif)

```dart
CurvedAppBar(
  title: const Text("Photo Vault"),
  subtitle: const Text("Overflow Styling Showcase"),
  maxVisibleActionItems: 2,
  actionItems: [
    CurvedAppBarAction(
      label: 'Search',
      icon: Icons.search_rounded,
      onPressed: () {},
    ),
    CurvedAppBarAction(
      label: 'Copy',
      icon: Icons.copy_rounded,
      onPressed: () {},
    ),
    CurvedAppBarAction(
      label: 'Settings',
      icon: Icons.settings_outlined,
      onPressed: () {},
    ),
  ],
);
```

Use `actions` only when you need fully custom widgets:

```dart
CurvedAppBar(
  title: const Text('Reports'),
  actionsMaxWidthFactor: 0.55,
  actions: const [
    Icon(Icons.search),
    Icon(Icons.filter_list),
  ],
);
```

### Overflow Menu Styling

Toolbar icon colors and popup menu item colors are resolved separately. This
keeps menu items readable when the app bar uses white icons and the popup menu
uses a light background.

![Overflow Menu Styling](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/7-Overflow-Menu-Styling.gif)

```dart
CurvedAppBar(
  foregroundColor: Colors.white,
  overflowMenuColor: Colors.white,
  overflowMenuIconColor: Colors.black87,
  overflowMenuTextStyle: const TextStyle(color: Colors.black87),
  actionItems: [
    CurvedAppBarAction(
      label: 'Settings',
      icon: Icons.settings_outlined,
      onPressed: () {},
    ),
  ],
);
```

Per-item menu styling is also supported:

```dart
CurvedAppBarAction(
  label: 'Delete',
  icon: Icons.delete_outline,
  menuIconColor: Colors.red,
  menuTextStyle: const TextStyle(color: Colors.red),
  onPressed: () {},
);
```

### Bottom Content

Use a `PreferredSize` when adding tabs, filters, or other bottom content.

![Bottom Content](https://raw.githubusercontent.com/labib-ur-rahman/curved_app_bar/main/assets/preview/8-Bottom-Content.png)

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

### Visibility and Animation

`visible: false` collapses the preferred app bar height to zero. Set
`animate: false` when the built-in fade/slide entrance animation is not needed.

```dart
CurvedAppBar(
  visible: showAppBar,
  animate: false,
  title: const Text('Static'),
);
```

## Property Reference

| Property | Type | Default | Use |
| --- | --- | --- | --- |
| `leading` | `Widget?` | `null` | Fully custom leading widget. Overrides implied back/drawer behavior. |
| `backButton` | `Widget?` | `BackButton()` | Custom button shown when the current route can pop. |
| `drawerButton` | `Widget?` | Menu `IconButton` | Custom button shown when the nearest `Scaffold` has a drawer. |
| `automaticallyImplyLeading` | `bool` | `true` | Enables automatic back or drawer leading behavior. |
| `title` | `Widget?` | `null` | Main toolbar title. |
| `subtitle` | `Widget?` | `null` | Optional text/widget under the title. |
| `actions` | `List<Widget>?` | `null` | Fully custom trailing widgets. |
| `actionItems` | `List<CurvedAppBarAction>?` | `null` | Typed actions that can automatically overflow into a popup menu. |
| `maxVisibleActionItems` | `int` | `2` | Number of typed actions shown directly before overflow. |
| `overflowMenuIcon` | `Widget?` | Three-dot icon | Custom overflow menu button icon. |
| `overflowMenuTooltip` | `String?` | Material tooltip | Tooltip for the overflow menu button. |
| `overflowMenuColor` | `Color?` | Popup menu theme | Background color of the overflow menu. |
| `overflowMenuIconColor` | `Color?` | Popup menu theme or `onSurface` | Default icon color for overflow menu items. |
| `overflowMenuTextStyle` | `TextStyle?` | Popup menu theme | Default text style for overflow menu items. |
| `bottom` | `PreferredSizeWidget?` | `null` | Bottom area for tabs, filters, or custom content. |
| `centerTitle` | `bool` | `false` | Centers the title area inside the available toolbar space. |
| `height` | `double?` | Shape-aware | Custom app bar height excluding status bar and bottom widget. |
| `leadingWidth` | `double` | `kToolbarHeight` | Width reserved for the leading widget. |
| `actionsMaxWidthFactor` | `double` | `0.45` | Maximum toolbar width fraction reserved for custom `actions`. |
| `curveRadius` | `double` | `32` | Radius used by the curved clipper. |
| `shape` | `CurvedAppBarShape` | `rounded` | Chooses rounded or inverted-rounded bottom shape. |
| `backgroundColor` | `Color?` | Theme primary | Solid background color and fallback surface color. |
| `backgroundGradient` | `Gradient?` | `null` | Gradient painted behind toolbar and bottom content. |
| `foregroundColor` | `Color?` | Theme onPrimary | Default toolbar icon and text color. |
| `statusBarColor` | `Color?` | Resolved background | Optional status bar background override. |
| `systemOverlayStyle` | `SystemUiOverlayStyle?` | Auto-resolved | Full manual system overlay style override. |
| `contentPadding` | `EdgeInsetsGeometry` | Horizontal `16` | Padding around toolbar row content. |
| `titleTextStyle` | `TextStyle?` | Theme titleLarge | Style applied to `title`. |
| `subtitleTextStyle` | `TextStyle?` | Theme bodySmall | Style applied to `subtitle`. |
| `visible` | `bool` | `true` | Collapses and hides the app bar when false. |
| `animate` | `bool` | `true` | Enables the built-in fade/slide entrance animation. |
| `animationDuration` | `Duration` | `220ms` | Built-in animation duration. |
| `animationCurve` | `Curve` | `easeOutCubic` | Built-in animation curve. |
| `clipBehavior` | `Clip` | `antiAlias` | Clip behavior used by the curved shape. |

## CurvedBody Reference

| Property | Type | Default | Use |
| --- | --- | --- | --- |
| `overlap` | `double` | `32` | Amount subtracted from the status bar top spacing so the body can rise into the curved area. |
| `includeStatusBar` | `bool` | `true` | Uses `MediaQuery.paddingOf(context).top` when calculating top spacing. |
| `removeTopMediaQueryPadding` | `bool` | `true` | Removes inherited top `MediaQuery` padding from the child to avoid double spacing in scroll views. |
| `child` | `Widget` | required | Body content. |

## CurvedAppBarAction Reference

| Property | Type | Default | Use |
| --- | --- | --- | --- |
| `label` | `String` | required | Text shown in the overflow menu. |
| `icon` | `IconData` | required | Icon shown in toolbar and overflow menu. |
| `onPressed` | `VoidCallback?` | required | Callback when selected. |
| `tooltip` | `String?` | `label` | Toolbar icon tooltip. |
| `menuIconColor` | `Color?` | Resolved menu color | Per-item overflow menu icon color. |
| `menuTextStyle` | `TextStyle?` | Resolved menu style | Per-item overflow menu text style. |
| `enabled` | `bool` | `true` | Enables or disables the action. |

## Run The Local Example

This repository includes a multi-file example app for visual testing and
integration reference.

```bash
cd example
flutter pub get
flutter run
```

For a specific device:

```bash
flutter devices
flutter run -d chrome
flutter run -d ios
flutter run -d android
```

## Public API

- `CurvedAppBar`
- `CurvedAppBarAction`
- `CurvedAppBarClipper`
- `CurvedBody`
- `CurvedBodyX.withCurvedBody`
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
dart format lib test example/lib example/test
flutter analyze
flutter test
cd example && flutter analyze && flutter test
dart pub publish --dry-run
```

## License

This package is released under the [MIT License](LICENSE).
