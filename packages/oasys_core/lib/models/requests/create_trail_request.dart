class CreateTrailRequest {
  CreateTrailRequest({
    required this.name,
    required this.description,
    required this.city,
    required this.durationMinutes,
    required this.distanceKm,
    required this.difficulty,
  });

  final String name;
  final String description;
  final String city;
  final int durationMinutes;
  final double distanceKm;
  final int difficulty;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'city': city,
      'durationMinutes': durationMinutes,
      'distanceKm': distanceKm,
      'difficulty': difficulty,
    };
  }
}
