import 'package:calculator/util/config.dart';
import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final Color color;
  final Key key;
  final Function callBack;
  CalcButton({
    this.key,
    @required this.text,
    this.color = const Color(0xFF222427),
    @required this.callBack,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callBack,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        alignment: Alignment.center,
        height: Config.yMargin(context, 8),
        width: Config.yMargin(context, 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Config.xMargin(context, 6),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
