import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  static const routeName = '/ImageViewScreen';
  final String passValue;

  ImageViewScreen(this.passValue);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(passValue),
    );
  }
}
