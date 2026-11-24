
class AuditLogModel {
  final int id;
  final int? userId;
  final String aktivitas;
  final String tabel;
  final int? recordId;
  final String? keterangan;
  final String? createdAt;
  final String? namaUser;

  AuditLogModel({
    required this.id,
    this.userId,
    required this.aktivitas,
    required this.tabel,
    this.recordId,
    this.keterangan,
    this.createdAt,
    this.namaUser,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];

    return AuditLogModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      aktivitas: json['aktivitas'] ?? '',
      tabel: json['tabel'] ?? '',
      recordId: json['record_id'],
      keterangan: json['keterangan'],
      createdAt: json['created_at'],
      namaUser: user is Map<String, dynamic>
          ? (user['nama'] ?? user['name'])?.toString()
          : null,
    );
  }
}

class AuditLogResponse {
  final List<AuditLogModel> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  AuditLogResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory AuditLogResponse.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] ?? {};

    return AuditLogResponse(
      data: (json['data'] as List? ?? [])
          .map((item) => AuditLogModel.fromJson(item))
          .toList(),
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      perPage: pagination['per_page'] ?? 20,
      total: pagination['total'] ?? 0,
    );
  }
}
