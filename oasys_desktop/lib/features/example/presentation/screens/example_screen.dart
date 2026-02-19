import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/layout/app_shell.dart';
import '../../../../shared/widgets/data_table_card.dart';

class ExampleScreen extends ConsumerStatefulWidget {
  const ExampleScreen({super.key});
  @override
  ConsumerState<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends ConsumerState<ExampleScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => AppShell(
    selectedIndex: _index,
    onDestinationSelected: (i) => setState(() => _index = i),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: DataTableCard<String>(
        title: 'Examples',
        items: const [],
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Created At')),
          DataColumn(label: Text('Actions')),
        ],
        rowBuilder: (items) => items.map((item) => DataRow(cells: [
          DataCell(Text(item)),
          const DataCell(Text('-')),
          const DataCell(Text('-')),
          DataCell(IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () {})),
        ])).toList(),
        onAdd: () {},
      ),
    ),
  );
}
