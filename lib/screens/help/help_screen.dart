import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/models/article.dart';
import 'package:konnex_aerothon/screens/help/feedback_screen.dart';
import 'package:konnex_aerothon/screens/help/article_screen.dart';
import 'package:konnex_aerothon/screens/messaging/message_screen.dart';
import 'package:konnex_aerothon/screens/report/report_screen.dart';
import 'package:konnex_aerothon/services/help_service.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:konnex_aerothon/utils/speech_overlay.dart';
import 'package:konnex_aerothon/widgets/announcement_section.dart';

class HelpScreen extends StatefulWidget {
  static const String routeName = '/HelpScreen';
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  TextEditingController controller = TextEditingController();

  issueWidget() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Icon(Icons.search),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your issue"),
                        textInputAction: TextInputAction.search,
                        controller: controller,
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: Material(
            color: Theme.of(context).primaryColor,
            child: InkWell(
              onTap: () async {
                String value = await Get.dialog(
                  SpeechOverlay(),
                );
                if (value != null) {
                  controller.text = value;
                  setState(() {});
                }
              },
              child: Icon(
                Icons.keyboard_voice,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  feedbackWidget(String title, IconData iconData, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Theme.of(context).primaryColor,
              size: 26,
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  initState() {
    LogUtil.instance.log(HelpScreen.routeName, LogType.open_screen,
        'Opened ${HelpScreen.routeName}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Support",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  issueWidget(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Need more help?",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Get.to(MessageScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.message,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Contact Us"),
                                Text(
                                    "Tell us more and we'll help you get there")
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  feedbackWidget("Send Feedback", Icons.announcement_rounded,
                      () => Get.to(FeedbackScreen())),
                  Container(
                    height: 0.5,
                    color: Colors.grey,
                  ),
                  feedbackWidget("Report a Bug", Icons.bug_report,
                      () => Get.to(ReportScreen())),
                  Container(
                    height: 0.5,
                    color: Colors.grey,
                    margin: EdgeInsets.only(bottom: 16),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Announcements",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  AnnouncementSection(),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Popular Articles",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  _ArticleSection()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleSection extends StatelessWidget {
  articleWidget(Article article, IconData iconData) {
    return InkWell(
      onTap: () {
        Get.to(ArticleScreen(article));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Get.theme.primaryColor,
              size: 25,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                article.title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Article> articles = [];
    HelpService helpService = HelpService();

    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          helpService.getAllArticles(snapshot, articles);
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                articleWidget(articles[index], Icons.library_books_sharp),
            itemCount: articles.length,
          );
        } else {
          return SizedBox.shrink();
        }
      },
      stream: FirebaseFirestore.instance.collection("article").snapshots(),
    );
  }
}
