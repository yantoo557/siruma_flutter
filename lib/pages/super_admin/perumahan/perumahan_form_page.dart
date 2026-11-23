
import 'package:flutter/material.dart';
import '../../../core/services/perumahan_service.dart';

class PerumahanFormPage extends StatefulWidget {
  final int? perumahanId;

  const PerumahanFormPage({
    super.key,
    this.perumahanId,
  });

  @override
  State<PerumahanFormPage> createState() =>
      _PerumahanFormPageState();
}

class _PerumahanFormPageState extends State<PerumahanFormPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  final TextEditingController _developerController =
      TextEditingController();

  final TextEditingController _namaController =
      TextEditingController();

  final TextEditingController _alamatController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSaving = false;

  bool get _isEdit => widget.perumahanId != null;

  @override
  void initState() {
    super.initState();

    if (_isEdit) {
      _loadDetailPerumahan();
    }
  }

  // Mengambil data perumahan untuk mode edit
  Future<void> _loadDetailPerumahan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await PerumahanService.getDetailPerumahan(
        widget.perumahanId!,
      );

      if (!mounted) return;

      _developerController.text =
          data['developer']?.toString() ?? '';

      _namaController.text =
          data['nama_perumahan']?.toString() ?? '';

      _alamatController.text =
          data['lokasi']?.toString() ?? '';

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data perumahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Menyimpan data tambah atau edit
  Future<void> _simpanPerumahan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isEdit) {
        await PerumahanService.updatePerumahan(
          id: widget.perumahanId!,
          developer: _developerController.text.trim(),
          namaPerumahan: _namaController.text.trim(),
          lokasi: _alamatController.text.trim(),
        );
      } else {
        await PerumahanService.tambahPerumahan(
          developer: _developerController.text.trim(),
          namaPerumahan: _namaController.text.trim(),
          lokasi: _alamatController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? 'Data perumahan berhasil diperbarui.'
                : 'Perumahan berhasil ditambahkan.',
          ),
          backgroundColor: primaryGreen,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan perumahan: $e'),
          backgroundColor: Colors.red,
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

  @override
  void dispose() {
    _developerController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryGreen,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        22, 22, 22, 25,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEdit
                                  ? 'Perbarui informasi perumahan.'
                                  : 'Lengkapi informasi dasar perumahan.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF52645D),
                              ),
                            ),

                            const SizedBox(height: 25),

                            _buildLabel(
                              'Nama Developer Perumahan',
                              true,
                            ),

                            const SizedBox(height: 8),

                            _buildTextField(
                              controller: _developerController,
                              required: true,
                            ),

                            const SizedBox(height: 20),

                            _buildLabel('Nama Perumahan', true),

                            const SizedBox(height: 8),

                            _buildTextField(
                              controller: _namaController,
                              required: true,
                            ),

                            const SizedBox(height: 20),

                            _buildLabel('Alamat Perumahan', false),

                            const SizedBox(height: 8),

                            _buildTextField(
                              controller: _alamatController,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            if (!_isLoading) _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5ECE8),
          ),
        ),
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

          Text(
            _isEdit ? 'Edit Perumahan' : 'Tambah Perumahan',
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

  Widget _buildLabel(String label, bool required) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          color: darkGreen,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(0xFFD64545),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.top,
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bagian ini wajib diisi.';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFD7E4DD),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFD7E4DD),
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
    );
  }

  Widget _buildBottomActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22, 14, 22, 18,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5ECE8),
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 49,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _simpanPerumahan,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF69AE9B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _isEdit ? 'Simpan Perubahan' : 'Simpan',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 8),

          TextButton(
            onPressed: _isSaving
                ? null
                : () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: primaryGreen,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
