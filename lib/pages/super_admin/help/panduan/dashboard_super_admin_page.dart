
import 'package:flutter/material.dart';

class DashboardSuperAdminPage extends StatelessWidget {
  const DashboardSuperAdminPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  Widget _buildPanduanItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF6F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryGreen, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.6,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: darkGreen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 0,
        title: const Text(
          'Dashboard Super Admin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFE4F2EA),
                    child: Icon(
                      Icons.dashboard_outlined,
                      color: primaryGreen,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard Super Admin',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Pusat pengelolaan data utama aplikasi SIRUMA.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Mengenal Menu Dashboard'),

            _buildPanduanItem(
              icon: Icons.apartment_outlined,
              title: 'Data Perumahan',
              description:
                  'Digunakan untuk menambahkan dan mengelola data perumahan, nama developer, serta alamat perumahan.',
            ),

            _buildPanduanItem(
              icon: Icons.house_outlined,
              title: 'Data Rumah',
              description:
                  'Digunakan untuk mengelola kelompok blok atau wilayah dan unit rumah yang terdaftar pada perumahan.',
            ),

            _buildPanduanItem(
              icon: Icons.history,
              title: 'Riwayat Aktivitas',
              description:
                  'Menampilkan catatan aktivitas Super Admin, seperti penambahan, perubahan, dan pengelolaan data perumahan maupun unit rumah.',
            ),

            _buildPanduanItem(
              icon: Icons.notifications_none,
              title: 'Notifikasi',
              description:
                  'Menampilkan pemberitahuan terkait perubahan data dan informasi penting dalam aplikasi SIRUMA.',
            ),

            _buildPanduanItem(
              icon: Icons.person_outline,
              title: 'Profil',
              description:
                  'Digunakan untuk melihat dan mengelola informasi profil, keamanan akun, bantuan, serta informasi aplikasi.',
            ),

            _buildSectionTitle('Hal yang Perlu Diperhatikan'),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5EF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryGreen,
                    size: 22,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pastikan data perumahan, blok atau wilayah, dan unit rumah sudah benar sebelum digunakan dalam proses penilaian.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.6,
                        color: darkGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
