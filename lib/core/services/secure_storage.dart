import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  ); [cite: 313, 314, 315, 318]

  static const _keyToken = 'auth_token'; [cite: 320]

  static Future<void> saveToken(String token) async =>
      _storage.write(key: _keyToken, value: token); [cite: 321, 322]

  static Future<String?> getToken() async =>
      _storage.read(key: _keyToken); [cite: 323, 324]

  static Future<void> clearAll() async =>
      _storage.deleteAll(); [cite: 325, 326]
}