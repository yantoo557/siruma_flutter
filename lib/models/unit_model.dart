
class UnitModel {
  final int id;
  final int blokId;
  final String nomorUnit;
  final double luasTanah;
  final double luasBangunan;
  final double nilaiTanahPerM2;
  final double nilaiBangunanPerM2;
  final String status;

  const UnitModel({
    required this.id,
    required this.blokId,
    required this.nomorUnit,
    required this.luasTanah,
    required this.luasBangunan,
    required this.nilaiTanahPerM2,
    required this.nilaiBangunanPerM2,
    required this.status,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: int.parse(json['id'].toString()),
      blokId: int.parse(json['blok_id'].toString()),
      nomorUnit: json['nomor_unit']?.toString() ?? '',
      luasTanah: double.tryParse(
            json['luas_tanah']?.toString() ?? '0',
          ) ??
          0,
      luasBangunan: double.tryParse(
            json['luas_bangunan']?.toString() ?? '0',
          ) ??
          0,
      nilaiTanahPerM2: double.tryParse(
            json['nilai_tanah_per_m2']?.toString() ?? '0',
          ) ??
          0,
      nilaiBangunanPerM2: double.tryParse(
            json['nilai_bangunan_per_m2']?.toString() ?? '0',
          ) ??
          0,
      status: json['status']?.toString() ?? 'aktif',
    );
  }
}
