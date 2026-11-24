
import '../../../models/audit_log_model.dart';
import 'api_service.dart';

class AuditLogService {
  // Mengambil riwayat aktivitas berdasarkan halaman
  static Future<AuditLogResponse> getRiwayat({
    int page = 1,
  }) async {
    final response = await ApiService.get(
      'audit-log?page=$page',
    );

    return AuditLogResponse.fromJson(response);
  }
}
