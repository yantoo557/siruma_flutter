import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';

class ApiService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Mengirim request GET
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  // Mengirim request POST
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Mengirim request PUT untuk memperbarui data
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Mengirim request DELETE untuk menghapus data
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  // Menyimpan token login
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Mengambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Menghapus token
  static Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Menangani response Laravel
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw Exception('Format response API tidak valid.');
    }

    if (decoded is Map<String, dynamic>) {
      final message =
          decoded['message'] ??
          decoded['errors'] ??
          'Terjadi kesalahan pada server.';

      throw Exception(message.toString());
    }

    throw Exception('Request gagal dengan status ${response.statusCode}.');
  }
}
