import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  String title;
  String description;
  String image;
  Timestamp createdAt;

  Announcement({this.title, this.description, this.image, this.createdAt});

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      image: json['image']);
}
