import 'package:flutter/material.dart';

Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  required String entityName,
  String? itemName,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Potvrda brisanja'),
        content: Text(
          itemName != null
              ? 'Da li ste sigurni da zelite obrisati $entityName "$itemName"?'
              : 'Da li ste sigurni da zelite obrisati ovaj $entityName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Odustani'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Obrisi'),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
