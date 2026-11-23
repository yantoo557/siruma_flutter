
import 'package:flutter/material.dart';

class RiwayatAktivitasPage extends StatelessWidget {
  const RiwayatAktivitasPage({super.key});

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final List<Map<String, dynamic>> aktivitas = const [
    {
      'judul': 'Menambahkan Perumahan',
      'detail': 'Perumahan Contoh Asri berhasil ditambahkan.',
      'waktu': '14 November 2026 • 09.30',
      'ikon': Icons.apartment_outlined,
    },
    {
      'judul': 'Menambahkan Blok',
      'detail': 'Blok A ditambahkan pada Perumahan Contoh Asri.',
      'waktu': '14 November 2026 • 09.15',
      'ikon': Icons.grid_view_rounded,
    },
    {
      'judul': 'Menambahkan Unit Rumah',
      'detail': 'Unit A-01 dengan luas tanah 98 m² berhasil ditambahkan.',
      'waktu': '14 November 2026 • 09.00',
      'ikon': Icons.house_outlined,
    },
    {
      'judul': 'Mengedit Data Perumahan',
      'detail': 'Informasi Perumahan Contoh Asri diperbarui.',
      'waktu': '13 November 2026 • 15.20',
      'ikon': Icons.edit_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Aktivitas',
          style: TextStyle(
            color: darkGreen,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text(
            'Catatan Aktivitas',
            style: TextStyle(
              color: darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Lihat aktivitas pengelolaan data yang dilakukan Super Admin.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F3EC),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Data demo fiktif',
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 22),

          ...aktivitas.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE1EBE5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF7F2),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      item['ikon'] as IconData,
                      color: primaryGreen,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['judul'] as String,
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          item['detail'] as String,
                          style: const TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 9),

                        Text(
                          item['waktu'] as String,
                          style: const TextStyle(
                            color: secondaryText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
