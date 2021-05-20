import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String title;
  String description;
  String image;
  Timestamp createdAt;

  Article({this.title, this.description, this.image, this.createdAt});

  factory Article.fromJson(Map<String, dynamic> json) => Article(
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      image: json['image']);
}
