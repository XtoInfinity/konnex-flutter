import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/screens/catalog/category_screen.dart';
import 'package:konnex_aerothon/screens/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GetStorage box = GetStorage();

  getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    box.write("appId", "b9RdbkE3hCvpjyw9S2PQ");
    if (auth.currentUser == null) {
      UserCredential userCredential = await auth.signInAnonymously();
      box.write("userId", userCredential.user.uid);
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userCredential.user.uid)
          .set({"createdAt": Timestamp.now(), "updatedAt": Timestamp.now()});
    }
    String id = box.read("userId");

    await FirebaseFirestore.instance.collection("user").doc(id).update({
      "updatedAt": Timestamp.now(),
    });
    Get.offAll(CategoryScreen());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.wifi_tethering,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
