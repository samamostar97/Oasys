class TrailFormValidators {
  static String? duration(String? value) {
    final duration = int.tryParse(value?.trim() ?? '');
    if (duration == null) {
      return 'Trajanje mora biti broj.';
    }

    if (duration < 1 || duration > 10080) {
      return 'Trajanje mora biti izmedu 1 i 10080.';
    }

    return null;
  }

  static String? distance(String? value) {
    final normalized = (value?.trim() ?? '').replaceAll(',', '.');
    final distance = double.tryParse(normalized);
    if (distance == null) {
      return 'Udaljenost mora biti broj.';
    }

    if (distance < 0.1 || distance > 1000) {
      return 'Udaljenost mora biti izmedu 0.1 i 1000.';
    }

    return null;
  }
}
