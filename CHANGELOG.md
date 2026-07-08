## 1.0.1

- Added `backgroundGradient` support for curved app bar backgrounds.
- Added automatic status bar icon/text contrast for solid colors and gradients.
- Made gradient status bars transparent by default so the gradient can continue
  behind the system status bar area.
- Split the package internals into a cleaner `src` structure with separate
  widgets, clipper, enum, and utility files.
- Added more focused tests for gradient rendering and status bar brightness.
- Updated package documentation and licensing for pub.dev publishing.

## 1.0.0

- Initial release.
- Added `CurvedAppBar` for direct `Scaffold.appBar` usage.
- Added `CurvedAppBarClipper` with rounded and inverted rounded shapes.
- Added customizable theme-aware colors, status bar styling, visibility,
  leading, title, subtitle, actions, and bottom content.
