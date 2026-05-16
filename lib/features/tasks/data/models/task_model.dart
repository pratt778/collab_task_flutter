import 'package:json_annotation/json_annotation.dart';
import 'package:collab_task/features/tasks/data/models/checklist_item_model.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

part 'task_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TaskModel {
  final String id;
  final String workspaceId;
  final String title;
  final String description;
  final TaskStatus status;
  final String createdBy;
  @JsonKey(includeToJson: false)
  final List<String> assignees;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> labels;
  final List<ChecklistItemModel> checklist;

  const TaskModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    this.assignees = const [],
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.labels,
    required this.checklist,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskEntity toEntity() => TaskEntity(
        id: id,
        workspaceId: workspaceId,
        title: title,
        description: description,
        status: status,
        createdBy: createdBy,
        assignees: assignees,
        dueDate: dueDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        labels: labels,
        checklist: checklist.map((e) => e.toEntity()).toList(),
      );

  factory TaskModel.fromEntity(TaskEntity entity) => TaskModel(
        id: entity.id,
        workspaceId: entity.workspaceId,
        title: entity.title,
        description: entity.description,
        status: entity.status,
        createdBy: entity.createdBy,
        assignees: entity.assignees,
        dueDate: entity.dueDate,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        labels: entity.labels,
        checklist: entity.checklist
            .map(ChecklistItemModel.fromEntity)
            .toList(),
      );
}
