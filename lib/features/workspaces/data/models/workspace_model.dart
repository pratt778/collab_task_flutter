import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';

class WorkspaceModel {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final DateTime createdAt;

  const WorkspaceModel({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    required this.createdAt,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      ownerId: json['owner_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  WorkspaceEntity toEntity() {
    return WorkspaceEntity(
      id: id,
      name: name,
      description: description,
      ownerId: ownerId,
      createdAt: createdAt,
    );
  }
}
