import 'package:flutter/material.dart';

enum ButtonVariant { primary, outlined, text } [cite: 482]

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator()); [cite: 499, 502]

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: variant == ButtonVariant.primary 
        ? ElevatedButton(onPressed: onPressed, child: Text(label)) 
        : OutlinedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}