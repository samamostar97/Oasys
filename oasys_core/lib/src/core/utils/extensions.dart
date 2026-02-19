extension StringX on String {
  bool   get isNullOrEmpty => isEmpty;
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

extension DateTimeX on DateTime {
  bool get isToday {
    final n = DateTime.now();
    return year == n.year && month == n.month && day == n.day;
  }
  bool get isPast   => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());
  String get formatted => '${day.toString().padLeft(2,'0')}.${month.toString().padLeft(2,'0')}.'
      '$year';
}
