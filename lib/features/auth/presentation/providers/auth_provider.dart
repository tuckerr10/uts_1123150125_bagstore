// Tambahkan di dalam class AuthProvider

  // Fungsi Login dengan Email & Password
  Future<void> login({required String email, required String password}) async {
    _setLoading();
    try {
      // 1. Login ke Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      final user = credential.user;
      
      // 2. Cek apakah email sudah diverifikasi
      if (user != null && !user.emailVerified) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return;
      }

      // 3. Ambil ID Token dari Firebase
      final idToken = await user?.getIdToken();

      // 4. Verifikasi ke Backend via Repository
      if (idToken != null) {
        final authRepo = AuthRepositoryImpl();
        final backendToken = await authRepo.verifyFirebaseToken(idToken);
        
        // 5. Simpan Token Backend ke Secure Storage
        await SecureStorageService.saveToken(backendToken);
        
        _status = AuthStatus.authenticated;
      }
    } catch (e) {
      _setError(e.toString());
    }
    notifyListeners();
  }