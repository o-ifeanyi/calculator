import 'dart:convert';

import 'package:calculator/util/config.dart';
import 'package:calculator/widgets/history_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('history');
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    icon: Icon(Icons.clear),
                    onPressed: () => showDialog(
                        context: (context),
                        builder: (ctx) => AlertDialog(
                              backgroundColor: Theme.of(context).primaryColor,
                              title: Text('Clear history?'),
                              actions: [
                                FlatButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text('Dismiss'),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    await SharedPreferences.getInstance()
                                        .then((pref) => pref.clear());
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Clear'),
                                ),
                              ],
                            )),
                  ),
                ],
              ),
            ),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, pref) {
                if (pref.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final history = pref.data.getStringList('history') ?? [];
                if (history.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history),
                        SizedBox(height: 10),
                        Text('No history'),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.white54,
                          thickness: 2.0,
                        ),
                        SizedBox(height: Config.yMargin(context, 2)),
                        ...history.map((e) {
                          final item =
                              json.decode(e) as Map<dynamic, dynamic>;
                          return HistoryItem(
                              item['equation'], item['result']);
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
