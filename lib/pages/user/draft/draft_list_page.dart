
import 'package:flutter/material.dart';

class DraftListPage extends StatefulWidget {
  const DraftListPage({super.key});

  @override
  State<DraftListPage> createState() => _DraftListPageState();
}

class _DraftListPageState extends State<DraftListPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final List<Map<String, String>> _drafts = [
    {
      'perumahan': 'Perumahan Contoh Asri',
      'blok': 'Blok A',
      'rumah': 'A-01',
      'tanggal': '13 November 2026',
      'waktu': '19:30',
    },
    {
      'perumahan': 'Perumahan Contoh Asri',
      'blok': 'Blok B',
      'rumah': 'B-02',
      'tanggal': '12 November 2026',
      'waktu': '16:45',
    },
  ];

  void _hapusDraft(int index) {
    final namaRumah = _drafts[index]['rumah']!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Draft?'),
          content: Text(
            'Apakah Anda yakin ingin menghapus Draft rumah $namaRumah?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: secondaryText),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _drafts.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Draft berhasil dihapus dari daftar demo.'),
                  ),
                );
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _lanjutkanDraft(String nomorRumah) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pemulihan Draft $nomorRumah akan diaktifkan setelah penyimpanan Draft terintegrasi.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _drafts.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
                      children: [
                        _buildSummary(),
                        const SizedBox(height: 22),
                        const Text(
                          'Daftar Draft',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          _drafts.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: _buildDraftCard(index),
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

  Widget _buildHeader() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5ECE8)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 19,
              color: darkGreen,
            ),
          ),
          const Expanded(
            child: Text(
              'Draft Saya',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4EE),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_open_outlined,
              color: primaryGreen,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Draft Tersimpan',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_drafts.length} Draft monitoring',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftCard(int index) {
    final draft = _drafts[index];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7F2),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.house_outlined,
                  color: primaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft['perumahan']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${draft['blok']} · Rumah ${draft['rumah']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4DF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Draft',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9A6B16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: Color(0xFFE8EFEB)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: secondaryText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Terakhir diedit: ${draft['tanggal']} · ${draft['waktu']}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => _lanjutkanDraft(draft['rumah']!),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text(
                      'Lanjutkan',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              SizedBox(
                height: 40,
                width: 45,
                child: OutlinedButton(
                  onPressed: () => _hapusDraft(index),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Color(0xFFF0DADA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4EE),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                color: primaryGreen,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Draft',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monitoring yang Anda simpan sementara akan tampil di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
