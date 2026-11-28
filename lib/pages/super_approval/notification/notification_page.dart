import 'package:flutter/material.dart';

import '../../../core/services/approval_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../models/approval_submission_model.dart';
import '../../../models/notification_model.dart';
import '../pemeriksaan/detail_pemeriksaan_page.dart';

class NotificationPage extends StatefulWidget {
  final ValueChanged<bool> onUnreadChanged;

  const NotificationPage({
    super.key,
    required this.onUnreadChanged,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  bool _isMarkingAll = false;
  bool _isOpeningNotification = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = await NotificationService.getNotifications();
      final notifications =
          result['notifications'] as List<NotificationModel>;
      final unreadCount = (result['unread_count'] as int?) ??
          notifications.where((item) => !item.isRead).length;

      if (!mounted) return;
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
      widget.onUnreadChanged(unreadCount > 0);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _markAllAsRead() async {
    if (_notifications.isEmpty || _isMarkingAll) return;

    setState(() => _isMarkingAll = true);
    try {
      await NotificationService.markAllAsRead();
      if (!mounted) return;
      setState(() {
        _notifications = _notifications
            .map(
              (item) => NotificationModel(
                id: item.id,
                judul: item.judul,
                pesan: item.pesan,
                tipe: item.tipe,
                referenceId: item.referenceId,
                isRead: true,
                createdAt: item.createdAt,
              ),
            )
            .toList();
        _isMarkingAll = false;
      });
      widget.onUnreadChanged(false);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isMarkingAll = false);
      _showMessage('Gagal menandai notifikasi: $error');
    }
  }

  Future<void> _openNotification(NotificationModel notification) async {
    if (_isOpeningNotification) return;

    final monitoringId = notification.referenceId;
    if (monitoringId == null || monitoringId <= 0) {
      _showMessage('Notifikasi ini tidak memiliki referensi pengajuan.');
      return;
    }

    setState(() => _isOpeningNotification = true);
    try {
      // reference_id pada notifikasi menunjuk ke monitoring_id, bukan approval_id.
      // Ambil daftar approval lalu cocokkan kedua ID tersebut.
      final approvals = await ApprovalService.getApprovals();
      ApprovalSubmissionModel? matchedApproval;
      for (final approval in approvals) {
        if (approval.monitoringId == monitoringId) {
          matchedApproval = approval;
          break;
        }
      }

      final approvalDetail = matchedApproval;
      if (approvalDetail == null) {
        throw Exception(
          'Data approval untuk pengajuan ini tidak ditemukan. '
          'Monitoring ID: $monitoringId',
        );
      }

      // Simpan status dibaca ke server. Jika gagal, jangan hentikan akses detail.
      if (!notification.isRead) {
        try {
          await NotificationService.markAsRead(notification.id);
          if (mounted) {
            setState(() {
              _notifications = _notifications
                  .map(
                    (item) => item.id == notification.id
                        ? NotificationModel(
                            id: item.id,
                            judul: item.judul,
                            pesan: item.pesan,
                            tipe: item.tipe,
                            referenceId: item.referenceId,
                            isRead: true,
                            createdAt: item.createdAt,
                          )
                        : item,
                  )
                  .toList();
            });
            widget.onUnreadChanged(
              _notifications.any((item) => !item.isRead),
            );
          }
        } catch (error) {
          debugPrint('Gagal menandai notifikasi dibaca: $error');
        }
      }

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPemeriksaanPage(
            data: {
              'approval_id': approvalDetail.id.toString(),
              'perumahan': approvalDetail.perumahan,
              'blok': approvalDetail.blok,
              'unit': approvalDetail.unit,
              'blok_unit': '${approvalDetail.blok} · ${approvalDetail.unit}',
              'pengaju': approvalDetail.pengaju,
              'tanggal': _formatDate(approvalDetail.tanggalMonitoring),
              'status': approvalDetail.status,
            },
          ),
        ),
      );
    } catch (error) {
      if (mounted) _showMessage('Gagal membuka detail pengajuan: $error');
    } finally {
      if (mounted) setState(() => _isOpeningNotification = false);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-${local.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '-';
    final difference = DateTime.now().difference(date.toLocal());
    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inMinutes < 60) return '${difference.inMinutes} menit lalu';
    if (difference.inHours < 24) return '${difference.inHours} jam lalu';
    if (difference.inDays == 1) return 'Kemarin';
    if (difference.inDays < 7) return '${difference.inDays} hari lalu';
    return _formatDate(date);
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PERLU_REVISI':
        return Icons.refresh_rounded;
      case 'DISETUJUI':
        return Icons.check_circle_outline_rounded;
      case 'DITOLAK':
        return Icons.highlight_off_rounded;
      case 'PENGAJUAN_BARU':
        return Icons.assignment_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toUpperCase()) {
      case 'PERLU_REVISI':
        return const Color(0xFF2563EB);
      case 'DISETUJUI':
        return const Color(0xFF16A34A);
      case 'DITOLAK':
        return const Color(0xFFD64545);
      default:
        return primaryGreen;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = _notifications.any((item) => !item.isRead);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: darkGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: hasUnread && !_isMarkingAll ? _markAllAsRead : null,
            child: _isMarkingAll
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Tandai Semua Dibaca',
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryGreen),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 40, color: primaryGreen),
              const SizedBox(height: 12),
              const Text(
                'Notifikasi gagal dimuat',
                style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF718078), fontSize: 12),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: _loadNotifications,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_notifications.isEmpty) {
      return RefreshIndicator(
        color: primaryGreen,
        onRefresh: _loadNotifications,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 150),
            Icon(Icons.notifications_none_rounded, size: 48, color: Color(0xFF89958F)),
            SizedBox(height: 12),
            Center(
              child: Text(
                'Belum ada notifikasi.',
                style: TextStyle(color: Color(0xFF718078), fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _loadNotifications,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: _isOpeningNotification ? null : () => _openNotification(item),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: item.isRead ? Colors.white : const Color(0xFFEAF5F0),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE8EFEB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getNotificationIcon(item.tipe),
                      color: _getNotificationColor(item.tipe),
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.judul,
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.pesan,
                          style: const TextStyle(
                            color: Color(0xFF5B6B66),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(item.createdAt),
                          style: const TextStyle(
                            color: Color(0xFF89958F),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!item.isRead)
                    Container(
                      width: 9,
                      height: 9,
                      margin: const EdgeInsets.only(top: 5, left: 8),
                      decoration: const BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
