import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';

class ApiService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // GET
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

  // POST JSON
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

  // PUT JSON
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

  // PATCH JSON
  static Future<Map<String, dynamic>> patch(
    String endpoint, [
    Map<String, dynamic>? body,
  ]) async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }

  // DELETE
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

  // MULTIPART UPLOAD
  // fields digunakan untuk mengirim data tambahan bersama file.
  static Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    String fieldName,
    File file, {
    Map<String, String>? fields,
  }) async {
    final token = await _storage.read(key: 'auth_token');

    final extension = file.path.split('.').last.toLowerCase();

    final mimeType = switch (extension) {
      'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      _ => throw Exception('Format foto tidak didukung.'),
    };

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    if (fields != null) {
      request.fields.addAll(fields);
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: mimeType,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  // LOGOUT
  static Future<Map<String, dynamic>> logout() async {
    try {
      return await post('logout', {});
    } catch (e) {
      return {'message': 'Sesi lokal berhasil diakhiri.'};
    } finally {
      await removeToken();
    }
  }

  // TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // RESPONSE HANDLER
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
