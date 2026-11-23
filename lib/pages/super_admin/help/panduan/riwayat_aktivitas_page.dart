
import 'package:flutter/material.dart';

class RiwayatAktivitasPage extends StatelessWidget {
  const RiwayatAktivitasPage({super.key});

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

  Widget _activityExample({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
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
          'Riwayat Aktivitas',
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
                      Icons.history,
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
                          'Riwayat Aktivitas',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Catatan aktivitas Super Admin dalam mengelola data SIRUMA.',
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

            _buildSectionTitle('Cara Melihat Riwayat Aktivitas'),

            _buildCard(
              child: Column(
                children: [
                  _buildStep(
                    number: 1,
                    title: 'Buka Dashboard Super Admin',
                    description:
                        'Masuk ke halaman utama menggunakan akun Super Admin.',
                  ),
                  _buildStep(
                    number: 2,
                    title: 'Pilih Riwayat Aktivitas',
                    description:
                        'Tekan menu Riwayat Aktivitas pada Dashboard.',
                  ),
                  _buildStep(
                    number: 3,
                    title: 'Periksa daftar aktivitas',
                    description:
                        'Lihat catatan aktivitas yang ditampilkan untuk mengetahui perubahan data yang telah dilakukan.',
                  ),
                  _buildStep(
                    number: 4,
                    title: 'Perhatikan informasi aktivitas',
                    description:
                        'Periksa jenis aktivitas, keterangan, pengguna yang melakukan perubahan, serta waktu aktivitas apabila informasi tersebut tersedia.',
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Jenis Aktivitas yang Dicatat'),

            _buildCard(
              child: Column(
                children: [
                  _activityExample(
                    icon: Icons.apartment_outlined,
                    title: 'Menambahkan Perumahan',
                    description:
                        'Pencatatan ketika Super Admin mendaftarkan perumahan baru.',
                  ),
                  _activityExample(
                    icon: Icons.grid_view_rounded,
                    title: 'Menambahkan Blok atau Wilayah',
                    description:
                        'Pencatatan ketika kelompok blok atau wilayah baru dibuat.',
                  ),
                  _activityExample(
                    icon: Icons.house_outlined,
                    title: 'Menambahkan Unit Rumah',
                    description:
                        'Pencatatan ketika unit rumah baru dimasukkan ke dalam data perumahan.',
                  ),
                  _activityExample(
                    icon: Icons.edit_outlined,
                    title: 'Mengedit Data',
                    description:
                        'Pencatatan ketika informasi perumahan, blok, atau unit rumah diperbarui.',
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Manfaat Riwayat Aktivitas'),

            _buildCard(
              child: const Text(
                '• Membantu Super Admin memantau perubahan data.\n\n'
                '• Memudahkan pemeriksaan aktivitas pengelolaan perumahan.\n\n'
                '• Menjadi referensi ketika terjadi perbedaan informasi data.\n\n'
                '• Membantu menjaga transparansi pengelolaan data SIRUMA.',
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
                      'Riwayat Aktivitas berbeda dengan Riwayat Penilaian. Riwayat Aktivitas mencatat perubahan data oleh Super Admin, sedangkan Riwayat Penilaian berkaitan dengan proses penilaian rumah dan persetujuannya.',
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
}
