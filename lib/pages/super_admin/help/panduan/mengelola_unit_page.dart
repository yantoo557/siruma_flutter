
import 'package:flutter/material.dart';

class MengelolaUnitPage extends StatelessWidget {
  const MengelolaUnitPage({super.key});

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
          'Mengelola Unit Rumah',
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
                      Icons.house_outlined,
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
                          'Pengelolaan Unit Rumah',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Kelola identitas dan informasi fisik setiap unit rumah.',
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

            _buildSectionTitle('Cara Menambahkan Unit Rumah'),

            _buildCard(
              child: Column(
                children: [
                  _buildStep(
                    number: 1,
                    title: 'Pilih perumahan',
                    description:
                        'Buka menu Data Rumah atau Data Perumahan, kemudian pilih perumahan yang ingin dikelola.',
                  ),
                  _buildStep(
                    number: 2,
                    title: 'Pilih blok atau wilayah',
                    description:
                        'Masuk ke kelompok blok atau wilayah tempat unit rumah akan ditambahkan.',
                  ),
                  _buildStep(
                    number: 3,
                    title: 'Pilih Tambah Unit',
                    description:
                        'Tekan tombol tambah unit untuk membuka formulir data rumah.',
                  ),
                  _buildStep(
                    number: 4,
                    title: 'Masukkan nomor rumah',
                    description:
                        'Isi identitas unit rumah, misalnya A-01 atau nomor rumah sesuai alamat yang digunakan.',
                  ),
                  _buildStep(
                    number: 5,
                    title: 'Masukkan luas tanah',
                    description:
                        'Isi luas tanah berdasarkan data yang benar dalam satuan meter persegi (m²).',
                  ),
                  _buildStep(
                    number: 6,
                    title: 'Masukkan luas bangunan',
                    description:
                        'Jika kolom luas bangunan tersedia, masukkan luas bangunan sesuai data properti.',
                  ),
                  _buildStep(
                    number: 7,
                    title: 'Simpan unit rumah',
                    description:
                        'Periksa kembali informasi unit kemudian tekan Simpan.',
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Contoh Data Unit Rumah'),

            _buildCard(
              child: Column(
                children: [
                  _buildExampleRow('Perumahan', 'Perumahan Contoh Asri'),
                  const Divider(height: 20),
                  _buildExampleRow('Blok / Wilayah', 'Blok A'),
                  const Divider(height: 20),
                  _buildExampleRow('Nomor Rumah', 'A-01'),
                  const Divider(height: 20),
                  _buildExampleRow('Luas Tanah', '100 m²'),
                  const Divider(height: 20),
                  _buildExampleRow('Luas Bangunan', '60 m²'),
                ],
              ),
            ),

            _buildSectionTitle('Mengedit Data Unit Rumah'),

            _buildCard(
              child: const Text(
                '1. Pilih unit rumah yang ingin diperbarui.\n\n'
                '2. Buka detail unit rumah.\n\n'
                '3. Tekan tombol Edit.\n\n'
                '4. Perbarui nomor rumah atau informasi luas tanah dan bangunan.\n\n'
                '5. Periksa kembali data lalu simpan perubahan.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.8,
                  color: darkGreen,
                ),
              ),
            ),

            _buildSectionTitle('Menghapus Data Unit Rumah'),

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
                      'Sebelum menghapus unit rumah, pastikan unit tersebut tidak memiliki riwayat penilaian atau data lain yang masih digunakan. Ikuti konfirmasi dan aturan penghapusan pada sistem.',
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
                '• Pastikan nomor rumah tidak duplikat dalam kelompok blok atau wilayah yang sama.\n\n'
                '• Luas tanah dan luas bangunan harus menggunakan satuan meter persegi (m²).\n\n'
                '• Periksa kembali unit rumah sebelum disimpan.\n\n'
                '• Data unit rumah menjadi dasar bagi pengguna dalam melakukan penilaian properti.',
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

  Widget _buildExampleRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: secondaryText,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: darkGreen,
            ),
          ),
        ),
      ],
    );
  }
}
