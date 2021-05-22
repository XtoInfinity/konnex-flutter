import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/models/message.dart';
import 'package:konnex_aerothon/utils/misc_utils.dart';

class MessagingService {
  String userId = GetStorage().read('userId');

  getAllMessage(AsyncSnapshot<QuerySnapshot> snapshot, List<Message> messages) {
    messages.clear();
    String convoId;
    snapshot.data.docs.map((e) {
      if (e.get('user') == userId) {
        convoId = e.get('convoId');
      }
    }).toList();
    if (convoId != null) {
      snapshot.data.docs.map((e) {
        if (e.get('convoId') == convoId) {
          messages.add(Message.fromJson(e.data()));
        }
      }).toList();
      messages.sort((a, b) => b.time.compareTo(a.time));
    }
  }
}
