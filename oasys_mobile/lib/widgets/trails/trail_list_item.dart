import 'package:flutter/material.dart';
import 'package:oasys_core/oasys_core.dart';

class TrailListItem extends StatelessWidget {
  const TrailListItem({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final TrailResponse item;
  final ValueChanged<TrailResponse> onEdit;
  final ValueChanged<TrailResponse> onDelete;

  @override
  Widget build(BuildContext context) {
    final difficultyLabel = _difficultyLabel(item.difficulty);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit(item);
                      return;
                    }
                    onDelete(item);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(value: 'edit', child: Text('Uredi')),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Obrisi'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(difficultyLabel),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text('${item.distanceKm.toStringAsFixed(1)} km'),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text('${item.durationMinutes} min'),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(DateFormatter.date(item.createdAt)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _difficultyLabel(int value) {
    return switch (value) {
      1 => 'Easy',
      2 => 'Medium',
      3 => 'Hard',
      _ => 'Nepoznato',
    };
  }
}
