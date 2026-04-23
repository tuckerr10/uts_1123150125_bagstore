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
  bool _resendCooldown = false;

  @override
  void initState() {
    super.initState();
    // ✅ Cek verifikasi otomatis setiap 5 detik
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final auth = context.read<AuthProvider>();
      final verified = await auth.checkEmailVerified();
      if (verified && mounted) {
        _timer?.cancel();
       
       await auth.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
    });   
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendEmail() async {
    if (_resendCooldown) return;

    await context.read<AuthProvider>().resendVerificationEmail();

    // ✅ Cooldown 30 detik biar tidak spam
    setState(() => _resendCooldown = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email verifikasi telah dikirim ulang!'),
        backgroundColor: Colors.green,
      ),
    );

    await Future.delayed(const Duration(seconds: 30));
    if (mounted) setState(() => _resendCooldown = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().firebaseUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  icon: Icons.mark_email_unread_outlined,
                  title: 'Verifikasi Email Anda',
                  subtitle:
                      'Klik link yang kami kirim ke email di bawah ini untuk mengaktifkan akun Bag Store kamu.',
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    user?.email ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Cek juga folder Spam jika email tidak ditemukan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  label: _resendCooldown
                      ? 'Tunggu 30 detik...'
                      : 'Kirim Ulang Email',
                  variant: ButtonVariant.outlined,
                  onPressed: _resendCooldown ? null : _resendEmail,
                ),
                const SizedBox(height: 12),
                // ✅ Tombol logout jika salah akun
                TextButton(
                  onPressed: () async {
                    _timer?.cancel();
                    await context.read<AuthProvider>().logout();
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  child: const Text(
                    'Gunakan akun lain',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}