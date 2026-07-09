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
    expect(annotatedRegion.value.statusBarBrightness, Brightness.light);
  });

  testWidgets('paints optional background gradient', (tester) async {
    const gradient = LinearGradient(
      colors: [Color(0xFF1565C0), Color(0xFF00ACC1)],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: Text('Gradient'),
            backgroundGradient: gradient,
          ),
        ),
      ),
    );

    final decoratedBoxes = tester.widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(CurvedAppBar),
        matching: find.byType(DecoratedBox),
      ),
    );
    final gradientDecoration = decoratedBoxes
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((decoration) => decoration.gradient == gradient);

    expect(gradientDecoration.gradient, gradient);
  });

  testWidgets('uses dark status bar content on light app bar backgrounds', (
    tester,
  ) async {
    const background = Color(0xFFF7FAFF);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: Text('Light'),
            backgroundColor: background,
          ),
        ),
      ),
    );

    final annotatedRegion = tester
        .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
        );

    expect(annotatedRegion.value.statusBarColor, background);
    expect(annotatedRegion.value.statusBarIconBrightness, Brightness.dark);
    expect(annotatedRegion.value.statusBarBrightness, Brightness.light);
  });

  testWidgets('uses light status bar content on dark app bar backgrounds', (
    tester,
  ) async {
    const background = Color(0xFF081A2F);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: Text('Dark'),
            backgroundColor: background,
          ),
        ),
      ),
    );

    final annotatedRegion = tester
        .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
        );

    expect(annotatedRegion.value.statusBarColor, background);
    expect(annotatedRegion.value.statusBarIconBrightness, Brightness.light);
    expect(annotatedRegion.value.statusBarBrightness, Brightness.dark);
  });

  testWidgets('uses gradient brightness for status bar content', (
    tester,
  ) async {
    const gradient = LinearGradient(
      colors: [Color(0xFF07111F), Color(0xFF16395F)],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: Text('Dark gradient'),
            backgroundGradient: gradient,
          ),
        ),
      ),
    );

    final annotatedRegion = tester
        .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
        );

    expect(annotatedRegion.value.statusBarColor, Colors.transparent);
    expect(annotatedRegion.value.statusBarIconBrightness, Brightness.light);
    expect(annotatedRegion.value.statusBarBrightness, Brightness.dark);
  });

  testWidgets('uses dark status bar content on light gradients', (
    tester,
  ) async {
    const gradient = LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFE3F2FD)],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: Text('Light gradient'),
            backgroundGradient: gradient,
          ),
        ),
      ),
    );

    final annotatedRegion = tester
        .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
        );

    expect(annotatedRegion.value.statusBarColor, Colors.transparent);
    expect(annotatedRegion.value.statusBarIconBrightness, Brightness.dark);
    expect(annotatedRegion.value.statusBarBrightness, Brightness.light);
  });

  testWidgets('collapses and hides content when visible is false', (
    tester,
  ) async {
    const appBar = CurvedAppBar(visible: false, title: Text('Hidden title'));

    expect(appBar.preferredSize, Size.zero);

    await tester.pumpWidget(const MaterialApp(home: Scaffold(appBar: appBar)));

    expect(find.text('Hidden title'), findsNothing);
  });

  testWidgets('can render without built-in animation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(animate: false, title: Text('No animation')),
        ),
      ),
    );

    expect(find.text('No animation'), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
  });

  test('uses shape-aware default heights', () {
    const roundedAppBar = CurvedAppBar();
    const invertedAppBar = CurvedAppBar(
      shape: CurvedAppBarShape.invertedRounded,
    );
    const customHeightAppBar = CurvedAppBar(
      shape: CurvedAppBarShape.invertedRounded,
      height: 84,
    );

    expect(roundedAppBar.preferredSize.height, kToolbarHeight);
    expect(
      invertedAppBar.preferredSize.height,
      CurvedAppBar.defaultExpandedHeight,
    );
    expect(customHeightAppBar.preferredSize.height, 84);
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

  testWidgets('keeps title visible when actions are crowded', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            leading: Icon(Icons.menu),
            title: Text('Crowded Title'),
            subtitle: Text('Still visible'),
            actions: [
              Icon(Icons.settings),
              Icon(Icons.settings),
              Icon(Icons.settings),
              Icon(Icons.settings),
              Icon(Icons.settings),
              Icon(Icons.settings),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Crowded Title'), findsOneWidget);
    expect(find.text('Still visible'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('moves extra typed actions into overflow menu', (tester) async {
    var selected = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: const Text('Actions'),
            maxVisibleActionItems: 1,
            actionItems: [
              CurvedAppBarAction(
                label: 'Search',
                icon: Icons.search,
                onPressed: () => selected = 'Search',
              ),
              CurvedAppBarAction(
                label: 'Settings',
                icon: Icons.settings,
                onPressed: () => selected = 'Settings',
              ),
              CurvedAppBarAction(
                label: 'Share',
                icon: Icons.share,
                onPressed: () => selected = 'Share',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);
    expect(find.text('Settings'), findsNothing);

    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(selected, 'Settings');
  });

  testWidgets('overflow menu item colors stay visible on menu surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: Scaffold(
          appBar: CurvedAppBar(
            title: const Text('Actions'),
            foregroundColor: Colors.white,
            overflowMenuColor: Colors.white,
            maxVisibleActionItems: 0,
            actionItems: [
              CurvedAppBarAction(
                label: 'Settings',
                icon: Icons.settings,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();

    final settingsIcon = tester.widget<Icon>(
      find.descendant(
        of: find.byType(PopupMenuItem<CurvedAppBarAction>),
        matching: find.byIcon(Icons.settings),
      ),
    );
    final settingsText = tester.widget<Text>(find.text('Settings'));

    expect(settingsIcon.color, isNot(Colors.white));
    expect(settingsText.style?.color, isNot(Colors.white));
  });

  testWidgets('shows custom back button when route can pop', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CurvedAppBar(
            title: const Text('Root'),
            actions: [
              Builder(
                builder: (context) {
                  return TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const Scaffold(
                            appBar: CurvedAppBar(
                              title: Text('Details'),
                              backButton: Icon(Icons.arrow_back_ios_new),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Open'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Details'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
  });

  testWidgets('does not show implied back button on root route', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: CurvedAppBar(title: Text('Root'))),
      ),
    );

    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('shows drawer button when root scaffold has drawer', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          drawer: Drawer(child: Text('Menu content')),
          appBar: CurvedAppBar(
            title: Text('Root'),
            drawerButton: Icon(Icons.dashboard_customize),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.dashboard_customize), findsOneWidget);
    expect(find.text('Menu content'), findsNothing);
  });

  testWidgets('curved body uses real layout spacing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: 48)),
          child: CurvedBody(overlap: 16, child: Text('Body content')),
        ),
      ),
    );

    final paddings = tester.widgetList<Padding>(
      find.ancestor(
        of: find.text('Body content'),
        matching: find.byType(Padding),
      ),
    );

    expect(
      paddings.map((padding) => padding.padding),
      contains(const EdgeInsets.only(top: 32)),
    );
  });

  testWidgets('curved body can exclude status bar spacing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: const Text(
            'Body content',
          ).withCurvedBody(overlap: 16, includeStatusBar: false),
        ),
      ),
    );

    final paddings = tester.widgetList<Padding>(
      find.ancestor(
        of: find.text('Body content'),
        matching: find.byType(Padding),
      ),
    );

    expect(
      paddings.map((padding) => padding.padding),
      contains(EdgeInsets.zero),
    );
  });

  testWidgets('curved body removes child top media query padding by default', (
    tester,
  ) async {
    EdgeInsets? childPadding;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: CurvedBody(
            overlap: 16,
            child: Builder(
              builder: (context) {
                childPadding = MediaQuery.paddingOf(context);
                return const Text('Body content');
              },
            ),
          ),
        ),
      ),
    );

    expect(childPadding?.top, 0);
  });

  testWidgets('curved body can preserve child top media query padding', (
    tester,
  ) async {
    EdgeInsets? childPadding;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: CurvedBody(
            overlap: 16,
            removeTopMediaQueryPadding: false,
            child: Builder(
              builder: (context) {
                childPadding = MediaQuery.paddingOf(context);
                return const Text('Body content');
              },
            ),
          ),
        ),
      ),
    );

    expect(childPadding?.top, 24);
  });

  testWidgets('curved body clamps negative top spacing to zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(),
          child: CurvedBody(overlap: 80, child: Text('Body content')),
        ),
      ),
    );

    final paddings = tester
        .widgetList<Padding>(
          find.ancestor(
            of: find.text('Body content'),
            matching: find.byType(Padding),
          ),
        )
        .map((padding) => padding.padding);

    expect(paddings, contains(EdgeInsets.zero));
  });

  testWidgets('default drawer button opens scaffold drawer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          drawer: Drawer(child: Text('Menu content')),
          appBar: CurvedAppBar(title: Text('Root')),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Menu content'), findsOneWidget);
  });
}
