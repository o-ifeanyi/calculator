import 'package:flutter_driver/flutter_driver.dart' as d;
import 'package:test/test.dart';


// pubspec.yaml dev dependencies
// dev_dependencies:
//   flutter_driver:
//     sdk: flutter
//   test: any

void main() {
  d.FlutterDriver driver;

  setUpAll(() async {
    driver = await d.FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) driver.close();
  });

  test('Calculate, add to history, clear history', () async {
    await Future.delayed(Duration(seconds: 1));
    final delayLimit = Duration(seconds: 3);
    // enter an equation
    await driver.tap(d.find.byValueKey('5'));
    await driver.tap(d.find.byValueKey('6'));
    await driver.tap(d.find.byValueKey('*'));
    await driver.tap(d.find.byValueKey('2'));
    await driver.tap(d.find.byValueKey('0'));

    // find the equation on the screen
    await driver.waitFor(d.find.text('56 * 20'), timeout: delayLimit);
    await driver.waitFor(d.find.text('1120.0'), timeout: delayLimit);

    await Future.delayed(Duration(milliseconds: 500));
    // = button shows only the result and adds the equation to history
    await driver.tap(d.find.byValueKey('='));

    // open history screen by tapping on the icon
    await driver.tap(d.find.byValueKey('history icon'));

    // find the equation as one of the entries
    await driver.waitFor(d.find.text('56 * 20'), timeout: delayLimit);
    await driver.waitFor(d.find.text('1120.0'), timeout: delayLimit);

    await Future.delayed(Duration(milliseconds: 500));
    // tap the clear button
    await driver.tap(d.find.byValueKey('clear'));

    // find the 'Clear history?' in the alert dialog
    await driver.waitFor(d.find.text('Clear history?'), timeout: delayLimit);

    // tap the continue button
    await driver.tap(d.find.byValueKey('continue'));

    // confirm history is cleard by finding text displayed when history is empty
    await driver.waitFor(d.find.text('No history'), timeout: delayLimit);

    await Future.delayed(Duration(seconds: 1));
  });
}
