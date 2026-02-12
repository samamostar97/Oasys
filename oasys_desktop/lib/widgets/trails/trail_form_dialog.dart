import 'package:flutter/material.dart';
import 'package:oasys_core/oasys_core.dart';

import '../../utils/app_snackbars.dart';
import 'trail_form_fields.dart';

class TrailFormDialog extends StatefulWidget {
  const TrailFormDialog({super.key, this.item, this.onCreate, this.onUpdate});

  final TrailResponse? item;
  final Future<void> Function(CreateTrailRequest request)? onCreate;
  final Future<void> Function(UpdateTrailRequest request)? onUpdate;

  bool get isEditMode => item != null;

  @override
  State<TrailFormDialog> createState() => _TrailFormDialogState();
}

class _TrailFormDialogState extends State<TrailFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _cityController;
  late final TextEditingController _durationController;
  late final TextEditingController _distanceController;

  int? _selectedDifficulty;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    _cityController = TextEditingController(text: widget.item?.city ?? '');
    _durationController = TextEditingController(
      text: widget.item?.durationMinutes.toString() ?? '',
    );
    _distanceController = TextEditingController(
      text: widget.item != null
          ? widget.item!.distanceKm.toStringAsFixed(1)
          : '',
    );
    _selectedDifficulty = widget.item?.difficulty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _durationController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditMode ? 'Uredi stazu' : 'Nova staza'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: TrailFormFields(
              nameController: _nameController,
              descriptionController: _descriptionController,
              cityController: _cityController,
              durationController: _durationController,
              distanceController: _distanceController,
              selectedDifficulty: _selectedDifficulty,
              onDifficultyChanged: (value) {
                setState(() {
                  _selectedDifficulty = value;
                });
              },
              validateDuration: _validateDuration,
              validateDistance: _validateDistance,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Odustani'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.isEditMode ? 'Sacuvaj' : 'Kreiraj'),
        ),
      ],
    );
  }

  String? _validateDuration(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Trajanje je obavezno.';
    }

    final duration = int.tryParse(trimmed);
    if (duration == null) {
      return 'Trajanje mora biti cijeli broj.';
    }

    if (duration < 1 || duration > 10080) {
      return 'Trajanje mora biti izmedu 1 i 10080 minuta.';
    }

    return null;
  }

  String? _validateDistance(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Udaljenost je obavezna.';
    }

    final normalized = trimmed.replaceAll(',', '.');
    final distance = double.tryParse(normalized);
    if (distance == null) {
      return 'Udaljenost mora biti broj.';
    }

    if (distance < 0.1 || distance > 1000) {
      return 'Udaljenost mora biti izmedu 0.1 i 1000 km.';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final duration = int.tryParse(_durationController.text.trim());
    final distance = double.tryParse(
      _distanceController.text.trim().replaceAll(',', '.'),
    );

    if (duration == null || distance == null || _selectedDifficulty == null) {
      AppSnackbars.error(context, 'Provjerite unesene vrijednosti.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (widget.isEditMode) {
        final onUpdate = widget.onUpdate;
        if (onUpdate == null) {
          throw StateError('onUpdate callback nije postavljen.');
        }

        await onUpdate(
          UpdateTrailRequest(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            city: _cityController.text.trim(),
            durationMinutes: duration,
            distanceKm: distance,
            difficulty: _selectedDifficulty,
          ),
        );
      } else {
        final onCreate = widget.onCreate;
        if (onCreate == null) {
          throw StateError('onCreate callback nije postavljen.');
        }

        await onCreate(
          CreateTrailRequest(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            city: _cityController.text.trim(),
            durationMinutes: duration,
            distanceKm: distance,
            difficulty: _selectedDifficulty!,
          ),
        );
      }

      if (!mounted) {
        return;
      }

      AppSnackbars.success(
        context,
        widget.isEditMode
            ? 'Staza uspjesno izmijenjena.'
            : 'Staza uspjesno kreirana.',
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      AppSnackbars.error(context, error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppSnackbars.error(context, 'Doslo je do neocekivane greske.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
