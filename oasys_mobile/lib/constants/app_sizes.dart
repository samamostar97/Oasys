import 'package:flutter/material.dart';

class AppSizes {
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) {
      return 12;
    }
    if (width < 600) {
      return 16;
    }
    return 24;
  }
}
