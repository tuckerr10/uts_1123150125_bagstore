import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> verifyFirebaseToken(String firebaseToken) async {
    try {
      // Mengirim Token Firebase ke Endpoint Backend
      final response = await DioClient.instance.post(
        ApiConstants.verifyToken,
        data: {
          'firebase_token': firebaseToken,
        },
      );

      // Mengambil access_token yang diberikan oleh Backend
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return data['access_token'] as String;
      } else {
        throw Exception('Gagal verifikasi ke backend');
      }
    } catch (e) {
      rethrow;
    }
  }
}