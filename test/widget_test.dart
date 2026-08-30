import 'package:flutter/material.dart';
import 'package:task/app_root.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task/injection_container.dart' as di;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AppRoot builds MaterialApp', (WidgetTester tester) async {
    await di.init();
    await tester.pumpWidget(const AppRoot());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
