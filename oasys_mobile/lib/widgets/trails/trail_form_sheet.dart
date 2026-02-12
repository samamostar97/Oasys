import 'package:flutter/material.dart';
import 'package:oasys_core/oasys_core.dart';

import '../../utils/app_snackbars.dart';
import 'trail_form_fields.dart';
import 'trail_form_validators.dart';

Future<bool?> showTrailFormSheet(
  BuildContext context, {
  TrailResponse? item,
  Future<void> Function(CreateTrailRequest request)? onCreate,
  Future<void> Function(UpdateTrailRequest request)? onUpdate,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return _TrailFormSheet(
        item: item,
        onCreate: onCreate,
        onUpdate: onUpdate,
      );
    },
  );
}

class _TrailFormSheet extends StatefulWidget {
  const _TrailFormSheet({required this.item, this.onCreate, this.onUpdate});

  final TrailResponse? item;
  final Future<void> Function(CreateTrailRequest request)? onCreate;
  final Future<void> Function(UpdateTrailRequest request)? onUpdate;

  bool get isEditMode => item != null;

  @override
  State<_TrailFormSheet> createState() => _TrailFormSheetState();
}

class _TrailFormSheetState extends State<_TrailFormSheet> {
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.isEditMode ? 'Uredi stazu' : 'Nova staza',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TrailFormFields(
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
                  validateDuration: TrailFormValidators.duration,
                  validateDistance: TrailFormValidators.distance,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(false),
                        child: const Text('Odustani'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(widget.isEditMode ? 'Sacuvaj' : 'Kreiraj'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final duration = int.parse(_durationController.text.trim());
    final distance = double.parse(
      _distanceController.text.trim().replaceAll(',', '.'),
    );

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
