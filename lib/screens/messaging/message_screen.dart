import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:konnex_aerothon/models/message.dart';
import 'package:konnex_aerothon/services/messaging_service.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:konnex_aerothon/utils/misc_utils.dart';
import 'package:konnex_aerothon/widgets/loading.dart';

class MessageScreen extends StatefulWidget {
  static const String routeName = '/MessageScreen';
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _messageController;
  MessagingService messagingService = MessagingService();
  String userId = GetStorage().read('userId');

  bool isLoad = true;

  List<Chatbot> chatbotMessages = [];
  List<Message> messages = [];

  getAllChatbotMessages() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("chatbot").get();
    snapshot.docs
        .map((e) => chatbotMessages.add(Chatbot.fromJson(e.data())))
        .toList();
    print(chatbotMessages.length);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    LogUtil.instance.log(MessageScreen.routeName, LogType.open_screen,
        'Opened ${MessageScreen.routeName}');
    super.initState();
    getAllChatbotMessages();
    _messageController = TextEditingController();
  }

  addMessage(String message, List<Message> messages) async {
    if (messages.length == 0) {
      String id = MiscUtils.getRandomId(6);
      await FirebaseFirestore.instance.collection('messaging').add({
        'user': userId,
        "time": Timestamp.now(),
        "sentBy": "user",
        "message": message,
        "convoId": id
      });
    } else {
      await FirebaseFirestore.instance.collection('messaging').add({
        'user': userId,
        "time": Timestamp.now(),
        "sentBy": "user",
        "message": message,
        "convoId": messages.first.convoId
      });
    }
    String tag = "greeting";
    String chatbotMessage =
        "We connected you with our support with. The representative will get back to you soon.";
    chatbotMessages.map((e) {
      if (e.tag == tag) {
        chatbotMessage = e.message;
      }
    }).toList();
    await FirebaseFirestore.instance.collection('messaging').add({
      'user': "chatbot",
      "time": Timestamp.now(),
      "sentBy": "chatbot",
      "message": chatbotMessage,
      "convoId": messages.first.convoId
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _customBottomNavBar() {
      return Container(
        height: 80,
        width: Get.width,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 8, bottom: 16),
                padding: const EdgeInsets.only(
                    left: 20.0, top: 8.0, right: 16.0, bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(fontSize: 16.0),
                  maxLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type Message",
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                String text = _messageController.text;
                if (text.length > 0) {
                  addMessage(text, messages);
                  _messageController.clear();
                  setState(() {});
                }
              },
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
        body: isLoad
            ? CustomLoading()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("messaging")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          messagingService.getAllMessage(snapshot, messages);

                          if (messages.length == 0) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.message,
                                      size: 36,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "Enter your query and we will try to resolve it.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "You can ask questions like -\nWhat does this application do?\nPayment options?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: messages.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return _MessageBubble(
                                    message: messages.toList()[index]);
                              },
                            );
                          }
                        } else {
                          return CustomLoading();
                        }
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
  final Message message;

  _MessageBubble({Key key, @required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: BubbleEdges.only(top: 20.0),
      alignment:
          "user" == message.sentBy ? Alignment.topRight : Alignment.topLeft,
      nipWidth: 12.0,
      nipHeight: 16.0,
      nip: "user" == message.sentBy
          ? BubbleNip.rightBottom
          : BubbleNip.leftBottom,
      color: "user" == message.sentBy ? Get.theme.primaryColor : Colors.white,
      padding: BubbleEdges.all(12.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
        child: Column(
          crossAxisAlignment: "user" == message.sentBy
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              textAlign:
                  "user" == message.sentBy ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: "user" != message.sentBy
                    ? Get.theme.primaryColor
                    : Colors.white,
                fontSize: 16.0,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              DateFormat('hh:mm').format(DateTime.now()),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: "user" != message.sentBy
                    ? Get.theme.primaryColor
                    : Colors.white,
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
