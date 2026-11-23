
import '../../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      'login',
      {
        'email': email,
        'password': password,
      },
    );

    final token = response['token'];

    if (token == null || token.toString().isEmpty) {
      throw Exception('Token login tidak ditemukan.');
    }

    await ApiService.saveToken(token.toString());

    final userJson = response['user'];

    if (userJson is! Map<String, dynamic>) {
      await ApiService.removeToken();
      throw Exception('Data pengguna tidak valid.');
    }

    return UserModel.fromJson(userJson);
  }

  static Future<void> logout() async {
    try {
      await ApiService.post('logout', {});
    } finally {
      await ApiService.removeToken();
    }
  }
}
