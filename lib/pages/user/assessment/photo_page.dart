
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPage extends StatefulWidget {
  final String namaPerumahan;
  final String namaBlok;
  final String nomorRumah;

  const PhotoPage({
    super.key,
    required this.namaPerumahan,
    required this.namaBlok,
    required this.nomorRumah,
  });

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _keteranganController =
      TextEditingController();

  final List<String> _jenisFoto = [
    'Tampak Depan Rumah',
    'Tampak Samping Rumah',
    'Tampak Belakang Rumah',
    'Ruang Dalam Rumah',
    'Foto Detail Rumah',
  ];

  final Map<String, XFile?> _fotoTerpilih = {};

  int get _jumlahFoto =>
      _fotoTerpilih.values.where((foto) => foto != null).length;

  bool get _semuaFotoWajibTerisi =>
      _jenisFoto.take(4).every(
        (jenis) => _fotoTerpilih[jenis] != null,
      );

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto(
    String jenisFoto,
    ImageSource source,
  ) async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (foto != null && mounted) {
        setState(() {
          _fotoTerpilih[jenisFoto] = foto;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal mengambil foto. Silakan coba lagi.',
          ),
        ),
      );
    }
  }

  void _hapusFoto(String jenisFoto) {
    setState(() {
      _fotoTerpilih[jenisFoto] = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$jenisFoto berhasil dihapus.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _simpanDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Fitur simpan Draft akan diaktifkan setelah integrasi backend.',
        ),
      ),
    );
  }

  void _uploadMonitoring() {
    if (!_semuaFotoWajibTerisi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi 4 foto wajib sebelum upload monitoring.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Tampilan Upload siap. Pengiriman ke Super Approval '
          'akan diaktifkan setelah integrasi backend.',
        ),
      ),
    );
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

                    const SizedBox(height: 10),

                    _buildDemoBadge(),

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
        border: Border.all(
          color: const Color(0xFFE1EBE5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _informationItem(
            'Nama Perumahan',
            widget.namaPerumahan,
          ),
          const Divider(
            height: 20,
            color: Color(0xFFE8EFEB),
          ),
          _informationItem(
            'Blok Perumahan',
            widget.namaBlok,
          ),
          const Divider(
            height: 20,
            color: Color(0xFFE8EFEB),
          ),
          _informationItem(
            'Nomor Rumah',
            widget.nomorRumah,
          ),
        ],
      ),
    );
  }

  Widget _informationItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: secondaryText,
          ),
        ),
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

  Widget _buildDemoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F4ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Data demo fiktif',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: primaryGreen,
        ),
      ),
    );
  }

  Widget _buildPhotoCard(String jenisFoto) {
    final foto = _fotoTerpilih[jenisFoto];
    final sudahAdaFoto = foto != null;
    final fotoWajib = _jenisFoto.indexOf(jenisFoto) < 4;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE1EBE5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7F2),
              borderRadius: BorderRadius.circular(11),
            ),
            clipBehavior: Clip.antiAlias,
            child: sudahAdaFoto
                ? Image.file(
                    File(foto.path),
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.camera_alt_outlined,
                    color: primaryGreen,
                    size: 23,
                  ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        jenisFoto,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                    _buildStatus(sudahAdaFoto),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  sudahAdaFoto
                      ? 'Foto berhasil dipilih'
                      : fotoWajib
                          ? 'Belum ada foto yang dipilih'
                          : 'Opsional - belum ada foto',
                  style: const TextStyle(
                    fontSize: 10,
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: 7),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildPhotoButton(
                      'Ambil Foto',
                      Icons.camera_alt_outlined,
                      () => _pilihFoto(
                        jenisFoto,
                        ImageSource.camera,
                      ),
                    ),
                    _buildPhotoButton(
                      'Pilih dari Galeri',
                      Icons.photo_library_outlined,
                      () => _pilihFoto(
                        jenisFoto,
                        ImageSource.gallery,
                      ),
                    ),
                    if (sudahAdaFoto)
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

  Widget _buildStatus(bool sudahAdaFoto) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: sudahAdaFoto
            ? const Color(0xFFE4F4ED)
            : const Color(0xFFF0F3F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        sudahAdaFoto ? 'Sudah ada' : 'Belum ada',
        style: const TextStyle(
          fontSize: 9,
          color: secondaryText,
        ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isDelete
              ? const Color(0xFFFFF0F0)
              : const Color(0xFFEDF7F2),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isDelete ? Colors.red : primaryGreen,
            ),
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
          maxLines: 5,
          minLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText:
                'Tuliskan keterangan tambahan mengenai kondisi rumah...',
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9AA8A1),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: Color(0xFFD8E5DE),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: Color(0xFFD8E5DE),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: primaryGreen,
                width: 1.3,
              ),
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
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5ECE8),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 49,
              child: OutlinedButton.icon(
                onPressed: _simpanDraft,
                icon: const Icon(
                  Icons.save_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Simpan Draft',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryGreen,
                  side: const BorderSide(
                    color: primaryGreen,
                  ),
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
                onPressed: _uploadMonitoring,
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  size: 18,
                ),
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
    );
  }
}
