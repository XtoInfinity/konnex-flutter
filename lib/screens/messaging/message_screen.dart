import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List messages = [
    {"message": "I have some issues when pressing back button", "sender": 0},
    {
      "message":
          "Please enter your problem in detail so that we can understand properly.",
      "sender": 1
    }
  ];

  @override
  Widget build(BuildContext context) {
    Widget _customBottomNavBar() {
      return Container(
        height: Get.height * 0.1,
        width: Get.width,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.only(
                    left: 20.0, top: 10.0, right: 16.0, bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(fontSize: 16.0),
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type Message",
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: Get.height * 0.07,
                width: Get.height * 0.07,
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () {
        Get.close(1);
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                    ),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
                    )),
              ),
              const SizedBox(width: 12.0),
              Text(
                "Konnex",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return _MessageBubble(
                      message: messages.reversed.toList()[index]);
                },
              ),
            ),
            _customBottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map message;

  _MessageBubble({Key key, @required this.message}) : super(key: key);
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: BubbleEdges.only(top: 20.0),
      alignment:
          0 == message['sender'] ? Alignment.topRight : Alignment.topLeft,
      nipWidth: 12.0,
      nipHeight: 16.0,
      nip:
          0 == message['sender'] ? BubbleNip.rightBottom : BubbleNip.leftBottom,
      color: 0 == message['sender']
          ? Get.theme.primaryColor
          : Get.theme.accentColor,
      padding: BubbleEdges.all(12.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
        child: Column(
          crossAxisAlignment: 0 == message['sender']
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              textAlign:
                  0 == message['sender'] ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              DateFormat('hh:mm').format(DateTime.now()),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
