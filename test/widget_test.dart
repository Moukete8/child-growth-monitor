import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:child_growth_monitor/main.dart';

void main() {
  setUpAll(() async {
    // SplashScreen reads Supabase.instance to check for an existing
    // session — initialize against a dummy project so that lookup doesn't
    // throw in tests. No network call is made for an anonymous session.
    // supabase_flutter persists the session via shared_preferences, which
    // needs its plugin channel mocked outside a real app context.
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(url: 'https://example.supabase.co', publishableKey: 'test-anon-key');
  });

  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ChildGrowthApp());
    await tester.pump();

    expect(find.text('Child Growth\nMonitoring'), findsOneWidget);

    // Let SplashScreen's minimum-display timer finish so it doesn't leak
    // into the test as a pending timer once it navigates to /login.
    await tester.pump(const Duration(milliseconds: 1500));
  });
}
