import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
// Catatan: import '../widgets/auth_header.dart'; sudah dihapus karena kita pakai logo

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
              // KITA TAMBAHKAN: Card container putih yang sama persis dengan halaman Login
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- BAGIAN HEADER MINIMALIS ---
                      Align(
                        alignment: Alignment.center,
                        child: Container(
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
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Buat Akun Baru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Daftar untuk mulai belanja tas impianmu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // -------------------------------------------

                      // --- BAGIAN INPUT FORM ---
                      CustomTextField(
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama kamu',
                        controller: _nameCtrl,
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (val) => val?.isEmpty ?? true ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Email',
                        hint: 'contoh@email.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (val) {
                          if (val?.isEmpty ?? true) return 'Email tidak boleh kosong';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(val!)) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Password',
                        hint: 'Minimal 8 karakter',
                        controller: _passCtrl,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (val) => (val?.length ?? 0) < 8 ? 'Password minimal 8 karakter' : null,
                      ),
                      const SizedBox(height: 32),

                      // --- BAGIAN TOMBOL ---
                      CustomButton(
                        label: 'Daftar Sekarang',
                        isLoading: authProvider.isLoading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.register(
                              name: _nameCtrl.text,
                              email: _emailCtrl.text,
                              password: _passCtrl.text,
                            );

                            if (!mounted) return;

                            // Navigasi dengan cek status
                            if (authProvider.status == AuthStatus.emailNotVerified) {
                              Navigator.pushReplacementNamed(context, '/verify-email');
                            } else if (authProvider.status == AuthStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.error ?? 'Terjadi kesalahan'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // --- LINK KEMBALI KE LOGIN ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey.shade600)),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5), // Biru khas tombol link
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