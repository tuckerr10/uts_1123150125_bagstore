import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uts_1123150125_bagstore/core/routes/auth_guard.dart'; // Import paket relatif ke root lib milikmu

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// KITA TAMBAHKAN: with SingleTickerProviderStateMixin agar bisa menjalankan animasi
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Deklarasi variabel untuk mengatur jalannya animasi
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. SETUP ANIMASI
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Animasi berjalan 1.5 detik
    );

    // Animasi memudar (dari tidak terlihat menjadi terlihat)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Animasi membesar (dari ukuran kecil melompat ke ukuran normal)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Jalankan animasi sekarang
    _animationController.forward();

    // 2. LOGIKA TIMER: Menunggu selama 3 detik
    Timer(const Duration(seconds: 3), () {
      // Setelah 3 detik, pindah ke AuthGuard untuk mengecek status login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthGuard(
            child: Scaffold(
              body: Center(
                // Menggunakan loading bulat bawaan Flutter agar lebih cantik
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    // KITA TAMBAHKAN: Hapus pengontrol animasi saat pindah halaman agar memori HP tidak penuh
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // KITA UBAH: Latar belakang gradien warna biru yang lebih premium dan elegan
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF1E88E5), // Biru cerah elegan
              Color(0xFF0D47A1), // Biru dongker/gelap
            ],
          ),
        ),
        child: Center(
          // KITA TAMBAHKAN: Pembungkus animasi agar UI merespons Timer animasi di atas
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // LOGO APP: Dibungkus container agar punya efek cahaya (glow) di belakangnya
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/icon/icon_app.png',
                          width: 110, // Disesuaikan sedikit karena ada padding dari wadah
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // KITA UBAH: Teks judul dibuat lebih tegas dan kekinian
                      const Text(
                        'BAG STORE',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900, // Ketebalan huruf maksimal
                          color: Colors.white,
                          letterSpacing: 6, // Jarak antar huruf
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // KITA TAMBAHKAN: Subtitle kecil agar mirip aplikasi komersial
                      Text(
                        'Premium Quality Bags',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}