import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/secure_storage.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, emailNotVerified, error }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  User? get firebaseUser => _auth.currentUser;

  // --- Fungsi Registrasi ---
  Future<bool> register({required String name, required String email, required String password}) async {
    _setLoading();
    try {
      // 1. Buat user di Firebase [cite: 96]
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // 2. Update Nama Profil [cite: 731]
      await credential.user?.updateDisplayName(name);
      
      // 3. Kirim Email Verifikasi [cite: 97]
      await credential.user?.sendEmailVerification();
      
      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? "Registrasi Gagal");
      return false;
    }
  }

  // --- Fungsi Verify Token ke Backend ---
  Future<bool> _verifyTokenToBackend() async {
    try {
      final idToken = await _auth.currentUser?.getIdToken(); // Ambil Firebase JWT [cite: 104]
      
      final response = await DioClient.instance.post(
        ApiConstants.verifyToken,
        data: {'firebase_token': idToken},
      );

      final backendToken = response.data['data']['access_token']; // Dapat Token Backend [cite: 107]
      await SecureStorageService.saveToken(backendToken); // Simpan Aman [cite: 108]

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Gagal verifikasi ke server");
      return false;
    }
  }

  // --- Helper State ---
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String msg) {
    _status = AuthStatus.error;
    _errorMessage = msg;
    notifyListeners();
  }
}