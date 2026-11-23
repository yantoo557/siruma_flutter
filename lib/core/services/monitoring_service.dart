import '../../models/monitoring_model.dart';
import 'api_service.dart';

class MonitoringService {
  static Future<List<MonitoringModel>> getRiwayatUnit(int unitId) async {
    final response = await ApiService.get('unit/$unitId/monitoring');

    final List<dynamic> data = response['data'] ?? [];

    return data.map((json) => MonitoringModel.fromJson(json)).toList();
  }
}
