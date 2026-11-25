
class NotificationModel {
  final int id;
  final String judul;
  final String pesan;
  final String tipe;
  final int? referenceId;
  final bool isRead;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    this.referenceId,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num).toInt(),
      judul: json['judul']?.toString() ?? '',
      pesan: json['pesan']?.toString() ?? '',
      tipe: json['tipe']?.toString() ?? '',
      referenceId: (json['reference_id'] as num?)?.toInt(),
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
