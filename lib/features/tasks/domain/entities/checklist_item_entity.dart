import 'package:equatable/equatable.dart';

class ChecklistItemEntity extends Equatable {
  final String id;
  final String title;
  final bool completed;

  const ChecklistItemEntity({
    required this.id,
    required this.title,
    required this.completed,
  });

  @override
  List<Object?> get props => [id, title, completed];

  ChecklistItemEntity copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return ChecklistItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
