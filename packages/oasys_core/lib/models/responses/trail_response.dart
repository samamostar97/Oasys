class TrailResponse {
  TrailResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.durationMinutes,
    required this.distanceKm,
    required this.difficulty,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String description;
  final String city;
  final int durationMinutes;
  final double distanceKm;
  final int difficulty;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory TrailResponse.fromJson(Map<String, dynamic> json) {
    return TrailResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? ''),
    );
  }
}
