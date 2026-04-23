import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/services/secure_storage.dart';

enum AuthStatus {
  unauthenticated,
  loading,
  authenticated,
  emailNotVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _firebaseUser;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _error;
  bool _isManualFlow = false; // ✅ Flag untuk block listener saat proses manual

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      // ✅ Block listener saat login/register/verify sedang berjalan
      if (_isManualFlow) return;

      _firebaseUser = user;
      _status = user == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated;
      notifyListeners();
    });
  }

  User? get firebaseUser => _firebaseUser;
  AuthStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == AuthStatus.loading;

  void _setLoading() {
    _isManualFlow = true; // ✅ Aktifkan flag
    _status = AuthStatus.loading;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _status = AuthStatus.error;
    _isManualFlow = false; // ✅ Reset flag
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      _firebaseUser = user;

      if (user != null && !user.emailVerified) {
        _status = AuthStatus.emailNotVerified;
        _isManualFlow = false;
        notifyListeners();
        return;
      }

      final idToken = await user?.getIdToken();
      if (idToken != null) {
        final authRepo = AuthRepositoryImpl();
        final backendToken = await authRepo.verifyFirebaseToken(idToken);
        await SecureStorageService.saveToken(backendToken);
        _status = AuthStatus.authenticated;
      }
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      _setError(e.toString());
    }
    _isManualFlow = false; // ✅ Reset flag setelah selesai
    notifyListeners();
  }

  Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    final refreshed = _auth.currentUser;
    return refreshed?.emailVerified ?? false;
  }

  Future<void> register({
    String? name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      _firebaseUser = user;

      if (user != null) {
        if (name != null && name.isNotEmpty) {
          await user.updateDisplayName(name);
        }
        await user.sendEmailVerification();
        _status = AuthStatus.emailNotVerified;
      }
    } catch (e) {
      debugPrint('REGISTER ERROR: $e');
      _setError(e.toString());
    }
    _isManualFlow = false; // ✅ Reset flag
    notifyListeners();
  }

  Future<void> resendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    _setLoading();
    _setError('Google login is not implemented');
  }

  Future<void> logout() async {
    _isManualFlow = false; // ✅ Reset flag saat logout
    await _auth.signOut();
    await SecureStorageService.clearAll();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}