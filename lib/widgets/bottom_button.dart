import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color backColor;
  final Color textColor;

  BottomButton({this.onTap, this.text, this.backColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    Color tColor = textColor ?? Colors.white;
    Color bColor = backColor ?? Theme.of(context).primaryColor;

    return Material(
      color: bColor,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: tColor,
                fontSize: 16,
                letterSpacing: 1.05,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
