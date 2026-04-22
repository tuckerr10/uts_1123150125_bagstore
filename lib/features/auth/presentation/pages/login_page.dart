import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/google_sign_in_button.dart'; // Buat widget ini nanti
import '../../../../core/routes/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const AuthHeader(
                  icon: Icons.lock_open_outlined,
                  title: 'Selamat Datang Kembali',
                  subtitle: 'Masuk ke akun Bag Store kamu untuk belanja lagi',
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Email',
                  hint: 'Masukkan email kamu',
                  controller: _emailCtrl,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  hint: 'Masukkan password',
                  controller: _passCtrl,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Masuk',
                  isLoading: auth.isLoading,
                  onPressed: () async {
                    // Logika login email/password akan dipanggil di sini
                  },
                ),
                const SizedBox(height: 20),
                const Text("atau masuk dengan"),
                const SizedBox(height: 20),
                GoogleSignInButton(
                  isLoading: auth.isLoading,
                  onPressed: () => auth.loginWithGoogle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}