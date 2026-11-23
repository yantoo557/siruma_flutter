import '../../models/perumahan_model.dart';
import 'api_service.dart';

class PerumahanService {
  // Mengambil daftar perumahan
  static Future<List<PerumahanModel>> getPerumahan() async {
    final response = await ApiService.get('perumahan');

    final data = response['data'];

    if (data is! List) {
      throw Exception('Format data perumahan tidak valid.');
    }

    return data.map((item) {
      return PerumahanModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  // Mengambil detail perumahan berdasarkan ID
  static Future<Map<String, dynamic>> getDetailPerumahan(int id) async {
    final response = await ApiService.get('perumahan/$id');

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Format detail perumahan tidak valid.');
    }

    return Map<String, dynamic>.from(data);
  }

  // Menambahkan perumahan
  static Future<Map<String, dynamic>> tambahPerumahan({
    required String developer,
    required String namaPerumahan,
    required String lokasi,
  }) async {
    return await ApiService.post('perumahan', {
      'developer': developer,
      'nama_perumahan': namaPerumahan,
      'lokasi': lokasi,
    });
  }

  // Memperbarui perumahan
  static Future<Map<String, dynamic>> updatePerumahan({
    required int id,
    required String developer,
    required String namaPerumahan,
    required String lokasi,
  }) async {
    return await ApiService.put('perumahan/$id', {
      'developer': developer,
      'nama_perumahan': namaPerumahan,
      'lokasi': lokasi,
    });
  }

  // Menghapus perumahan
  static Future<Map<String, dynamic>> hapusPerumahan({required int id}) async {
    return await ApiService.delete('perumahan/$id');
  }
}
