import 'package:calculator/util/config.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Key key;
  final Function callBack;
  RoundedButton({
    this.key,
    @required this.text,
    @required this.callBack
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callBack,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        alignment: Alignment.center,
        height: Config.yMargin(context, 8),
        width: Config.yMargin(context, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: Theme.of(context).accentColor
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
