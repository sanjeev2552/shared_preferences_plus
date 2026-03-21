import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';
import 'package:shared_preferences_plus_example/main.dart';

void main() {
  testWidgets('example app renders and updates main value', (WidgetTester tester) async {
    SharedPreferencesPlus.setMockInitialValues(
      <String, Object?>{},
      options: const SharedPreferencesPlusOptions(name: 'main'),
    );
    SharedPreferencesPlus.setMockInitialValues(
      <String, Object?>{},
      options: const SharedPreferencesPlusOptions(name: 'other'),
    );
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Main container:'), findsOneWidget);
    expect(find.textContaining('Other container:'), findsOneWidget);

    final setMainButton = find.widgetWithText(ElevatedButton, 'Set Main String');
    expect(setMainButton, findsOneWidget);

    await tester.tap(setMainButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('key_main: value_main'), findsOneWidget);
  });
}
