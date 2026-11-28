import 'package:flutter/material.dart';

import '../../../core/services/monitoring_service.dart';
import '../assessment/land_data_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  String selectedFilter = 'Semua';

  late Future<List<Map<String, dynamic>>> _monitoringFuture;

  @override
  void initState() {
    super.initState();
    _monitoringFuture = MonitoringService.getAllMonitoring();
  }

  // Dipanggil dashboard untuk membuka riwayat dengan filter tertentu.
  void setFilter(String filter) {
    if (!mounted) return;

    setState(() {
      selectedFilter = filter;
    });
  }

  // Memuat ulang data dari server.
  Future<void> _muatUlang() async {
    setState(() {
      _monitoringFuture = MonitoringService.getAllMonitoring();
    });

    await _monitoringFuture;
  }
  double _angka(dynamic value, {double fallback = 0}) {
    if (value == null) return fallback;

    return double.tryParse(
          value.toString().replaceAll(',', '.'),
        ) ??
        fallback;
  }

  int? _angkaInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  Future<void> _bukaFormRevisi(Map<String, dynamic> item) async {
    final monitoringId = _angkaInt(item['id']);

    if (monitoringId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID monitoring tidak valid.')),
      );
      return;
    }

    try {
      final response = await MonitoringService.getDetailMonitoring(
        monitoringId,
      );

      final dynamic rawData = response['data'] ?? response;

      if (rawData is! Map) {
        throw Exception('Data monitoring tidak valid.');
      }

      final monitoring = Map<String, dynamic>.from(rawData);

      final unit = monitoring['unit'] is Map
          ? Map<String, dynamic>.from(monitoring['unit'])
          : <String, dynamic>{};

      final blok = unit['blok'] is Map
          ? Map<String, dynamic>.from(unit['blok'])
          : <String, dynamic>{};

      final perumahan = blok['perumahan'] is Map
          ? Map<String, dynamic>.from(blok['perumahan'])
          : <String, dynamic>{};

      final penilaian = monitoring['penilaian'] is Map
          ? Map<String, dynamic>.from(monitoring['penilaian'])
          : <String, dynamic>{};

      final fotoTersimpan = monitoring['fotoMonitoring'] is List
          ? (monitoring['fotoMonitoring'] as List)
              .whereType<Map>()
              .map((foto) => Map<String, dynamic>.from(foto))
              .toList()
          : <Map<String, dynamic>>[];

      if (!mounted) return;

      final hasil = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => LandDataPage(
            unitId: _angkaInt(unit['id']) ?? 0,
            namaPerumahan:
                perumahan['nama_perumahan']?.toString() ?? '-',
            namaBlok: blok['nama_blok']?.toString() ?? '-',
            nomorRumah: unit['nomor_unit']?.toString() ?? '-',

            // Data tanah dari unit.
            luasTanah: unit['luas_tanah']?.toString() ?? '0',

            // Nilai bangunan per m2 dari data unit.
            nilaiBangunanPerM2: _angka(
              unit['nilai_bangunan_per_m2'],
              fallback: _angka(penilaian['nilai_bangunan_per_m2']),
            ),

            // ID lama agar data diperbarui, bukan dibuat ulang.
            monitoringId: monitoringId,
            penilaianId: _angkaInt(penilaian['id']),

            // Data penilaian lama.
            nilaiTanahAwal: penilaian['nilai_tanah_per_m2'] == null
                ? null
                : _angka(penilaian['nilai_tanah_per_m2']),

            sumberDataTanahAwal:
                penilaian['sumber_data_tanah']?.toString(),

            nilaiBangunanAwal:
                penilaian['nilai_bangunan_per_m2'] == null
                    ? null
                    : _angka(penilaian['nilai_bangunan_per_m2']),

            luasBangunanAwal:
                penilaian['luas_bangunan'] == null
                    ? null
                    : _angka(penilaian['luas_bangunan']),

            jumlahLantaiAwal:
                _angkaInt(penilaian['jumlah_lantai']),

            tahunBangunanAwal:
                _angkaInt(penilaian['tahun_bangunan']),

            kondisiBangunanAwal:
                monitoring['kondisi']?.toString(),

            keteranganAwal:
                monitoring['keterangan']?.toString() ?? '',

            fotoTersimpan: fotoTersimpan,
            isRevision: true,
          ),
        ),
      );

      if (hasil == true && mounted) {
        await _muatUlang();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Monitoring berhasil diperbarui.'),
            backgroundColor: Color(0xFF16865D),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka data revisi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return 'Draft';

      case 'DIAJUKAN':
        return 'Menunggu Approval';

      case 'DISETUJUI':
        return 'Disetujui';

      case 'DITOLAK':
        return 'Ditolak';

      case 'REVISI':
      case 'PERLU_REVISI':
        return 'Revisi';

      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFF16865D);
      case 'Ditolak':
        return const Color(0xFFD64545);
      case 'Revisi':
        return const Color(0xFF8A5AB5);
      case 'Draft':
        return const Color(0xFF718078);
      default:
        return const Color(0xFFD58A19);
    }
  }

  Color getStatusBackground(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFFE6F5EE);
      case 'Ditolak':
        return const Color(0xFFFCEAEA);
      case 'Revisi':
        return const Color(0xFFF2EAF8);
      case 'Draft':
        return const Color(0xFFEFF2F0);
      default:
        return const Color(0xFFFFF4DF);
    }
  }

  String _tanggalLabel(dynamic tanggal) {
    if (tanggal == null) return '-';

    final date = DateTime.tryParse(tanggal.toString());
    if (date == null) return tanggal.toString();

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

    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }

  Map<String, dynamic> _ubahKeDataTampilan(Map<String, dynamic> monitoring) {
    final unit = monitoring['unit'] is Map
        ? Map<String, dynamic>.from(monitoring['unit'])
        : <String, dynamic>{};

    final blok = unit['blok'] is Map
        ? Map<String, dynamic>.from(unit['blok'])
        : <String, dynamic>{};

    final perumahan = blok['perumahan'] is Map
        ? Map<String, dynamic>.from(blok['perumahan'])
        : <String, dynamic>{};

    final approvals = monitoring['approval'] is List
        ? List<dynamic>.from(monitoring['approval'])
        : <dynamic>[];

    final approvalTerbaru = approvals.isNotEmpty && approvals.first is Map
        ? Map<String, dynamic>.from(approvals.first)
        : <String, dynamic>{};

    final status = _statusLabel(monitoring['status']?.toString() ?? '-');

    return {
      'id': monitoring['id'],
      'perumahan': perumahan['nama_perumahan']?.toString() ?? '-',
      'blok': blok['nama_blok']?.toString() ?? '-',
      'unit': unit['nomor_unit']?.toString() ?? '-',
      'tanggal': _tanggalLabel(monitoring['tanggal_monitoring']),
      'status': status,
      'catatan': approvalTerbaru['catatan']?.toString() ?? '',
      'keterangan': monitoring['keterangan']?.toString() ?? '',
      'kondisi': monitoring['kondisi']?.toString() ?? '-',
      'progress': monitoring['progress']?.toString() ?? '0',
      'namaApprover': approvalTerbaru['approver'] is Map
          ? (approvalTerbaru['approver']['nama'] ??
                    approvalTerbaru['approver']['name'])
                ?.toString()
          : '',
    };
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    final hasil = data.map(_ubahKeDataTampilan).toList();

    if (selectedFilter == 'Semua') return hasil;

    return hasil.where((item) => item['status'] == selectedFilter).toList();
  }

  void showMonitoringDetail(Map<String, dynamic> item) {
    final status = item['status']?.toString() ?? '-';
    final catatan = item['catatan']?.toString() ?? '';
    final keterangan = item['keterangan']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: SingleChildScrollView(
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
                    'Detail Monitoring',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _detailRow('Perumahan', item['perumahan'] ?? '-'),
                  _detailRow('Blok', item['blok'] ?? '-'),
                  _detailRow('Nomor Unit', item['unit'] ?? '-'),
                  _detailRow('Tanggal Monitoring', item['tanggal'] ?? '-'),
                  _detailRow('Kondisi', item['kondisi'] ?? '-'),
                  _detailRow('Progress', '${item['progress']}%'),
                  if (keterangan.isNotEmpty)
                    _detailRow('Keterangan', keterangan),
                  const SizedBox(height: 16),
                  const Text(
                    'Status Monitoring',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusBackground(status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: getStatusColor(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (catatan.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    const Text(
                      'Catatan Approval',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      catatan,
                      style: const TextStyle(color: Color(0xFF5B6B66)),
                    ),
                  ],
                  if ((item['namaApprover'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _detailRow('Diperiksa oleh', item['namaApprover']),
                  ],
                  const SizedBox(height: 22),

                  // Tombol ini hanya muncul jika status Revisi.
                  if (status == 'Revisi') ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _bukaFormRevisi(item);
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Perbaiki Monitoring'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006B50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF006B50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF006B50)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 135,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF718078)),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(
                color: Color(0xFF26332E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () => setFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006B50) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF006B50)
                : const Color(0xFFE0E7E3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF5B6B66),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMonitoringCard(Map<String, dynamic> item) {
    final status = item['status']?.toString() ?? '-';

    return InkWell(
      onTap: () => showMonitoringDetail(item),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EEEA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['perumahan']?.toString() ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF26332E),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusBackground(status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: getStatusColor(status),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.home_outlined,
                  size: 17,
                  color: Color(0xFF718078),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Blok ${item['blok']} • Unit ${item['unit']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5B6B66),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xFF718078),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    item['tanggal']?.toString() ?? '-',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718078),
                    ),
                  ),
                ),
                const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF006B50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.chevron_right,
                  size: 17,
                  color: Color(0xFF006B50),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaftar(List<Map<String, dynamic>> data) {
    final filteredList = _filterData(data);

    if (filteredList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 48, color: Color(0xFFB5C2BB)),
            SizedBox(height: 12),
            Text(
              'Belum ada riwayat monitoring',
              style: TextStyle(
                color: Color(0xFF718078),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return _buildMonitoringCard(filteredList[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Riwayat Monitoring',
          style: TextStyle(
            color: Color(0xFF173D32),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(Icons.refresh, color: Color(0xFF006B50)),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
            child: const Text(
              'Pantau status monitoring rumah yang telah kamu ajukan.',
              style: TextStyle(fontSize: 12, color: Color(0xFF718078)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: const Text(
              'Daftar Pengajuan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26332E),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilter('Semua'),
                const SizedBox(width: 8),
                _buildFilter('Draft'),
                const SizedBox(width: 8),
                _buildFilter('Menunggu Approval'),
                const SizedBox(width: 8),
                _buildFilter('Disetujui'),
                const SizedBox(width: 8),
                _buildFilter('Ditolak'),
                const SizedBox(width: 8),
                _buildFilter('Revisi'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _monitoringFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF006B50)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off_outlined,
                            size: 45,
                            color: Color(0xFFB5C2BB),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal mengambil riwayat monitoring',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF26332E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF718078),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: _muatUlang,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006B50),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final data = snapshot.data ?? [];
                return RefreshIndicator(
                  color: const Color(0xFF006B50),
                  onRefresh: _muatUlang,
                  child: _buildDaftar(data),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
