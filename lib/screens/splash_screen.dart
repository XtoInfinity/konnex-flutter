import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/screens/catalog/category_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  GetStorage box = GetStorage();
  AnimationController _controller;

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
    super.initState();
    this._controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 1),
    )..repeat();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: CurvedAnimation(
              parent: this._controller, curve: Curves.fastOutSlowIn),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.wifi_tethering,
                  color: Theme.of(context).primaryColor,
                  size: 70 * this._controller.value,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  dispose() {
    this._controller.dispose();
    super.dispose();
  }
}
