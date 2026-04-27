import 'package:flutter_clean_starter/features/demo/domain/entities/demo_entity.dart';

class DemoModel {
  final int id;
  final String title;
  final String body;

  const DemoModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory DemoModel.fromJson(Map<String, dynamic> json) {
    return DemoModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  DemoEntity toEntity() => DemoEntity(id: id, title: title, body: body);
}
