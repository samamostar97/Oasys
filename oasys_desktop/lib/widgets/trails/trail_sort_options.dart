class TrailSortOption {
  const TrailSortOption({
    required this.key,
    required this.label,
    required this.sortBy,
    required this.descending,
  });

  final String key;
  final String label;
  final String? sortBy;
  final bool descending;
}

const List<TrailSortOption> trailSortOptions = [
  TrailSortOption(
    key: 'created_desc',
    label: 'Najnovije',
    sortBy: 'createdAt',
    descending: true,
  ),
  TrailSortOption(
    key: 'created_asc',
    label: 'Najstarije',
    sortBy: 'createdAt',
    descending: false,
  ),
  TrailSortOption(
    key: 'name_asc',
    label: 'Naziv A-Z',
    sortBy: 'name',
    descending: false,
  ),
  TrailSortOption(
    key: 'name_desc',
    label: 'Naziv Z-A',
    sortBy: 'name',
    descending: true,
  ),
  TrailSortOption(
    key: 'distance_asc',
    label: 'Udaljenost uzlazno',
    sortBy: 'distance',
    descending: false,
  ),
  TrailSortOption(
    key: 'distance_desc',
    label: 'Udaljenost silazno',
    sortBy: 'distance',
    descending: true,
  ),
  TrailSortOption(
    key: 'duration_asc',
    label: 'Trajanje uzlazno',
    sortBy: 'duration',
    descending: false,
  ),
  TrailSortOption(
    key: 'duration_desc',
    label: 'Trajanje silazno',
    sortBy: 'duration',
    descending: true,
  ),
];
