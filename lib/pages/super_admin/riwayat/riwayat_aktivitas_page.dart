
import 'package:flutter/material.dart';

import '../../../core/services/audit_log_service.dart';
import '../../../models/audit_log_model.dart';

class RiwayatAktivitasPage extends StatefulWidget {
  const RiwayatAktivitasPage({super.key});

  @override
  State<RiwayatAktivitasPage> createState() =>
      _RiwayatAktivitasPageState();
}

class _RiwayatAktivitasPageState
    extends State<RiwayatAktivitasPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  List<AuditLogModel> aktivitas = [];

  bool isLoading = true;
  String? errorMessage;

  int currentPage = 1;
  int lastPage = 1;
  int totalAktivitas = 0;

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat({int page = 1}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await AuditLogService.getRiwayat(
        page: page,
      );

      if (!mounted) return;

      setState(() {
        aktivitas = response.data;
        currentPage = response.currentPage;
        lastPage = response.lastPage;
        totalAktivitas = response.total;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  IconData _getIcon(String tabel) {
    switch (tabel.toLowerCase()) {
      case 'perumahan':
        return Icons.apartment_outlined;
      case 'blok':
        return Icons.grid_view_rounded;
      case 'unit':
        return Icons.house_outlined;
      case 'monitoring':
        return Icons.fact_check_outlined;
      case 'foto_monitoring':
        return Icons.photo_camera_outlined;
      case 'approval':
        return Icons.verified_outlined;
      default:
        return Icons.history_rounded;
    }
  }

  Color _getActivityColor(String aktivitas) {
    switch (aktivitas.toUpperCase()) {
      case 'TAMBAH':
      case 'CREATE':
        return const Color(0xFF16865B);
      case 'EDIT':
      case 'UPDATE':
        return const Color(0xFF2876C7);
      case 'HAPUS':
      case 'DELETE':
        return const Color(0xFFD64545);
      default:
        return primaryGreen;
    }
  }

  String _formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) {
      return 'Waktu tidak tersedia';
    }

    try {
      final date = DateTime.parse(tanggal).toLocal();

      final hari = date.day.toString().padLeft(2, '0');
      final bulan = date.month.toString().padLeft(2, '0');
      final tahun = date.year;

      final jam = date.hour.toString().padLeft(2, '0');
      final menit = date.minute.toString().padLeft(2, '0');

      return '$hari/$bulan/$tahun • $jam:$menit';
    } catch (_) {
      return tanggal;
    }
  }

  String _formatAktivitas(String aktivitas) {
    switch (aktivitas.toUpperCase()) {
      case 'TAMBAH':
      case 'CREATE':
        return 'Menambahkan Data';
      case 'EDIT':
      case 'UPDATE':
        return 'Mengedit Data';
      case 'HAPUS':
      case 'DELETE':
        return 'Menghapus Data';
      default:
        return aktivitas;
    }
  }

  Widget _buildActivityCard(AuditLogModel item) {
    final warna = _getActivityColor(item.aktivitas);

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
              _getIcon(item.tabel),
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
                  '${_formatAktivitas(item.aktivitas)} ${item.tabel}',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: warna.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.aktivitas.toUpperCase(),
                    style: TextStyle(
                      color: warna,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.keterangan ?? 'Tidak ada keterangan.',
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 14,
                      color: secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.namaUser ?? 'Pengguna tidak diketahui',
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTanggal(item.createdAt),
                      style: const TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryGreen,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 55,
                color: secondaryText,
              ),
              const SizedBox(height: 14),
              const Text(
                'Gagal Memuat Riwayat',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _loadRiwayat,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (aktivitas.isEmpty) {
      return RefreshIndicator(
        color: primaryGreen,
        onRefresh: () => _loadRiwayat(page: currentPage),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Icon(
              Icons.history_rounded,
              size: 65,
              color: secondaryText,
            ),
            SizedBox(height: 15),
            Center(
              child: Text(
                'Belum Ada Aktivitas',
                style: TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Riwayat aktivitas akan muncul di sini.',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: () => _loadRiwayat(page: currentPage),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        children: [
          ...aktivitas.map(_buildActivityCard),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Halaman $currentPage dari $lastPage',
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () => _loadRiwayat(
                              page: currentPage - 1,
                            )
                        : null,
                    icon: const Icon(Icons.chevron_left),
                    color: primaryGreen,
                  ),
                  IconButton(
                    onPressed: currentPage < lastPage
                        ? () => _loadRiwayat(
                              page: currentPage + 1,
                            )
                        : null,
                    icon: const Icon(Icons.chevron_right),
                    color: primaryGreen,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          icon: const Icon(
            Icons.arrow_back,
            color: darkGreen,
          ),
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
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: () => _loadRiwayat(
              page: currentPage,
            ),
            icon: const Icon(
              Icons.refresh,
              color: darkGreen,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Pantau aktivitas pengelolaan data dalam sistem SIRUMA.',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F3EC),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Total $totalAktivitas aktivitas tercatat',
                    style: const TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
