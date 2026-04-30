import 'package:equatable/equatable.dart';
import 'package:collab_task/features/tasks/domain/entities/checklist_item_entity.dart';

enum TaskStatus { todo, inProgress, done }

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final List<String> assignees;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> labels;
  final List<ChecklistItemEntity> checklist;

  const TaskEntity({
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        assignees,
        dueDate,
        createdAt,
        updatedAt,
        labels,
        checklist,
      ];

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    List<String>? assignees,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? labels,
    List<ChecklistItemEntity>? checklist,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignees: assignees ?? this.assignees,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      labels: labels ?? this.labels,
      checklist: checklist ?? this.checklist,
    );
  }
}
