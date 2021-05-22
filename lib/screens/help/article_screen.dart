import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:konnex_aerothon/models/article.dart';
import 'package:konnex_aerothon/utils/log_util.dart';

class ArticleScreen extends StatefulWidget {
  static const String routeName = '/ArticleScreen';
  final Article article;

  ArticleScreen(this.article);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  void initState() {
    LogUtil.instance.log(ArticleScreen.routeName, LogType.open_screen,
        'Opened ${ArticleScreen.routeName}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.article.image),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.article.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            widget.article.createdAt.millisecondsSinceEpoch *
                                1000),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.article.description,
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
