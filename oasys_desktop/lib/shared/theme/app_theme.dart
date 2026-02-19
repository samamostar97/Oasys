import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB), brightness: Brightness.dark),
  );
}
