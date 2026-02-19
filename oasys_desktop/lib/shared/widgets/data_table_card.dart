import 'package:flutter/material.dart';

class DataTableCard<T> extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T>) rowBuilder;
  final List<T> items;
  final VoidCallback? onAdd;

  const DataTableCard({super.key, required this.title, required this.columns,
      required this.rowBuilder, required this.items, this.onAdd});

  @override
  Widget build(BuildContext context) => Card(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (onAdd != null)
            ElevatedButton.icon(onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18), label: const Text('Add')),
        ]),
      ),
      const Divider(height: 1),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(columns: columns, rows: rowBuilder(items))),
    ]),
  );
}
