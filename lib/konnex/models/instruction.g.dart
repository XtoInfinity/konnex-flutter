// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructionById _$InstructionByIdFromJson(Map<String, dynamic> json) {
  return InstructionById(
    json['id'] as String,
    description: json['description'] as String,
    waitInMils: json['waitInMils'] as int,
  );
}

Map<String, dynamic> _$InstructionByIdToJson(InstructionById instance) =>
    <String, dynamic>{
      'description': instance.description,
      'waitInMils': instance.waitInMils,
      'id': instance.id,
    };

InstructionByCoordinate _$InstructionByCoordinateFromJson(
    Map<String, dynamic> json) {
  return InstructionByCoordinate(
    (json['x'] as num)?.toDouble(),
    (json['y'] as num)?.toDouble(),
    description: json['description'] as String,
    waitInMils: json['waitInMils'] as int,
  );
}

Map<String, dynamic> _$InstructionByCoordinateToJson(
        InstructionByCoordinate instance) =>
    <String, dynamic>{
      'description': instance.description,
      'waitInMils': instance.waitInMils,
      'x': instance.x,
      'y': instance.y,
    };
