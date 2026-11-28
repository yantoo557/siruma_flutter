class ApprovalSubmissionModel {
  final int id;
  final int monitoringId;
  final String status;
  final String? catatan;
  final DateTime? tanggalApproval;
  final String pengaju;
  final String perumahan;
  final String blok;
  final String unit;
  final DateTime? tanggalMonitoring;
  final String kondisi;
  final String? keterangan;
  final double luasTanah;
  final double luasBangunan;
  final double nilaiTanahPerM2;
  final double nilaiBangunanPerM2;
  final double nilaiTotalTanah;
  final double nilaiTotalBangunan;
  final double totalNilai;
  final List<ApprovalPhotoModel> foto;
  final String lokasi;

  const ApprovalSubmissionModel({
    required this.id,
    required this.monitoringId,
    required this.status,
    required this.catatan,
    required this.tanggalApproval,
    required this.pengaju,
    required this.perumahan,
    required this.blok,
    required this.unit,
    required this.tanggalMonitoring,
    required this.kondisi,
    required this.keterangan,
    required this.luasTanah,
    required this.luasBangunan,
    required this.nilaiTanahPerM2,
    required this.nilaiBangunanPerM2,
    required this.nilaiTotalTanah,
    required this.nilaiTotalBangunan,
    required this.totalNilai,
    required this.foto,
    required this.lokasi,
  });

  factory ApprovalSubmissionModel.fromJson(Map<String, dynamic> json) {
    final monitoring = _asMap(json['monitoring']);
    final user = _asMap(monitoring['user']);
    final unitData = _asMap(monitoring['unit']);
    final blokData = _asMap(unitData['blok']);
    final perumahanData = _asMap(blokData['perumahan']);
    final penilaian = _asMap(monitoring['penilaian']);

    final fotoData =
        monitoring['foto_monitoring'] ?? monitoring['fotoMonitoring'];

    final fotoList = fotoData is List
        ? fotoData
              .whereType<Map>()
              .map(
                (item) => ApprovalPhotoModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
        : <ApprovalPhotoModel>[];

    return ApprovalSubmissionModel(
      id: _toInt(json['id']),
      monitoringId: _toInt(json['monitoring_id'] ?? monitoring['id']),
      status: json['status']?.toString() ?? 'MENUNGGU',
      catatan: json['catatan']?.toString(),
      tanggalApproval: _toDate(json['tanggal_approval']),
      pengaju: _firstText([
        user['nama'],
        user['name'],
        user['username'],
      ], 'User SIRUMA'),
      perumahan: _firstText([
        perumahanData['nama_perumahan'],
        perumahanData['nama'],
      ], '-'),
      lokasi: _firstText([perumahanData['lokasi']], '-'),
      blok: _firstText([blokData['nama_blok'], blokData['nama']], '-'),
      unit: _firstText([unitData['nomor_unit'], unitData['nama_unit']], '-'),
      tanggalMonitoring: _toDate(monitoring['tanggal_monitoring']),
      kondisi: monitoring['kondisi']?.toString() ?? '-',
      keterangan: monitoring['keterangan']?.toString(),
      luasTanah: _toDouble(penilaian['luas_tanah']),
      luasBangunan: _toDouble(penilaian['luas_bangunan']),
      nilaiTanahPerM2: _toDouble(penilaian['nilai_tanah_per_m2']),
      nilaiBangunanPerM2: _toDouble(penilaian['nilai_bangunan_per_m2']),
      nilaiTotalTanah: _toDouble(penilaian['nilai_total_tanah']),
      nilaiTotalBangunan: _toDouble(penilaian['nilai_total_bangunan']),
      totalNilai: _toDouble(penilaian['total_nilai']),
      foto: fotoList,
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String _firstText(List<dynamic> values, String fallback) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty && text != 'null') {
        return text;
      }
    }
    return fallback;
  }
}

class ApprovalPhotoModel {
  final int id;
  final String jenisFoto;
  final String filePath;
  final String? keterangan;

  const ApprovalPhotoModel({
    required this.id,
    required this.jenisFoto,
    required this.filePath,
    required this.keterangan,
  });

  factory ApprovalPhotoModel.fromJson(Map<String, dynamic> json) {
    return ApprovalPhotoModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      jenisFoto: json['jenis_foto']?.toString() ?? 'Foto',
      filePath: json['file_path']?.toString() ?? '',
      keterangan: json['keterangan']?.toString(),
    );
  }
}
