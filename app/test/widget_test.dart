import 'package:flutter_test/flutter_test.dart';

import 'package:number_drop_clone/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NumberDropApp());

    // Verify that the game screen shows CURRENT block label
    expect(find.text('CURRENT'), findsOneWidget);
  });
}
