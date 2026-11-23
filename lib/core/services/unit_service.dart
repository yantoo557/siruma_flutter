
import 'api_service.dart';

class UnitService {
  // TAMBAH UNIT
  static Future<Map<String, dynamic>> tambahUnit({
    required int blokId,
    required String nomorUnit,
    required double luasTanah,
    double luasBangunan = 0,
    double nilaiTanahPerM2 = 0,
    double nilaiBangunanPerM2 = 0,
  }) async {
    return await ApiService.post(
      'blok/$blokId/unit',
      {
        'nomor_unit': nomorUnit,
        'luas_tanah': luasTanah,
        'luas_bangunan': luasBangunan,
        'nilai_tanah_per_m2': nilaiTanahPerM2,
        'nilai_bangunan_per_m2': nilaiBangunanPerM2,
      },
    );
  }

  // EDIT UNIT
  static Future<Map<String, dynamic>> updateUnit({
    required int unitId,
    required String nomorUnit,
    required double luasTanah,
    required double luasBangunan,
    required double nilaiTanahPerM2,
    required double nilaiBangunanPerM2,
    required String status,
  }) async {
    return await ApiService.put(
      'unit/$unitId',
      {
        'nomor_unit': nomorUnit,
        'luas_tanah': luasTanah,
        'luas_bangunan': luasBangunan,
        'nilai_tanah_per_m2': nilaiTanahPerM2,
        'nilai_bangunan_per_m2': nilaiBangunanPerM2,
        'status': status,
      },
    );
  }

  // HAPUS UNIT
  static Future<Map<String, dynamic>> hapusUnit(int unitId) async {
    return await ApiService.delete('unit/$unitId');
  }
}
