import 'dart:io';

import 'api_service.dart';

class ProfileService {
  // Mengambil profil Super Admin
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiService.get('profile');

    return Map<String, dynamic>.from(response['data'] ?? {});
  }

  // Memperbarui nama profil
  static Future<Map<String, dynamic>> updateProfile({
    required String nama,
  }) async {
    final response = await ApiService.put('profile', {'nama': nama});

    return Map<String, dynamic>.from(response['data'] ?? {});
  }

  // Mengunggah foto profil
  static Future<Map<String, dynamic>> uploadProfilePhoto(File file) async {
    final response = await ApiService.uploadFile(
      'profile/photo',
      'foto_profil',
      file,
    );

    return Map<String, dynamic>.from(response['data'] ?? {});
  }

  // Mengubah password akun
  static Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    await ApiService.put('change-password', {
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    });
  }

  // Logout akun
  static Future<void> logout() async {
    await ApiService.logout();
  }
}
