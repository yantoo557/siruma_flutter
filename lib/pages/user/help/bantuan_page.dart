import 'package:flutter/material.dart';

import 'panduan/membuat_penilaian_page.dart';
import 'panduan/dokumentasi_foto_page.dart';
import 'panduan/pengajuan_approval_page.dart';
import 'panduan/melihat_riwayat_page.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final List<Map<String, String>> faq = const [
    {
      'question': 'Bagaimana cara membuat penilaian rumah?',
      'answer': 'Buka menu Beranda, pilih Buat Penilaian, kemudian pilih perumahan dan unit rumah. Lengkapi data tanah, data bangunan, dokumentasi foto, lalu periksa kembali sebelum mengajukan penilaian.',
    },
    {
      'question': 'Bagaimana cara mengunggah foto rumah?',
      'answer': 'Pada tahap dokumentasi foto, pilih foto sesuai kategori yang diminta. Pastikan foto terlihat jelas dan sesuai dengan kondisi properti.',
    },
    {
      'question': 'Bagaimana cara mengajukan approval?',
      'answer': 'Setelah semua data penilaian lengkap, buka halaman Review dan tekan tombol Ajukan Approval untuk mengirim pengajuan kepada Super Approval.',
    },
    {
      'question': 'Apa yang harus dilakukan jika pengajuan direvisi?',
      'answer': 'Periksa catatan revisi dari pemeriksa. Perbaiki data atau dokumentasi sesuai arahan, kemudian ajukan kembali untuk diperiksa.',
    },
    {
      'question': 'Di mana saya dapat melihat riwayat penilaian?',
      'answer': 'Buka menu Riwayat untuk melihat daftar penilaian yang pernah dibuat beserta status pengajuannya.',
    },
    {
      'question': 'Bagaimana jika terjadi kendala saat menggunakan aplikasi?',
      'answer': 'Hubungi administrator SIRUMA melalui saluran komunikasi internal yang berlaku di lingkungan kerja Anda. Sertakan penjelasan kendala agar dapat ditindaklanjuti.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: darkGreen,
        title: const Text(
          'Bantuan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkGreen,
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
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4F2EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_outlined,
                      color: primaryGreen,
                      size: 31,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pusat Bantuan',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Temukan panduan dan jawaban seputar penggunaan aplikasi SIRUMA.',
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

            const SizedBox(height: 27),

            const Text(
              'Panduan Penggunaan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 12),

            _PanduanItem(
              icon: Icons.home_work_outlined,
              title: 'Membuat Penilaian',
              subtitle: 'Panduan pengisian data properti',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembuatPenilaianPage(),
                  ),
                );
              },
            ),
            _PanduanItem(
              icon: Icons.camera_alt_outlined,
              title: 'Dokumentasi Foto',
              subtitle: 'Panduan pengambilan dan unggah foto',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DokumentasiFotoPage(),
                  ),
                );
              },
            ),
            _PanduanItem(
              icon: Icons.send_outlined,
              title: 'Pengajuan Approval',
              subtitle: 'Panduan mengirim penilaian',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PengajuanApprovalPage(),
                  ),
                );
              },
            ),
            _PanduanItem(
              icon: Icons.history_outlined,
              title: 'Melihat Riwayat',
              subtitle: 'Panduan melihat status pengajuan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MelihatRiwayatPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Pertanyaan yang Sering Diajukan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < faq.length; i++) ...[
                    ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      iconColor: primaryGreen,
                      collapsedIconColor: secondaryText,
                      title: Text(
                        faq[i]['question']!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faq[i]['answer']!,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              color: secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (i != faq.length - 1)
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFE9EFEB),
                      ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4EF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.headset_mic_outlined,
                    color: primaryGreen,
                    size: 27,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Masih Membutuhkan Bantuan?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Silakan hubungi administrator SIRUMA melalui saluran komunikasi internal yang tersedia.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: secondaryText,
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
                      letterSpacing: 1.5,
                      color: primaryGreen,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sistem Informasi Rumah dan Aset',
                    style: TextStyle(fontSize: 10, color: secondaryText),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(fontSize: 10, color: secondaryText),
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

class _PanduanItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _PanduanItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color secondaryText = Color(0xFF718078);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE5ECE8)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF6F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryGreen, size: 21),
            ),
            const SizedBox(width: 13),
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
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.menu_book_outlined,
              color: secondaryText,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}
