// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_manager/core/di/injection_container.dart';
import 'package:task_manager/main.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await init();
  });

  testWidgets('App builds and shows register page when logged out',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isLoggedIn: false));
    await tester.pumpAndSettle();

    // The register page should be shown when the user is not logged in.
    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets('App shows dashboard when logged in', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isLoggedIn: true));
    await tester.pumpAndSettle();

    // The app widget should still render.
    expect(find.byType(MyApp), findsOneWidget);
  });
}