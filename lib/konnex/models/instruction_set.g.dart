// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructionSet _$InstructionSetFromJson(Map<String, dynamic> json) {
  return InstructionSet(
    uniqueRouteName: json['uniqueRouteName'] as String,
    instructions: (json['instructions'] as List)
        ?.map((e) =>
            e == null ? null : Instruction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$InstructionSetToJson(InstructionSet instance) =>
    <String, dynamic>{
      'uniqueRouteName': instance.uniqueRouteName,
      'instructions': instance.instructions?.map((e) => e?.toJson())?.toList(),
    };
