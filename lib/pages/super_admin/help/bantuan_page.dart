import 'package:flutter/material.dart';

import 'panduan/dashboard_super_admin_page.dart';
import 'panduan/mengelola_perumahan_page.dart';
import 'panduan/mengelola_blok_page.dart';
import 'panduan/mengelola_unit_page.dart';
import 'panduan/notifikasi_super_admin_page.dart';
import 'panduan/riwayat_aktivitas_page.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final List<Map<String, String>> faq = const [
    {
      'question': 'Bagaimana cara menambahkan perumahan?',
      'answer': 'Buka Data Perumahan, tekan tombol tambah, lalu isi nama developer, nama perumahan, dan alamat. Setelah diperiksa, simpan data.',
    },
    {
      'question': 'Bagaimana jika perumahan tidak memiliki blok?',
      'answer': 'Gunakan nama jalan atau wilayah sebagai kelompok untuk mengatur unit rumah.',
    },
    {
      'question': 'Bagaimana cara menambahkan unit rumah?',
      'answer': 'Pilih perumahan, buka blok atau wilayah yang sesuai, lalu tambahkan unit dengan mengisi nomor rumah dan informasi luas yang tersedia.',
    },
    {
      'question': 'Di mana melihat perubahan data?',
      'answer': 'Buka menu Riwayat Aktivitas pada Dashboard Super Admin untuk melihat catatan aktivitas yang tersedia.',
    },
    {
      'question': 'Bagaimana cara membaca notifikasi?',
      'answer': 'Buka menu Notifikasi. Kamu dapat melihat semua notifikasi atau memfilter notifikasi yang belum dibaca.',
    },
  ];

  void bukaPanduan(BuildContext context, String title) {
    Widget halaman;

    switch (title) {
      case 'Dashboard Super Admin':
        halaman = const DashboardSuperAdminPage();
        break;

      case 'Mengelola Data Perumahan':
        halaman = const MengelolaPerumahanPage();
        break;

      case 'Mengelola Blok atau Wilayah':
        halaman = const MengelolaBlokPage();
        break;

      case 'Mengelola Unit Rumah':
        halaman = const MengelolaUnitPage();
        break;

      case 'Melihat Riwayat Aktivitas':
        halaman = const RiwayatAktivitasPage();
        break;

      case 'Mengelola Notifikasi':
        halaman = const NotifikasiSuperAdminPage();
        break;

      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => halaman));
  }

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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PUSAT BANTUAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE1E9E5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5F2EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: primaryGreen,
                      size: 35,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pusat Bantuan',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Temukan panduan dan jawaban seputar pengelolaan data SIRUMA.',
                          style: TextStyle(
                            fontSize: 13,
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

            const SizedBox(height: 32),

            const Text(
              'Panduan Penggunaan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 16),

            ...[
              {
                'icon': Icons.dashboard_outlined,
                'title': 'Dashboard Super Admin',
                'subtitle': 'Mengenal menu dan fitur utama aplikasi',
              },
              {
                'icon': Icons.apartment_outlined,
                'title': 'Mengelola Data Perumahan',
                'subtitle': 'Panduan menambahkan dan mengubah data perumahan',
              },
              {
                'icon': Icons.grid_view_outlined,
                'title': 'Mengelola Blok atau Wilayah',
                'subtitle': 'Panduan mengatur blok dan wilayah perumahan',
              },
              {
                'icon': Icons.house_outlined,
                'title': 'Mengelola Unit Rumah',
                'subtitle': 'Panduan menambahkan dan mengubah data unit',
              },
              {
                'icon': Icons.history,
                'title': 'Melihat Riwayat Aktivitas',
                'subtitle': 'Panduan melihat catatan perubahan data',
              },
              {
                'icon': Icons.notifications_none,
                'title': 'Mengelola Notifikasi',
                'subtitle': 'Panduan membaca pemberitahuan aplikasi',
              },
            ].map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: InkWell(
                  onTap: () => bukaPanduan(context, item['title'] as String),
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: const Color(0xFFE1E9E5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF7F2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: primaryGreen,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item['subtitle'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.menu_book_outlined,
                          color: secondaryText,
                          size: 23,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Pertanyaan yang Sering Diajukan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: const Color(0xFFE1E9E5)),
              ),
              child: Column(
                children: faq.map((item) {
                  return ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 15),
                    iconColor: primaryGreen,
                    collapsedIconColor: secondaryText,
                    title: Text(
                      item['question']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['answer']!,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: secondaryText,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}