import 'package:curved_app_bar_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Curved App Bar Example smoke test', (tester) async {
    await tester.pumpWidget(const CurvedAppBarExampleApp());

    expect(find.text('Curved App Bar'), findsOneWidget);
    expect(find.text('Gradient AppBar'), findsAtLeastNWidgets(1));
    expect(find.text('Light AppBar'), findsAtLeastNWidgets(1));
  });
}
