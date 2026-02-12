import 'package:flutter/material.dart';

class SafeAreaWrapper extends StatelessWidget {
  const SafeAreaWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: child);
  }
}
