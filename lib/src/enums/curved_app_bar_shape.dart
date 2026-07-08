/// Defines the bottom edge shape rendered by a curved app bar.
enum CurvedAppBarShape {
  /// Rounds the app bar's own bottom-left and bottom-right corners.
  rounded,

  /// Cuts a top-rounded surface out of the app bar's bottom edge.
  ///
  /// This is useful when the body background should appear to rise into the
  /// app bar with top-left and top-right rounded corners.
  invertedRounded,
}
