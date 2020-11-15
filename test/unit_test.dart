import 'package:calculator/provider/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('assign function should update display text', () {
    final calculator = Calculator();

    expect(calculator.displayText, '');

    calculator.assignNum('4');
    calculator.assignNum('7');

    calculator.assignOperand(' + ');

    calculator.assignNum('3');

    expect(calculator.displayText, '47 + 3');
  });

  test('clear function should reset all values', () {
    final calculator = Calculator();

    calculator.assignNum('2');
    calculator.assignNum('0');

    calculator.assignOperand(' * ');
    expect(calculator.operand, ' * ');

    calculator.assignNum('1');
    calculator.assignNum('0');

    expect(calculator.displayText, '20 * 10');
    expect(calculator.result, '200.0');

    calculator.clear();

    expect(calculator.displayText, '');
    expect(calculator.result, '');
    expect(calculator.operand, '');
  });

  test(
      'delete function should reduce the lenght of display text and re-evalute result',
      () {
    final calculator = Calculator();

    calculator.assignNum('2');

    calculator.assignOperand(' * ');
    expect(calculator.operand, ' * ');

    calculator.assignNum('2');
    calculator.assignNum('2');
    expect(calculator.result, '44.0');

    calculator.delete();

    expect(calculator.displayText, '2 * 2');
    expect(calculator.result, '4.0');
  });

  test('assign function should not be able to add multiple decimal to a number',
      () {
    final calculator = Calculator();

    expect(calculator.displayText, '');

    calculator.assignNum('8');
    calculator.assignNum('.');
    calculator.assignNum('9');
    calculator.assignNum('.');

    expect(calculator.displayText, '8.9');
  });

  test(
      'assign function should call evaluate if displayText is a valid equation',
      () {
    final calculator = Calculator();

    expect(calculator.displayText, '');

    calculator.assignNum('5');
    calculator.assignOperand(' * ');
    calculator.assignNum('5'); // valid equation
    expect(calculator.result, '25.0');

    calculator.assignOperand(' - ');
    expect(calculator.result, '25.0');

    calculator.assignNum('2'); // valid equation
    expect(calculator.result, '23.0');

    calculator.assignOperand(' + ');
    expect(calculator.result, '23.0');

    calculator.assignNum('7'); // valid equation
    expect(calculator.result, '30.0');
  });

  test('evaluate function should be called automatically for valid equations',
      () {
    final calculator = Calculator();

    expect(calculator.result, '');

    calculator.assignNum('8');
    calculator.assignNum('.');
    calculator.assignNum('9');

    calculator.assignOperand(' / ');

    calculator.assignNum('2');

    expect(calculator.result, '4.45');
  });

  test(
      'evaluate function called by tapping = should assign result to displayText and reset result',
      () async {
    final calculator = Calculator();

    expect(calculator.result, '');

    calculator.assignNum('6');
    calculator.assignNum('4');

    calculator.assignOperand(' / ');

    calculator.assignNum('8');

    expect(calculator.displayText, '64 / 8');
    expect(calculator.result, '8.0');

    await calculator.evaluate(isTaped: true);

    expect(calculator.displayText, '8.0');
    expect(calculator.result, '');
  });

  test(
      'assignOperand should not add multiple operands without a number inbetween',
      () {
    final calculator = Calculator();

    expect(calculator.displayText, '');
    expect(calculator.operand, '');

    calculator.assignNum('13');

    calculator.assignOperand(' + ');
    calculator.assignOperand(' - '); // nothing happens
    calculator.assignOperand(' / '); // nothing happens

    expect(calculator.operand, ' + ');
    calculator.assignNum('3');

    expect(calculator.displayText, '13 + 3');
    expect(calculator.operand, '',
        reason: 'evaluate is called and operand is reset');
  });
}
