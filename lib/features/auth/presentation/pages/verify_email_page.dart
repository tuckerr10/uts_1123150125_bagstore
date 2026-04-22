import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Jalankan pengecekan otomatis setiap 5 detik [cite: 1036]
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final auth = context.read<AuthProvider>();
      // Jika sudah diverifikasi, pindah ke Dashboard [cite: 1042]
      final verified = await auth.checkEmailVerified();
      if (verified && mounted) {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().firebaseUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthHeader(
              icon: Icons.email_outlined,
              title: 'Verifikasi Email Anda',
              subtitle: 'Klik link yang kami kirim ke email di bawah ini untuk mengaktifkan akun Bag Store kamu.',
            ),
            const SizedBox(height: 20),
            Text(user?.email ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            CustomButton(
              label: 'Kirim Ulang Email',
              variant: ButtonVariant.outlined,
              onPressed: () => context.read<AuthProvider>().resendVerificationEmail(),
            ),
          ],
        ),
      ),
    );
  }
}