import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/models/message.dart';
import 'package:konnex_aerothon/utils/misc_utils.dart';

class MessagingService {
  String userId = GetStorage().read('userId');

  getAllMessage(AsyncSnapshot<QuerySnapshot> snapshot, List<Message> messages) {
    messages.clear();
    snapshot.data.docs.map((e) {
      if (e.get('user') == userId) {
        messages.add(Message.fromJson(e.data()));
      }
    }).toList();
  }

  addMessage(String message, List<Message> messages) {
    if (messages.length == 0) {
      String id = MiscUtils.getRandomId(6);
      FirebaseFirestore.instance.collection('messaging').add({
        'user': userId,
        "time": Timestamp.now(),
        "sentBy": "user",
        "message": message,
        "convoId": id
      });
    } else {
      FirebaseFirestore.instance.collection('messaging').add({
        'user': userId,
        "time": Timestamp.now(),
        "sentBy": "user",
        "message": message,
        "convoId": messages.first.convoId
      });
    }
  }
}
