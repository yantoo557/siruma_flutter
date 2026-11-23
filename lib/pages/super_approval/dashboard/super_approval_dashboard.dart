import 'package:flutter/material.dart';

import '../pemeriksaan/detail_pemeriksaan_page.dart';
import '../pemeriksaan/pemeriksaan_page.dart';
import '../notification/notification_page.dart';
import '../history/history_approval_page.dart';
import '../profile/profile_page.dart';

class SuperApprovalDashboardPage extends StatefulWidget {
  const SuperApprovalDashboardPage({super.key});

  @override
  State<SuperApprovalDashboardPage> createState() =>
      _SuperApprovalDashboardPageState();
}

class _SuperApprovalDashboardPageState
    extends State<SuperApprovalDashboardPage> {
  int _selectedIndex = 0;
  bool _hasUnreadNotifications = true;
  String _pemeriksaanFilter = 'Semua';

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  final List<Map<String, dynamic>> _summaryData = [
    {
      'title': 'Menunggu Pemeriksaan',
      'count': '08',
      'icon': Icons.pending_actions_outlined,
      'color': const Color(0xFFD97706),
    },
    {
      'title': 'Perlu Revisi',
      'count': '02',
      'icon': Icons.refresh_rounded,
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Disetujui',
      'count': '15',
      'icon': Icons.check_circle_outline,
      'color': const Color(0xFF16A34A),
    },
    {
      'title': 'Ditolak',
      'count': '01',
      'icon': Icons.cancel_outlined,
      'color': const Color(0xFFD64545),
    },
  ];

  final List<Map<String, String>> _recentSubmissions = [
    {
      'property': 'Perumahan H',
      'unit': 'Blok A · Unit A1',
      'user': 'User SIRUMA',
      'date': '13 November 2026',
      'status': 'Menunggu',
    },
    {
      'property': 'Perumahan B',
      'unit': 'Blok B · Unit B2',
      'user': 'User SIRUMA',
      'date': '12 November 2026',
      'status': 'Menunggu',
    },
    {
      'property': 'Perumahan C',
      'unit': 'Blok A · Unit A3',
      'user': 'User SIRUMA',
      'date': '11 November 2026',
      'status': 'Menunggu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomePage(),
            PemeriksaanPage(
              key: ValueKey(_pemeriksaanFilter),
              initialFilter: _pemeriksaanFilter,
            ),
            const HistoryApprovalPage(),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 28),
          const Text(
            'Selamat Datang,',
            style: TextStyle(fontSize: 15, color: Color(0xFF5B6B66)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Super Approval',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pantau dan kelola pengajuan monitoring rumah.',
            style: TextStyle(fontSize: 13, color: Color(0xFF5B6B66)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ringkasan Approval',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _summaryData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final item = _summaryData[index];

              return _buildSummaryCard(
                title: item['title'],
                count: item['count'],
                icon: item['icon'],
                color: item['color'],
                onTap: () {
                  setState(() {
                    _pemeriksaanFilter = item['title'];
                    _selectedIndex = 1;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pengajuan Terbaru',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentSubmissions.map(_buildSubmissionCard),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            'assets/images/siruma-logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.home_work_outlined, color: primaryGreen);
            },
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIRUMA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              Text(
                'Sistem Informasi Rumah dan Aset',
                style: TextStyle(fontSize: 11, color: Color(0xFF5B6B66)),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPage(
                  onUnreadChanged: (hasUnread) {
                    setState(() {
                      _hasUnreadNotifications = hasUnread;
                    });
                  },
                ),
              ),
            );
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: darkGreen,
                size: 27,
              ),
              if (_hasUnreadNotifications)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: backgroundColor, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8EFEB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 25),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF5B6B66),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(Map<String, String> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPemeriksaanPage(
              data: {
                'perumahan': item['property']!,
                'unit': item['unit']!,
                'pengaju': item['user']!,
                'tanggal': item['date']!,
                'status': item['status'] == 'Menunggu'
                    ? 'Menunggu Pemeriksaan'
                    : item['status']!,
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE8EFEB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.home_work_outlined,
                  color: primaryGreen,
                  size: 22,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item['property']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: darkGreen,
                    ),
                  ),
                ),
                _buildStatusBadge(item['status']!),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item['unit']!,
              style: const TextStyle(fontSize: 13, color: Color(0xFF5B6B66)),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 15,
                  color: Color(0xFF7B8983),
                ),
                const SizedBox(width: 5),
                Text(
                  item['user']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7B8983),
                  ),
                ),
                const Spacer(),
                Text(
                  item['date']!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7B8983),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFFD97706),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPlaceholderPage(
    String title,
    String description,
    IconData icon,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 65, color: primaryGreen),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF5B6B66), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE0F1EA),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: Icon(Icons.fact_check_outlined),
          selectedIcon: Icon(Icons.fact_check_rounded),
          label: 'Pemeriksaan',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_rounded),
          label: 'Riwayat',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }
}
