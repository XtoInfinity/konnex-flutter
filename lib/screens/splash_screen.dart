import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/screens/dashboard_screen.dart';
import 'package:konnex_aerothon/utils/misc_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GetStorage box = GetStorage();

  getData() async {
    if (!box.hasData("userId")) {
      String id = MiscUtils.getRandomId(12);
      box.write("userId", id);
      await FirebaseFirestore.instance.collection("user").doc(id).set({
        "userId": id,
        "createdAt": Timestamp.now(),
      });
    }
    String id = box.read("userId");

    await FirebaseFirestore.instance.collection("user").doc(id).set({
      "updatedAt": Timestamp.now(),
    });
    Get.to(DashboardScreen());
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
