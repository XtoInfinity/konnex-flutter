import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomErrorWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String description;
  final double height;

  CustomErrorWidget({this.title, this.iconData, this.height, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Get.width * 0.17,
            width: Get.width * 0.17,
            padding: EdgeInsets.all(Get.width * 0.05),
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(
              iconData,
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          if (title != null)
            Text(
              title,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 1.05),
            ),
          SizedBox(
            height: 8,
          ),
          if (description != null)
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}
