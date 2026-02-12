import 'package:flutter/material.dart';
import 'package:oasys_core/oasys_core.dart';

class TrailTable extends StatelessWidget {
  const TrailTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<TrailResponse> items;
  final ValueChanged<TrailResponse> onEdit;
  final ValueChanged<TrailResponse> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              columns: const [
                DataColumn(label: Text('Naziv')),
                DataColumn(label: Text('Grad')),
                DataColumn(label: Text('Tezina')),
                DataColumn(label: Text('Trajanje')),
                DataColumn(label: Text('Udaljenost')),
                DataColumn(label: Text('Kreirano')),
                DataColumn(label: Text('Akcije')),
              ],
              rows: items
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 220,
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(
                              item.city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(_difficultyLabel(item.difficulty))),
                        DataCell(Text('${item.durationMinutes} min')),
                        DataCell(
                          Text('${item.distanceKm.toStringAsFixed(1)} km'),
                        ),
                        DataCell(Text(DateFormatter.date(item.createdAt))),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Uredi',
                                onPressed: () => onEdit(item),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                tooltip: 'Obrisi',
                                onPressed: () => onDelete(item),
                                color: Theme.of(context).colorScheme.error,
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
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
