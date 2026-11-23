
class PerumahanModel {
  final int id;
  final String namaPerumahan;
  final String lokasi;
  final String developer;
  final int blokCount;

  const PerumahanModel({
    required this.id,
    required this.namaPerumahan,
    required this.lokasi,
    required this.developer,
    required this.blokCount,
  });

  factory PerumahanModel.fromJson(Map<String, dynamic> json) {
    return PerumahanModel(
      id: int.parse(json['id'].toString()),
      namaPerumahan: json['nama_perumahan']?.toString() ?? '',
      lokasi: json['lokasi']?.toString() ?? '',
      developer: json['developer']?.toString() ?? '',
      blokCount: int.tryParse(
        json['blok_count']?.toString() ?? '0',
      ) ?? 0,
    );
  }
}
