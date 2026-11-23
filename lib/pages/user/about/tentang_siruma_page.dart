
import 'package:flutter/material.dart';

class TentangSirumaPage extends StatelessWidget {
  const TentangSirumaPage({super.key});

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
          'Tentang SIRUMA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
        child: Column(
          children: [
            // Logo dan identitas aplikasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 22,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE5ECE8),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/siruma-logo.png',
                    height: 105,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.home_work_rounded,
                        size: 85,
                        color: primaryGreen,
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'SIRUMA',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Sistem Informasi Rumah dan Aset',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4EF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Versi 1.0.0',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Deskripsi aplikasi
            _InfoCard(
              title: 'Tentang Aplikasi',
              icon: Icons.info_outline,
              child: const Text(
                'SIRUMA merupakan aplikasi Sistem Informasi Rumah '
                'dan Aset yang digunakan untuk membantu proses '
                'pengelolaan data properti, penilaian rumah, '
                'dokumentasi kondisi properti, serta pengajuan '
                'dan pemeriksaan approval secara terstruktur.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.7,
                  color: secondaryText,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 15),

            // Fungsi aplikasi
            _InfoCard(
              title: 'Fungsi Utama',
              icon: Icons.grid_view_rounded,
              child: const Column(
                children: [
                  _FeatureItem(
                    icon: Icons.home_work_outlined,
                    title: 'Data Properti',
                    description:
                        'Pengelolaan data perumahan, blok, dan unit rumah.',
                  ),
                  _FeatureItem(
                    icon: Icons.assessment_outlined,
                    title: 'Penilaian Rumah',
                    description:
                        'Pencatatan data tanah dan bangunan untuk penilaian.',
                  ),
                  _FeatureItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'Dokumentasi',
                    description:
                        'Penyimpanan foto kondisi properti.',
                  ),
                  _FeatureItem(
                    icon: Icons.fact_check_outlined,
                    title: 'Approval',
                    description:
                        'Proses pemeriksaan dan persetujuan penilaian.',
                  ),
                  _FeatureItem(
                    icon: Icons.history_outlined,
                    title: 'Riwayat',
                    description:
                        'Pemantauan status dan riwayat pengajuan.',
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Informasi pengembang
            _InfoCard(
              title: 'Informasi Pengembang',
              icon: Icons.groups_outlined,
              child: const Column(
                children: [
                  _DetailRow(
                    label: 'Pengembang',
                    value: 'Tim Pengembangan SIRUMA',
                  ),
                  Divider(height: 22),
                  _DetailRow(
                    label: 'Platform',
                    value: 'Android',
                  ),
                  Divider(height: 22),
                  _DetailRow(
                    label: 'Versi Aplikasi',
                    value: '1.0.0',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'SIRUMA',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Sistem Informasi Rumah dan Aset',
              style: TextStyle(
                fontSize: 10,
                color: secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '© 2026 SIRUMA. All rights reserved.',
              style: TextStyle(
                fontSize: 10,
                color: secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                size: 20,
                color: TentangSirumaPage.primaryGreen,
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TentangSirumaPage.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: TentangSirumaPage.primaryGreen,
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
                    fontWeight: FontWeight.w600,
                    color: TentangSirumaPage.darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: TentangSirumaPage.secondaryText,
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: TentangSirumaPage.secondaryText,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: TentangSirumaPage.darkGreen,
            ),
          ),
        ),
      ],
    );
  }
}
