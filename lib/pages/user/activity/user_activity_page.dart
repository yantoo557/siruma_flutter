import 'package:flutter/material.dart';

import '../../../core/services/audit_log_service.dart';
import '../../../models/audit_log_model.dart';

class UserActivityPage extends StatefulWidget {
  const UserActivityPage({super.key});

  @override
  State<UserActivityPage> createState() => _UserActivityPageState();
}

class _UserActivityPageState extends State<UserActivityPage> {
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
      final response = await AuditLogService.getRiwayat(page: page);
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
      case 'monitoring':
        return Icons.fact_check_outlined;
      case 'penilaian':
        return Icons.assessment_outlined;
      case 'foto_monitoring':
        return Icons.photo_camera_outlined;
      case 'approval':
        return Icons.verified_outlined;
      default:
        return Icons.history_rounded;
    }
  }

  Color _getColor(String aktivitas) {
    switch (aktivitas.toUpperCase()) {
      case 'TAMBAH':
      case 'CREATE':
      case 'AJUKAN':
      case 'SUBMIT':
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

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'Waktu tidak tersedia';
    try {
      final date = DateTime.parse(value).toLocal();
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month/${date.year} • $hour:$minute';
    } catch (_) {
      return value;
    }
  }

  String _activityLabel(String value) {
    switch (value.toUpperCase()) {
      case 'TAMBAH':
      case 'CREATE':
        return 'Membuat';
      case 'EDIT':
      case 'UPDATE':
        return 'Memperbarui';
      case 'HAPUS':
      case 'DELETE':
        return 'Menghapus';
      case 'AJUKAN':
      case 'SUBMIT':
        return 'Mengajukan';
      default:
        return value;
    }
  }

  Widget _activityCard(AuditLogModel item) {
    final color = _getColor(item.aktivitas);
    final detail = (item.keterangan ?? '').trim();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(item.tabel), color: primaryGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_activityLabel(item.aktivitas)} ${item.tabel.replaceAll('_', ' ')}',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.aktivitas.toUpperCase(),
                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                if (detail.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(detail, style: const TextStyle(color: secondaryText, fontSize: 12, height: 1.4)),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: secondaryText),
                    const SizedBox(width: 5),
                    Text(_formatDate(item.createdAt), style: const TextStyle(color: secondaryText, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    if (isLoading) return const Center(child: CircularProgressIndicator(color: primaryGreen));
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_outlined, size: 52, color: secondaryText),
            const SizedBox(height: 12),
            const Text('Gagal Memuat Aktivitas', style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 7),
            Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: secondaryText, fontSize: 12)),
            const SizedBox(height: 15),
            ElevatedButton.icon(onPressed: () => _loadRiwayat(), icon: const Icon(Icons.refresh), label: const Text('Coba Lagi')),
          ]),
        ),
      );
    }
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: () => _loadRiwayat(page: 1),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        children: [
          if (aktivitas.isEmpty) ...[
            const SizedBox(height: 85),
            const Icon(Icons.history_rounded, size: 62, color: secondaryText),
            const SizedBox(height: 14),
            const Center(child: Text('Belum Ada Aktivitas', style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 7),
            const Center(child: Text('Aktivitas yang Anda lakukan akan tercatat di sini.', textAlign: TextAlign.center, style: TextStyle(color: secondaryText, fontSize: 13))),
          ] else ...[
            ...aktivitas.map(_activityCard),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Halaman $currentPage dari $lastPage', style: const TextStyle(color: secondaryText, fontSize: 12)),
              Row(children: [
                IconButton(onPressed: currentPage > 1 ? () => _loadRiwayat(page: currentPage - 1) : null, icon: const Icon(Icons.chevron_left), color: primaryGreen),
                IconButton(onPressed: currentPage < lastPage ? () => _loadRiwayat(page: currentPage + 1) : null, icon: const Icon(Icons.chevron_right), color: primaryGreen),
              ]),
            ]),
          ],
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
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: darkGreen), onPressed: () => Navigator.pop(context)),
        title: const Text('Riwayat Aktivitas', style: TextStyle(color: darkGreen, fontSize: 19, fontWeight: FontWeight.bold)),
        actions: [IconButton(tooltip: 'Muat ulang', onPressed: () => _loadRiwayat(page: currentPage), icon: const Icon(Icons.refresh, color: darkGreen))],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Aktivitas Saya', style: TextStyle(color: darkGreen, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 7),
            const Text('Lihat catatan aktivitas monitoring yang Anda lakukan di SIRUMA.', style: TextStyle(color: secondaryText, fontSize: 13, height: 1.4)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(color: const Color(0xFFE4F3EC), borderRadius: BorderRadius.circular(30)),
              child: Text('Total $totalAktivitas aktivitas tercatat', style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ]),
        ),
        Expanded(child: _content()),
      ]),
    );
  }
}
