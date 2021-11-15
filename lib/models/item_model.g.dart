// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Item _$_$_ItemFromJson(Map<String, dynamic> json) {
  return _$_Item(
    id: json['id'] as String?,
    name: json['name'] as String,
    category: json['category'] as String?,
    obtained: json['obtained'] as bool? ?? false,
    weekly: json['weekly'] as bool? ?? false,
    toBuy: json['toBuy'] as bool? ?? false,
  );
}

Map<String, dynamic> _$_$_ItemToJson(_$_Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'obtained': instance.obtained,
      'weekly': instance.weekly,
      'toBuy': instance.toBuy,
    };
