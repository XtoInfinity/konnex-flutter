import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  String appId;
  String title;
  String description;
  Timestamp createdAt;
  List options;
  List attemptedUsers;
  String docId;

  Poll(
      {this.title,
      this.description,
      this.createdAt,
      this.options,
      this.attemptedUsers,
      this.appId,
      this.docId});

  factory Poll.fromJson(Map<String, dynamic> json, String id) => Poll(
      title: json['title'],
      description: json['description'],
      options: json['options'].map((e) => Option.fromJson(e)).toList(),
      createdAt: json['createdAt'],
      attemptedUsers:
          json['attemptedUsers'].map((e) => UserAnswer.fromJson(e)).toList(),
      docId: id);
}

class Option {
  String optionName;
  int selectedCount;

  Option({this.optionName, this.selectedCount});

  factory Option.fromJson(Map<String, dynamic> json) => Option(
      optionName: json['optionName'], selectedCount: json['selectedCount']);
}

class UserAnswer {
  String answer;
  String id;

  UserAnswer({this.answer, this.id});

  factory UserAnswer.fromJson(Map<String, dynamic> json) =>
      UserAnswer(answer: json['answer'], id: json['id']);

  Map<String, dynamic> toJson() => {"id": id, "answer": answer};
}
