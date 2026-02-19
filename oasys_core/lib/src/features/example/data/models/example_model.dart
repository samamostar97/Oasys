import '../../domain/entities/example.dart';

class ExampleModel extends Example {
  const ExampleModel({
    required super.id, required super.title, required super.description,
    required super.isActive, required super.createdAt,
  });

  factory ExampleModel.fromJson(Map<String, dynamic> json) => ExampleModel(
    id:          json['id']          as String,
    title:       json['title']       as String,
    description: json['description'] as String? ?? '',
    isActive:    json['isActive']    as bool?   ?? true,
    createdAt:   DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description,
    'isActive': isActive, 'createdAt': createdAt.toIso8601String(),
  };
}
