import 'dart:convert';

import 'package:calculator/provider/calculator.dart';
import 'package:calculator/util/config.dart';
import 'package:calculator/widgets/history_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<Calculator>(
          builder: (context, calc, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        key: Key('clear'),
                        icon: Icon(Icons.clear),
                        onPressed: () => showDialog(
                            context: (context),
                            builder: (context) => AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  title: Text('Clear history?'),
                                  actions: [
                                    FlatButton(
                                      key: Key('dismiss'),
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Dismiss'),
                                    ),
                                    FlatButton(
                                      key: Key('continue'),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await calc.clearHistory();
                                      },
                                      child: Text('Continue'),
                                    ),
                                  ],
                                )),
                      ),
                    ],
                  ),
                ),
                calc.history.isEmpty
                    ? Expanded(
                      key: Key('empty'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history),
                            SizedBox(height: 10),
                            Text('No history'),
                          ],
                        ),
                      )
                    : Expanded(
                      key: Key('not empty'),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Divider(
                                color: Colors.white54,
                                thickness: 2.0,
                              ),
                              SizedBox(height: Config.yMargin(context, 2)),
                              ...calc.history.map((e) {
                                final item =
                                    json.decode(e) as Map<dynamic, dynamic>;
                                return HistoryItem(
                                    item['equation'], item['result']);
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
