
class MonitoringModel {
  final int id;
  final int unitId;
  final int userId;
  final DateTime? tanggalMonitoring;
  final double progress;
  final String kondisi;
  final String? keterangan;
  final String status;
  final List<ApprovalModel> approvals;

  const MonitoringModel({
    required this.id,
    required this.unitId,
    required this.userId,
    required this.tanggalMonitoring,
    required this.progress,
    required this.kondisi,
    required this.keterangan,
    required this.status,
    required this.approvals,
  });

  ApprovalModel? get approvalTerbaru {
    if (approvals.isEmpty) return null;
    return approvals.first;
  }

  factory MonitoringModel.fromJson(Map<String, dynamic> json) {
    return MonitoringModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      unitId: int.tryParse(json['unit_id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tanggalMonitoring: json['tanggal_monitoring'] != null
          ? DateTime.tryParse(json['tanggal_monitoring'].toString())
          : null,
      progress: double.tryParse(json['progress']?.toString() ?? '0') ?? 0,
      kondisi: json['kondisi']?.toString() ?? '-',
      keterangan: json['keterangan']?.toString(),
      status: json['status']?.toString() ?? '-',
      approvals: (json['approval'] as List<dynamic>? ?? [])
          .map((item) => ApprovalModel.fromJson(item))
          .toList(),
    );
  }
}

class ApprovalModel {
  final int id;
  final String status;
  final String? catatan;
  final DateTime? tanggalApproval;
  final String? namaApprover;

  const ApprovalModel({
    required this.id,
    required this.status,
    required this.catatan,
    required this.tanggalApproval,
    required this.namaApprover,
  });

  factory ApprovalModel.fromJson(Map<String, dynamic> json) {
    final approver = json['approver'];

    return ApprovalModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      status: json['status']?.toString() ?? '-',
      catatan: json['catatan']?.toString(),
      tanggalApproval: json['tanggal_approval'] != null
          ? DateTime.tryParse(json['tanggal_approval'].toString())
          : null,
      namaApprover: approver is Map
          ? approver['nama']?.toString() ??
              approver['name']?.toString()
          : null,
    );
  }
}
