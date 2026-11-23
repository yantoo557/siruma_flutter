import 'package:flutter/material.dart';

import '../blok/blok_list_page.dart';
import 'perumahan_form_page.dart';
import '../../../core/services/perumahan_service.dart';

class PerumahanDetailPage extends StatefulWidget {
  final int perumahanId;
  final String namaDeveloper;
  final String namaPerumahan;
  final String alamatPerumahan;

  const PerumahanDetailPage({
    super.key,
    required this.perumahanId,
    required this.namaDeveloper,
    required this.namaPerumahan,
    required this.alamatPerumahan,
  });

  @override
  State<PerumahanDetailPage> createState() => _PerumahanDetailPageState();
}

class _PerumahanDetailPageState extends State<PerumahanDetailPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  late String _namaDeveloper;
  late String _namaPerumahan;
  late String _alamatPerumahan;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _namaDeveloper = widget.namaDeveloper;
    _namaPerumahan = widget.namaPerumahan;
    _alamatPerumahan = widget.alamatPerumahan;

    _loadDetailPerumahan();
  }

  // Mengambil detail terbaru dari backend
  Future<void> _loadDetailPerumahan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await PerumahanService.getDetailPerumahan(
        widget.perumahanId,
      );

      if (!mounted) return;

      setState(() {
        _namaDeveloper = data['developer']?.toString() ?? '';
        _namaPerumahan = data['nama_perumahan']?.toString() ?? '';
        _alamatPerumahan = data['lokasi']?.toString() ?? '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui detail perumahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Membuka halaman edit
  Future<void> _bukaEditPerumahan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PerumahanFormPage(perumahanId: widget.perumahanId),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await _loadDetailPerumahan();
    }
  }

  // Konfirmasi sebelum menghapus perumahan
  Future<void> _konfirmasiHapusPerumahan() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Perumahan?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus "$_namaPerumahan"? '
          'Seluruh blok dan unit di dalamnya juga akan dihapus. '
          'Data yang memiliki riwayat monitoring tidak dapat dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      await _hapusPerumahan();
    }
  }

  // Menghapus perumahan melalui API
  Future<void> _hapusPerumahan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await PerumahanService.hapusPerumahan(id: widget.perumahanId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perumahan berhasil dihapus.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
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
            _buildHeader(context),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryGreen),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 25, 22, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Perumahan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),

                          const SizedBox(height: 13),
                          const SizedBox(height: 12),

                          _buildInformationCard(),
                        ],
                      ),
                    ),
            ),

            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5ECE8))),
      ),
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
            'Detail Perumahan',
            style: TextStyle(
              color: darkGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInformationItem('Nama Developer Perumahan', _namaDeveloper),

          _buildDivider(),

          _buildInformationItem('Nama Perumahan', _namaPerumahan),

          _buildDivider(),

          _buildInformationItem('Alamat Perumahan', _alamatPerumahan),
        ],
      ),
    );
  }

  Widget _buildInformationItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF718078)),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1, color: Color(0xFFE8EFEB)),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 49,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlokListPage(
                            perumahanId: widget.perumahanId,
                            namaDeveloper: _namaDeveloper,
                            namaPerumahan: _namaPerumahan,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Blok Perumahan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 5),

          TextButton(
            onPressed: _isLoading ? null : _bukaEditPerumahan,
            child: const Text(
              'Edit Data Perumahan',
              style: TextStyle(
                color: Color(0xFF69AE9B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 4),

          TextButton.icon(
            onPressed: _isLoading ? null : _konfirmasiHapusPerumahan,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text(
              'Hapus Perumahan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
          ),
        ],
      ),
    );
  }
}
