
import 'package:flutter/material.dart';

import '../../../core/services/notification_service.dart';
import '../../../models/notification_model.dart';
import 'detail_notifikasi.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  int _selectedFilter = 0;
  int _unreadCount = 0;

  bool _isLoading = true;
  bool _isMarkingAllRead = false;

  String? _errorMessage;

  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // Mengambil notifikasi dari Laravel API.
  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await NotificationService.getNotifications();

      if (!mounted) return;

      setState(() {
        _notifications =
            response['notifications'] as List<NotificationModel>;

        _unreadCount = response['unread_count'] as int;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // Filter notifikasi.
  List<NotificationModel> get _filteredNotifications {
    if (_selectedFilter == 1) {
      return _notifications.where((item) => !item.isRead).toList();
    }

    return _notifications;
  }

  // Menandai satu notifikasi sudah dibaca.
  Future<void> _markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    try {
      await NotificationService.markAsRead(notification.id);

      if (!mounted) return;

      setState(() {
        final index = _notifications.indexWhere(
          (item) => item.id == notification.id,
        );

        if (index != -1) {
          final old = _notifications[index];

          _notifications[index] = NotificationModel(
            id: old.id,
            judul: old.judul,
            pesan: old.pesan,
            tipe: old.tipe,
            referenceId: old.referenceId,
            isRead: true,
            createdAt: old.createdAt,
          );
        }

        _unreadCount =
            _notifications.where((item) => !item.isRead).length;
      });
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal memperbarui notifikasi: '
        '${e.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  // Mengambil detail dan menampilkan pop-up.
  Future<void> _openNotificationDetail(NotificationModel item) async {
    await _markAsRead(item);

    if (!mounted) return;

    try {
      final detail =
          await NotificationService.getNotificationDetail(item.id);

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return DetailNotifikasiDialog(
            detail: detail,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal mengambil detail notifikasi: '
        '${e.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  // Menandai semua notifikasi sudah dibaca.
  Future<void> _markAllAsRead() async {
    if (_unreadCount == 0 || _isMarkingAllRead) return;

    setState(() {
      _isMarkingAllRead = true;
    });

    try {
      await NotificationService.markAllAsRead();

      if (!mounted) return;

      setState(() {
        _notifications = _notifications.map((item) {
          return NotificationModel(
            id: item.id,
            judul: item.judul,
            pesan: item.pesan,
            tipe: item.tipe,
            referenceId: item.referenceId,
            isRead: true,
            createdAt: item.createdAt,
          );
        }).toList();

        _unreadCount = 0;
        _isMarkingAllRead = false;
      });

      _showMessage('Semua notifikasi sudah dibaca.');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isMarkingAllRead = false;
      });

      _showMessage(
        'Gagal memperbarui notifikasi: '
        '${e.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  // Menentukan ikon berdasarkan tipe notifikasi.
  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'PENGAJUAN_BARU':
        return Icons.assignment_outlined;
      case 'DISETUJUI':
        return Icons.check_circle_outline;
      case 'DITOLAK':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  // Format tanggal notifikasi.
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(dateString)?.toLocal();

    if (date == null) return dateString;

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day ${months[date.month - 1]} ${date.year}, $hour.$minute';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Informasi pengajuan dan status penilaian SIRUMA.',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryText,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_unreadCount belum dibaca',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                      TextButton(
                        onPressed: _unreadCount == 0 ||
                                _isLoading ||
                                _isMarkingAllRead
                            ? null
                            : _markAllAsRead,
                        child: const Text(
                          'Tandai semua dibaca',
                          style: TextStyle(
                            color: primaryGreen,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFilterChip('Semua', 0),
                      const SizedBox(width: 10),
                      _buildFilterChip('Belum Dibaca', 1),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // Konten utama halaman.
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryGreen,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_outlined,
                size: 48,
                color: secondaryText,
              ),
              const SizedBox(height: 14),
              const Text(
                'Gagal Memuat Notifikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadNotifications,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _loadNotifications,
      child: _filteredNotifications.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 350,
                  child: _buildEmptyState(),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
              itemCount: _filteredNotifications.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _filteredNotifications[index];
                return _buildNotificationCard(item);
              },
            ),
    );
  }

  // Filter chip.
  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryGreen
                : const Color(0xFFE1EBE5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : secondaryText,
          ),
        ),
      ),
    );
  }

  // Kartu notifikasi.
  Widget _buildNotificationCard(NotificationModel item) {
    final bool isRead = item.isRead;

    final title = item.judul;
    final description = item.pesan;
    final type = item.tipe;
    final date = _formatDate(
      item.createdAt?.toIso8601String(),
    );

    return InkWell(
      onTap: () => _openNotificationDetail(item),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFEDF7F2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isRead
                ? const Color(0xFFE1EBE5)
                : const Color(0xFFD0E9DC),
          ),
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
                _getNotificationIcon(type),
                color: primaryGreen,
                size: 23,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: darkGreen,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 10,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan ketika tidak ada notifikasi.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 55,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 14),
          const Text(
            'Tidak Ada Notifikasi',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Belum ada notifikasi yang perlu dibaca.',
            style: TextStyle(
              fontSize: 12,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
