part of 'konnex.dart';

class _KonnexBodyOverlay extends ModalRoute<void> {
  final String routeName;

  _KonnexBodyOverlay(this.routeName);

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

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
              Expanded(child: _NavigationOptionWidget(
                onNavigatePressed: (navigation) {
                  KonnexHandler.instance.startToolTipNavigation(
                      context, this.widget.routeName, navigation.steps);
                },
              )),
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
              "Get Help", Icons.help_outline, () => Get.to(MessageScreen())),
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
                        // autofocus: true,
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
}

class _NavigationOptionWidget extends StatelessWidget {
  final Function(NavigationObject navigation) onNavigatePressed;

  const _NavigationOptionWidget({Key key, @required this.onNavigatePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NavigationObject>>(
        future: KonnexHandler.instance.fetchAllNavigationOjects(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Fetching data ....');
          }
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final navObject = snapshot.data.elementAt(index);
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
