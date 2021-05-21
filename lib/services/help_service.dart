import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/models/announcement.dart';
import 'package:konnex_aerothon/models/article.dart';
import 'package:konnex_aerothon/models/message.dart';
import 'package:konnex_aerothon/utils/classifier.dart';

class HelpService {
  String userId = GetStorage().read('userId');
  String appId = GetStorage().read('appId');
  Classifier _classifier = Classifier();

  getAllArticles(
      AsyncSnapshot<QuerySnapshot> snapshot, List<Article> articles) async {
    articles.clear();
    snapshot.data.docs.map((e) {
      if (e.get('appId') == appId) {
        articles.add(Article.fromJson(e.data()));
      }
    }).toList();
  }

  getAllAnnouncements(AsyncSnapshot<QuerySnapshot> snapshot,
      List<Announcement> announcements) async {
    announcements.clear();
    snapshot.data.docs.map((e) {
      if (e.get('appId') == appId) {
        announcements.add(Announcement.fromJson(e.data()));
      }
    }).toList();
  }

  addReport(List<File> files, String category, String subCategory,
      String message) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List urls = [];

    for (int i = 0; i < files.length; i++) {
      Reference ref =
          storage.ref().child("reports/" + userId + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(files[i]);
      await uploadTask.whenComplete(() async {
        urls.add(await ref.getDownloadURL());
      });
    }

    await FirebaseFirestore.instance.collection("report").add({
      "userId": userId,
      "appId": appId,
      "category": category,
      "subCategory": subCategory,
      "message": message,
      "createdAt": Timestamp.now(),
      "images": urls,
      "status": "Open",
    });
  }

  addFeedback(String message) async {
    final prediction = _classifier.classify(message);
    String sentiment = prediction[0] < prediction[1] ? "positive" : "negative";
    await FirebaseFirestore.instance.collection("feedback").add({
      "userId": userId,
      "appId": appId,
      "message": message,
      "createdAt": Timestamp.now(),
      "sentiment": sentiment,
    });
  }
}
