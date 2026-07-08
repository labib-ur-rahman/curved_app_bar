## 1.0.2

- Added customizable implied `backButton` and `drawerButton` support.
- Added typed `CurvedAppBarAction` support with automatic Material overflow
  menus.
- Added overflow menu color, icon color, and text style controls so menu items
  stay readable independently from the app bar foreground color.
- Added shape-aware default heights: rounded app bars default to
  `kToolbarHeight`, while non-rounded shapes default to
  `kToolbarHeight + 40`.
- Added `animate` to enable or disable the built-in app bar entrance animation.
- Added action overflow protection with `actionsMaxWidthFactor` for custom
  action widgets.
- Kept taller app bar toolbar content aligned to the top while extra height
  grows below the toolbar row.
- Organized the example app into focused files and added a custom page
  transition for screen navigation.
- Added an `example/` app for local visual testing.
- Split the package internals into a cleaner `src` structure with separate
  widgets, clipper, enum, model, and utility files.
- Added focused tests for gradient rendering, status bar brightness, action
  overflow, drawer behavior, and animation control.
- Updated package documentation and licensing for pub.dev publishing.

## 1.0.1

- Documentation and package metadata maintenance.
- Added `backgroundGradient` support for curved app bar backgrounds.
- Added automatic status bar icon/text contrast for solid colors and gradients.
- Made gradient status bars transparent by default so the gradient can continue
behind the system status bar area.

## 1.0.0

- Initial release.
- Added `CurvedAppBar` for direct `Scaffold.appBar` usage.
- Added `CurvedAppBarClipper` with rounded and inverted rounded shapes.
- Added customizable theme-aware colors, status bar styling, visibility,
  leading, title, subtitle, actions, and bottom content.
