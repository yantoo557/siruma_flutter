import 'package:flutter/material.dart';

import '../assessment/select_perumahan_page.dart';
import '../draft/draft_list_page.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';

class UserDashboardPage extends StatefulWidget {
  final String namaPengguna;

  const UserDashboardPage({super.key, this.namaPengguna = 'Pengguna'});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _selectedIndex = 0;

  final GlobalKey<HistoryPageState> _historyKey = GlobalKey<HistoryPageState>();

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  // Membuka halaman riwayat dengan filter yang dipilih.
  void _bukaRiwayat(String filter) {
    _historyKey.currentState?.setFilter(filter);

    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildDashboard(),
            HistoryPage(key: _historyKey),
            ProfilePage(namaPengguna: widget.namaPengguna),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // =========================
  // DASHBOARD UTAMA
  // =========================

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 29),

          const Text(
            'Selamat Datang,',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF52645D),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            widget.namaPengguna,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 25,
              height: 1.25,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Kelola monitoring rumah dan aset dengan mudah.',
            style: TextStyle(fontSize: 13, color: secondaryText),
          ),

          const SizedBox(height: 27),

          _buildCreateMonitoringButton(),

          const SizedBox(height: 28),

          _buildSectionTitle('Ringkasan Monitoring'),

          const SizedBox(height: 12),

          _buildSummaryCard(
            icon: Icons.folder_open_outlined,
            title: 'Draft Saya',
            description: 'Monitoring belum diajukan',
            color: const Color(0xFFE8F4EE),
            iconColor: primaryGreen,
            onTap: _bukaDraft,
          ),

          const SizedBox(height: 10),

          _buildSummaryCard(
            icon: Icons.hourglass_top_rounded,
            title: 'Menunggu Approval',
            description: 'Monitoring sedang diperiksa',
            color: const Color(0xFFEAF1F8),
            iconColor: const Color(0xFF35658A),
            onTap: () => _bukaRiwayat('Menunggu Approval'),
          ),

          const SizedBox(height: 10),

          _buildSummaryCard(
            icon: Icons.check_circle_outline,
            title: 'Disetujui',
            description: 'Monitoring telah disetujui',
            color: const Color(0xFFE8F4EE),
            iconColor: primaryGreen,
            onTap: () => _bukaRiwayat('Disetujui'),
          ),

          const SizedBox(height: 28),

          _buildSectionTitle('Aktivitas Terbaru'),

          const SizedBox(height: 12),

          _buildInformationCard(
            icon: Icons.history,
            title: 'Belum ada aktivitas monitoring',
            description: 'Aktivitas terbaru Anda akan tampil di sini.',
          ),
        ],
      ),
    );
  }

  // =========================
  // NAVIGASI DRAFT
  // =========================

  void _bukaDraft() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DraftListPage()),
    );
  }

  // =========================
  // HEADER DAN LOGO
  // =========================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/siruma-logo.png',
          width: 90,
          height: 58,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'SIRUMA',
              style: TextStyle(
                color: primaryGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),

        InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDCE9E2)),
            ),
            child: const Icon(
              Icons.person_outline,
              color: primaryGreen,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // TOMBOL BUAT MONITORING
  // =========================

  Widget _buildCreateMonitoringButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectPerumahanPage(),
            ),
          );
        },
        icon: const Icon(Icons.add_circle_outline, size: 22),
        label: const Text(
          'Buat Monitoring Baru',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: primaryGreen.withValues(alpha: 0.18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  // =========================
  // RINGKASAN MONITORING
  // =========================

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE1EBE5)),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, size: 20, color: secondaryText),
          ],
        ),
      ),
    );
  }

  // =========================
  // JUDUL BAGIAN
  // =========================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: darkGreen,
      ),
    );
  }

  // =========================
  // KARTU INFORMASI
  // =========================

  Widget _buildInformationCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 94),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryGreen, size: 21),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // BOTTOM NAVIGATION
  // =========================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            _historyKey.currentState?.setFilter('Semua');
          }

          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: secondaryText,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
