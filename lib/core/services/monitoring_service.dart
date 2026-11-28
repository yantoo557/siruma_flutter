import 'dart:io';

import '../../models/monitoring_model.dart';
import 'api_service.dart';

class MonitoringService {
  // Mengambil riwayat monitoring suatu unit
  static Future<List<MonitoringModel>> getRiwayatUnit(int unitId) async {
    final response = await ApiService.get('unit/$unitId/monitoring');

    final List<dynamic> data = response['data'] ?? [];

    return data.map((json) => MonitoringModel.fromJson(json)).toList();
  }

  // Mengambil semua draft milik User yang sedang login
  static Future<List<Map<String, dynamic>>> getDraft() async {
    final response = await ApiService.get('monitoring');

    final List<dynamic> data = response['data'] ?? [];

    return data
        .where((item) => item['status']?.toString() == 'DRAFT')
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  // Mengambil semua monitoring milik User yang sedang login
  static Future<List<Map<String, dynamic>>> getAllMonitoring() async {
    final response = await ApiService.get('monitoring');

    final List<dynamic> data = response['data'] ?? [];

    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  // Mengambil Draft aktif milik user untuk satu unit.
  static Future<Map<String, dynamic>?> getDraftForUnit(int unitId) async {
    final response = await ApiService.get('unit/$unitId/draft');
    final data = response['data'];

    if (data is! Map) return null;
    return Map<String, dynamic>.from(data);
  }

  // Menghapus Draft yang belum lengkap (server tetap memvalidasi kepemilikan
  // dan status agar monitoring yang sudah diajukan tidak dapat terhapus).
  static Future<void> deleteIncompleteDraft(int monitoringId) async {
    await ApiService.delete('monitoring/$monitoringId/draft');
  }

  // Mengambil detail satu monitoring berdasarkan ID
  static Future<Map<String, dynamic>> getDetailMonitoring(
    int monitoringId,
  ) async {
    final response = await ApiService.get('monitoring/$monitoringId');

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Data detail monitoring tidak ditemukan.');
    }

    return Map<String, dynamic>.from(data);
  }

  // Mengambil daftar foto yang sudah tersimpan di server
  static Future<List<Map<String, dynamic>>> getFotoMonitoring(
    int monitoringId,
  ) async {
    final response = await ApiService.get('monitoring/$monitoringId/foto');

    final List<dynamic> data = response['data'] ?? [];

    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  // Membuat monitoring baru dengan status DRAFT
  static Future<Map<String, dynamic>> createMonitoring({
    required int unitId,
    required String kondisi,
    String? keterangan,
    String? tanggalMonitoring,
    double progress = 0,
  }) async {
    return await ApiService.post('monitoring', {
      'unit_id': unitId,
      'kondisi': kondisi,
      'keterangan': keterangan,
      'tanggal_monitoring': tanggalMonitoring,
      'progress': progress,
    });
  }

  // Membuat penilaian baru
  static Future<Map<String, dynamic>> createPenilaian({
    required int monitoringId,
    required double luasTanah,
    required double luasBangunan,
    required double nilaiTanahPerM2,
    required double nilaiBangunanPerM2,
    String? sumberDataTanah,
    int? jumlahLantai,
    int? tahunBangunan,
  }) async {
    return await ApiService.post('penilaian', {
      'monitoring_id': monitoringId,
      'luas_tanah': luasTanah,
      'luas_bangunan': luasBangunan,
      'nilai_tanah_per_m2': nilaiTanahPerM2,
      'nilai_bangunan_per_m2': nilaiBangunanPerM2,
      'sumber_data_tanah': sumberDataTanah,
      'jumlah_lantai': jumlahLantai,
      'tahun_bangunan': tahunBangunan,
    });
  }

  // Memperbarui penilaian yang sudah ada
  // penilaianId adalah ID tabel penilaian, bukan ID monitoring
  static Future<Map<String, dynamic>> updatePenilaian({
    required int penilaianId,
    required double luasTanah,
    required double luasBangunan,
    required double nilaiTanahPerM2,
    required double nilaiBangunanPerM2,
    String? sumberDataTanah,
    int? jumlahLantai,
    int? tahunBangunan,
  }) async {
    return await ApiService.put('penilaian/$penilaianId', {
      'luas_tanah': luasTanah,
      'luas_bangunan': luasBangunan,
      'nilai_tanah_per_m2': nilaiTanahPerM2,
      'nilai_bangunan_per_m2': nilaiBangunanPerM2,
      'sumber_data_tanah': sumberDataTanah,
      'jumlah_lantai': jumlahLantai,
      'tahun_bangunan': tahunBangunan,
    });
  }

  // Mengunggah satu foto monitoring
  static Future<Map<String, dynamic>> uploadFoto({
    required int monitoringId,
    required File foto,
    required String jenisFoto,
    String? keterangan,
  }) async {
    return await ApiService.uploadFile(
      'monitoring/$monitoringId/foto',
      'foto',
      foto,
      fields: {
        'jenis_foto': jenisFoto,
        if (keterangan != null && keterangan.isNotEmpty)
          'keterangan': keterangan,
      },
    );
  }

  // Memperbarui keterangan foto yang sudah tersimpan
  static Future<Map<String, dynamic>> updateKeteranganFoto({
    required int monitoringId,
    required int fotoId,
    String? keterangan,
  }) async {
    return await ApiService.put('monitoring/$monitoringId/foto/$fotoId', {
      'keterangan': keterangan,
    });
  }

  // Mengajukan monitoring ke Super Approval
  static Future<Map<String, dynamic>> ajukanApproval(int monitoringId) async {
    return await ApiService.post('monitoring/$monitoringId/ajukan', {});
  }

  // Memperbarui keterangan monitoring
  static Future<Map<String, dynamic>> updateMonitoring({
    required int monitoringId,
    String? keterangan,
    String? kondisi,
  }) async {
    return await ApiService.put('monitoring/$monitoringId', {
      'keterangan': keterangan,
      if (kondisi != null) 'kondisi': kondisi,
    });
  }

  // Mengganti foto yang sudah tersimpan di server
  static Future<Map<String, dynamic>> replaceFoto({
    required int monitoringId,
    required int fotoId,
    required File foto,
    String? keterangan,
  }) async {
    return await ApiService.uploadFile(
      'monitoring/$monitoringId/foto/$fotoId/ganti',
      'foto',
      foto,
      fields: {if (keterangan != null) 'keterangan': keterangan},
    );
  }
}
