import '../../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  // Mengambil daftar notifikasi dari Laravel.
  static Future<Map<String, dynamic>> getNotifications() async {
    final response = await ApiService.get('notifications');

    final List<dynamic> data = response['data'] ?? [];

    final notifications = data
        .map(
          (item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();

    final unreadCount = (response['unread_count'] as num?)?.toInt() ?? 0;

    return {'notifications': notifications, 'unread_count': unreadCount};
  }

  // Menandai satu notifikasi sudah dibaca.
  static Future<Map<String, dynamic>> markAsRead(int id) async {
    return await ApiService.patch('notifications/$id/read');
  }

  // Menandai semua notifikasi sudah dibaca.
  static Future<Map<String, dynamic>> markAllAsRead() async {
    return await ApiService.patch('notifications/read-all');
  }

  static Future<Map<String, dynamic>> getNotificationDetail(int id) async {
    final response = await ApiService.get('notifications/$id');

    return Map<String, dynamic>.from(response['data'] ?? {});
  }
}
