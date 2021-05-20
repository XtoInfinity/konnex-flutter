import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function negativeButtonOnTap;
  final Function positiveButtonOnTap;
  final String negativeButtonText;
  final String positiveButtonText;
  final Color negativeButtonColor;
  final Color positiveButtonColor;

  CustomDialog(this.title, this.description,
      {this.negativeButtonOnTap,
      this.positiveButtonOnTap,
      this.negativeButtonText = "Cancel",
      this.positiveButtonText = "Yes",
      this.negativeButtonColor = Colors.red,
      this.positiveButtonColor = Colors.green});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        CustomDialogButton(
          color: negativeButtonColor,
          text: negativeButtonText,
          onTap: negativeButtonOnTap ?? () => Get.close(1),
        ),
        CustomDialogButton(
          color: positiveButtonColor,
          text: positiveButtonText,
          onTap: positiveButtonOnTap,
        ),
      ],
    );
  }
}

class CustomDialogButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onTap;

  CustomDialogButton({this.text, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      onPressed: onTap,
    );
  }
}
