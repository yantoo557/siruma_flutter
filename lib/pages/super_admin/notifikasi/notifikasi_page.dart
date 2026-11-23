
import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Perumahan Baru Ditambahkan',
      'description':
          'Perumahan Contoh Asri berhasil ditambahkan ke sistem.',
      'date': 'Hari ini, 10.30',
      'icon': Icons.apartment,
      'isRead': false,
    },
    {
      'title': 'Blok Baru Ditambahkan',
      'description':
          'Blok A berhasil ditambahkan pada Perumahan Contoh Asri.',
      'date': 'Kemarin, 14.20',
      'icon': Icons.grid_view,
      'isRead': false,
    },
    {
      'title': 'Unit Rumah Baru Ditambahkan',
      'description':
          'Unit A-01 berhasil ditambahkan dengan luas tanah 100 m².',
      'date': '12 November 2026, 09.15',
      'icon': Icons.house_outlined,
      'isRead': true,
    },
    {
      'title': 'Data Perumahan Diperbarui',
      'description':
          'Informasi Perumahan Contoh Asri berhasil diperbarui.',
      'date': '11 November 2026, 15.00',
      'icon': Icons.edit_outlined,
      'isRead': true,
    },
  ];

  int get _unreadCount =>
      _notifications.where((item) => item['isRead'] == false).length;

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 1) {
      return _notifications
          .where((item) => item['isRead'] == false)
          .toList();
    }
    return _notifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (final item in _notifications) {
        item['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi sudah dibaca.'),
      ),
    );
  }

  void _markAsRead(Map<String, dynamic> notification) {
    if (notification['isRead'] == false) {
      setState(() {
        notification['isRead'] = true;
      });
    }
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
                    'Informasi aktivitas pengelolaan SIRUMA.',
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
                        onPressed: _unreadCount == 0
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
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
                      itemCount: _filteredNotifications.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _filteredNotifications[index];
                        return _buildNotificationCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

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
            color: isSelected ? primaryGreen : const Color(0xFFE1EBE5),
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

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    final bool isRead = item['isRead'];

    return InkWell(
      onTap: () => _markAsRead(item),
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
                item['icon'],
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
                          item['title'],
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
                    item['description'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    item['date'],
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
