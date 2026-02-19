import 'package:flutter/material.dart';
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  const AppButton({super.key, required this.label, this.onPressed,
      this.isLoading = false, this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2))
        : Text(label);
    return SizedBox(width: double.infinity, height: 48,
      child: isOutlined
          ? OutlinedButton(onPressed: isLoading ? null : onPressed, child: child)
          : ElevatedButton(onPressed: isLoading ? null : onPressed, child: child));
  }
}
