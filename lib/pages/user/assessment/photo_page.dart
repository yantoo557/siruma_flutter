import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/monitoring_service.dart';
import '../../../core/services/api_service.dart';

class PhotoPage extends StatefulWidget {
  final int unitId;

  final String namaPerumahan;
  final String namaBlok;
  final String nomorRumah;

  final double luasTanah;
  final double nilaiTanahPerM2;
  final String sumberDataTanah;
  final double nilaiBangunanPerM2;

  final double luasBangunan;
  final int jumlahLantai;
  final int? tahunBangunan;
  final String kondisiBangunan;

  final int? monitoringId;
  final int? penilaianId;
  final String keteranganAwal;
  final List<Map<String, dynamic>> fotoTersimpan;
  final bool isRevision;

  const PhotoPage({
    super.key,
    required this.unitId,
    required this.namaPerumahan,
    required this.namaBlok,
    required this.nomorRumah,
    required this.luasTanah,
    required this.nilaiTanahPerM2,
    required this.sumberDataTanah,
    required this.nilaiBangunanPerM2,
    required this.luasBangunan,
    required this.jumlahLantai,
    this.tahunBangunan,
    required this.kondisiBangunan,
    this.monitoringId,
    this.penilaianId,
    this.keteranganAwal = '',
    this.fotoTersimpan = const [],
    this.isRevision = false,
  });

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);
  int? _monitoringId;

  int? _penilaianId;

  final Map<String, Map<String, dynamic>> _fotoServer = {};

  // Header autentikasi untuk mengambil foto dari endpoint/storage yang dilindungi.
  Map<String, String> _imageHeaders = const {'Accept': 'image/*'};

  // Menyimpan preview lokal agar gambar tetap terlihat setelah upload selesai.
  // Ini terpisah dari _fotoTerpilih supaya foto yang sudah diunggah tidak
  // terkirim ulang saat pengguna menekan Simpan Draft lagi.
  final Map<String, XFile> _fotoPreviewLokal = {};

  bool _isSaving = false;
  bool _penilaianSaved = false;
  bool _isSubmitting = false;
  bool _hasUnsavedChanges = false;

  int _uploadedCount = 0;

  final Set<String> _fotoBerhasilDiunggah = {};
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _keteranganController = TextEditingController();

  final List<String> _jenisFoto = [
    'Tampak Depan Rumah',
    'Tampak Samping Rumah',
    'Tampak Belakang Rumah',
    'Ruang Dalam Rumah',
    'Foto Detail Rumah',
  ];

  final Map<String, XFile?> _fotoTerpilih = {};

  int get _jumlahFotoTersimpan => _fotoServer.length;

  bool get _semuaFotoWajibTerisi => _jenisFoto
      .take(4)
      .every(
        (jenis) =>
            _fotoTerpilih[jenis] != null || _fotoServer.containsKey(jenis),
      );

  @override
  void initState() {
    super.initState();

    _monitoringId = widget.monitoringId;
    _penilaianId = widget.penilaianId;
    _penilaianSaved = _penilaianId != null;
    // Monitoring baru dan seluruh sesi Revisi dianggap belum tersimpan sampai
    // pengguna menekan Simpan Draft atau berhasil mengajukan perubahan.
    _hasUnsavedChanges = widget.monitoringId == null || widget.isRevision;
    _keteranganController.text = widget.keteranganAwal;

    // Isi awal dari halaman sebelumnya dipakai sebagai fallback.
    _gabungkanFotoServer(widget.fotoTersimpan);

    // Selalu ambil ulang foto dari endpoint khusus. Ini mencegah halaman
    // Draft/Revisi bergantung pada nama relasi JSON dari endpoint detail.
    _inisialisasiFotoServer();
  }

  Future<void> _inisialisasiFotoServer() async {
    await _muatHeaderFoto();
    await _muatFotoTersimpan();
  }

  Future<void> _muatHeaderFoto() async {
    try {
      final token = await ApiService.getToken();
      if (!mounted) return;

      setState(() {
        _imageHeaders = {
          'Accept': 'image/*',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        };
      });
    } catch (_) {
      // Foto publik tetap dapat dimuat dengan header Accept saja.
    }
  }

  String? _jenisFotoCanonical(dynamic value) {
    if (value == null) return null;
    final normalized = value.toString().trim().toLowerCase();
    if (normalized.isEmpty) return null;

    for (final jenis in _jenisFoto) {
      if (jenis.toLowerCase() == normalized) return jenis;
    }
    return null;
  }

  void _gabungkanFotoServer(List<Map<String, dynamic>> daftarFoto) {
    for (final foto in daftarFoto) {
      final jenis = _jenisFotoCanonical(
        foto['jenis_foto'] ?? foto['jenisFoto'] ?? foto['jenis'],
      );
      if (jenis != null) {
        _fotoServer[jenis] = Map<String, dynamic>.from(foto);
      }
    }
  }

  Future<void> _muatFotoTersimpan() async {
    final id = _monitoringId;
    if (id == null) return;

    try {
      final daftarFoto = await MonitoringService.getFotoMonitoring(id);
      if (!mounted || daftarFoto.isEmpty) return;

      setState(() {
        _gabungkanFotoServer(daftarFoto);
      });
    } catch (e) {
      debugPrint('Gagal memuat foto monitoring $id: $e');
    }
  }

  String get _pesanKonfirmasiKeluar {
    if (widget.isRevision) {
      return 'Perubahan revisi yang belum disimpan akan dibuang. Data monitoring sebelumnya tetap aman.';
    }

    if (_monitoringId != null) {
      return _hasUnsavedChanges
          ? 'Draft terakhir yang sudah tersimpan tetap aman. Perubahan sejak penyimpanan terakhir akan dibuang.'
          : 'Draft sudah tersimpan. Kamu yakin ingin keluar dari halaman ini?';
    }

    return 'Data monitoring baru belum tersimpan. Jika keluar, seluruh data dalam proses ini akan dibuang.';
  }

  Future<void> _konfirmasiKeluar() async {
    if (_isSaving || _isSubmitting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tunggu proses penyimpanan selesai sebelum keluar.'),
        ),
      );
      return;
    }

    final keluar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Keluar dari penilaian?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(_pesanKonfirmasiKeluar),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (keluar != true || !mounted) return;

    final navigator = Navigator.of(context);

    if (widget.isRevision) {
      // Tumpukan revisi: History -> Land -> Building -> Photo.
      // Kembali langsung ke History tanpa mengubah data server yang lama.
      for (var i = 0; i < 3 && navigator.canPop(); i++) {
        navigator.pop();
      }
    } else if (widget.monitoringId != null) {
      // Draft yang sudah tersimpan tetap ada; hanya perubahan di layar ini dibuang.
      navigator.pop();
    } else {
      // Monitoring baru: tutup seluruh alur pembuatan dan kembali ke halaman awal.
      navigator.popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto(String jenisFoto, ImageSource source) async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (foto != null && mounted) {
        _fotoBerhasilDiunggah.remove(jenisFoto);
        setState(() {
          _fotoTerpilih[jenisFoto] = foto;
          _fotoPreviewLokal[jenisFoto] = foto;
          _hasUnsavedChanges = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil foto. Silakan coba lagi.'),
        ),
      );
    }
  }

  void _hapusFoto(String jenisFoto) {
    _fotoBerhasilDiunggah.remove(jenisFoto);
    setState(() {
      _fotoTerpilih[jenisFoto] = null;
      // Jika foto server lama ada, UI kembali menampilkan foto server lama.
      _fotoPreviewLokal.remove(jenisFoto);
      _hasUnsavedChanges = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$jenisFoto berhasil dihapus.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pastikanMonitoringTersimpan() async {
    if (_monitoringId != null) return;

    final response = await MonitoringService.createMonitoring(
      unitId: widget.unitId,
      kondisi: widget.kondisiBangunan,
      keterangan: _keteranganController.text.trim(),
      tanggalMonitoring: DateTime.now().toIso8601String().substring(0, 10),
      progress: 0,
    );

    final data = response['data'];

    final dynamic id = data is Map ? data['id'] : response['id'];

    if (id == null) {
      throw Exception(
        'ID monitoring tidak ditemukan dalam respons server: $response',
      );
    }

    _monitoringId = int.parse(id.toString());
  }

  Future<void> _pastikanPenilaianTersimpan() async {
    if (_penilaianId != null) {
      await MonitoringService.updatePenilaian(
        penilaianId: _penilaianId!,
        luasTanah: widget.luasTanah,
        luasBangunan: widget.luasBangunan,
        nilaiTanahPerM2: widget.nilaiTanahPerM2,
        nilaiBangunanPerM2: widget.nilaiBangunanPerM2,
        sumberDataTanah: widget.sumberDataTanah,
        jumlahLantai: widget.jumlahLantai,
        tahunBangunan: widget.tahunBangunan,
      );
      _penilaianSaved = true;
      return;
    }

    if (_penilaianSaved) return;

    final response = await MonitoringService.createPenilaian(
      monitoringId: _monitoringId!,
      luasTanah: widget.luasTanah,
      luasBangunan: widget.luasBangunan,
      nilaiTanahPerM2: widget.nilaiTanahPerM2,
      nilaiBangunanPerM2: widget.nilaiBangunanPerM2,
      sumberDataTanah: widget.sumberDataTanah,
      jumlahLantai: widget.jumlahLantai,
      tahunBangunan: widget.tahunBangunan,
    );

    final data = response['data'];
    final dynamic id = data is Map ? data['id'] : response['id'];
    if (id != null) {
      _penilaianId = int.tryParse(id.toString());
    }
    _penilaianSaved = true;
  }

  // Simpan foto ke server sebagai bagian dari Draft.
  // Foto yang sudah berhasil diunggah atau sudah ada di server akan dilewati,
  // sehingga proses simpan ulang tidak membuat foto duplikat.
  Future<void> _unggahFotoDraft() async {
    for (final jenisFoto in _jenisFoto) {
      final foto = _fotoTerpilih[jenisFoto];

      if (foto == null) continue;

      final fotoLama = _fotoServer[jenisFoto];
      final keterangan = _keteranganController.text.trim();

      Map<String, dynamic> response;

      if (fotoLama != null) {
        final fotoId = int.tryParse(fotoLama['id']?.toString() ?? '');

        if (fotoId == null) {
          throw Exception('ID foto $jenisFoto tidak ditemukan.');
        }

        response = await MonitoringService.replaceFoto(
          monitoringId: _monitoringId!,
          fotoId: fotoId,
          foto: File(foto.path),
          keterangan: keterangan,
        );
      } else {
        response = await MonitoringService.uploadFoto(
          monitoringId: _monitoringId!,
          foto: File(foto.path),
          jenisFoto: jenisFoto,
          keterangan: keterangan,
        );
      }

      final data = response['data'];

      if (data is! Map) {
        throw Exception('Respons penyimpanan foto tidak valid.');
      }

      // Gabungkan respons API dengan data foto sebelumnya. Ini menjaga ID foto
      // tetap tersedia jika endpoint replace hanya mengembalikan sebagian field.
      final fotoData = <String, dynamic>{
        if (fotoLama != null) ...fotoLama,
        ...Map<String, dynamic>.from(data),
      };
      fotoData['jenis_foto'] ??= jenisFoto;

      _fotoServer[jenisFoto] = fotoData;
      // Jangan hapus _fotoPreviewLokal: preview tetap memakai file lokal
      // meskipun respons API tidak menyertakan URL foto yang bisa ditampilkan.
      _fotoTerpilih[jenisFoto] = null;
      _fotoBerhasilDiunggah.add(jenisFoto);

      if (!mounted) return;

      setState(() {
        _uploadedCount = _jumlahFotoTersimpan;
      });
    }
  }

  Future<void> _simpanDraft() async {
    if (_isSaving || _isSubmitting) return;

    setState(() {
      _isSaving = true;
      _uploadedCount = _jumlahFotoTersimpan;
    });

    try {
      await _pastikanMonitoringTersimpan();

      await MonitoringService.updateMonitoring(
        monitoringId: _monitoringId!,
        keterangan: _keteranganController.text.trim(),
        kondisi: widget.kondisiBangunan,
      );

      await _pastikanPenilaianTersimpan();

      // Cukup satu kali untuk mengunggah atau mengganti foto.
      await _unggahFotoDraft();

      if (!mounted) return;

      setState(() {
        _hasUnsavedChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Draft tersimpan. $_jumlahFotoTersimpan foto sudah tersimpan di server.',
          ),
          backgroundColor: primaryGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan draft: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _uploadMonitoring() async {
    if (_isSaving || _isSubmitting) return;

    if (!_semuaFotoWajibTerisi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi 4 foto wajib sebelum upload monitoring.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _uploadedCount = _jumlahFotoTersimpan;
    });

    try {
      await _pastikanMonitoringTersimpan();

      // Perbarui monitoring lama, bukan membuat yang baru.
      await MonitoringService.updateMonitoring(
        monitoringId: _monitoringId!,
        keterangan: _keteranganController.text.trim(),
        kondisi: widget.kondisiBangunan,
      );

      // Perbarui penilaian berdasarkan ID yang sudah ada.
      await _pastikanPenilaianTersimpan();

      // Unggah foto baru atau ganti foto lama.
      await _unggahFotoDraft();

      // Ajukan monitoring.
      await MonitoringService.ajukanApproval(_monitoringId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Monitoring berhasil diajukan ke Super Approval.'),
          backgroundColor: primaryGreen,
        ),
      );

      if (widget.isRevision) {
        Navigator.pop(context, true);
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
      }

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Proses pengajuan gagal. Detail: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInformationCard(),
                    const SizedBox(height: 18),
                    const Text(
                      'Pastikan foto terlihat jelas dan sesuai '
                      'dengan kondisi rumah sebenarnya.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: secondaryText,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ..._jenisFoto.map(
                      (jenis) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildPhotoCard(jenis),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildKeteranganField(),

                    const SizedBox(height: 10),

                    const Text(
                      '* Empat foto pertama wajib diisi. '
                      'Foto Detail Rumah bersifat opsional.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 62,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: darkGreen,
              ),
            ),
          ),
          const Text(
            'Foto Rumah',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Keluar dari penilaian',
              onPressed: _konfirmasiKeluar,
              icon: const Icon(Icons.close, size: 22, color: darkGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _informationItem('Nama Perumahan', widget.namaPerumahan),
          const Divider(height: 20, color: Color(0xFFE8EFEB)),
          _informationItem('Blok Perumahan', widget.namaBlok),
          const Divider(height: 20, color: Color(0xFFE8EFEB)),
          _informationItem('Nomor Rumah', widget.nomorRumah),
        ],
      ),
    );
  }

  Widget _informationItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: secondaryText)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkGreen,
          ),
        ),
      ],
    );
  }

  String? _urlFotoServer(Map<String, dynamic>? fotoServer) {
    if (fotoServer == null) return null;

    final serverRoot = ApiConfig.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    final rawUrl = (fotoServer['url'] ??
            fotoServer['foto_url'] ??
            fotoServer['url_foto'] ??
            fotoServer['image_url'])
        ?.toString()
        .trim();

    String normalizeAbsoluteOrRelative(String value) {
      final parsed = Uri.tryParse(value);
      if (parsed != null && parsed.hasScheme && parsed.host.isNotEmpty) {
        if (parsed.host == 'localhost' ||
            parsed.host == '127.0.0.1' ||
            parsed.host == '0.0.0.0') {
          return Uri.parse(serverRoot)
              .replace(path: parsed.path, query: parsed.query)
              .toString();
        }
        return value;
      }

      final path = value.startsWith('/') ? value : '/$value';
      return Uri.parse(serverRoot).resolve(path).toString();
    }

    if (rawUrl != null && rawUrl.isNotEmpty) {
      return normalizeAbsoluteOrRelative(rawUrl);
    }

    final rawPath = (fotoServer['file_path'] ??
            fotoServer['path'] ??
            fotoServer['foto_path'] ??
            fotoServer['file'] ??
            fotoServer['gambar'])
        ?.toString()
        .trim()
        .replaceAll('\\', '/');

    if (rawPath == null || rawPath.isEmpty) return null;
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return normalizeAbsoluteOrRelative(rawPath);
    }

    var normalizedPath = rawPath.startsWith('/')
        ? rawPath.substring(1)
        : rawPath;
    if (normalizedPath.startsWith('public/')) {
      normalizedPath = normalizedPath.substring('public/'.length);
    }
    if (!normalizedPath.startsWith('storage/')) {
      normalizedPath = 'storage/$normalizedPath';
    }

    return '$serverRoot/$normalizedPath';
  }

  void _lihatFoto({XFile? fotoLokal, Map<String, dynamic>? fotoServer}) {
    final urlServer = _urlFotoServer(fotoServer);
    if (fotoLokal == null && urlServer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat foto tidak tersedia.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4,
                      child: fotoLokal != null
                          ? Image.file(
                              File(fotoLokal.path),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.white,
                                size: 60,
                              ),
                            )
                          : Image.network(
                              urlServer!,
                              fit: BoxFit.contain,
                              headers: _imageHeaders,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Foto tidak dapat dimuat',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoCard(String jenisFoto) {
    final foto = _fotoTerpilih[jenisFoto];
    final fotoPreview = _fotoPreviewLokal[jenisFoto] ?? foto;
    final fotoServer = _fotoServer[jenisFoto];
    final sudahAdaFoto =
        fotoPreview != null || fotoServer != null;
    final fotoWajib = _jenisFoto.indexOf(jenisFoto) < 4;
    final urlServer = _urlFotoServer(fotoServer);

    Widget thumbnail;
    if (fotoPreview != null) {
      thumbnail = Image.file(
        File(fotoPreview.path),
        width: 86,
        height: 86,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image_outlined, color: primaryGreen),
      );
    } else if (urlServer != null) {
      thumbnail = Image.network(
        urlServer,
        headers: _imageHeaders,
        width: 86,
        height: 86,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image_outlined, color: primaryGreen),
      );
    } else {
      thumbnail = const Icon(
        Icons.camera_alt_outlined,
        color: primaryGreen,
        size: 23,
      );
    }

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: sudahAdaFoto
                ? () => _lihatFoto(
                    fotoLokal: fotoPreview,
                    fotoServer: fotoServer,
                  )
                : null,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7F2),
                borderRadius: BorderRadius.circular(11),
              ),
              clipBehavior: Clip.antiAlias,
              child: thumbnail,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jenisFoto,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  sudahAdaFoto
                      ? 'Ketuk gambar untuk melihat lebih jelas'
                      : fotoWajib
                      ? 'Belum ada foto yang dipilih'
                      : 'Opsional - belum ada foto',
                  style: const TextStyle(fontSize: 10, color: secondaryText),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildPhotoButton(
                      'Ambil Foto',
                      Icons.camera_alt_outlined,
                      () => _pilihFoto(jenisFoto, ImageSource.camera),
                    ),
                    _buildPhotoButton(
                      'Pilih dari Galeri',
                      Icons.photo_library_outlined,
                      () => _pilihFoto(jenisFoto, ImageSource.gallery),
                    ),
                    if (foto != null)
                      _buildPhotoButton(
                        'Hapus',
                        Icons.delete_outline,
                        () => _hapusFoto(jenisFoto),
                        isDelete: true,
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

  Widget _buildPhotoButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isDelete = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isDelete ? const Color(0xFFFFF0F0) : const Color(0xFFEDF7F2),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: isDelete ? Colors.red : primaryGreen),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isDelete ? Colors.red : primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeteranganField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Keterangan Monitoring',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: _keteranganController,
          onChanged: (_) {
            if (!_hasUnsavedChanges) {
              setState(() => _hasUnsavedChanges = true);
            }
          },
          maxLines: 5,
          minLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Tuliskan keterangan tambahan mengenai kondisi rumah...',
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9AA8A1)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFD8E5DE)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFD8E5DE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: primaryGreen, width: 1.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 13, 22, 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isSaving || _isSubmitting) ...[
            LinearProgressIndicator(
              value: (_isSaving || _isSubmitting) && _jenisFoto.isNotEmpty
                  ? (_uploadedCount / _jenisFoto.length).clamp(0.0, 1.0)
                  : null,
              color: primaryGreen,
              backgroundColor: const Color(0xFFE1EBE5),
            ),
            const SizedBox(height: 8),
            Text(
              _isSaving
                  ? 'Menyimpan draft & foto: $_uploadedCount/${_jenisFoto.length}'
                  : 'Mengunggah foto: $_uploadedCount/${_jenisFoto.length}',
              style: const TextStyle(fontSize: 11, color: secondaryText),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 49,
                  child: OutlinedButton.icon(
                    onPressed: _isSaving || _isSubmitting ? null : _simpanDraft,
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: const Text(
                      'Simpan Draft',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryGreen,
                      side: const BorderSide(color: primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 49,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving || _isSubmitting
                        ? null
                        : _uploadMonitoring,
                    icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: const Text(
                      'Upload Monitoring',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
