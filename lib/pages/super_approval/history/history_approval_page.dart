import 'package:flutter/material.dart';

import '../../../core/services/approval_service.dart';
import '../../../models/approval_submission_model.dart';

class HistoryApprovalPage extends StatefulWidget {
  const HistoryApprovalPage({super.key});

  @override
  State<HistoryApprovalPage> createState() => _HistoryApprovalPageState();
}

class _HistoryApprovalPageState extends State<HistoryApprovalPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  String selectedFilter = 'Semua';
  List<ApprovalSubmissionModel> _history = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final approvals = await ApprovalService.getApprovals();

      if (!mounted) return;

      // Riwayat hanya menampilkan keputusan yang sudah diproses.
      final processed = approvals.where((item) {
        return ['DISETUJUI', 'PERLU_REVISI', 'DITOLAK']
            .contains(item.status.toUpperCase());
      }).toList()
        ..sort((a, b) {
          final dateA = a.tanggalApproval ?? a.tanggalMonitoring;
          final dateB = b.tanggalApproval ?? b.tanggalMonitoring;
          if (dateA == null && dateB == null) return b.id.compareTo(a.id);
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateB.compareTo(dateA);
        });

      setState(() {
        _history = processed;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'DISETUJUI':
        return 'Disetujui';
      case 'PERLU_REVISI':
        return 'Perlu Revisi';
      case 'DITOLAK':
        return 'Ditolak';
      case 'MENUNGGU':
        return 'Menunggu';
      default:
        return status;
    }
  }

  String _formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return '-';

    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFF16A34A);
      case 'Perlu Revisi':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFFD64545);
    }
  }

  Color _statusBackground(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFFE8F5EC);
      case 'Perlu Revisi':
        return const Color(0xFFEAF1FF);
      default:
        return const Color(0xFFFCECEC);
    }
  }

  List<ApprovalSubmissionModel> get _filteredHistory {
    if (selectedFilter == 'Semua') return _history;
    return _history
        .where((item) => _statusLabel(item.status) == selectedFilter)
        .toList();
  }

  void _showHistoryDetail(ApprovalSubmissionModel item) {
    final status = _statusLabel(item.status);
    final date = _formatTanggal(item.tanggalApproval ?? item.tanggalMonitoring);
    final note = (item.catatan == null || item.catatan!.trim().isEmpty)
        ? 'Tidak ada catatan approval.'
        : item.catatan!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Detail Riwayat Approval',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    item.perumahan,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Blok ${item.blok} · Unit ${item.unit}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B8983),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _statusBackground(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hasil Approval',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5B6B66),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _statusColor(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _detailRow('Pengaju', item.pengaju),
                  _detailRow('Tanggal keputusan', date),
                  _detailRow('Kondisi rumah', item.kondisi),
                  const SizedBox(height: 5),
                  const Text(
                    'Catatan Approval',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    note,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF5B6B66),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7B8983),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: darkGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EFEB)),
        ),
        child: Column(
          children: [
            Text(
              count.toString().padLeft(2, '0'),
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5B6B66),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ApprovalSubmissionModel item) {
    final status = _statusLabel(item.status);
    final color = _statusColor(status);
    final date = _formatTanggal(item.tanggalApproval ?? item.tanggalMonitoring);

    return InkWell(
      onTap: () => _showHistoryDetail(item),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE8EFEB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.home_work_outlined,
                  color: primaryGreen,
                  size: 21,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item.perumahan,
                    style: const TextStyle(
                      color: darkGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBackground(status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Text(
              'Blok ${item.blok} · Unit ${item.unit}',
              style: const TextStyle(
                color: Color(0xFF5B6B66),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Color(0xFF89958F),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    item.pengaju,
                    style: const TextStyle(
                      color: Color(0xFF89958F),
                      fontSize: 11,
                    ),
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF89958F),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Lihat Detail',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryGreen,
                  size: 11,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryGreen),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 55, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Gagal Memuat Riwayat',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _loadHistory,
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

    final items = _filteredHistory;

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _loadHistory,
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 300,
                  child: Center(
                    child: Text(
                      'Belum ada riwayat pengajuan.',
                      style: TextStyle(
                        color: Color(0xFF7B8983),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildHistoryCard(items[index]),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final approvedCount = _history
        .where((item) => item.status.toUpperCase() == 'DISETUJUI')
        .length;
    final revisionCount = _history
        .where((item) => item.status.toUpperCase() == 'PERLU_REVISI')
        .length;
    final rejectedCount = _history
        .where((item) => item.status.toUpperCase() == 'DITOLAK')
        .length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Riwayat Approval',
          style: TextStyle(
            color: darkGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadHistory,
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh_rounded, color: darkGreen),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            child: Row(
              children: [
                _buildSummaryCard(
                  'Disetujui',
                  approvedCount,
                  const Color(0xFF16A34A),
                ),
                const SizedBox(width: 10),
                _buildSummaryCard(
                  'Perlu Revisi',
                  revisionCount,
                  const Color(0xFF2563EB),
                ),
                const SizedBox(width: 10),
                _buildSummaryCard(
                  'Ditolak',
                  rejectedCount,
                  const Color(0xFFD64545),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: ['Semua', 'Disetujui', 'Perlu Revisi', 'Ditolak'].map((
                filter,
              ) {
                final isSelected = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedFilter = filter);
                    },
                    selectedColor: primaryGreen,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : darkGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? primaryGreen
                          : const Color(0xFFE0E8E3),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
