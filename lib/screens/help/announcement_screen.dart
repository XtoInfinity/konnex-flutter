import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:konnex_aerothon/models/announcement.dart';
import 'package:konnex_aerothon/services/help_service.dart';
import 'package:konnex_aerothon/utils/log_util.dart';

class AnnouncementScreen extends StatelessWidget {
  static const String routeName = '/AnnouncementScreen';

  final Announcement announcement;

  AnnouncementScreen(this.announcement) {
    LogUtil.instance.log(routeName, LogType.open_screen, 'Opened $routeName');
    HelpService().markAnnouncementAsSeen(this.announcement.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Announcement",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(announcement.image),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      announcement.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            announcement.createdAt.millisecondsSinceEpoch *
                                1000),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      announcement.description,
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
