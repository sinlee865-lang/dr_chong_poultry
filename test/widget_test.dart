import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_app1/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PoultryMedApp());

    // Verify the app renders without crashing
    expect(find.byType(PoultryMedApp), findsOneWidget);
  });
}