import 'package:json_annotation/json_annotation.dart';

import 'instruction.dart';

part 'instruction_set.g.dart';

@JsonSerializable(explicitToJson: true)
class NavigationObject {
  String title;
  @JsonKey(defaultValue: [])
  List<InstructionSet> steps;

  NavigationObject({this.title, this.steps});

  factory NavigationObject.fromJson(Map<String, dynamic> json) =>
      _$NavigationObjectFromJson(json);
  Map<String, dynamic> toJson() => _$NavigationObjectToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InstructionSet {
  /// Page Name
  final String uniqueRouteName;

  /// Duation of time this instruction is to be shown over the screen
  @JsonKey(defaultValue: [])
  final List<Instruction> instructions;

  InstructionSet({this.uniqueRouteName, this.instructions});

  factory InstructionSet.fromJson(Map<String, dynamic> json) {
    return InstructionSet(
      uniqueRouteName: json['uniqueRouteName'] as String,
      instructions: (json['instructions'] as List)?.map((e) {
            if (e == null) return null;
            final data = e as Map<String, dynamic>;
            if (data.containsKey('id')) {
              return InstructionById.fromJson(e as Map<String, dynamic>);
            } else if (data.containsKey('x')) {
              return InstructionByCoordinate.fromJson(
                  e as Map<String, dynamic>);
            } else {
              return null;
            }
          })?.toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => _$InstructionSetToJson(this);
}
