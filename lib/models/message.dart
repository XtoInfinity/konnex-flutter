import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  Timestamp time;
  String convoId;
  String sentBy;

  Message({this.message, this.time, this.convoId, this.sentBy});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      message: json['message'],
      convoId: json['convoId'],
      sentBy: json['sentBy'],
      time: json['time']);
}
