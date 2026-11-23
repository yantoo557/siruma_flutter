
import 'package:flutter/material.dart';

class RiwayatApprovalPage extends StatelessWidget {
  const RiwayatApprovalPage({super.key});

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
          'Riwayat Approval',
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
                    Icons.history,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Riwayat Keputusan Approval',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Halaman riwayat digunakan untuk melihat kembali pengajuan yang telah diberikan keputusan oleh Super Approval.',
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
              'Informasi dalam Riwayat',
              style: TextStyle(
                color: darkGreen,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            _informasi(
              Icons.home_work_outlined,
              'Informasi Rumah',
              'Nama perumahan, blok, dan nomor unit yang telah diajukan.',
            ),
            _informasi(
              Icons.verified_outlined,
              'Status Keputusan',
              'Menampilkan status pengajuan, seperti Disetujui atau Ditolak.',
            ),
            _informasi(
              Icons.calendar_today_outlined,
              'Tanggal Approval',
              'Menampilkan tanggal ketika keputusan approval diberikan.',
            ),
            _informasi(
              Icons.person_outline,
              'Pemberi Keputusan',
              'Menampilkan informasi pihak yang memberikan keputusan approval.',
            ),
            _informasi(
              Icons.notes_outlined,
              'Catatan Approval',
              'Menampilkan catatan atau alasan yang diberikan saat proses approval.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Cara Melihat Riwayat',
              style: TextStyle(
                color: darkGreen,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            _langkah(
              '01',
              'Buka menu Riwayat Approval',
              'Pilih menu riwayat pada dashboard Super Approval.',
            ),
            _langkah(
              '02',
              'Pilih pengajuan',
              'Pilih pengajuan yang ingin dilihat informasinya.',
            ),
            _langkah(
              '03',
              'Periksa detail keputusan',
              'Tinjau status, tanggal keputusan, dan catatan approval.',
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
                      'Riwayat approval membantu memantau keputusan yang telah diberikan dan menjadi referensi pemeriksaan pengajuan sebelumnya.',
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

  Widget _informasi(
    IconData icon,
    String judul,
    String deskripsi,
  ) {
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
          Icon(icon, color: primaryGreen, size: 22),
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
