class Example {
  final String   id;
  final String   title;
  final String   description;
  final bool     isActive;
  final DateTime createdAt;

  const Example({
    required this.id, required this.title, required this.description,
    required this.isActive, required this.createdAt,
  });
}
