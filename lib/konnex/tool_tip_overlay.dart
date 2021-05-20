part of 'konnex_handler.dart';

class _ToolTipOverlay extends ModalRoute<void> {
  final double x;
  final double y;
  final Duration wait;
  final double size;
  final Color color;
  _ToolTipOverlay(
    this.x,
    this.y,
    this.wait, {
    this.size = 30,
    this.color = Colors.white,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.transparent; // .black.withOpacity(0.5);

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
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    this.popAfterWait(context);
    return Stack(
      children: [
        Positioned(
          left: x - this.size / 2,
          top: y - this.size / 2,
          child: _RippleContainer(
            size: this.size,
            borderColor: this.color,
          ),
        )
      ],
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

  void popAfterWait(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(this.wait);
      if (this.isCurrent) {
        Navigator.of(context).pop();
      }
    });
  }
}

class _RippleContainer extends StatefulWidget {
  final double size;
  final Color borderColor;

  const _RippleContainer({
    Key key,
    @required this.size,
    @required this.borderColor,
  }) : super(key: key);

  @override
  __RippleContainerState createState() => __RippleContainerState();
}

class __RippleContainerState extends State<_RippleContainer>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    this._controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.size,
      height: this.widget.size,
      child: AnimatedBuilder(
        animation: CurvedAnimation(
            parent: this._controller, curve: Curves.fastOutSlowIn),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildContainer(this.widget.size * 0.7 * this._controller.value),
              _buildContainer(this.widget.size),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: this.widget.borderColor, width: 2),
      ),
    );
  }

  @override
  dispose() {
    this._controller.dispose();
    super.dispose();
  }
}
