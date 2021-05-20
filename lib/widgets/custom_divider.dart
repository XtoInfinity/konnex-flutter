import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final bool isColor;

  CustomDivider({this.isColor = false});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.5,
      color: isColor
          ? Theme.of(context).primaryColor
          : Colors.black.withOpacity(0.3),
    );
  }
}
