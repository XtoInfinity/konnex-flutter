import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:render_metrics/render_metrics.dart';

import 'models/instruction.dart';
import 'models/instruction_set.dart';

part 'tool_tip_overlay.dart';

class KonnexHandler {
  static KonnexHandler instance = KonnexHandler._();

  final _renderManager = RenderParametersManager<String>();

  RenderParametersManager get manager => this._renderManager;

  List<NavigationObject> _navObjects;

  KonnexHandler._() {
    this.fetchAllNavigationOjects();
  }

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
              ?.log('Instruction id not present: ${instruction.toString()}');
        }
        await Navigator.of(context).push(_ToolTipOverlay(
          data.xCenter,
          data.yCenter - topPadding,
          Duration(milliseconds: instruction.waitInMils),
          color: Colors.red,
          size: 20,
        ));
      } else if (instruction is InstructionByCoordinate) {
        await Navigator.of(context).push(_ToolTipOverlay(
          instruction.x,
          instruction.y - topPadding,
          Duration(milliseconds: instruction.waitInMils),
          color: Colors.red,
          size: 20,
        ));
      } else {
        throw UnimplementedError();
      }
    }
    this._currInstructionSet.removeAt(0);
  }

  /// Returns all the navigation objects for this particular screen
  Future<List<NavigationObject>> fetchAllNavigationOjects() async {
    if (this._navObjects != null) return this._navObjects;
    final String appId = 'pa5309JvtnfFLqwNCJr5';
    final snapshot = await FirebaseFirestore.instance
        .collection('application/$appId/navigations/')
        .get();
    this._navObjects = snapshot?.docs?.map((doc) {
      final json = doc.data();
      return NavigationObject.fromJson(json);
    })?.toList();
    this._navObjects?.removeWhere((element) => element == null);
    print("${this._navObjects.toString()}");
    return this._navObjects;
  }
}
