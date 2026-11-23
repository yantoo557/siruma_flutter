import 'package:flutter/material.dart';

import '../approval_store.dart';

class DetailPemeriksaanPage extends StatefulWidget {
  final Map<String, String> data;

  const DetailPemeriksaanPage({super.key, required this.data});

  @override
  State<DetailPemeriksaanPage> createState() => _DetailPemeriksaanPageState();
}

class _DetailPemeriksaanPageState extends State<DetailPemeriksaanPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  late String status;

  String getData(List<String> keys, String fallback) {
    for (final key in keys) {
      final value = widget.data[key];
      if (value != null && value.isNotEmpty) return value;
    }
    return fallback;
  }

  void _catatKeputusan(String statusBaru, String catatan) {
    ApprovalStore.instance.addDecision({
      'property': getData(['perumahan', 'property'], 'Perumahan H'),
      'unit': getData(['unit', 'blok_unit'], 'Blok A · Unit A1'),
      'user': getData(['pengaju', 'user', 'nama_pengaju'], 'User SIRUMA'),
      'date': getData([
        'tanggal',
        'date',
        'tanggal_pengajuan',
      ], '13 November 2026'),
      'status': statusBaru,
      'note': catatan,
    });
  }

  @override
  void initState() {
    super.initState();
    status = getData(['status'], 'Menunggu Pemeriksaan');
  }

  @override
  Widget build(BuildContext context) {
    final properti = getData(['perumahan', 'property'], 'Perumahan H');
    final blokUnit = getData(['unit', 'blok_unit'], 'Blok A · Unit A1');
    final pengaju = getData(['pengaju', 'user', 'nama_pengaju'], 'User SIRUMA');
    final tanggal = getData([
      'tanggal',
      'date',
      'tanggal_pengajuan',
    ], '13 November 2026');

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 0,
        title: const Text(
          'Detail Pemeriksaan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: 'Informasi Pengajuan',
              icon: Icons.description_outlined,
              children: [
                _buildInfoRow('Nama Pengaju', pengaju),
                _buildInfoRow('Tanggal Pengajuan', tanggal),
                _buildInfoRow('Status', status),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Informasi Properti',
              icon: Icons.home_work_outlined,
              children: [
                _buildInfoRow('Nama Perumahan', properti),
                _buildInfoRow('Blok dan Unit', blokUnit),
                _buildInfoRow('Luas Tanah', '98 m²'),
                _buildInfoRow('Luas Bangunan', '45 m²'),
                _buildInfoRow('Lokasi', 'Makassar'),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Detail Penilaian',
              icon: Icons.calculate_outlined,
              children: [
                _buildInfoRow('Nilai Tanah per m²', 'Rp1.000.000'),
                _buildInfoRow('Nilai Bangunan per m²', 'Rp1.500.000'),
                _buildInfoRow('Total Nilai Tanah', 'Rp98.000.000'),
                _buildInfoRow('Total Nilai Bangunan', 'Rp67.500.000'),
                const Divider(height: 22),
                _buildInfoRow(
                  'Total Estimasi Rumah',
                  'Rp165.500.000',
                  isTotal: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Dokumentasi Foto',
              icon: Icons.photo_library_outlined,
              children: [
                _buildPhotoPlaceholder('Tampak Depan'),
                _buildPhotoPlaceholder('Tampak Samping'),
                _buildPhotoPlaceholder('Tampak Belakang'),
                _buildPhotoPlaceholder('Ruang Dalam'),
                _buildPhotoPlaceholder('Foto Detail (Opsional)'),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Keterangan Monitoring',
              icon: Icons.notes_outlined,
              children: [
                const Text(
                  'Kondisi rumah dalam keadaan baik. '
                  'Dokumentasi dan data penilaian telah '
                  'dikirim oleh User.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Keputusan Pemeriksaan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: status == 'Menunggu Pemeriksaan'
                    ? _konfirmasiPersetujuan
                    : null,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Setujui Pengajuan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: status == 'Menunggu Pemeriksaan'
                    ? () => _dialogCatatan('Minta Revisi', 'PERLU_REVISI')
                    : null,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Minta Revisi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: status == 'Menunggu Pemeriksaan'
                    ? () => _dialogCatatan('Tolak Pengajuan', 'DITOLAK')
                    : null,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Tolak Pengajuan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD64545),
                  side: const BorderSide(color: Color(0xFFD64545)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryGreen, size: 21),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isTotal ? darkGreen : secondaryText,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                color: darkGreen,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Row(
        children: [
          const Icon(Icons.image_outlined, color: primaryGreen, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            'Belum tersedia',
            style: TextStyle(fontSize: 10, color: secondaryText),
          ),
        ],
      ),
    );
  }

  Future<void> _konfirmasiPersetujuan() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Setujui Pengajuan?'),
        content: const Text(
          'Pastikan seluruh data dan dokumentasi telah diperiksa. '
          'Pengajuan akan ditandai sebagai disetujui.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Periksa Lagi'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Setujui'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      setState(() => status = 'Disetujui');

      _catatKeputusan(
        'Disetujui',
        'Data penilaian telah diperiksa dan disetujui.',
      );

      _tampilkanPesan('Pengajuan berhasil disetujui.');
    }
  }

  Future<void> _dialogCatatan(String judul, String statusBaru) async {
    final controller = TextEditingController();

    final catatan = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(judul),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: statusBaru == 'DITOLAK'
                ? 'Tuliskan alasan penolakan...'
                : 'Tuliskan bagian yang perlu diperbaiki...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              Navigator.pop(dialogContext, controller.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kirim Keputusan'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (catatan != null && mounted) {
      final hasilStatus = statusBaru == 'DITOLAK' ? 'Ditolak' : 'Perlu Revisi';

      setState(() {
        status = hasilStatus;
      });

      _catatKeputusan(hasilStatus, catatan);

      _tampilkanPesan('Keputusan berhasil dicatat: $catatan');
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }
}
