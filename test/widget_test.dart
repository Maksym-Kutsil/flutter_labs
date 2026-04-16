// Basic Flutter widget smoke test for Smart Pet Bowl.

import 'package:flutter_test/flutter_test.dart';

import 'package:my_project/main.dart';

void main() {
  testWidgets('Smart Pet Bowl home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Smart Pet Bowl'), findsOneWidget);
    expect(find.text('Bowl overview'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
