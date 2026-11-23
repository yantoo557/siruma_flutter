import 'package:flutter/material.dart';

class PengajuanApprovalPage extends StatelessWidget {
  const PengajuanApprovalPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  static const List<Map<String, dynamic>> langkah = [
    {
      'nomor': '01',
      'judul': 'Periksa Kelengkapan Data',
      'deskripsi': 'Pastikan seluruh data tanah, bangunan, dan dokumentasi foto sudah diisi dengan benar.',
      'icon': Icons.fact_check_outlined,
    },
    {
      'nomor': '02',
      'judul': 'Buka Halaman Review',
      'deskripsi': 'Masuk ke halaman Review untuk melihat kembali seluruh informasi penilaian properti.',
      'icon': Icons.preview_outlined,
    },
    {
      'nomor': '03',
      'judul': 'Periksa Hasil Penilaian',
      'deskripsi': 'Periksa hasil perhitungan nilai tanah dan bangunan sebelum mengirim pengajuan.',
      'icon': Icons.calculate_outlined,
    },
    {
      'nomor': '04',
      'judul': 'Ajukan Approval',
      'deskripsi': 'Tekan tombol Ajukan Approval untuk mengirim hasil penilaian kepada Super Approval.',
      'icon': Icons.send_outlined,
    },
    {
      'nomor': '05',
      'judul': 'Tunggu Pemeriksaan',
      'deskripsi': 'Pengajuan akan masuk ke proses pemeriksaan oleh Super Approval. Pantau statusnya melalui aplikasi.',
      'icon': Icons.hourglass_empty_outlined,
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
          'Pengajuan Approval',
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: Color(0xFFE4F2EA),
                    child: Icon(
                      Icons.approval_outlined,
                      color: primaryGreen,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panduan Pengajuan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ikuti langkah berikut untuk mengirim hasil penilaian properti.',
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
              'Langkah Pengajuan Approval',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 14),

            // Daftar langkah
            ...langkah.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 11),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5ECE8)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4EF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
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
                            'LANGKAH ${item['nomor']}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['judul'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['deskripsi'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 15),

            // Informasi status
            const Text(
              'Status Pengajuan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: const Column(
                children: [
                  _StatusItem(
                    color: Color(0xFFE5A000),
                    title: 'Menunggu Pemeriksaan',
                    description: 'Pengajuan sedang menunggu diperiksa.',
                  ),
                  _StatusItem(
                    color: Color(0xFF2878C8),
                    title: 'Perlu Revisi',
                    description: 'Ada data yang perlu diperbaiki.',
                  ),
                  _StatusItem(
                    color: Color(0xFF24966B),
                    title: 'Disetujui',
                    description: 'Pengajuan telah disetujui.',
                  ),
                  _StatusItem(
                    color: Color(0xFFD64545),
                    title: 'Ditolak',
                    description: 'Pengajuan tidak disetujui.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Catatan
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
                  Icon(Icons.info_outline, color: primaryGreen, size: 22),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'Pastikan seluruh informasi penilaian sudah benar sebelum diajukan. Jika terdapat revisi, ikuti catatan dari Super Approval dan lakukan perbaikan.',
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
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
                    color: PengajuanApprovalPage.darkGreen,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: PengajuanApprovalPage.secondaryText,
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
