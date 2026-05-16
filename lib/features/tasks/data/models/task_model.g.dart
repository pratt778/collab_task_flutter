// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: json['id'] as String,
  workspaceId: json['workspace_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  createdBy: json['created_by'] as String,
  assignees:
      (json['assignees'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  labels: (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
  checklist: (json['checklist'] as List<dynamic>)
      .map((e) => ChecklistItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'workspace_id': instance.workspaceId,
  'title': instance.title,
  'description': instance.description,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'created_by': instance.createdBy,
  'due_date': instance.dueDate?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'labels': instance.labels,
  'checklist': instance.checklist,
};

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.done: 'done',
};
