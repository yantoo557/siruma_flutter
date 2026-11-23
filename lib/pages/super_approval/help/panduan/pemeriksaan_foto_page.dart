
import 'package:flutter/material.dart';

class PemeriksaanFotoPage extends StatelessWidget {
  const PemeriksaanFotoPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkGreen,
            size: 19,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pemeriksaan Dokumentasi Foto',
          style: TextStyle(
            color: darkGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
                color: primaryGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Pemeriksaan Dokumentasi Foto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Pastikan dokumentasi foto rumah yang dilampirkan oleh User sudah lengkap dan sesuai dengan kondisi objek penilaian.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hal yang Perlu Diperiksa',
              style: TextStyle(
                color: darkGreen,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            _pemeriksaan(
              Icons.home_outlined,
              'Foto Tampak Depan Rumah',
              'Pastikan bagian depan rumah terlihat jelas dan sesuai dengan unit yang diajukan.',
            ),
            _pemeriksaan(
              Icons.meeting_room_outlined,
              'Foto Bagian Dalam',
              'Periksa dokumentasi bagian dalam rumah agar kondisi bangunan dapat dinilai.',
            ),
            _pemeriksaan(
              Icons.landscape_outlined,
              'Foto Area Tanah',
              'Pastikan area tanah atau halaman yang relevan terlihat dalam dokumentasi.',
            ),
            _pemeriksaan(
              Icons.image_search_outlined,
              'Kualitas dan Kejelasan Foto',
              'Pastikan foto tidak buram, tidak terpotong, dan objek dapat dikenali dengan baik.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Tahapan Pemeriksaan',
              style: TextStyle(
                color: darkGreen,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _langkah('01', 'Buka dokumentasi foto pada detail pengajuan.'),
            _langkah('02', 'Periksa seluruh foto yang telah diunggah.'),
            _langkah('03', 'Cocokkan foto dengan informasi rumah dan data penilaian.'),
            _langkah('04', 'Pastikan dokumentasi cukup untuk mendukung proses penilaian.'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4EF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryGreen,
                    size: 21,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Jika dokumentasi tidak lengkap atau tidak sesuai, lakukan pemeriksaan lebih lanjut sebelum memberikan keputusan approval.',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pemeriksaan(
    IconData icon,
    String judul,
    String deskripsi,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4EF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: primaryGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  deskripsi,
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _langkah(String nomor, String deskripsi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE1F0E9),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              nomor,
              style: const TextStyle(
                color: primaryGreen,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                deskripsi,
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
