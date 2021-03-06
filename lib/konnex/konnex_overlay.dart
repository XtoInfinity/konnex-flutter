part of 'konnex.dart';

class _KonnexBodyOverlay extends ModalRoute<void> {
  final String routeName;
  _KonnexBodyOverlay(this.routeName);

  @override
  Duration get transitionDuration => Duration(milliseconds: 250);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.4);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _KonnexBodyWidget(this.routeName),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class _KonnexBodyWidget extends StatefulWidget {
  final String routeName;

  const _KonnexBodyWidget(this.routeName, {Key key}) : super(key: key);
  @override
  __KonnexBodyWidgetState createState() => __KonnexBodyWidgetState();
}

class __KonnexBodyWidgetState extends State<_KonnexBodyWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            children: [
              _getSearchBox(),
              _getChipSection(),
              AnnouncementSection(
                removeSeen: true,
                onTap: (announcement) {
                  Navigator.of(context).pop();
                  Get.to(() => AnnouncementScreen(announcement));
                },
              ),
              Expanded(
                child: _NavigationOptionWidget(
                  filter: controller.text,
                  onNavigatePressed: (navigation) async {
                    LogUtil.instance.log('konnex', LogType.navigation,
                        'Navigation for ${navigation.title}');
                    Navigator.of(context).pop();
                    KonnexHandler.instance.startToolTipNavigation(
                        this.widget.routeName, navigation.steps.toList());
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                )),
          ),
        ],
      ),
    );
  }

  _getChip(String title, IconData icon, Function onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
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
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  _getChipSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.start,
        children: [
          _getChip(
            "Get Help",
            Icons.help_outline,
            () {
              Navigator.of(context).pop();
              Get.to(HelpScreen());
            },
          ),
          _getChip(
            "Play & Win",
            Icons.group_work_outlined,
            () {
              Navigator.of(context).pop();
              Get.to(PlayScreen());
            },
          ),
        ],
      ),
    );
  }

  _getSearchBox() {
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
                        controller: controller,
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your issue"),
                        textInputAction: TextInputAction.search,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSubmitted: (val) {
                          setState(() {});
                        },
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            controller.clear();
            setState(() {});
            String textFromSpeech = await Get.dialog(
              SpeechOverlay(),
            );
            if (textFromSpeech != null) {
              controller.text = textFromSpeech;
              setState(() {});

              LogUtil.instance
                  .log('konnex', LogType.search_navigation, '$textFromSpeech');
            }
          },
          child: Container(
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
          ),
        )
      ],
    );
  }
}

class _NavigationOptionWidget extends StatelessWidget {
  final Function(NavigationObject navigation) onNavigatePressed;
  final String filter;

  const _NavigationOptionWidget({
    Key key,
    @required this.onNavigatePressed,
    String filter,
  })  : this.filter = filter ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NavigationObject>>(
        future: KonnexHandler.instance.fetchAllNavigationOjects(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Fetching data ....');
          }
          List<NavigationObject> navObjects = snapshot.data.toList();
          if (this.filter.isNotEmpty) {
            navObjects.retainWhere((nav) {
              int similarity = partialRatio(nav.title, this.filter);
              return similarity > 50;
            });
            print('Filtering for: ${this.filter}');
          }
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: navObjects.length,
              padding: EdgeInsets.only(bottom: 40),
              itemBuilder: (context, index) {
                final navObject = navObjects.elementAt(index);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: Card(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                navObject.title,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                this.onNavigatePressed?.call(navObject);
                              },
                              child: Text(
                                "Navigate",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
