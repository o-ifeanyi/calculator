import 'package:calculator/provider/calculator.dart';
import 'package:calculator/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Calculator screen test', () {
    testWidgets('number buttons / subtraction test',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      await tester.tap(find.byKey(Key('3')));
      await tester.tap(find.byKey(Key('8')));

      await tester.tap(find.byKey(Key('-')));

      await tester.tap(find.byKey(Key('5')));
      await tester.tap(find.byKey(Key('0')));
      await tester.pump();

      expect(find.text('38 - 50'), findsOneWidget,
          reason: 'displayText = 38 - 50');
      expect(find.text('-12.0'), findsOneWidget, reason: 'result value');

      await tester.tap(find.byKey(Key('=')));
      await tester.pump();

      expect(find.text('-12.0'), findsOneWidget, reason: 'result value');
    });

    testWidgets('number buttons / multiplication test',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      await tester.tap(find.byKey(Key('8')));

      await tester.tap(find.byKey(Key('*')));

      await tester.tap(find.byKey(Key('5')));
      await tester.pump();

      expect(find.text('8 * 5'), findsOneWidget, reason: 'displayText = 8 * 5');
      expect(find.text('40.0'), findsOneWidget, reason: 'result value');

      await tester.tap(find.byKey(Key('=')));
      await tester.pump();

      expect(find.text('40.0'), findsOneWidget, reason: 'result value');
    });

    testWidgets('number buttons / addition test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      await tester.tap(find.byKey(Key('5')));
      await tester.tap(find.byKey(Key('5')));

      await tester.tap(find.byKey(Key('+')));

      await tester.tap(find.byKey(Key('2')));
      await tester.tap(find.byKey(Key('5')));
      await tester.pump();

      expect(find.text('55 + 25'), findsOneWidget,
          reason: 'displayText = 55 + 25');
      expect(find.text('80.0'), findsOneWidget, reason: 'result value');

      await tester.tap(find.byKey(Key('=')));
      await tester.pump();

      expect(find.text('80.0'), findsOneWidget, reason: 'result value');
    });

    testWidgets('number buttons / division test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      await tester.tap(find.byKey(Key('5')));
      await tester.tap(find.byKey(Key('0')));

      await tester.tap(find.byKey(Key('/')));

      await tester.tap(find.byKey(Key('5')));
      await tester.pump();

      expect(find.text('50 / 5'), findsOneWidget,
          reason: 'displayText = 50 / 5');
      expect(find.text('10.0'), findsOneWidget, reason: 'result value');

      await tester.tap(find.byKey(Key('=')));
      await tester.pump();

      expect(find.text('10.0'), findsOneWidget, reason: 'result value');

      await tester.tap(find.byKey(Key('/')));
      await tester.tap(find.byKey(Key('4')));

      await tester.tap(find.byKey(Key('=')));
      await tester.pump();

      expect(find.text('2.5'), findsOneWidget, reason: 'result value');
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

      expect(find.text('31 - 74'), findsOneWidget,
          reason: 'displayText = 31 - 74');
      expect(find.text('-43.0'), findsOneWidget, reason: 'result value');

      await tester.tap(find.byKey(Key('AC')));
      await tester.pump();

      expect(find.text('31 - 74'), findsNothing, reason: 'displayText = ');
      expect(find.text('-43.0'), findsNothing, reason: 'result value');
    });

    testWidgets('number buttons / delete button test',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      await tester.tap(find.byKey(Key('3')));
      await tester.tap(find.byKey(Key('8')));

      await tester.tap(find.byKey(Key('-')));

      await tester.tap(find.byKey(Key('5')));
      await tester.tap(find.byKey(Key('0')));
      await tester.pump();

      expect(find.text('38 - 50'), findsOneWidget,
          reason: 'displayText = 38 - 50');
      expect(find.text('-12.0'), findsOneWidget, reason: 'result value');

      await tester.tap(find.byKey(Key('D')));
      await tester.pump();

      expect(find.text('38 - 5'), findsOneWidget,
          reason: 'displayText = 38 - 5');
      expect(find.text('33.0'), findsOneWidget, reason: 'result value');
    });
  });

  Widget makeTestatble(Widget child) {
    return ChangeNotifierProvider(
      create: (ctx) => Calculator(),
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('History screen test', () {
    testWidgets('History screen opend', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(makeTestatble(HistoryScreen()));

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });

    testWidgets('History screen is empty', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(makeTestatble(HistoryScreen()));

      final history = await SharedPreferences.getInstance()
              .then((pref) => pref.getStringList('history')) ??
          [];

      if (history.isEmpty) {
        expect(find.byKey(Key('empty')), findsOneWidget);
        expect(find.byKey(Key('not empty')), findsNothing);
      }
    });

    testWidgets('History screen is not empty', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(makeTestatble(HistoryScreen()));

      final history = await SharedPreferences.getInstance()
              .then((pref) => pref.getStringList('history')) ??
          [];
      // print(history);

      print(history);

      if (history.isNotEmpty) {
        expect(find.byKey(Key('empty')), findsNothing);
        expect(find.byKey(Key('not empty')), findsOneWidget);
      }
    });
  });
}
