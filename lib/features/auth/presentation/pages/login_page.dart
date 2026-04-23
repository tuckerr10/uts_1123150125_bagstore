import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/google_sign_in_button.dart';
// Catatan: import '../widgets/auth_header.dart'; sudah dihapus karena kita pakai logo langsung

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
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      // Latar belakang minimalis: Warna dasar putih keabu-abuan/biru sangat pudar
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA), // Nyaris putih
              Color(0xFFE3F2FD), // Biru sangat pudar di bagian bawah
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32), // Sudut lebih membulat kekinian
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04), // Bayangan sangat lembut
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- BAGIAN HEADER MINIMALIS DENGAN LOGO ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icon/icon_app.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A), // Hitam pekat modern
                          letterSpacing: -0.5, // Jarak huruf agak rapat khas desain modern
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masuk ke akun Bag Store kamu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // -------------------------------------------

                      // --- BAGIAN INPUT FORM ---
                      CustomTextField(
                        label: 'Email',
                        hint: 'contoh@email.com', // Hint dibuat lebih kasual
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (val) {
                          if (val?.isEmpty ?? true) return 'Email tidak boleh kosong';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(val!)) return 'Email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Password',
                        hint: 'Masukkan password',
                        controller: _passCtrl,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (val) => (val?.isEmpty ?? true) ? 'Password tidak boleh kosong' : null,
                      ),
                      
                      // Lupa Password (Opsional, tapi bagus untuk UI modern)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {}, // Nanti bisa kamu arahkan ke halaman lupa password
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN TOMBOL ---
                      SizedBox(
                        width: double.infinity, // Tombol memenuhi lebar form
                        child: CustomButton(
                          label: 'Masuk',
                          isLoading: auth.isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await auth.login(email: _emailCtrl.text, password: _passCtrl.text);
                              if (auth.status == AuthStatus.authenticated && mounted) {
                                Navigator.pushReplacementNamed(context, '/dashboard');
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Pemisah dengan garis (Divider)
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Atau',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Tombol Google
                      SizedBox(
                        width: double.infinity,
                        child: GoogleSignInButton(
                          isLoading: auth.isLoading,
                          onPressed: () async {
                            await auth.loginWithGoogle();
                            if (auth.status == AuthStatus.authenticated && mounted) {
                              Navigator.pushReplacementNamed(context, '/dashboard');
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Belum punya akun? ', style: TextStyle(color: Colors.grey.shade600)),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/register'),
                            child: const Text(
                              'Daftar Sekarang', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}