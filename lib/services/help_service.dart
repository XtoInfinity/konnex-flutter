import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/models/article.dart';
import 'package:konnex_aerothon/models/message.dart';

class HelpService {
  String userId = GetStorage().read('userId');
  String appId = GetStorage().read('appId');

  getAllArticles(
      AsyncSnapshot<QuerySnapshot> snapshot, List<Article> articles) async {
    articles.clear();
    snapshot.data.docs.map((e) {
      if (e.get('appId') == appId) {
        articles.add(Article.fromJson(e.data()));
      }
    }).toList();
  }
}
