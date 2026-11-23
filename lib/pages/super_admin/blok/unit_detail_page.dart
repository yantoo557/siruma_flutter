import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/unit_model.dart';
import '../../../models/monitoring_model.dart';
import '../../../core/services/monitoring_service.dart';

class UnitDetailPage extends StatefulWidget {
  final UnitModel unit;
  final String namaPerumahan;
  final String namaBlok;

  const UnitDetailPage({
    super.key,
    required this.unit,
    required this.namaPerumahan,
    required this.namaBlok,
  });

  @override
  State<UnitDetailPage> createState() => _UnitDetailPageState();
}

class _UnitDetailPageState extends State<UnitDetailPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  late Future<List<MonitoringModel>> _riwayatFuture;

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  void _loadRiwayat() {
    _riwayatFuture = MonitoringService.getRiwayatUnit(widget.unit.id);
  }

  String _formatRupiah(double value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  String _formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return '-';

    const namaBulan = [
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

    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;

    final estimasiTanah = unit.luasTanah * unit.nilaiTanahPerM2;

    final estimasiBangunan = unit.luasBangunan * unit.nilaiBangunanPerM2;

    final estimasiTotal = estimasiTanah + estimasiBangunan;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 0,
        title: const Text(
          'Detail Unit',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIdentityCard(),
            const SizedBox(height: 22),

            _buildSectionTitle('Informasi Fisik'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.landscape_outlined,
                    title: 'Luas Tanah',
                    value: '${unit.luasTanah} m²',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.home_outlined,
                    title: 'Luas Bangunan',
                    value: '${unit.luasBangunan} m²',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            _buildSectionTitle('Informasi Penilaian'),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _buildValueRow(
                    'Nilai tanah / m²',
                    _formatRupiah(unit.nilaiTanahPerM2),
                  ),
                  const Divider(height: 24),
                  _buildValueRow(
                    'Nilai bangunan / m²',
                    _formatRupiah(unit.nilaiBangunanPerM2),
                  ),
                  const Divider(height: 24),
                  _buildValueRow(
                    'Estimasi nilai tanah',
                    _formatRupiah(estimasiTanah),
                  ),
                  const Divider(height: 24),
                  _buildValueRow(
                    'Estimasi nilai bangunan',
                    _formatRupiah(estimasiBangunan),
                  ),
                  const Divider(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Estimasi Total Nilai Aset',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _formatRupiah(estimasiTotal),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            _buildSectionTitle('Informasi Lainnya'),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: _buildValueRow('Status Unit', unit.status.toUpperCase()),
            ),

            const SizedBox(height: 22),

            _buildSectionTitle('Riwayat Monitoring'),
            const SizedBox(height: 12),

            _buildRiwayatMonitoring(),
          ],
        ),
      ),
    );
  }

  Widget _buildRingkasanMonitoring(List<MonitoringModel> riwayat) {
    final totalMonitoring = riwayat.length;

    // Monitoring terbaru berdasarkan urutan dari backend.
    final monitoringTerakhir = riwayat.isNotEmpty ? riwayat.first : null;

    // Gabungkan seluruh approval dari semua monitoring.
    final semuaApproval = riwayat.expand((item) => item.approvals).toList();

    // Urutkan approval berdasarkan tanggal terbaru.
    semuaApproval.sort((a, b) {
      final tanggalA = a.tanggalApproval;
      final tanggalB = b.tanggalApproval;

      if (tanggalA == null && tanggalB == null) {
        return b.id.compareTo(a.id);
      }

      if (tanggalA == null) return 1;
      if (tanggalB == null) return -1;

      final hasilTanggal = tanggalB.compareTo(tanggalA);

      if (hasilTanggal != 0) {
        return hasilTanggal;
      }

      return b.id.compareTo(a.id);
    });

    // Approval pertama adalah keputusan paling terbaru.
    final approvalTerakhir = semuaApproval.isNotEmpty
        ? semuaApproval.first
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.history,
                  title: 'Total Monitoring',
                  value: '$totalMonitoring kali',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.health_and_safety_outlined,
                  title: 'Kondisi Terakhir',
                  value: monitoringTerakhir?.kondisi ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildValueRow(
            'Monitoring Terakhir',
            _formatTanggal(monitoringTerakhir?.tanggalMonitoring),
          ),
          const Divider(height: 24),
          _buildValueRow(
            'Status Approval',
            approvalTerakhir?.status ?? 'Belum ada approval',
          ),
          if (approvalTerakhir?.catatan != null &&
              approvalTerakhir!.catatan!.trim().isNotEmpty) ...[
            const Divider(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Catatan Approval',
                style: TextStyle(color: Color(0xFF718078), fontSize: 11),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                approvalTerakhir.catatan!,
                style: const TextStyle(color: darkGreen, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiwayatMonitoring() {
    return FutureBuilder<List<MonitoringModel>>(
      future: _riwayatFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: CircularProgressIndicator(color: primaryGreen),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 32),
                const SizedBox(height: 8),
                const Text(
                  'Gagal mengambil riwayat monitoring.',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    setState(_loadRiwayat);
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final riwayat = snapshot.data ?? [];

        if (riwayat.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: _cardDecoration(),
            child: const Column(
              children: [
                Icon(Icons.history, color: Color(0xFF9AA9A1), size: 35),
                SizedBox(height: 8),
                Text(
                  'Belum ada riwayat monitoring.',
                  style: TextStyle(color: Color(0xFF718078), fontSize: 13),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRingkasanMonitoring(riwayat),

            const SizedBox(height: 16),

            ...riwayat.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMonitoringCard(item),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildMonitoringCard(MonitoringModel item) {
    final kondisi = item.kondisi.toLowerCase();

    final Color warnaKondisi = kondisi == 'baik'
        ? primaryGreen
        : Colors.orange.shade700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: primaryGreen,
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatTanggal(item.tanggalMonitoring),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: warnaKondisi.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.kondisi.toUpperCase(),
                  style: TextStyle(
                    color: warnaKondisi,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress Monitoring',
                style: TextStyle(color: Color(0xFF718078), fontSize: 12),
              ),
              Text(
                '${item.progress.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (item.progress / 100).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: const Color(0xFFE8EFEB),
              color: primaryGreen,
            ),
          ),

          if (item.keterangan != null &&
              item.keterangan!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'Keterangan',
              style: TextStyle(color: Color(0xFF718078), fontSize: 11),
            ),
            const SizedBox(height: 5),
            Text(
              item.keterangan!,
              style: const TextStyle(color: darkGreen, fontSize: 12),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          _buildValueRow('Status Monitoring', item.status),
        ],
      ),
    );
  }

  Widget _buildIdentityCard() {
    final unit = widget.unit;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOMOR UNIT',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Text(
            unit.nomorUnit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${widget.namaBlok} · ${widget.namaPerumahan}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              unit.status.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: darkGreen,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryGreen, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF718078), fontSize: 11),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF718078), fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFE1EBE5)),
    );
  }
}
