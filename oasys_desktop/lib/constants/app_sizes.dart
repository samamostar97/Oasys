import 'package:flutter/material.dart';

class AppSizes {
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) {
      return 16;
    }
    if (width < 1100) {
      return 24;
    }
    return 32;
  }
}
