import '../perumahan/perumahan_list_page.dart';
import '../riwayat/riwayat_aktivitas_page.dart';
import '../notifikasi/notifikasi_page.dart';
import '../profile/profile_page.dart';

import 'package:flutter/material.dart';

class SuperAdminDashboardPage extends StatefulWidget {
  final String namaPengguna;

  const SuperAdminDashboardPage({super.key, this.namaPengguna = 'Super Admin'});

  @override
  State<SuperAdminDashboardPage> createState() =>
      _SuperAdminDashboardPageState();
}

class _SuperAdminDashboardPageState extends State<SuperAdminDashboardPage> {
  int _selectedIndex = 0;
  String _namaPengguna = 'Super Admin';

  @override
  void initState() {
    super.initState();
    _namaPengguna = widget.namaPengguna;
  }

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildDashboard(),
            const NotifikasiPage(),
            ProfilePage(
              onNamaBerubah: (namaBaru) {
                setState(() {
                  _namaPengguna = namaBaru;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 30),

          Text(
            'Selamat Datang, $_namaPengguna',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Kelola data perumahan dan unit rumah.',
            style: TextStyle(fontSize: 13, color: secondaryText),
          ),

          const SizedBox(height: 29),

          _buildMenuCard(
            icon: Icons.apartment_outlined,
            title: 'Data Perumahan',
            description: 'Kelola daftar perumahan yang terdaftar.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PerumahanListPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          _buildMenuCard(
            icon: Icons.house_outlined,
            title: 'Data Rumah',
            description: 'Kelola blok dan unit rumah.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const PerumahanListPage(modeKelolaRumah: true),
                ),
              );
            },
          ),
          const SizedBox(height: 15),

          _buildMenuCard(
            icon: Icons.history,
            title: 'Riwayat Aktivitas',
            description: 'Lihat catatan perubahan data yang dilakukan.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RiwayatAktivitasPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1EBE5)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7F2),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: primaryGreen, size: 24),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: secondaryText, size: 23),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
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
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
