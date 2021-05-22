import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';
import 'package:konnex_aerothon/models/announcement.dart';
import 'package:konnex_aerothon/screens/help/announcement_screen.dart';
import 'package:konnex_aerothon/screens/help/help_screen.dart';
import 'package:konnex_aerothon/services/help_service.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:konnex_aerothon/screens/playwin/play_screen.dart';
import 'package:konnex_aerothon/utils/speech_overlay.dart';

import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:konnex_aerothon/widgets/announcement_section.dart';

import 'models/instruction_set.dart';
import 'konnex_handler.dart';

part 'konnex_overlay.dart';

class KonnexWidget extends StatefulWidget {
  final String currentRoute;
  final Color color;

  const KonnexWidget(
      {Key key, @required this.currentRoute, this.color = Colors.white})
      : super(key: key);

  @override
  _KonnexWidgetState createState() => _KonnexWidgetState();
}

class _KonnexWidgetState extends State<KonnexWidget> {
  bool isOpen;
  StreamSubscription annStreamSubscription;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allAnnouncements;

  @override
  void initState() {
    this.isOpen = false;
    this.allAnnouncements = [];

    // this.updateAnnouncementCount();
    // this.listenToSeenAnnouncement();

    LogUtil.instance.log(this.widget.currentRoute, LogType.open_screen,
        'Opened ${this.widget.currentRoute}');

    super.initState();
  }

  // List<QueryDocumentSnapshot<Map<String, dynamic>>> get unSeenAnnouncements {
  //   final announcements = this.allAnnouncements;
  //   announcements.retainWhere((element) {
  //     final Map<String, dynamic> data = element.data();
  //     return !HelpService().isAnnouncementSeen(data['id']);
  //   });
  //   return announcements;
  // }

  // updateAnnouncementCount() {
  //   this.annStreamSubscription = FirebaseFirestore.instance
  //       .collection("announcement")
  //       .snapshots()
  //       .listen((event) {
  //     try {
  //       if (event?.docs?.isNotEmpty ?? false) {
  //         String appId = GetStorage().read('appId');
  //         final list = event.docs.toList();
  //         list.retainWhere((element) => element.data()['appId'] == appId);
  //         this.allAnnouncements = list;
  //         if (this.mounted) {
  //           setState(() {});
  //         }
  //       }
  //     } catch (e) {
  //       LogUtil.instance
  //           .log('konnex', LogType.error, 'Error listening to stream.');
  //     }
  //   });
  // }

  // listenToSeenAnnouncement() {
  //   GetStorage().listenKey('seen-announcements', (data) {
  //     if (this.mounted) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         setState(() {});
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    /// Resume any tooltip navigation if present
    WidgetsBinding.instance.addPostFrameCallback((_) {
      KonnexHandler.instance.resumeToolTipNavIfAny(
        context,
        this.widget.currentRoute,
      );
    });

    return Visibility(
      visible: !this.isOpen,
      child: FloatingActionButton(
        backgroundColor: widget.color,
        onPressed: () {
          this.onToggle();
        },
        child: Badge(
          showBadge:
              false, // (!this.isOpen && this.unSeenAnnouncements.isNotEmpty),
          // badgeContent: Text(
          //   '${this.unSeenAnnouncements.length}',
          //   style: TextStyle(
          //     color: Colors.white,
          //   ),
          // ),
          child: Image.asset(
            "assets/images/logo.png",
            height: 60,
          ),
        ),
      ),
    );
  }

  Future<void> onToggle() async {
    this.isOpen = !this.isOpen;
    setState(() {});
    if (this.isOpen) {
      await Navigator.of(context)
          .push(_KonnexBodyOverlay(this.widget.currentRoute));
      if (this.mounted && this.isOpen) {
        this.onToggle();
      }
    } else {
      Navigator.of(context).popUntil((route) => route.isCurrent);
    }
  }

  @override
  void dispose() {
    this.annStreamSubscription?.cancel();
    super.dispose();
  }
}
