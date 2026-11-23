
import 'package:flutter/material.dart';

import 'panduan/dashboard_super_approval_page.dart';
import 'panduan/daftar_pengajuan_page.dart';
import 'panduan/detail_penilaian_page.dart';
import 'panduan/pemeriksaan_foto_page.dart';
import 'panduan/menyetujui_pengajuan_page.dart';
import 'panduan/menolak_pengajuan_page.dart';
import 'panduan/riwayat_approval_page.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  Widget itemPanduan({
    required BuildContext context,
    required IconData icon,
    required String judul,
    required String deskripsi,
    required Widget halaman,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => halaman),
        );
      },
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF6F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryGreen,
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deskripsi,
                    style: const TextStyle(
                      fontSize: 11,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: secondaryText,
              size: 21,
            ),
          ],
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
          'Bantuan',
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
                color: primaryGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Pusat Bantuan Super Approval',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Pelajari cara memeriksa, mengevaluasi, dan memberikan keputusan terhadap pengajuan penilaian rumah.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Panduan Penggunaan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Column(
                children: [
                  itemPanduan(
                    context: context,
                    icon: Icons.dashboard_outlined,
                    judul: 'Dashboard Super Approval',
                    deskripsi: 'Mengenal dashboard dan ringkasan pengajuan',
                    halaman: const DashboardSuperApprovalPage(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),

                  itemPanduan(
                    context: context,
                    icon: Icons.assignment_outlined,
                    judul: 'Daftar Pengajuan',
                    deskripsi: 'Melihat daftar penilaian yang diajukan',
                    halaman: const DaftarPengajuanPage(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),

                  itemPanduan(
                    context: context,
                    icon: Icons.fact_check_outlined,
                    judul: 'Detail Penilaian',
                    deskripsi: 'Memeriksa data tanah dan bangunan',
                    halaman: const DetailPenilaianPage(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),

                  itemPanduan(
                    context: context,
                    icon: Icons.photo_library_outlined,
                    judul: 'Pemeriksaan Dokumentasi Foto',
                    deskripsi: 'Memeriksa kelengkapan foto rumah',
                    halaman: const PemeriksaanFotoPage(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),

                  itemPanduan(
                    context: context,
                    icon: Icons.check_circle_outline,
                    judul: 'Menyetujui Pengajuan',
                    deskripsi: 'Memberikan persetujuan penilaian',
                    halaman: const MenyetujuiPengajuanPage(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),

                  itemPanduan(
                    context: context,
                    icon: Icons.cancel_outlined,
                    judul: 'Menolak Pengajuan',
                    deskripsi: 'Menolak pengajuan dan memberikan catatan',
                    halaman: const MenolakPengajuanPage(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),

                  itemPanduan(
                    context: context,
                    icon: Icons.history,
                    judul: 'Riwayat Approval',
                    deskripsi: 'Melihat riwayat keputusan pengajuan',
                    halaman: const RiwayatApprovalPage(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                      'Pastikan seluruh data dan dokumentasi diperiksa dengan teliti sebelum memberikan keputusan approval.',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Column(
                children: [
                  Text(
                    'SIRUMA',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sistem Informasi Rumah dan Aset',
                    style: TextStyle(
                      fontSize: 10,
                      color: secondaryText,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(
                      fontSize: 10,
                      color: secondaryText,
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
}
