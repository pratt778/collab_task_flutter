import 'package:json_annotation/json_annotation.dart';
import 'package:collab_task/features/tasks/data/models/checklist_item_model.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final List<String> assignees;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> labels;
  final List<ChecklistItemModel> checklist;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignees,
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
        title: title,
        description: description,
        status: status,
        assignees: assignees,
        dueDate: dueDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        labels: labels,
        checklist: checklist.map((e) => e.toEntity()).toList(),
      );

  factory TaskModel.fromEntity(TaskEntity entity) => TaskModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        status: entity.status,
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
