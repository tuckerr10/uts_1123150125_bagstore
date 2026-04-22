import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pastikan kamu punya logo google di folder assets
                  Image.network('https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_Logo.svg', height: 22, errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_circle)),
                  const SizedBox(width: 12),
                  const Text('Lanjutkan dengan Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                ],
              ),
      ),
    );
  }
}