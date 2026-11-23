import 'package:flutter/material.dart';

class DokumentasiFotoPage extends StatelessWidget {
  const DokumentasiFotoPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  static const List<Map<String, dynamic>> daftarFoto = [
    {
      'nomor': '01',
      'judul': 'Foto Tampak Depan Rumah',
      'deskripsi': 'Ambil foto seluruh bagian depan rumah agar kondisi dan bentuk bangunan terlihat jelas.',
      'icon': Icons.home_outlined,
    },
    {
      'nomor': '02',
      'judul': 'Foto Bagian Dalam Bangunan',
      'deskripsi': 'Dokumentasikan kondisi ruangan bagian dalam, seperti ruang tamu, kamar, dan area lainnya.',
      'icon': Icons.chair_outlined,
    },
    {
      'nomor': '03',
      'judul': 'Foto Kondisi Bangunan',
      'deskripsi': 'Ambil foto bagian bangunan yang menunjukkan kondisi fisik, termasuk dinding, lantai, atap, dan bagian penting lainnya.',
      'icon': Icons.construction_outlined,
    },
    {
      'nomor': '04',
      'judul': 'Foto Lingkungan Sekitar',
      'deskripsi': 'Dokumentasikan kondisi lingkungan dan akses jalan di sekitar properti.',
      'icon': Icons.landscape_outlined,
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
          'Dokumentasi Foto',
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
                      Icons.camera_alt_outlined,
                      color: DokumentasiFotoPage.primaryGreen,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panduan Dokumentasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Pelajari jenis foto yang diperlukan dalam proses penilaian properti.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: DokumentasiFotoPage.secondaryText,
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
              'Jenis Foto yang Dibutuhkan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 12),

            // Daftar jenis foto
            ...daftarFoto.map((foto) {
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
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4EF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        foto['icon'] as IconData,
                        color: DokumentasiFotoPage.primaryGreen,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foto['judul'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            foto['deskripsi'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: DokumentasiFotoPage.secondaryText,
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

            // Tips foto
            const Text(
              'Tips Pengambilan Foto',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: const Column(
                children: [
                  _TipsItem(
                    icon: Icons.wb_sunny_outlined,
                    text: 'Gunakan pencahayaan yang cukup.',
                  ),
                  _TipsItem(
                    icon: Icons.center_focus_strong_outlined,
                    text: 'Pastikan objek foto terlihat jelas dan tidak buram.',
                  ),
                  _TipsItem(
                    icon: Icons.crop_free_outlined,
                    text: 'Ambil gambar dengan sudut yang memperlihatkan kondisi objek.',
                  ),
                  _TipsItem(
                    icon: Icons.visibility_outlined,
                    text: 'Pastikan tidak ada bagian penting yang tertutup.',
                  ),
                  _TipsItem(
                    icon: Icons.check_circle_outline,
                    text: 'Periksa kembali foto sebelum mengunggahnya.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Informasi
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
                      'Pastikan seluruh dokumentasi foto sesuai dengan kondisi aktual properti. Foto yang jelas akan membantu proses pemeriksaan penilaian.',
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

class _TipsItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipsItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DokumentasiFotoPage.primaryGreen, size: 19),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: DokumentasiFotoPage.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
