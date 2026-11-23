
import 'package:flutter/material.dart';

class MengelolaPerumahanPage extends StatelessWidget {
  const MengelolaPerumahanPage({super.key});

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
          'Mengelola Perumahan',
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
                      Icons.apartment_outlined,
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
                          'Data Perumahan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Kelola informasi perumahan dan developer yang terdaftar di SIRUMA.',
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

            _buildSectionTitle('Cara Menambahkan Perumahan'),

            _buildCard(
              child: Column(
                children: [
                  _buildStep(
                    number: 1,
                    title: 'Buka menu Data Perumahan',
                    description:
                        'Pilih menu Data Perumahan pada halaman Dashboard Super Admin.',
                  ),
                  _buildStep(
                    number: 2,
                    title: 'Pilih Tambah Perumahan',
                    description:
                        'Tekan tombol tambah untuk membuka formulir perumahan baru.',
                  ),
                  _buildStep(
                    number: 3,
                    title: 'Isi informasi perumahan',
                    description:
                        'Masukkan nama developer, nama perumahan, dan alamat atau lokasi perumahan sesuai data yang tersedia.',
                  ),
                  _buildStep(
                    number: 4,
                    title: 'Simpan data',
                    description:
                        'Periksa kembali informasi yang dimasukkan, kemudian tekan tombol Simpan.',
                  ),
                  _buildStep(
                    number: 5,
                    title: 'Periksa daftar perumahan',
                    description:
                        'Pastikan perumahan yang baru ditambahkan sudah muncul pada daftar Data Perumahan.',
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Mengedit Data Perumahan'),

            _buildCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jika terdapat perubahan informasi perumahan, Super Admin dapat:',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: secondaryText,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1. Buka menu Data Perumahan.\n'
                    '2. Pilih perumahan yang ingin diperbarui.\n'
                    '3. Tekan tombol Edit.\n'
                    '4. Perbarui informasi yang diperlukan.\n'
                    '5. Simpan perubahan.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.9,
                      color: darkGreen,
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Menghapus Data Perumahan'),

            _buildCard(
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFD28B26),
                    size: 25,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pastikan data yang akan dihapus sudah benar. Periksa terlebih dahulu apakah perumahan tersebut masih memiliki blok, unit rumah, atau data penilaian yang terkait. Penghapusan harus mengikuti aturan sistem.',
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

            _buildSectionTitle('Catatan Penting'),

            _buildCard(
              child: const Text(
                '• Pastikan nama developer dan perumahan ditulis dengan benar.\n\n'
                '• Gunakan alamat yang jelas agar lokasi perumahan mudah dikenali.\n\n'
                '• Hindari membuat data perumahan yang sama lebih dari satu kali.\n\n'
                '• Data perumahan menjadi dasar untuk pengelolaan blok atau wilayah dan unit rumah.',
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
