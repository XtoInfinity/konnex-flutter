// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationObject _$NavigationObjectFromJson(Map<String, dynamic> json) {
  return NavigationObject(
    title: json['title'] as String,
    steps: (json['steps'] as List)
            ?.map((e) => e == null
                ? null
                : InstructionSet.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$NavigationObjectToJson(NavigationObject instance) =>
    <String, dynamic>{
      'title': instance.title,
      'steps': instance.steps?.map((e) => e?.toJson())?.toList(),
    };

