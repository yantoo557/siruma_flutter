
import 'package:flutter/material.dart';

class MenyetujuiPengajuanPage extends StatelessWidget {
  const MenyetujuiPengajuanPage({super.key});

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
          'Menyetujui Pengajuan',
          style: TextStyle(
            color: darkGreen,
            fontSize: 17,
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
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Persetujuan Pengajuan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Panduan memberikan persetujuan terhadap pengajuan penilaian rumah yang telah diperiksa.',
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
              'Syarat Sebelum Menyetujui',
              style: TextStyle(
                color: darkGreen,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            _syarat(
              'Data rumah sesuai',
              'Informasi perumahan, blok, nomor unit, dan luas rumah telah diperiksa.',
            ),
            _syarat(
              'Data penilaian benar',
              'Nilai tanah, nilai bangunan, dan hasil perhitungan telah diperiksa.',
            ),
            _syarat(
              'Dokumentasi lengkap',
              'Foto rumah tersedia, jelas, dan sesuai dengan objek penilaian.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Langkah Memberikan Persetujuan',
              style: TextStyle(
                color: darkGreen,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            _langkah(
              '01',
              'Pilih pengajuan',
              'Buka pengajuan dengan status Menunggu Approval.',
            ),
            _langkah(
              '02',
              'Periksa seluruh informasi',
              'Tinjau detail penilaian dan dokumentasi foto rumah.',
            ),
            _langkah(
              '03',
              'Pilih Setujui',
              'Tekan tombol persetujuan setelah seluruh pemeriksaan selesai.',
            ),
            _langkah(
              '04',
              'Konfirmasi keputusan',
              'Periksa kembali keputusan sebelum mengonfirmasi persetujuan.',
            ),
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
                      'Berikan persetujuan hanya jika data dan dokumentasi telah diperiksa serta dinyatakan sesuai.',
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

  Widget _syarat(String judul, String deskripsi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: primaryGreen,
            size: 21,
          ),
          const SizedBox(width: 11),
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

  Widget _langkah(String nomor, String judul, String deskripsi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE1F0E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              nomor,
              style: const TextStyle(
                color: primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
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
}
