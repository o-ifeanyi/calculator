import 'package:calculator/util/config.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String equation;
  final String result;

  HistoryItem(this.equation, this.result);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            equation,
            style: TextStyle(
              fontSize: Config.xMargin(context, 3.5),
            ),
          ),
        ),
        SizedBox(
          height: Config.yMargin(context, 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  fontSize: Config.xMargin(context, 8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: Config.yMargin(context, 3),
          color: Colors.white54,
          thickness: 2.0,
        ),
      ],
    );
  }
}
