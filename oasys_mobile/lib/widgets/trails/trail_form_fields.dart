import 'package:flutter/material.dart';
import 'package:oasys_core/oasys_core.dart';

class TrailFormFields extends StatelessWidget {
  const TrailFormFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.cityController,
    required this.durationController,
    required this.distanceController,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.validateDuration,
    required this.validateDistance,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController cityController;
  final TextEditingController durationController;
  final TextEditingController distanceController;
  final int? selectedDifficulty;
  final ValueChanged<int?> onDifficultyChanged;
  final String? Function(String? value) validateDuration;
  final String? Function(String? value) validateDistance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Naziv'),
          validator: FormValidators.compose([
            FormValidators.requiredField('Naziv je obavezan.'),
            FormValidators.minLength(
              2,
              'Naziv mora imati najmanje 2 karaktera.',
            ),
          ]),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: descriptionController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Opis'),
          validator: FormValidators.compose([
            FormValidators.requiredField('Opis je obavezan.'),
            FormValidators.minLength(
              10,
              'Opis mora imati najmanje 10 karaktera.',
            ),
          ]),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: cityController,
          decoration: const InputDecoration(labelText: 'Grad'),
          validator: FormValidators.compose([
            FormValidators.requiredField('Grad je obavezan.'),
            FormValidators.minLength(
              2,
              'Grad mora imati najmanje 2 karaktera.',
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Trajanje (min)'),
                validator: validateDuration,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Udaljenost (km)'),
                validator: validateDistance,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<int>(
          initialValue: selectedDifficulty,
          decoration: const InputDecoration(labelText: 'Tezina'),
          items: const [
            DropdownMenuItem<int>(value: 1, child: Text('Easy')),
            DropdownMenuItem<int>(value: 2, child: Text('Medium')),
            DropdownMenuItem<int>(value: 3, child: Text('Hard')),
          ],
          onChanged: onDifficultyChanged,
          validator: (value) {
            if (value == null) {
              return 'Tezina je obavezna.';
            }
            return null;
          },
        ),
      ],
    );
  }
}
