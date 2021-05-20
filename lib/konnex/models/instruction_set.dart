import 'package:json_annotation/json_annotation.dart';

import 'instruction.dart';

part 'instruction_set.g.dart';

@JsonSerializable(explicitToJson: true)
class InstructionSet {
  /// Page Name
  final String uniqueRouteName;

  /// Duation of time this instruction is to be shown over the screen
  final List<Instruction> instructions;

  InstructionSet({this.uniqueRouteName, this.instructions});

  factory InstructionSet.fromJson(Map<String, dynamic> json) =>
      _$InstructionSetFromJson(json);
  Map<String, dynamic> toJson() => _$InstructionSetToJson(this);
}
