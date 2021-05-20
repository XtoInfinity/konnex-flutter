import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/widgets/bottom_button.dart';
import 'package:lottie/lottie.dart';

class DoneScreen extends StatelessWidget {
  final Function onTap;
  final String title;
  final String subTitle;
  final String lottieAnimUrl;

  DoneScreen(
      {this.onTap,
      this.title,
      this.subTitle,
      this.lottieAnimUrl = "assets/anims/done.json"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          onTap();
          return false;
        },
        child: Column(
          children: [
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.1,
                      ),
                      Lottie.asset(lottieAnimUrl,
                          repeat: false, height: Get.height * 0.4),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                        child: Column(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  letterSpacing: 0.9),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              subTitle,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  letterSpacing: 0.9),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomButton(
              onTap: onTap,
              text: "Continue",
            )
          ],
        ),
      ),
    );
  }
}
