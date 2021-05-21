import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';
import 'package:konnex_aerothon/screens/messaging/message_screen.dart';

import 'models/instruction.dart';
import 'models/instruction_set.dart';
import 'konnex_handler.dart';

part 'konnex_overlay.dart';

class KonnexWidget extends StatefulWidget {
  final String currentRoute;
  final Color color;

  const KonnexWidget(
      {Key key, @required this.currentRoute, this.color = Colors.transparent})
      : super(key: key);

  @override
  _KonnexWidgetState createState() => _KonnexWidgetState();
}

class _KonnexWidgetState extends State<KonnexWidget> {
  bool isOpen;

  @override
  void initState() {
    this.isOpen = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Resume any tooltip navigation if present
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        child: Image.asset(
          "assets/images/logo.png",
          height: 60,
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

  mockNavigation() {
    KonnexHandler.instance.startToolTipNavigation(this.widget.currentRoute, [
      InstructionSet(
        uniqueRouteName: '0',
        instructions: [
          InstructionById('1'),
          InstructionById('2'),
          InstructionById('3'),
        ],
      ),
      InstructionSet(
        uniqueRouteName: '2',
        instructions: [
          InstructionById('1'),
          InstructionById('2'),
          InstructionById('3'),
        ],
      ),
      InstructionSet(
        uniqueRouteName: '3',
        instructions: [
          InstructionById('1'),
          InstructionById('2'),
          InstructionById('3'),
        ],
      ),
    ]);
  }
}
