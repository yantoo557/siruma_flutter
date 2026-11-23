
import 'package:flutter/material.dart';

class MelihatRiwayatPage extends StatelessWidget {
  const MelihatRiwayatPage({super.key});

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
        foregroundColor: darkGreen,
        title: const Text(
          'Panduan Melihat Riwayat',
          style: TextStyle(
            fontSize: 17,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFE4F2EA),
                    child: Icon(
                      Icons.history_outlined,
                      size: 34,
                      color: primaryGreen,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Riwayat Penilaian',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Pantau seluruh pengajuan penilaian rumah '
                    'yang pernah Anda buat melalui menu Riwayat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Cara Melihat Riwayat',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 14),

            const _RiwayatStep(
              number: '1',
              title: 'Buka Menu Riwayat',
              description:
                  'Pada halaman utama aplikasi SIRUMA, '
                  'pilih menu Riwayat untuk membuka daftar '
                  'penilaian yang pernah dibuat.',
              icon: Icons.history,
            ),

            const _RiwayatStep(
              number: '2',
              title: 'Pilih Data Penilaian',
              description:
                  'Cari dan pilih salah satu data penilaian '
                  'yang ingin Anda lihat informasinya.',
              icon: Icons.description_outlined,
            ),

            const _RiwayatStep(
              number: '3',
              title: 'Periksa Detail Penilaian',
              description:
                  'Periksa informasi properti, tanggal '
                  'pengajuan, serta hasil dan status '
                  'pemeriksaan penilaian.',
              icon: Icons.search_outlined,
            ),

            const _RiwayatStep(
              number: '4',
              title: 'Perhatikan Status Pengajuan',
              description:
                  'Periksa status terakhir untuk mengetahui '
                  'perkembangan proses penilaian rumah Anda.',
              icon: Icons.fact_check_outlined,
              isLast: true,
            ),

            const SizedBox(height: 25),

            const Text(
              'Mengenal Status Pengajuan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 12),

            const _StatusItem(
              color: Color(0xFFE5A000),
              title: 'Menunggu Pemeriksaan',
              description:
                  'Pengajuan telah dikirim dan menunggu '
                  'pemeriksaan Super Approval.',
            ),

            const _StatusItem(
              color: Color(0xFF2878C8),
              title: 'Perlu Revisi',
              description:
                  'Pengajuan perlu diperbaiki sesuai '
                  'catatan dari pemeriksa.',
            ),

            const _StatusItem(
              color: Color(0xFF219653),
              title: 'Disetujui',
              description:
                  'Pengajuan telah disetujui oleh '
                  'Super Approval.',
            ),

            const _StatusItem(
              color: Color(0xFFD64545),
              title: 'Ditolak',
              description:
                  'Pengajuan tidak disetujui oleh '
                  'Super Approval.',
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4EF),
                borderRadius: BorderRadius.circular(14),
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
                      'Periksa riwayat secara berkala untuk '
                      'mengetahui perubahan status pengajuan. '
                      'Jika terdapat revisi, ikuti catatan '
                      'yang diberikan oleh pemeriksa.',
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

class _RiwayatStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final bool isLast;

  const _RiwayatStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4F2EA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MelihatRiwayatPage.primaryGreen,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 55,
                  color: const Color(0xFFDCE9E1),
                ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: const Color(0xFFE5ECE8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        color: MelihatRiwayatPage.primaryGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: MelihatRiwayatPage.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.6,
                      color: MelihatRiwayatPage.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final Color color;
  final String title;
  final String description;

  const _StatusItem({
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MelihatRiwayatPage.darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: MelihatRiwayatPage.secondaryText,
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
