import 'dart:convert';

import 'package:calculator/screens/history_screen.dart';
import 'package:calculator/util/config.dart';
import 'package:calculator/widgets/calc_button.dart';
import 'package:calculator/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
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
  num firstNum;
  num secondNum;
  num prevValue;
  Operand operand;

  void clear() {
    setState(() {
      displayText = '';
      result = '';
      firstNum = null;
      secondNum = null;
      prevValue = null;
      operand = null;
    });
  }

  void delete() {}

  void assignNum(var number) {
    if ((firstNum == null) && number == '.') {
      return;
    }
    if ((operand != null && secondNum == null) && number == '.') {
      return;
    }
    if (number == '.') {
      setState(() {
        displayText += '$number';
      });
      return;
    }
    setState(() {
      (firstNum == null || operand == null) && prevValue == null
          ? firstNum = displayText.endsWith('.')
              ? num.parse(('${firstNum ?? ''}')) + num.parse('.$number')
              : num.parse('${firstNum ?? ''}$number')
          : secondNum = displayText.endsWith('.')
              ? num.parse(('${secondNum ?? ''}')) + num.parse('.$number')
              : num.parse('${secondNum ?? ''}$number');
      displayText += '$number';
    });
  }

  Future<void> evaluate() async {
    if (secondNum == null || secondNum.toString().endsWith('.')) return;
    switch (operand) {
      case Operand.Add:
        result = ((prevValue ?? firstNum) + secondNum).toString();
        break;
      case Operand.Divide:
        result = ((prevValue ?? firstNum) / secondNum).toString();
        break;
      case Operand.Multiply:
        result = ((prevValue ?? firstNum) * secondNum).toString();
        break;
      case Operand.Subtract:
        result = ((prevValue ?? firstNum) - secondNum).toString();
        break;
      default:
    }
    setState(() {
      operand = null;
      secondNum = null;
      firstNum = null;
      prevValue = double.parse(result);
    });
    await SharedPreferences.getInstance().then((pref) {
      final history = pref.getStringList('history') ?? [];
      history.add(json.encode({
        'equation': displayText,
        'result': result,
      }));
      pref.setStringList('history', history);
    });
  }

  void assignOperand(Operand option) {
    if (displayText.endsWith(' ')) return;
    switch (option) {
      case Operand.Add:
        displayText += ' + ';
        break;
      case Operand.Divide:
        displayText += ' ÷ ';
        break;
      case Operand.Multiply:
        displayText += ' × ';
        break;
      case Operand.Subtract:
        displayText += ' - ';
        break;
      default:
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
                        ...['D', '×'].map((e) {
                          if (e == '×') {
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
                      children: ['7', '8', '9', '÷'].map((e) {
                        if (e == '÷') {
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
                              callBack: () async => await evaluate(),
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
