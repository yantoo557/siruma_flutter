import 'package:flutter/material.dart';

import '../pemeriksaan/detail_pemeriksaan_page.dart';

class NotificationPage extends StatefulWidget {
  final ValueChanged<bool> onUnreadChanged;

  const NotificationPage({super.key, required this.onUnreadChanged});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Pengajuan Monitoring Baru',
      'message': 'Ahmad Fauzi mengirim pengajuan Perumahan H, Blok A, Unit A1.',
      'time': 'Baru saja',
      'type': 'new',
      'isRead': false,
      'perumahan': 'Perumahan H',
      'unit': 'Blok A · Unit A1',
      'pengaju': 'Ahmad Fauzi',
      'tanggal': '13 November 2026',
      'status': 'Menunggu Pemeriksaan',
    },
    {
      'title': 'Pengajuan Dikirim Ulang',
      'message':
          'Andi Saputra mengirim ulang pengajuan setelah melakukan revisi.',
      'time': '2 jam lalu',
      'type': 'revision',
      'isRead': false,
      'perumahan': 'Perumahan C',
      'unit': 'Blok A · Unit A3',
      'pengaju': 'Andi Saputra',
      'tanggal': '11 November 2026',
      'status': 'Menunggu Pemeriksaan',
    },
    {
      'title': 'Pengajuan Monitoring Baru',
      'message':
          'Muhammad Rizal mengirim pengajuan Perumahan B, Blok B, Unit B2.',
      'time': '5 jam lalu',
      'type': 'new',
      'isRead': false,
      'perumahan': 'Perumahan B',
      'unit': 'Blok B · Unit B2',
      'pengaju': 'Muhammad Rizal',
      'tanggal': '12 November 2026',
      'status': 'Menunggu Pemeriksaan',
    },
    {
      'title': 'Pemeriksaan Selesai',
      'message': 'Pengajuan Perumahan C, Blok A, Unit A3 telah disetujui.',
      'time': 'Kemarin',
      'type': 'approved',
      'isRead': true,
      'perumahan': 'Perumahan C',
      'unit': 'Blok A · Unit A3',
      'pengaju': 'Andi Saputra',
      'tanggal': '10 November 2026',
      'status': 'Disetujui',
    },
  ];

  bool get _hasUnreadNotifications {
    return _notifications.any(
      (notification) => notification['isRead'] == false,
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification['isRead'] = true;
      }
    });

    widget.onUnreadChanged(_hasUnreadNotifications);
  }

  void _openNotification(int index) {
    final item = _notifications[index];

    setState(() {
      item['isRead'] = true;
    });

    widget.onUnreadChanged(_hasUnreadNotifications);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPemeriksaanPage(
          data: {
            'perumahan': item['perumahan'].toString(),
            'unit': item['unit'].toString(),
            'pengaju': item['pengaju'].toString(),
            'tanggal': item['tanggal'].toString(),
            'status': item['status'].toString(),
          },
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'revision':
        return Icons.refresh_rounded;
      case 'approved':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.assignment_outlined;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'revision':
        return const Color(0xFF2563EB);
      case 'approved':
        return const Color(0xFF16A34A);
      default:
        return primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: _markAllAsRead,
            child: const Text(
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
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          final bool isRead = item['isRead'];

          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => _openNotification(index),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isRead ? Colors.white : const Color(0xFFEAF5F0),
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
                      _getNotificationIcon(item['type']),
                      color: _getNotificationColor(item['type']),
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['message'],
                          style: const TextStyle(
                            color: Color(0xFF5B6B66),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['time'],
                          style: const TextStyle(
                            color: Color(0xFF89958F),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isRead)
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
