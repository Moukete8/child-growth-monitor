import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:child_growth_monitor/design_system/templates/role_scaffold.dart';
import 'package:child_growth_monitor/design_system/tokens/app_colors.dart';

void main() {
  testWidgets('renders header and body, and pins the nav bar to the bottom', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RoleScaffold(
        role: Role.parent,
        currentNavIndex: 0,
        header: const Text('HEADER CONTENT'),
        body: const Text('BODY CONTENT'),
      ),
    ));

    expect(find.text('HEADER CONTENT'), findsOneWidget);
    expect(find.text('BODY CONTENT'), findsOneWidget);

    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    final navTop = tester.getTopLeft(find.text('Home')).dy;
    final headerTop = tester.getTopLeft(find.text('HEADER CONTENT')).dy;

    expect(navTop, greaterThan(headerTop), reason: 'nav must sit below the header, not above it');
    expect(navTop, greaterThan(screenHeight / 2), reason: 'nav must be pinned near the bottom of the screen');
  });

  testWidgets('hides the nav bar when currentNavIndex is null', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RoleScaffold(
        role: Role.parent,
        currentNavIndex: null,
        header: const Text('HEADER CONTENT'),
        body: const Text('BODY CONTENT'),
      ),
    ));

    expect(find.text('Home'), findsNothing);
  });
}
