import 'package:calculator/provider/calculator.dart';
import 'package:calculator/screens/history_screen.dart';
import 'package:calculator/util/config.dart';
import 'package:calculator/widgets/calc_button.dart';
import 'package:calculator/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<Calculator>(builder: (context, calc, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  key: Key('history icon'),
                  icon: Icon(Icons.history),
                  onPressed: () {
                    calc.getHistory();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HistoryScreen(),
                        ));
                  }),
              SizedBox(
                height: Config.yMargin(context, 3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  calc.displayText,
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
                    if (calc.result.isNotEmpty)
                      Text(
                        '=',
                        style: TextStyle(
                          fontSize: Config.xMargin(context, 10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Text(
                      calc.result,
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
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedButton(
                            key: Key('AC'),
                            text: 'AC',
                            callBack: calc.clear,
                          ),
                          ...['D', '*'].map((e) {
                            if (e == '*') {
                              return CalcButton(
                                key: Key(e),
                                text: e,
                                color: Theme.of(context).accentColor,
                                callBack: () => calc.assignOperand(' * '),
                              );
                            }
                            return CalcButton(
                              key: Key(e),
                              text: e,
                              callBack: calc.delete,
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
                              callBack: () => calc.assignOperand(' / '),
                            );
                          }
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            callBack: () => calc.assignNum(int.parse(e)),
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
                              callBack: () => calc.assignOperand(' - '),
                            );
                          }
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            callBack: () => calc.assignNum(int.parse(e)),
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
                              callBack: () => calc.assignOperand(' + '),
                            );
                          }
                          return CalcButton(
                            key: Key(e),
                            text: e,
                            callBack: () => calc.assignNum(int.parse(e)),
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedButton(
                            key: Key('0'),
                            text: '0',
                            callBack: () => calc.assignNum(0),
                          ),
                          ...['.', '='].map((e) {
                            if (e == '=') {
                              return CalcButton(
                                key: Key(e),
                                text: e,
                                color: Colors.green,
                                callBack: () async =>
                                    await calc.evaluate(isTaped: true),
                              );
                            }
                            return CalcButton(
                              key: Key(e),
                              text: e,
                              callBack: () => calc.assignNum('.'),
                            );
                          })
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
