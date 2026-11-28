import 'package:flutter/material.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/approval_service.dart';
import '../../../models/approval_submission_model.dart';
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

  late Future<ApprovalSubmissionModel> _detailFuture;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _detailFuture = _ambilDetail();
  }

  int _getApprovalId() {
    final id = int.tryParse(widget.data['approval_id'] ?? '');

    if (id == null || id <= 0) {
      throw Exception('ID approval tidak valid.');
    }

    return id;
  }

  Future<ApprovalSubmissionModel> _ambilDetail() async {
    final id = _getApprovalId();
    return ApprovalService.getApprovalDetail(id);
  }

  String _labelStatus(String value) {
    switch (value.toUpperCase()) {
      case 'MENUNGGU':
      case 'DIAJUKAN':
      case 'MENUNGGU PEMERIKSAAN':
        return 'Menunggu Pemeriksaan';
      case 'DISETUJUI':
        return 'Disetujui';
      case 'DITOLAK':
        return 'Ditolak';
      case 'PERLU_REVISI':
        return 'Perlu Revisi';
      default:
        return value;
    }
  }

  bool _isWaiting(String value) {
    final normalized = value
        .trim()
        .toUpperCase()
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');

    return normalized == 'MENUNGGU' ||
        normalized == 'DIAJUKAN' ||
        normalized == 'MENUNGGU PEMERIKSAAN';
  }

  String _formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return '-';

    final local = tanggal.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');

    return '$day-$month-${local.year}';
  }

  String _formatAngka(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  String _rupiah(double value) {
    final angka = value.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < angka.length; i++) {
      if (i > 0 && (angka.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(angka[i]);
    }

    return 'Rp${buffer.toString()}';
  }

  String _fotoUrl(String filePath) {
    final origin = ApiConfig.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    final encodedPath = filePath.split('/').map(Uri.encodeComponent).join('/');

    return '$origin/storage/$encodedPath';
  }

  void _catatKeputusan(String statusBaru, String catatan) {
    ApprovalStore.instance.addDecision({
      'property': widget.data['perumahan'] ?? '-',
      'unit':
          widget.data['blok_unit'] ??
          '${widget.data['blok'] ?? '-'} · ${widget.data['unit'] ?? '-'}',
      'user': widget.data['pengaju'] ?? 'User SIRUMA',
      'date': widget.data['tanggal'] ?? '-',
      'status': statusBaru,
      'note': catatan,
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<ApprovalSubmissionModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryGreen),
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
                      Icons.error_outline,
                      color: Colors.red,
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal mengambil detail pengajuan.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _detailFuture = _ambilDetail();
                        });
                      },
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

          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          final detail = snapshot.data!;
          debugPrint('=== DEBUG APPROVAL ===');
          debugPrint('Approval ID: ${detail.id}');
          debugPrint('Status API: "${detail.status}"');
          debugPrint('Is Waiting: ${_isWaiting(detail.status)}');
          debugPrint('Is Submitting: $_isSubmitting');

          final statusTampil = _labelStatus(detail.status);

          final blokUnit = '${detail.blok} · ${detail.unit}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(
                  title: 'Informasi Pengajuan',
                  icon: Icons.description_outlined,
                  children: [
                    _buildInfoRow('Nama Pengaju', detail.pengaju),
                    _buildInfoRow(
                      'Tanggal Pengajuan',
                      _formatTanggal(detail.tanggalMonitoring),
                    ),
                    _buildInfoRow('Status', statusTampil),
                  ],
                ),
                const SizedBox(height: 16),

                _buildSectionCard(
                  title: 'Informasi Properti',
                  icon: Icons.home_work_outlined,
                  children: [
                    _buildInfoRow('Nama Perumahan', detail.perumahan),
                    _buildInfoRow('Blok dan Unit', blokUnit),
                    _buildInfoRow(
                      'Luas Tanah',
                      '${_formatAngka(detail.luasTanah)} m²',
                    ),
                    _buildInfoRow(
                      'Luas Bangunan',
                      '${_formatAngka(detail.luasBangunan)} m²',
                    ),
                    _buildInfoRow('Lokasi', detail.lokasi),
                  ],
                ),
                const SizedBox(height: 16),

                _buildSectionCard(
                  title: 'Detail Penilaian',
                  icon: Icons.calculate_outlined,
                  children: [
                    _buildInfoRow(
                      'Nilai Tanah per m²',
                      _rupiah(detail.nilaiTanahPerM2),
                    ),
                    _buildInfoRow(
                      'Nilai Bangunan per m²',
                      _rupiah(detail.nilaiBangunanPerM2),
                    ),
                    _buildInfoRow(
                      'Total Nilai Tanah',
                      _rupiah(detail.nilaiTotalTanah),
                    ),
                    _buildInfoRow(
                      'Total Nilai Bangunan',
                      _rupiah(detail.nilaiTotalBangunan),
                    ),
                    const Divider(height: 22),
                    _buildInfoRow(
                      'Total Estimasi Rumah',
                      _rupiah(detail.totalNilai),
                      isTotal: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildSectionCard(
                  title: 'Dokumentasi Foto',
                  icon: Icons.photo_library_outlined,
                  children: [
                    if (detail.foto.isEmpty)
                      const Text(
                        'Belum ada foto monitoring.',
                        style: TextStyle(fontSize: 12, color: secondaryText),
                      )
                    else
                      ...detail.foto.map(_buildPhoto),
                  ],
                ),
                const SizedBox(height: 16),

                _buildSectionCard(
                  title: 'Keterangan Monitoring',
                  icon: Icons.notes_outlined,
                  children: [
                    _buildInfoRow('Kondisi Rumah', detail.kondisi),
                    const SizedBox(height: 4),
                    Text(
                      detail.keterangan?.trim().isNotEmpty == true
                          ? detail.keterangan!
                          : 'Tidak ada keterangan monitoring.',
                      style: const TextStyle(
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
                    onPressed: !_isSubmitting && _isWaiting(detail.status)
                        ? _konfirmasiPersetujuan
                        : null,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      _isSubmitting ? 'Memproses...' : 'Setujui Pengajuan',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16865D),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF16865D)
                          .withValues(alpha: 0.55),
                      disabledForegroundColor: Colors.white,
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
                  child: ElevatedButton.icon(
                    onPressed: !_isSubmitting && _isWaiting(detail.status)
                        ? () => _dialogCatatan('Minta Revisi', 'PERLU_REVISI')
                        : null,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Minta Revisi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD99A24),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFD99A24)
                          .withValues(alpha: 0.55),
                      disabledForegroundColor: Colors.white,
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
                  child: ElevatedButton.icon(
                    onPressed: !_isSubmitting && _isWaiting(detail.status)
                        ? () => _dialogCatatan('Tolak Pengajuan', 'DITOLAK')
                        : null,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Tolak Pengajuan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD64545),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFD64545)
                          .withValues(alpha: 0.55),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
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

  Widget _buildPhoto(ApprovalPhotoModel photo) {
    final url = _fotoUrl(photo.filePath);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            photo.jenisFoto,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: darkGreen,
            ),
          ),
          if (photo.keterangan?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              photo.keterangan!,
              style: const TextStyle(fontSize: 11, color: secondaryText),
            ),
          ],
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.network(
              url,
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image_outlined, size: 30),
                      SizedBox(height: 6),
                      Text(
                        'Foto tidak dapat dimuat',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                );
              },
            ),
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
              backgroundColor: const Color(0xFF16865D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Setujui'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      await _kirimKeputusan(
        statusBaru: 'DISETUJUI',
        catatan: 'Data penilaian telah diperiksa dan disetujui.',
      );
    }
  }

  Future<void> _dialogCatatan(String judul, String statusBaru) async {
    final catatan = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _CatatanKeputusanDialog(judul: judul, statusBaru: statusBaru);
      },
    );

    if (!mounted || catatan == null) return;

    await _kirimKeputusan(statusBaru: statusBaru, catatan: catatan);
  }

  Future<void> _kirimKeputusan({
    required String statusBaru,
    required String catatan,
  }) async {
    if (_isSubmitting) return;

    final int approvalId;

    try {
      approvalId = _getApprovalId();
    } catch (e) {
      _tampilkanPesan(e.toString());
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      Map<String, dynamic> response;

      switch (statusBaru) {
        case 'DISETUJUI':
          response = await ApprovalService.approve(
            approvalId,
            catatan: catatan,
          );
          break;
        case 'PERLU_REVISI':
          response = await ApprovalService.requestRevision(approvalId, catatan);
          break;
        case 'DITOLAK':
          response = await ApprovalService.reject(approvalId, catatan);
          break;
        default:
          throw Exception('Jenis keputusan tidak dikenal.');
      }

      if (!mounted) return;

      final labelStatus = _labelStatus(statusBaru);

      // Pertahankan catatan riwayat lokal yang digunakan halaman riwayat.
      _catatKeputusan(labelStatus, catatan);

      setState(() {
        _detailFuture = ApprovalService.getApprovalDetail(approvalId);
      });

      _tampilkanPesan(
        response['message']?.toString() ??
            'Keputusan berhasil disimpan ke server.',
      );
    } catch (e) {
      if (mounted) {
        _tampilkanPesan('Gagal mengirim keputusan: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }
}

// Dialog harus berada di luar _DetailPemeriksaanPageState.
class _CatatanKeputusanDialog extends StatefulWidget {
  final String judul;
  final String statusBaru;

  const _CatatanKeputusanDialog({
    required this.judul,
    required this.statusBaru,
  });

  @override
  State<_CatatanKeputusanDialog> createState() =>
      _CatatanKeputusanDialogState();
}

class _CatatanKeputusanDialogState extends State<_CatatanKeputusanDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRejected = widget.statusBaru == 'DITOLAK';

    return AlertDialog(
      title: Text(widget.judul),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 4,
        maxLength: 1000,
        decoration: InputDecoration(
          hintText: isRejected
              ? 'Tuliskan alasan penolakan...'
              : 'Tuliskan bagian yang perlu diperbaiki...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final catatan = _controller.text.trim();

            if (catatan.isEmpty) return;

            Navigator.of(context).pop(catatan);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isRejected
                ? const Color(0xFFD64545)
                : const Color(0xFFD99A24),
            foregroundColor: Colors.white,
          ),
          child: const Text('Kirim Keputusan'),
        ),
      ],
    );
  }
}
