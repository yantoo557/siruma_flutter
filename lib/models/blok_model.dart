
class BlokModel {
  final int id;
  final int perumahanId;
  final String namaBlok;

  const BlokModel({
    required this.id,
    required this.perumahanId,
    required this.namaBlok,
  });

  factory BlokModel.fromJson(Map<String, dynamic> json) {
    return BlokModel(
      id: int.parse(json['id'].toString()),
      perumahanId: int.parse(json['perumahan_id'].toString()),
      namaBlok: json['nama_blok']?.toString() ?? '',
    );
  }
}
