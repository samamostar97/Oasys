import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExampleListScreen extends ConsumerWidget {
  const ExampleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Examples')),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.add)),
      body: const Center(child: Text('Wire up your provider here')),
    );
  }
}
