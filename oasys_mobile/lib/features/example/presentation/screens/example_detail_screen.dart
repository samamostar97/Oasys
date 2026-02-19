import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExampleDetailScreen extends ConsumerWidget {
  final String id;
  const ExampleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Detail')),
    body: Center(child: Text('ID: $id')),
  );
}
