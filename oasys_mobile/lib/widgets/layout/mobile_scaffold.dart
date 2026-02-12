import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import 'safe_area_wrapper.dart';

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeAreaWrapper(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSizes.horizontalPadding(context),
            16,
            AppSizes.horizontalPadding(context),
            16,
          ),
          child: child,
        ),
      ),
    );
  }
}
