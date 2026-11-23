
import 'package:flutter/material.dart';

class NotifikasiSuperAdminPage extends StatelessWidget {
  const NotifikasiSuperAdminPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: child,
    );
  }

  Widget _buildStep({
    required int number,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE4F2EA),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                const SizedBox(height: 5),
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
      padding: const EdgeInsets.only(top: 24, bottom: 12),
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
          'Notifikasi Super Admin',
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
            _buildCard(
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFE4F2EA),
                    child: Icon(
                      Icons.notifications_none,
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
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Pemberitahuan mengenai aktivitas dan perubahan data dalam SIRUMA.',
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

            _buildSectionTitle('Cara Membuka Notifikasi'),

            _buildCard(
              child: Column(
                children: [
                  _buildStep(
                    number: 1,
                    title: 'Buka menu Notifikasi',
                    description:
                        'Pilih menu Notifikasi melalui navigasi bagian bawah Dashboard Super Admin.',
                  ),
                  _buildStep(
                    number: 2,
                    title: 'Periksa daftar pemberitahuan',
                    description:
                        'Baca judul dan keterangan setiap notifikasi untuk mengetahui informasi yang disampaikan.',
                  ),
                  _buildStep(
                    number: 3,
                    title: 'Pilih notifikasi',
                    description:
                        'Tekan notifikasi untuk menandainya sebagai sudah dibaca.',
                  ),
                  _buildStep(
                    number: 4,
                    title: 'Gunakan filter',
                    description:
                        'Pilih Semua untuk melihat seluruh notifikasi atau Belum Dibaca untuk melihat pemberitahuan yang belum dibuka.',
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Jenis Notifikasi Super Admin'),

            _buildCard(
              child: Column(
                children: [
                  _notificationItem(
                    Icons.apartment_outlined,
                    'Perumahan Baru Ditambahkan',
                    'Pemberitahuan ketika terdapat data perumahan baru.',
                  ),
                  const Divider(height: 22),
                  _notificationItem(
                    Icons.grid_view_rounded,
                    'Blok Baru Ditambahkan',
                    'Informasi mengenai penambahan blok atau wilayah.',
                  ),
                  const Divider(height: 22),
                  _notificationItem(
                    Icons.house_outlined,
                    'Unit Rumah Baru Ditambahkan',
                    'Pemberitahuan ketika unit rumah baru terdaftar.',
                  ),
                  const Divider(height: 22),
                  _notificationItem(
                    Icons.edit_outlined,
                    'Data Perumahan Diperbarui',
                    'Informasi mengenai perubahan data perumahan.',
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Mengelola Status Notifikasi'),

            _buildCard(
              child: const Text(
                '• Notifikasi yang belum dibaca dapat dikenali melalui penanda status pada daftar.\n\n'
                '• Tekan notifikasi untuk menandainya sebagai sudah dibaca.\n\n'
                '• Gunakan tombol Tandai Semua Dibaca apabila ingin mengubah seluruh notifikasi menjadi sudah dibaca.\n\n'
                '• Gunakan filter Semua dan Belum Dibaca untuk memudahkan pencarian.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.8,
                  color: darkGreen,
                ),
              ),
            ),

            _buildSectionTitle('Catatan Penting'),

            _buildCard(
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryGreen,
                    size: 23,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Periksa notifikasi secara berkala agar Super Admin mengetahui perubahan dan aktivitas penting dalam pengelolaan data SIRUMA.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.7,
                        color: secondaryText,
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

  Widget _notificationItem(
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFEDF6F1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: primaryGreen, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
