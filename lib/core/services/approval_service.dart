import '../../models/approval_submission_model.dart';
import 'api_service.dart';

class ApprovalService {
  // Mengambil seluruh daftar pengajuan dari Laravel.
  static Future<List<ApprovalSubmissionModel>> getApprovals() async {
    final response = await ApiService.get('approval');

    final dynamic rawData = response['data'];

    if (rawData is! List) {
      throw Exception('Format daftar approval dari server tidak valid.');
    }

    return rawData
        .whereType<Map>()
        .map(
          (item) =>
              ApprovalSubmissionModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  // Mengambil detail satu pengajuan berdasarkan ID approval.
  static Future<ApprovalSubmissionModel> getApprovalDetail(int id) async {
    final response = await ApiService.get('approval/$id');
    final dynamic rawData = response['data'];

    if (rawData is! Map) {
      throw Exception('Format detail approval dari server tidak valid.');
    }

    return ApprovalSubmissionModel.fromJson(Map<String, dynamic>.from(rawData));
  }

  // Menyetujui pengajuan.
  static Future<Map<String, dynamic>> approve(int id, {String? catatan}) async {
    return await ApiService.post('approval/$id/setujui', {'catatan': catatan});
  }

  // Meminta pengajuan untuk direvisi.
  static Future<Map<String, dynamic>> requestRevision(
    int id,
    String catatan,
  ) async {
    return await ApiService.post('approval/$id/revisi', {'catatan': catatan});
  }

  // Menolak pengajuan.
  static Future<Map<String, dynamic>> reject(int id, String catatan) async {
    return await ApiService.post('approval/$id/tolak', {'catatan': catatan});
  }
}
