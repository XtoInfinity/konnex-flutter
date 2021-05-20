import 'package:flutter/material.dart';

class CustomNetWorkImage extends StatelessWidget {
  final photo;
  final assetLink;

  CustomNetWorkImage(this.photo,
      {this.assetLink = "assets/images/profileHolder.jpg"});

  @override
  Widget build(BuildContext context) {
    String filteredPhoto = photo;
    if (photo != null && photo != "no photo" && photo != '') {
      filteredPhoto = photo.toString().replaceAll(' ', '%20');
    }

    return filteredPhoto == null ||
            filteredPhoto == "no photo" ||
            filteredPhoto == ''
        ? Image.asset(
            assetLink,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          )
        : FadeInImage(
            image: NetworkImage(filteredPhoto.toString()),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            placeholder: AssetImage(assetLink),
          );
  }
}
