import 'package:flutter/material.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';

import 'models/instruction.dart';
import 'models/instruction_set.dart';
import 'konnex_handler.dart';

class KonnexWidget extends StatelessWidget {
  final String currentRoute;

  const KonnexWidget({Key key, @required this.currentRoute}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        KonnexHandler.instance.resumeToolTipNavIfAny(
          context,
          this.currentRoute,
        );
      });
      return FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          KonnexHandler.instance
              .startToolTipNavigation(context, this.currentRoute, [
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
        },
        child: Image.asset(
          "assets/images/logo.png",
          height: 60,
        ),
      );
    });
  }
}
