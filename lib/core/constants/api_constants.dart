class ApiConstants {
  // Masukkan IP Address laptop kamu jika menggunakan emulator/device asli
  static const String baseUrl = 'http://192.168.1.106:8080/v1'; [cite: 198]

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token'; [cite: 200]

  // Product endpoints
  static const String products = '/products'; [cite: 202]

  // Timeout setting
  static const int connectTimeout = 15000; [cite: 204]
  static const int receiveTimeout = 15000; [cite: 205]
}