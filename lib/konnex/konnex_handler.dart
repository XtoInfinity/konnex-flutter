import 'package:flutter/material.dart';
import 'package:konnex_aerothon/util/log_util.dart';
import 'package:render_metrics/render_metrics.dart';

import 'models/instruction.dart';
import 'models/instruction_set.dart';

part 'overlay_screen.dart';

class KonnexHandler {
  static KonnexHandler instance = KonnexHandler._();

  final _renderManager = RenderParametersManager<String>();

  RenderParametersManager get manager => this._renderManager;

  KonnexHandler._();

  List<InstructionSet> _currInstructionSet = [];

  void startToolTipNavigation(BuildContext context, String routeName,
      List<InstructionSet> setOfInstructions) {
    this._currInstructionSet = setOfInstructions;
    this.resumeToolTipNavIfAny(context, routeName);
  }

  Future<void> resumeToolTipNavIfAny(
      BuildContext context, String routeName) async {
    // If there are no instructions, Don't do anything
    if (this._currInstructionSet.isEmpty) return;
    final instructionSet = this._currInstructionSet.first;

    /// If the user is not on the correct screen, the navigation guide won't
    /// do anything
    if (instructionSet.uniqueRouteName != routeName) {
      return;
    }
    List<Instruction> firstSet = instructionSet.instructions;
    // Get the top padding of the screen to eliminate it from the y coordinate.
    final topPadding = MediaQuery.of(context).padding.top;
    for (var i = 0; i < firstSet.length; i++) {
      final instruction = firstSet.elementAt(i);
      if (instruction == null) {
        LogUtil.instance.log('instruction null: ${instruction.toString()}');
        continue;
      }
      if (instruction is InstructionById) {
        RenderData data = _renderManager.getRenderData(instruction.id);
        if (data == null) {
          LogUtil.instance
              ?.log('instruction id not present: ${instruction.toString()}');
        }
        await Navigator.of(context).push(_OverlayScreen(
          data.xCenter,
          data.yCenter - topPadding,
          Duration(milliseconds: instruction.waitInMils),
          color: Colors.red,
          size: 20,
        ));
      } else if (instruction is InstructionByCoordinate) {
      } else {
        throw UnimplementedError();
      }
    }
    this._currInstructionSet.removeAt(0);
  }
}
