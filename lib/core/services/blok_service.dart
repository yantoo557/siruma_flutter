import '../../models/blok_model.dart';
import '../../models/unit_model.dart';
import 'api_service.dart';

class BlokService {
  // Mengambil daftar blok berdasarkan ID perumahan
  static Future<List<BlokModel>> getBlok(int perumahanId) async {
    final response = await ApiService.get('perumahan/$perumahanId/blok');

    final data = response['data'];

    if (data is! List) {
      throw Exception('Format data blok tidak valid.');
    }

    return data
        .map((item) => BlokModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Mengambil daftar unit berdasarkan ID blok
  static Future<List<UnitModel>> getUnit(int blokId) async {
    final response = await ApiService.get('blok/$blokId/unit');

    final data = response['data'];

    if (data is! List) {
      throw Exception('Format data unit tidak valid.');
    }

    return data
        .map((item) => UnitModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Menambahkan blok baru ke perumahan
  static Future<Map<String, dynamic>> tambahBlok({
    required int perumahanId,
    required String namaBlok,
  }) async {
    return await ApiService.post('perumahan/$perumahanId/blok', {
      'nama_blok': namaBlok,
    });
  }

  // Memperbarui nama blok
  static Future<Map<String, dynamic>> updateBlok({
    required int id,
    required String namaBlok,
  }) async {
    return await ApiService.put('blok/$id', {'nama_blok': namaBlok});
  }

  // Menghapus blok
  static Future<Map<String, dynamic>> hapusBlok({required int id}) async {
    return await ApiService.delete('blok/$id');
  }
}
