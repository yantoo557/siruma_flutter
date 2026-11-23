
import 'package:flutter/material.dart';

class MembuatPenilaianPage extends StatelessWidget {
  const MembuatPenilaianPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  static const List<Map<String, dynamic>> langkah = [
    {
      'nomor': '01',
      'judul': 'Buka Menu Buat Penilaian',
      'deskripsi':
          'Masuk ke halaman Beranda, kemudian pilih menu Buat Penilaian untuk memulai proses penilaian rumah.',
      'icon': Icons.assignment_add,
    },
    {
      'nomor': '02',
      'judul': 'Pilih Perumahan',
      'deskripsi':
          'Pilih perumahan yang menjadi objek penilaian dari daftar perumahan yang tersedia.',
      'icon': Icons.location_city_outlined,
    },
    {
      'nomor': '03',
      'judul': 'Pilih Blok dan Unit Rumah',
      'deskripsi':
          'Pilih blok dan nomor unit rumah yang akan dinilai. Pastikan unit yang dipilih sudah sesuai dengan objek penilaian.',
      'icon': Icons.home_work_outlined,
    },
    {
      'nomor': '04',
      'judul': 'Isi Data Tanah',
      'deskripsi':
          'Lengkapi informasi tanah, termasuk luas tanah dan nilai tanah per meter persegi sesuai data yang tersedia.',
      'icon': Icons.landscape_outlined,
    },
    {
      'nomor': '05',
      'judul': 'Isi Data Bangunan',
      'deskripsi':
          'Lengkapi informasi bangunan, termasuk luas bangunan dan nilai bangunan per meter persegi.',
      'icon': Icons.house_outlined,
    },
    {
      'nomor': '06',
      'judul': 'Unggah Dokumentasi Foto',
      'deskripsi':
          'Tambahkan foto dokumentasi rumah sesuai kategori yang diminta. Pastikan foto jelas dan menggambarkan kondisi properti.',
      'icon': Icons.camera_alt_outlined,
    },
    {
      'nomor': '07',
      'judul': 'Periksa Kembali Penilaian',
      'deskripsi':
          'Tinjau kembali data perumahan, unit, tanah, bangunan, dan dokumentasi foto sebelum mengirim pengajuan.',
      'icon': Icons.fact_check_outlined,
    },
    {
      'nomor': '08',
      'judul': 'Ajukan Approval',
      'deskripsi':
          'Jika seluruh informasi sudah benar dan lengkap, tekan Ajukan Approval untuk mengirim penilaian kepada Super Approval.',
      'icon': Icons.send_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 0,
        title: const Text(
          'Membuat Penilaian',
          style: TextStyle(
            color: darkGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE5ECE8),
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: Color(0xFFE4F2EA),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: primaryGreen,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panduan Membuat Penilaian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ikuti langkah berikut untuk membuat penilaian rumah di SIRUMA.',
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

            const SizedBox(height: 25),

            const Text(
              'Langkah-langkah Penilaian',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 15),

            ...langkah.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4F2EA),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: primaryGreen,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE5ECE8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LANGKAH ${item['nomor']}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: primaryGreen,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item['judul'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: darkGreen,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['deskripsi'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.6,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4EF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryGreen,
                    size: 22,
                  ),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'Pastikan semua data dan dokumentasi sudah benar sebelum mengajukan approval. Periksa kembali informasi agar proses pemeriksaan berjalan lancar.',
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

            const Center(
              child: Text(
                'SIRUMA • Sistem Informasi Rumah dan Aset',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
