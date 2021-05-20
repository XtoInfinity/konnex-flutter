import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/screens/misc/done_screen.dart';
import 'package:konnex_aerothon/services/help_service.dart';
import 'package:konnex_aerothon/widgets/bottom_button.dart';
import 'package:konnex_aerothon/widgets/loading.dart';
import 'package:lottie/lottie.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoad = false;

  addFeedback() async {
    String message = controller.text;

    if (message.length > 0) {
      isLoad = true;
      setState(() {});
      HelpService helpService = HelpService();
      await helpService.addFeedback(message);
      Get.to(DoneScreen(
        onTap: () => Get.close(2),
        title: "Feedback Submitted",
        subTitle: "Thank you for submitting your feedback. Keep supporting us!",
      ));
    } else {
      Get.rawSnackbar(message: "Please enter all details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feedback",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: isLoad
          ? CustomLoading()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Lottie.asset(
                            "assets/anims/robot_hello.json",
                            repeat: false,
                            height: Get.height * 0.3,
                          ),
                          Text(
                            "HEY THERE!",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                letterSpacing: 0.9),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Need a new feature? Dont like an existing feature? Have any ideas in mind? Let us know down below",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                letterSpacing: 0.9),
                            textAlign: TextAlign.center,
                          ),
                          TextField(
                            minLines: 8,
                            maxLines: 10,
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: "Enter your feedback",
                              hintText: "Enter your feedbasck here",
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomButton(
                  onTap: () {
                    addFeedback();
                  },
                  text: "Submit",
                )
              ],
            ),
    );
  }
}
