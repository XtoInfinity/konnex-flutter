import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/konnex/models/poll.dart';
import 'package:konnex_aerothon/widgets/loading.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  List<Poll> polls = [];
  bool isLoad = true;

  getAllPolls() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("poll").get();
    snapshot.docs.map((e) => polls.add(Poll.fromJson(e.data(), e.id))).toList();
    isLoad = false;
    setState(() {});
  }

  pollCard(Poll poll) {
    String answer;
    String userId = GetStorage().read("userId");
    poll.attemptedUsers.map((e) {
      if (e.id == userId) {
        answer = e.answer;
      }
    }).toList();
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poll.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(poll.description),
            SizedBox(
              height: 16,
            ),
            Column(
              children: poll.options.map((e) {
                return Card(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: Material(
                      color: answer != e.optionName
                          ? Colors.transparent
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      child: RadioListTile(
                        onChanged: (val) {
                          if (answer == null) {
                            poll.attemptedUsers
                                .add(UserAnswer(answer: val, id: userId));
                            setState(() {});
                            FirebaseFirestore.instance
                                .collection("poll")
                                .doc(poll.docId)
                                .update({
                              "attemptedUsers": poll.attemptedUsers
                                  .map((e) => e.toJson())
                                  .toList()
                            });
                          }
                        },
                        title: Text(e.optionName),
                        groupValue: answer,
                        value: e.optionName,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPolls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Play & Win",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: isLoad
          ? CustomLoading()
          : ListView.builder(
              itemBuilder: (context, index) => pollCard(polls[index]),
              itemCount: polls.length,
            ),
    );
  }
}
