
import 'package:flutter/material.dart';

class DetailNotifikasiDialog extends StatelessWidget {
  final Map<String, dynamic> detail;

  const DetailNotifikasiDialog({
    super.key,
    required this.detail,
  });

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);
  static const Color borderColor = Color(0xFFE3EBE6);

  Map<String, dynamic> _map(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }

  List<Map<String, dynamic>> _list(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _value(dynamic data) {
    if (data == null || data.toString().trim().isEmpty) {
      return '-';
    }
    return data.toString();
  }

  String _rupiah(dynamic amount) {
    final number = double.tryParse(amount?.toString() ?? '');

    if (number == null) return '-';

    final formatted = number.toStringAsFixed(0);
    final result = formatted.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp$result';
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null || dateString.toString().isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(dateString.toString())?.toLocal();

    if (date == null) return dateString.toString();

    const months = [
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DISETUJUI':
        return const Color(0xFF16845B);
      case 'DITOLAK':
        return const Color(0xFFD64545);
      case 'MENUNGGU':
        return const Color(0xFFB7791F);
      default:
        return secondaryText;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toUpperCase()) {
      case 'DISETUJUI':
        return const Color(0xFFE8F5EE);
      case 'DITOLAK':
        return const Color(0xFFFFEEEE);
      case 'MENUNGGU':
        return const Color(0xFFFFF5E5);
      default:
        return const Color(0xFFF0F2F1);
    }
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _statusBackground(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _statusColor(status),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: primaryGreen),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(
    String label,
    dynamic content, {
    bool emphasized = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: secondaryText,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Text(
              _value(content),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                fontWeight:
                    emphasized ? FontWeight.w800 : FontWeight.w600,
                color: emphasized ? primaryGreen : darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalCard(dynamic total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF006B50),
            Color(0xFF174D3E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL NILAI PENILAIAN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            _rupiah(total),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 7),
          const Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 14,
                color: Colors.white70,
              ),
              SizedBox(width: 5),
              Text(
                'Ringkasan hasil penilaian rumah',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _photoCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE4F1EA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: primaryGreen,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _value(item['jenis_foto']),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _value(item['keterangan']),
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _approvalTimeline(List<Map<String, dynamic>> history) {
    if (history.isEmpty) {
      return const Text(
        'Belum ada riwayat approval.',
        style: TextStyle(
          fontSize: 11,
          color: secondaryText,
        ),
      );
    }

    return Column(
      children: List.generate(history.length, (index) {
        final item = history[index];
        final petugas = _map(item['petugas']);
        final status = _value(item['status']);

        final color = _statusColor(status);
        final isLast = index == history.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          color: borderColor,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 17),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statusBadge(status),
                      const SizedBox(height: 9),
                      Text(
                        _value(petugas['nama']),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(item['tanggal_approval']),
                        style: const TextStyle(
                          fontSize: 10,
                          color: secondaryText,
                        ),
                      ),
                      if (_value(item['catatan']) != '-') ...[
                        const SizedBox(height: 9),
                        Text(
                          _value(item['catatan']),
                          style: const TextStyle(
                            fontSize: 10,
                            height: 1.5,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notification = _map(detail['notification']);
    final pengajuan = _map(detail['pengajuan']);
    final pengaju = _map(detail['pengaju']);
    final properti = _map(detail['properti']);
    final penilaian = _map(detail['penilaian']);
    final foto = _list(detail['foto']);
    final history = _list(detail['riwayat_approval']);

    final status = _value(pengajuan['status']);
    final total = penilaian['total_nilai'];

    return Dialog(
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 22,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 500,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 17, 12, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detail Pengajuan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Informasi lengkap penilaian rumah',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: borderColor),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'STATUS PENGAJUAN',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 0.7,
                              fontWeight: FontWeight.w700,
                              color: secondaryText,
                            ),
                          ),
                          _statusBadge(status),
                        ],
                      ),
                      const SizedBox(height: 13),
                      _totalCard(total),
                      const SizedBox(height: 17),

                      _sectionCard(
                        title: 'Informasi Pengajuan',
                        icon: Icons.assignment_outlined,
                        children: [
                          _infoRow(
                            'ID Pengajuan',
                            pengajuan['monitoring_id'],
                          ),
                          _infoRow(
                            'Tanggal',
                            _formatDate(pengajuan['tanggal_monitoring']),
                          ),
                          _infoRow('Progress', '${_value(pengajuan['progress'])}%'),
                          _infoRow('Kondisi', pengajuan['kondisi']),
                          _infoRow('Keterangan', pengajuan['keterangan']),
                          _infoRow('Judul Notifikasi', notification['judul']),
                        ],
                      ),

                      _sectionCard(
                        title: 'Informasi Pengaju',
                        icon: Icons.person_outline,
                        children: [
                          _infoRow('Nama', pengaju['nama']),
                          _infoRow('Email', pengaju['email']),
                        ],
                      ),

                      _sectionCard(
                        title: 'Informasi Properti',
                        icon: Icons.home_work_outlined,
                        children: [
                          _infoRow('Perumahan', properti['perumahan']),
                          _infoRow('Lokasi', properti['lokasi']),
                          _infoRow('Blok', properti['blok']),
                          _infoRow('Nomor Unit', properti['nomor_unit']),
                          _infoRow(
                            'Luas Tanah',
                            '${_value(properti['luas_tanah'])} m²',
                          ),
                          _infoRow(
                            'Luas Bangunan',
                            '${_value(properti['luas_bangunan'])} m²',
                          ),
                        ],
                      ),

                      _sectionCard(
                        title: 'Rincian Penilaian',
                        icon: Icons.calculate_outlined,
                        children: [
                          _infoRow(
                            'Nilai Tanah / m²',
                            _rupiah(penilaian['nilai_tanah_per_m2']),
                          ),
                          _infoRow(
                            'Nilai Bangunan / m²',
                            _rupiah(penilaian['nilai_bangunan_per_m2']),
                          ),
                          const Divider(height: 13, color: borderColor),
                          _infoRow(
                            'Total Nilai Tanah',
                            _rupiah(penilaian['nilai_total_tanah']),
                          ),
                          _infoRow(
                            'Total Nilai Bangunan',
                            _rupiah(penilaian['nilai_total_bangunan']),
                          ),
                          _infoRow(
                            'Total Penilaian',
                            _rupiah(total),
                            emphasized: true,
                          ),
                        ],
                      ),

                      _sectionCard(
                        title: 'Foto Monitoring',
                        icon: Icons.photo_library_outlined,
                        children: [
                          if (foto.isEmpty)
                            const Text(
                              'Belum ada foto monitoring.',
                              style: TextStyle(
                                fontSize: 11,
                                color: secondaryText,
                              ),
                            )
                          else
                            ...foto.map(_photoCard),
                        ],
                      ),

                      _sectionCard(
                        title: 'Riwayat Approval',
                        icon: Icons.timeline_outlined,
                        children: [
                          _approvalTimeline(history),
                        ],
                      ),

                      Center(
                        child: Text(
                          'Notifikasi: ${_value(notification['tipe'])}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 11, 16, 14),
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: const Text(
                      'Tutup Detail',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
