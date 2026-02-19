import 'package:flutter/material.dart';
class ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;
  const ExampleCard({super.key, required this.title, required this.description, this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
