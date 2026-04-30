import 'package:json_annotation/json_annotation.dart';
import 'package:collab_task/features/tasks/domain/entities/checklist_item_entity.dart';

part 'checklist_item_model.g.dart';

@JsonSerializable()
class ChecklistItemModel {
  final String id;
  final String title;
  final bool completed;

  const ChecklistItemModel({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistItemModelToJson(this);

  ChecklistItemEntity toEntity() => ChecklistItemEntity(
        id: id,
        title: title,
        completed: completed,
      );

  factory ChecklistItemModel.fromEntity(ChecklistItemEntity entity) =>
      ChecklistItemModel(
        id: entity.id,
        title: entity.title,
        completed: entity.completed,
      );
}
