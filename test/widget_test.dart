import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/main.dart';

void main() {

  testWidgets('number buttons / subtraction test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    
    await tester.tap(find.byKey(Key('3')));
    await tester.tap(find.byKey(Key('8')));

    await tester.tap(find.byKey(Key('-')));

    await tester.tap(find.byKey(Key('5')));
    await tester.tap(find.byKey(Key('0')));

    await tester.tap(find.byKey(Key('=')));
    await tester.pump();

    expect(find.text('38 - 50'), findsOneWidget, reason: 'displayText = 38 - 50');
    expect(find.text('-12'), findsOneWidget, reason: 'result value');
  });

  testWidgets('number buttons / multiplication test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    
    await tester.tap(find.byKey(Key('8')));

    await tester.tap(find.byKey(Key('×')));

    await tester.tap(find.byKey(Key('5')));

    await tester.tap(find.byKey(Key('=')));
    await tester.pump();

    expect(find.text('8 × 5'), findsOneWidget, reason: 'displayText = 8 × 5');
    expect(find.text('40'), findsOneWidget, reason: 'result value');
  });

  testWidgets('number buttons / addition test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    
    await tester.tap(find.byKey(Key('5')));
    await tester.tap(find.byKey(Key('5')));

    await tester.tap(find.byKey(Key('+')));

    await tester.tap(find.byKey(Key('2')));
    await tester.tap(find.byKey(Key('5')));

    await tester.tap(find.byKey(Key('=')));
    await tester.pump();

    expect(find.text('55 + 25'), findsOneWidget, reason: 'displayText = 55 + 25');
    expect(find.text('80'), findsOneWidget, reason: 'result value');
  });

  testWidgets('number buttons / division test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    
    await tester.tap(find.byKey(Key('5')));
    await tester.tap(find.byKey(Key('0')));

    await tester.tap(find.byKey(Key('÷')));

    await tester.tap(find.byKey(Key('5')));

    await tester.tap(find.byKey(Key('=')));
    await tester.pump();

    expect(find.text('50 ÷ 5'), findsOneWidget, reason: 'displayText = 50 ÷ 5');
    expect(find.text('10.0'), findsOneWidget, reason: 'result value');

    await tester.tap(find.byKey(Key('÷')));

    await tester.tap(find.byKey(Key('2')));

    await tester.tap(find.byKey(Key('=')));
    await tester.pump();

    expect(find.text('50 ÷ 5 ÷ 2'), findsOneWidget, reason: 'displayText = 50 ÷ 5 ÷ 2');
    expect(find.text('5.0'), findsOneWidget, reason: 'result value');
  });

  testWidgets('number buttons / all clear test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    
    await tester.tap(find.byKey(Key('3')));
    await tester.tap(find.byKey(Key('1')));

    await tester.tap(find.byKey(Key('-')));

    await tester.tap(find.byKey(Key('7')));
    await tester.tap(find.byKey(Key('4')));
    await tester.pump();

    expect(find.text('31 - 74'), findsOneWidget, reason: 'displayText = 31 - 74');

    await tester.tap(find.byKey(Key('AC')));
    await tester.pump();

    expect(find.text('31 - 74'), findsNothing, reason: 'displayText = ');
  });
}
