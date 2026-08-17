// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistItemModel _$ChecklistItemModelFromJson(Map<String, dynamic> json) =>
    ChecklistItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$ChecklistItemModelToJson(ChecklistItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
    };
