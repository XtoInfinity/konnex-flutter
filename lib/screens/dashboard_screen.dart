import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/screens/messaging/message_screen.dart';
import 'package:konnex_aerothon/screens/report/report_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcaseview/showcaseview.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isOpen = false;
  GlobalKey firstInput = GlobalKey();
  GlobalKey secondInput = GlobalKey();

  getQuestionCard(String title, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                isOpen = false;
                setState(() {});
                ShowCaseWidget.of(context)
                    .startShowCase([firstInput, secondInput]);
              },
              child: Text(
                "Navigate",
              ),
            )
          ],
        ),
      ),
    );
  }

  getChip(String title, IconData icon, Function onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          isOpen = false;
          setState(() {});
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 4,
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  getChipSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.start,
        children: [
          getChip(
              "Get Help", Icons.help_outline, () => Get.to(MessageScreen())),
        ],
      ),
    );
  }

  getFabButton(IconData icon) {
    return IconButton(
      icon: Icon(
        icon,
        size: 30,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () {},
    );
  }

  getSearchBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your issue"),
                        textInputAction: TextInputAction.search,
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
            color: Theme.of(context).primaryColor,
          ),
          child: Icon(
            Icons.keyboard_voice,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  getTextBox(GlobalKey key, String description) {
    return Showcase(
      key: key,
      description: description,
      child: Card(
          child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isOpen ? Colors.white : Colors.transparent,
        onPressed: () {
          isOpen = !isOpen;
          setState(() {});
        },
        child: isOpen
            ? Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              )
            : Image.asset(
                "assets/images/logo.png",
                height: 60,
              ),
      ),
      body: ShowCaseWidget(
        builder: Builder(
          builder: (context) => Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    getTextBox(firstInput, "Enter your name here"),
                    SizedBox(
                      height: 16,
                    ),
                    getTextBox(secondInput, "Enter your address here"),
                  ],
                ),
              ),
              if (isOpen)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  width: double.infinity,
                  child: Column(
                    children: [
                      getSearchBox(),
                      getChipSection(),
                      Expanded(
                        child: AnimationLimiter(
                          child: ListView.builder(
                            itemCount: 50,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50,
                                  child: getQuestionCard(
                                      "How do I purchase in this application?",
                                      context),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
