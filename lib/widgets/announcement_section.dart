import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/models/announcement.dart';
import 'package:konnex_aerothon/screens/help/announcement_screen.dart';
import 'package:konnex_aerothon/services/help_service.dart';

class AnnouncementSection extends StatelessWidget {
  final bool removeSeen;
  final Function(Announcement announcement) onTap;
  const AnnouncementSection({Key key, bool removeSeen, this.onTap})
      : this.removeSeen = removeSeen ?? false,
        super(key: key);

  announcementWidget(Announcement announcement) {
    return InkWell(
      onTap: () {
        if (this.onTap == null) {
          this.onTap.call(announcement);
        }
        Get.to(AnnouncementScreen(announcement));
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          width: Get.width * 0.8,
          height: double.infinity,
          margin: EdgeInsets.only(right: 16),
          child: Image.network(
            announcement.image,
            fit: BoxFit.cover,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    HelpService helpService = HelpService();
    List<Announcement> announcements = [];

    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          helpService.getAllAnnouncements(snapshot, announcements);
          if (this.removeSeen) {
            announcements.removeWhere(
                (element) => helpService.isAnnouncementSeen(element.id));
          }
          if (announcements.isEmpty) return Container();
          return Container(
            height: 150,
            padding: EdgeInsets.only(top: 0, bottom: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  announcementWidget(announcements[index]),
              itemCount: announcements.length,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
      stream: FirebaseFirestore.instance.collection("announcement").snapshots(),
    );
  }
}
