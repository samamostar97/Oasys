class UpdateTrailRequest {
  UpdateTrailRequest({
    this.name,
    this.description,
    this.city,
    this.durationMinutes,
    this.distanceKm,
    this.difficulty,
  });

  final String? name;
  final String? description;
  final String? city;
  final int? durationMinutes;
  final double? distanceKm;
  final int? difficulty;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (city != null) 'city': city,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      if (distanceKm != null) 'distanceKm': distanceKm,
      if (difficulty != null) 'difficulty': difficulty,
    };
  }
}
