import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends ChangeNotifier {
  String displayText = '';
  String result = '';
  String prevValue = '';
  String operand = '';
  String prevOperand = '';
  List<String> history = [];

  void clear() {
    displayText = '';
    result = '';
    prevValue = '';
    operand = '';
    prevOperand = '';
    notifyListeners();
  }

  void delete() {
    // delete the last entry and remove any trailing space
    displayText = displayText.substring(0, displayText.length - 1);
    // no need to call evaluate if theres not a second value
    notifyListeners();
    if (displayText.endsWith(' ')) return;
    if (displayText.endsWith('+') ||
        displayText.endsWith('-') ||
        displayText.endsWith('*') ||
        displayText.endsWith('/')) return;
    if (displayText.isEmpty) return;
    evaluate();
  }

  void assignNum(var number) {
    // each entry cannot contain more than one decimal point
    if (displayText.split(RegExp(r'\s.{1}\s')).last.contains('.') &&
        number == '.') return;
    // the first entry cannot be a decimal
    if (displayText.isEmpty && number == '.') return;

    displayText += '$number';
    notifyListeners();
    // no need to call evaluate if last entry was a decimal
    if (number == '.') return;
    if (operand.isNotEmpty || prevOperand.isNotEmpty) {
      evaluate();
    }
  }

  Future<void> evaluate({bool isTaped = false}) async {
    Parser p = Parser();
    ContextModel cm = ContextModel();
    Expression exp = p.parse(displayText);
    result = exp.evaluate(EvaluationType.REAL, cm).toString();
    if (isTaped) {
      await SharedPreferences.getInstance().then((pref) {
        final history = pref.getStringList('history') ?? [];
        history.add(json.encode({
          'equation': displayText,
          'result': result,
        }));
        pref.setStringList('history', history);
      });
    }
    prevOperand = operand;
    operand = '';
    prevValue = result;
    // if equal to button is tapped displayText resets to current total
    // and result resets to empty string
    isTaped ? displayText = prevValue : displayText = displayText;
    isTaped ? result = '' : result = result;
    notifyListeners();
  }

  void assignOperand(String option) {
    // operands have trailing spaces so if display text ends with a space
    // the last thing that was entered is an operand and should therefore not add another
    if (displayText.endsWith(' ')) return;
    displayText += option;

    operand = option;
    notifyListeners();
  }

  Future<void> getHistory() async {
    history = await SharedPreferences.getInstance().then(
      (pref) => pref.getStringList('history') ?? [],
    );
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await SharedPreferences.getInstance().then((pref) => pref.clear());
    history = [];
    notifyListeners();
  }
}
