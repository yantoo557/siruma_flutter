
import 'package:flutter/material.dart';

import '../../../core/services/approval_service.dart';
import '../../../models/approval_submission_model.dart';
import 'detail_pemeriksaan_page.dart';

class PemeriksaanPage extends StatefulWidget {
  final String initialFilter;

  const PemeriksaanPage({
    super.key,
    this.initialFilter = 'Semua',
  });

  @override
  State<PemeriksaanPage> createState() => _PemeriksaanPageState();
}

class _PemeriksaanPageState extends State<PemeriksaanPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);

  late String filterAktif;

  List<ApprovalSubmissionModel> pengajuan = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    filterAktif = widget.initialFilter;
    _ambilPengajuan();
  }

  Future<void> _ambilPengajuan() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final data = await ApprovalService.getApprovals();

      if (!mounted) return;

      setState(() {
        pengajuan = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'MENUNGGU':
        return 'Menunggu Pemeriksaan';
      case 'DISETUJUI':
        return 'Disetujui';
      case 'DITOLAK':
        return 'Ditolak';
      case 'PERLU_REVISI':
        return 'Perlu Revisi';
      default:
        return status;
    }
  }

  List<ApprovalSubmissionModel> get pengajuanTerfilter {
    if (filterAktif == 'Semua') return pengajuan;

    return pengajuan
        .where((item) => _statusLabel(item.status) == filterAktif)
        .toList();
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

  Color warnaStatus(String status) {
    switch (status) {
      case 'Menunggu Pemeriksaan':
        return const Color(0xFFD97706);
      case 'Perlu Revisi':
        return const Color(0xFF2563EB);
      case 'Disetujui':
        return const Color(0xFF16A34A);
      case 'Ditolak':
        return const Color(0xFFD64545);
      default:
        return darkGreen;
    }
  }

  Color latarStatus(String status) {
    switch (status) {
      case 'Menunggu Pemeriksaan':
        return const Color(0xFFFFF4DF);
      case 'Perlu Revisi':
        return const Color(0xFFEAF1FF);
      case 'Disetujui':
        return const Color(0xFFE8F7EE);
      case 'Ditolak':
        return const Color(0xFFFCECEC);
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pemeriksaan',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: isLoading ? null : _ambilPengajuan,
            tooltip: 'Muat ulang',
            icon: const Icon(
              Icons.refresh_rounded,
              color: darkGreen,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilter(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
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
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 55,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal Memuat Pengajuan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _ambilPengajuan,
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

    final dataTerfilter = pengajuanTerfilter;

    if (dataTerfilter.isEmpty) {
      return RefreshIndicator(
        color: primaryGreen,
        onRefresh: _ambilPengajuan,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 350,
              child: _buildEmptyState(),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _ambilPengajuan,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: dataTerfilter.length,
        itemBuilder: (context, index) {
          final item = dataTerfilter[index];
          return _buildPengajuanCard(item);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Pengajuan',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Periksa dan tinjau pengajuan monitoring rumah.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    final filters = [
      'Semua',
      'Menunggu Pemeriksaan',
      'Perlu Revisi',
      'Disetujui',
      'Ditolak',
    ];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filterAktif == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: selected,
            showCheckmark: false,
            selectedColor: primaryGreen,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: selected
                    ? primaryGreen
                    : Colors.grey.shade200,
              ),
            ),
            onSelected: (_) {
              setState(() => filterAktif = filter);
            },
          );
        },
      ),
    );
  }

  Widget _buildPengajuanCard(ApprovalSubmissionModel item) {
    final status = _statusLabel(item.status);
    final warna = warnaStatus(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPemeriksaanPage(
                data: {
                  'approval_id': item.id.toString(),
                  'monitoring_id': item.monitoringId.toString(),
                  'perumahan': item.perumahan,
                  'blok': item.blok,
                  'unit': item.unit,
                  'blok_unit': 'Blok ${item.blok} · Unit ${item.unit}',
                  'pengaju': item.pengaju,
                  'tanggal': _formatTanggal(item.tanggalMonitoring),
                  'status': status,
                },
              ),
            ),
          ).then((_) {
            if (mounted) {
              _ambilPengajuan();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3EF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      color: primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.perumahan,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: latarStatus(status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: warna,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Blok ${item.blok} · Unit ${item.unit}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Pengaju: ${item.pengaju}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      _formatTanggal(item.tanggalMonitoring),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: primaryGreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Pengajuan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Belum ada pengajuan pada kategori ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
