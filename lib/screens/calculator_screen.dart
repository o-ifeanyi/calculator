import 'dart:convert';

import 'package:calculator/screens/history_screen.dart';
import 'package:calculator/util/config.dart';
import 'package:calculator/widgets/calc_button.dart';
import 'package:calculator/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Operand {
  Add,
  Divide,
  Subtract,
  Multiply,
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '';
  String result = '';
  String prevValue;
  Operand operand;
  Operand prevOperand;

  void clear() {
    setState(() {
      displayText = '';
      result = '';
      prevValue = '';
      operand = null;
      prevOperand = null;
    });
  }

  void delete() {
    setState(() {
      // delete the last entry and remove any trailing space
      displayText =
          displayText.substring(0, displayText.length - 1).trimRight();
      // no need to call evaluate if theres not a second value
      if (displayText.endsWith('+') ||
          displayText.endsWith('-') ||
          displayText.endsWith('*') ||
          displayText.endsWith('/')) return;
      if (displayText.isEmpty) return;
      evaluate();
    });
  }

  void assignNum(var number) {
    // each entry cannot contain more than one decimal point
    if (displayText.split(RegExp(r'\s.{1}\s')).last.contains('.') &&
        number == '.') return;
    // the first entry cannot be a decimal
    if (displayText.isEmpty && number == '.') return;
    setState(() {
      displayText += '$number';
    });
    // no need to call evaluate if last entry was a decimal
    if (number == '.') return;
    if (operand != null || prevOperand != null) {
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
    setState(() {
      prevOperand = operand;
      operand = null;
      prevValue = result;
      // if equal to button is tapped displayText resets to current total
      // and result resets to empty string
      isTaped ? displayText = prevValue : displayText = displayText;
      isTaped ? result = '' : result = result;
    });
  }

  void assignOperand(Operand option) {
    // operands have trailing spaces so if display text ends with a space
    // the last thing that was entered is an operand and should therefore not add another
    if (displayText.endsWith(' ')) return;
    switch (option) {
      case Operand.Add:
        displayText += ' + ';
        break;
      case Operand.Divide:
        displayText += ' / ';
        break;
      case Operand.Multiply:
        displayText += ' * ';
        break;
      case Operand.Subtract:
        displayText += ' - ';
        break;
      default:
        throw Error();
    }
    setState(() {
      operand = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryScreen(),
                ),
              ),
            ),
            SizedBox(
              height: Config.yMargin(context, 3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: Config.xMargin(context, 6),
                ),
              ),
            ),
            SizedBox(
              height: Config.yMargin(context, 3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (result.isNotEmpty)
                    Text(
                      '=',
                      style: TextStyle(
                        fontSize: Config.xMargin(context, 10),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: Config.xMargin(context, 12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: Config.yMargin(context, 6),
              color: Colors.white54,
              thickness: 2.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButton(
                          key: Key('AC'),
                          text: 'AC',
                          callBack: clear,
                        ),
                        ...['D', '*'].map((e) {
                          if (e == '*') {
                            return CalcButton(
                              key: Key(e),
                              text: e,
                              color: Theme.of(context).accentColor,
                              callBack: () => assignOperand(Operand.Multiply),
                            );
                          }
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            callBack: delete,
                          );
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['7', '8', '9', '/'].map((e) {
                        if (e == '/') {
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            color: Theme.of(context).accentColor,
                            callBack: () => assignOperand(Operand.Divide),
                          );
                        }
                        return CalcButton(
                          key: Key(e),
                          text: e,
                          callBack: () => assignNum(int.parse(e)),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['4', '5', '6', '-'].map((e) {
                        if (e == '-') {
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            color: Theme.of(context).accentColor,
                            callBack: () => assignOperand(Operand.Subtract),
                          );
                        }
                        return CalcButton(
                          key: Key(e),
                          text: e,
                          callBack: () => assignNum(int.parse(e)),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['1', '2', '3', '+'].map((e) {
                        if (e == '+') {
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            color: Theme.of(context).accentColor,
                            callBack: () => assignOperand(Operand.Add),
                          );
                        }
                        return CalcButton(
                          key: Key(e),
                          text: e,
                          callBack: () => assignNum(int.parse(e)),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButton(
                          key: Key('0'),
                          text: '0',
                          callBack: () => assignNum(0),
                        ),
                        ...['.', '='].map((e) {
                          if (e == '=') {
                            return CalcButton(
                              key: Key(e),
                              text: e,
                              color: Colors.green,
                              callBack: () async =>
                                  await evaluate(isTaped: true),
                            );
                          }
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            callBack: () => assignNum('.'),
                          );
                        })
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
