import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'core/routes/app_router.dart';
import 'core/routes/auth_guard.dart';
import 'features/dashboard/presentation/providers/product_provider.dart';

// KITA TAMBAHKAN: Jangan lupa import file splash_screen kamu.
import 'features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bag Store',
        routes: AppRouter.routes,
        // KITA UBAH: Jadikan SplashScreen sebagai halaman pertama yang dimuat
        home: const SplashScreen(),
      ),
    );
  }
}