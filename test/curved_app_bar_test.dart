import 'package:curved_app_bar/curved_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders directly in Scaffold.appBar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(title: Text('Dashboard')),
          body: Text('Body'),
        ),
      ),
    );

    expect(find.byType(CurvedAppBar), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });

  testWidgets('uses theme fallback colors', (tester) async {
    const primary = Color(0xFF2853A4);
    const onPrimary = Color(0xFFF6F8FF);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            primary: primary,
            onPrimary: onPrimary,
          ),
        ),
        home: const Scaffold(appBar: CurvedAppBar(title: Text('Themed'))),
      ),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CurvedAppBar),
        matching: find.byType(Material),
      ),
    );

    final titleStyle = tester
        .widget<DefaultTextStyle>(
          find
              .ancestor(
                of: find.text('Themed'),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;

    expect(material.color, primary);
    expect(titleStyle.color, onPrimary);
  });

  testWidgets('accepts custom colors and status bar style', (tester) async {
    const background = Color(0xFFE8F1FF);
    const foreground = Color(0xFF132238);
    const statusBar = Color(0xFFBFD8FF);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: Text('Custom'),
            backgroundColor: background,
            foregroundColor: foreground,
            statusBarColor: statusBar,
          ),
        ),
      ),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CurvedAppBar),
        matching: find.byType(Material),
      ),
    );
    final annotatedRegion = tester
        .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
        );

    expect(material.color, background);
    expect(annotatedRegion.value.statusBarColor, statusBar);
    expect(annotatedRegion.value.statusBarIconBrightness, Brightness.dark);
  });

  testWidgets('collapses and hides content when visible is false', (
    tester,
  ) async {
    const appBar = CurvedAppBar(visible: false, title: Text('Hidden title'));

    expect(appBar.preferredSize, Size.zero);

    await tester.pumpWidget(const MaterialApp(home: Scaffold(appBar: appBar)));

    expect(find.text('Hidden title'), findsNothing);
  });

  test('rounded and inverted clippers produce non-empty paths', () {
    const size = Size(360, 120);

    final roundedPath = const CurvedAppBarClipper(
      shape: CurvedAppBarShape.rounded,
      radius: 32,
    ).getClip(size);
    final invertedPath = const CurvedAppBarClipper(
      shape: CurvedAppBarShape.invertedRounded,
      radius: 48,
    ).getClip(size);

    expect(roundedPath.getBounds().isEmpty, isFalse);
    expect(invertedPath.getBounds().isEmpty, isFalse);
  });

  testWidgets('renders title, subtitle, leading, actions, and bottom', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            leading: Icon(Icons.menu),
            title: Text('Orders'),
            subtitle: Text('Today'),
            actions: [Icon(Icons.search), Icon(Icons.more_vert)],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(36),
              child: Text('Bottom content'),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.more_vert), findsOneWidget);
    expect(find.text('Bottom content'), findsOneWidget);
  });
}
