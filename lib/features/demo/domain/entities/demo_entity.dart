import 'package:equatable/equatable.dart';

/// Placeholder entity. Delete or replace when you build your real first feature.
class DemoEntity extends Equatable {
  final int id;
  final String title;
  final String body;

  const DemoEntity({
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [id, title, body];
}
