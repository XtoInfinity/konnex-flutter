import 'package:json_annotation/json_annotation.dart';

part 'instruction.g.dart';

abstract class Instruction {
  /// Desription to the instruction
  String description;

  /// Duration of time this instruction is to be shown over the screen
  int waitInMils;

  Instruction({this.description, int waitInMils})
      : this.waitInMils = waitInMils ?? 1500;

  Map<String, dynamic> toJson();
}

@JsonSerializable(explicitToJson: true)
class InstructionById extends Instruction {
  /// Id of the widget
  String id;

  InstructionById(this.id, {String description, int waitInMils})
      : super(description: description, waitInMils: waitInMils);

  factory InstructionById.fromJson(Map<String, dynamic> json) =>
      _$InstructionByIdFromJson(json);
  Map<String, dynamic> toJson() => _$InstructionByIdToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InstructionByCoordinate extends Instruction {
  /// X coordinate of widget
  double x;

  /// X coordinate of widget
  double y;

  InstructionByCoordinate(this.x, this.y, {String description, int waitInMils})
      : super(description: description, waitInMils: waitInMils);

  factory InstructionByCoordinate.fromJson(Map<String, dynamic> json) =>
      _$InstructionByCoordinateFromJson(json);
  Map<String, dynamic> toJson() => _$InstructionByCoordinateToJson(this);
}
