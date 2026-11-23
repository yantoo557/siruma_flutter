
import 'package:flutter/material.dart';

class MengelolaBlokPage extends StatelessWidget {
  const MengelolaBlokPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

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
          'Mengelola Blok / Wilayah',
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
                      Icons.grid_view_rounded,
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
                          'Pengelolaan Blok / Wilayah',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Kelompokkan unit rumah berdasarkan blok atau wilayah perumahan.',
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

            _buildSectionTitle('Cara Menambahkan Blok'),

            _buildCard(
              child: Column(
                children: [
                  _buildStep(
                    number: 1,
                    title: 'Buka Data Perumahan',
                    description:
                        'Pilih perumahan yang ingin dikelola melalui menu Data Perumahan atau Data Rumah.',
                  ),
                  _buildStep(
                    number: 2,
                    title: 'Masuk ke pengelolaan blok',
                    description:
                        'Pilih perumahan untuk melihat daftar blok atau wilayah yang sudah terdaftar.',
                  ),
                  _buildStep(
                    number: 3,
                    title: 'Pilih Tambah Blok',
                    description:
                        'Tekan tombol tambah untuk membuat kelompok blok baru.',
                  ),
                  _buildStep(
                    number: 4,
                    title: 'Masukkan nama blok',
                    description:
                        'Contohnya Blok A, Blok B, atau Blok C sesuai pembagian perumahan.',
                  ),
                  _buildStep(
                    number: 5,
                    title: 'Simpan blok',
                    description:
                        'Periksa nama blok kemudian simpan. Blok baru akan muncul dalam daftar.',
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Perumahan Tanpa Sistem Blok'),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jika perumahan tidak menggunakan pembagian blok, gunakan nama jalan atau wilayah sebagai kelompok unit rumah.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.7,
                      color: secondaryText,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF6F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contoh pengelompokan:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Jalan Melati\n'
                          '• Jalan Anggrek\n'
                          '• Jalan Mawar',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.8,
                            color: darkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Mengedit dan Menghapus Blok'),

            _buildCard(
              child: const Text(
                'Untuk memperbarui nama blok atau wilayah:\n\n'
                '1. Pilih blok atau wilayah yang ingin dikelola.\n'
                '2. Gunakan menu Edit untuk mengubah namanya.\n'
                '3. Simpan perubahan setelah diperiksa.\n\n'
                'Sebelum menghapus blok, pastikan tidak ada unit rumah atau data penilaian yang masih terkait.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.8,
                  color: darkGreen,
                ),
              ),
            ),

            _buildSectionTitle('Catatan Penting'),

            _buildCard(
              child: const Text(
                '• Setiap blok atau wilayah harus berada di bawah satu perumahan.\n\n'
                '• Hindari penggunaan nama blok atau wilayah yang sama dalam satu perumahan.\n\n'
                '• Pastikan pengelompokan sudah benar sebelum menambahkan unit rumah.\n\n'
                '• Unit rumah akan dikelompokkan berdasarkan blok atau wilayah yang dipilih.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.7,
                  color: darkGreen,
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
