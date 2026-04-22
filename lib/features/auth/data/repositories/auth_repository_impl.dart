import '../../../../core/constants/api_constants.dart'; [cite: 197]
import '../../../../core/services/dio_client.dart'; [cite: 332]
import '../../domain/repositories/auth_repository.dart'; [cite: 1733]

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> verifyFirebaseToken(String firebaseToken) async {
    final response = await DioClient.instance.post(
      ApiConstants.verifyToken, [cite: 200]
      data: {'firebase_token': firebaseToken}, [cite: 769]
    );

    final data = response.data['data'] as Map<String, dynamic>; [cite: 772]
    return data['access_token'] as String; [cite: 773]
  }
}