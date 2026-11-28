import 'package:flutter/material.dart';

import '../../../core/services/monitoring_service.dart';

import '../assessment/photo_page.dart';
import '../assessment/land_data_page.dart';

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

  List<Map<String, dynamic>> _drafts = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  // Mengambil draft langsung dari Laravel
  Future<void> _loadDrafts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final drafts = await MonitoringService.getDraft();

      if (!mounted) return;

      setState(() {
        _drafts = drafts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Mengambil data relasi bertingkat dengan aman
  Map<String, dynamic> _getMap(Map<String, dynamic> data, String key) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  String _getText(dynamic value, {String fallback = '-'}) {
    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }

    return value.toString();
  }

  String _formatTanggal(dynamic value) {
    if (value == null) return 'Tanggal tidak tersedia';

    final date = DateTime.tryParse(value.toString());

    if (date == null) return value.toString();

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

    final tanggal = date.day.toString().padLeft(2, '0');
    final namaBulan = bulan[date.month - 1];
    final tahun = date.year;

    return '$tanggal $namaBulan $tahun';
  }

  String _formatWaktu(dynamic value) {
    if (value == null) return '';

    final date = DateTime.tryParse(value.toString());

    if (date == null) return '';

    final jam = date.hour.toString().padLeft(2, '0');
    final menit = date.minute.toString().padLeft(2, '0');

    return '$jam:$menit';
  }

  // Mengambil nama perumahan, blok, dan nomor rumah
  Map<String, String> _getInformasiRumah(Map<String, dynamic> draft) {
    final unit = _getMap(draft, 'unit');
    final blok = _getMap(unit, 'blok');
    final perumahan = _getMap(blok, 'perumahan');

    return {
      'perumahan': _getText(perumahan['nama_perumahan']),
      'blok': _getText(blok['nama_blok']),
      'rumah': _getText(unit['nomor_unit']),
    };
  }

  Future<void> _lanjutkanDraft(Map<String, dynamic> draft) async {
    final id = int.tryParse(draft['id']?.toString() ?? '');

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID monitoring tidak ditemukan.')),
      );
      return;
    }

    try {
      final detail = await MonitoringService.getDetailMonitoring(id);
      if (!mounted) return;

      final status = detail['status']?.toString();
      final isRevision = status == 'PERLU_REVISI';

      if (status != 'DRAFT' && !isRevision) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Monitoring ini bukan lagi berstatus Draft atau Perlu Revisi.',
            ),
          ),
        );
        await _loadDrafts();
        return;
      }

      final unit = _getMap(detail, 'unit');
      final blok = _getMap(unit, 'blok');
      final perumahan = _getMap(blok, 'perumahan');
      final penilaian = _getMap(detail, 'penilaian');

      final unitId = int.tryParse(unit['id']?.toString() ?? '');

      if (unitId == null) {
        throw Exception('ID unit tidak ditemukan.');
      }

      double parseDouble(dynamic value, {double fallback = 0}) {
        return double.tryParse(value?.toString() ?? '') ?? fallback;
      }

      int parseInt(dynamic value, {int fallback = 0}) {
        return int.tryParse(value?.toString() ?? '') ?? fallback;
      }

      final fotoData = detail['foto_monitoring'] ?? detail['fotoMonitoring'];

      final List<Map<String, dynamic>> fotoTersimpan = fotoData is List
          ? fotoData
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
          : [];

      if (penilaian.isEmpty) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LandDataPage(
              unitId: unitId,
              namaPerumahan: _getText(perumahan['nama_perumahan']),
              namaBlok: _getText(blok['nama_blok']),
              nomorRumah: _getText(unit['nomor_unit']),
              luasTanah: _getText(unit['luas_tanah'], fallback: '0'),
              nilaiBangunanPerM2: parseDouble(unit['nilai_bangunan_per_m2']),
              monitoringId: id,
              kondisiBangunanAwal: _getText(
                detail['kondisi'],
                fallback: 'Baik',
              ),
              keteranganAwal: _getText(detail['keterangan'], fallback: ''),
              fotoTersimpan: fotoTersimpan,
              isRevision: isRevision,
            ),
          ),
        );
      } else {
        final penilaianId = int.tryParse(penilaian['id']?.toString() ?? '');

        if (penilaianId == null) {
          throw Exception('ID penilaian tidak valid.');
        }

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PhotoPage(
              unitId: unitId,
              namaPerumahan: _getText(perumahan['nama_perumahan']),
              namaBlok: _getText(blok['nama_blok']),
              nomorRumah: _getText(unit['nomor_unit']),
              luasTanah: parseDouble(penilaian['luas_tanah']),
              nilaiTanahPerM2: parseDouble(penilaian['nilai_tanah_per_m2']),
              sumberDataTanah: _getText(
                penilaian['sumber_data_tanah'],
                fallback: '',
              ),
              nilaiBangunanPerM2: parseDouble(
                penilaian['nilai_bangunan_per_m2'],
              ),
              luasBangunan: parseDouble(penilaian['luas_bangunan']),
              jumlahLantai: parseInt(penilaian['jumlah_lantai'], fallback: 1),
              tahunBangunan: penilaian['tahun_bangunan'] == null
                  ? null
                  : parseInt(penilaian['tahun_bangunan']),
              kondisiBangunan: _getText(detail['kondisi'], fallback: 'Baik'),
              monitoringId: id,
              penilaianId: penilaianId,
              keteranganAwal: _getText(detail['keterangan'], fallback: ''),
              fotoTersimpan: fotoTersimpan,
              isRevision: isRevision,
            ),
          ),
        );
      }

      if (!mounted) return;
      await _loadDrafts();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memulihkan Draft: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  bool _isIncompleteDraft(Map<String, dynamic> draft) {
    final penilaian = _getMap(draft, 'penilaian');
    final progress = double.tryParse(draft['progress']?.toString() ?? '') ?? 0;
    return penilaian.isEmpty || progress < 100;
  }

  Future<void> _hapusDraft(Map<String, dynamic> draft) async {
    final id = int.tryParse(draft['id']?.toString() ?? '');
    if (id == null) return;

    final rumah = _getInformasiRumah(draft);
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Draft tidak lengkap?'),
        content: Text(
          'Draft ${rumah['perumahan']} · Blok ${rumah['blok']} · Rumah ${rumah['rumah']} akan dihapus beserta foto yang tersimpan. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus Draft'),
          ),
        ],
      ),
    );

    if (yakin != true || !mounted) return;

    try {
      await MonitoringService.deleteIncompleteDraft(id);
      if (!mounted) return;
      await _loadDrafts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft tidak lengkap berhasil dihapus.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Draft gagal dihapus: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
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
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 48,
                color: secondaryText,
              ),
              const SizedBox(height: 15),
              const Text(
                'Gagal Memuat Draft',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: secondaryText),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _loadDrafts,
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

    if (_drafts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _loadDrafts,
      child: ListView(
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
              child: _buildDraftCard(_drafts[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5ECE8))),
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
          IconButton(
            onPressed: _loadDrafts,
            icon: const Icon(Icons.refresh, color: primaryGreen),
          ),
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
                  style: TextStyle(fontSize: 12, color: secondaryText),
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

  Widget _buildDraftCard(Map<String, dynamic> draft) {
    final rumah = _getInformasiRumah(draft);
    final isRevision = draft['status']?.toString() == 'PERLU_REVISI';

    final tanggal =
        draft['updated_at'] ??
        draft['tanggal_monitoring'] ??
        draft['created_at'];

    final waktu = _formatWaktu(tanggal);

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
                      rumah['perumahan']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${rumah['blok']} · Rumah ${rumah['rumah']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: isRevision
                      ? const Color(0xFFFFF0E0)
                      : const Color(0xFFFFF4DF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isRevision ? 'Perlu Revisi' : 'Draft',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isRevision
                        ? const Color(0xFFB76B16)
                        : const Color(0xFF9A6B16),
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
              const Icon(Icons.access_time, size: 14, color: secondaryText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Terakhir diedit: ${_formatTanggal(tanggal)}'
                  '${waktu.isNotEmpty ? ' · $waktu' : ''}',
                  style: const TextStyle(fontSize: 10, color: secondaryText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => _lanjutkanDraft(draft),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: Text(
                isRevision ? 'Perbaiki Data' : 'Lanjutkan',
                style: const TextStyle(
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
          if (!isRevision && _isIncompleteDraft(draft)) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _hapusDraft(draft),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Hapus Draft tidak lengkap'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          ],
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
              style: TextStyle(fontSize: 12, height: 1.5, color: secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
