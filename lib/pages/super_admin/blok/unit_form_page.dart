
import 'package:flutter/material.dart';

import '../../../core/services/unit_service.dart';
import '../../../models/unit_model.dart';

class UnitFormPage extends StatefulWidget {
  final String namaPerumahan;
  final String namaBlok;
  final int blokId;
  final UnitModel? unit;

  const UnitFormPage({
    super.key,
    required this.namaPerumahan,
    required this.namaBlok,
    required this.blokId,
    this.unit,
  });

  @override
  State<UnitFormPage> createState() => _UnitFormPageState();
}

class _UnitFormPageState extends State<UnitFormPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  bool _isSaving = false;
  bool get _isEdit => widget.unit != null;

  final _nomorController = TextEditingController();
  final _luasTanahController = TextEditingController();
  final _luasBangunanController = TextEditingController();
  final _nilaiTanahController = TextEditingController();
  final _nilaiBangunanController = TextEditingController();

  String _status = 'aktif';

  @override
  void initState() {
    super.initState();

    final unit = widget.unit;

    if (unit != null) {
      _nomorController.text = unit.nomorUnit;
      _luasTanahController.text = unit.luasTanah.toString();
      _luasBangunanController.text = unit.luasBangunan.toString();
      _nilaiTanahController.text = unit.nilaiTanahPerM2.toString();
      _nilaiBangunanController.text = unit.nilaiBangunanPerM2.toString();
      _status = unit.status.toLowerCase();
    }
  }

  @override
  void dispose() {
    _nomorController.dispose();
    _luasTanahController.dispose();
    _luasBangunanController.dispose();
    _nilaiTanahController.dispose();
    _nilaiBangunanController.dispose();
    super.dispose();
  }

  double _parseAngka(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.')) ?? 0;
  }

  Future<void> _simpanUnit() async {
    final nomorUnit = _nomorController.text.trim();
    final luasTanah = _parseAngka(_luasTanahController.text);
    final luasBangunan = _parseAngka(_luasBangunanController.text);
    final nilaiTanah = _parseAngka(_nilaiTanahController.text);
    final nilaiBangunan = _parseAngka(_nilaiBangunanController.text);

    if (nomorUnit.isEmpty || luasTanah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nomor rumah dan luas tanah harus diisi dengan benar.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (luasBangunan < 0 || nilaiTanah < 0 || nilaiBangunan < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nilai tidak boleh negatif.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (_isEdit) {
        await UnitService.updateUnit(
          unitId: widget.unit!.id,
          nomorUnit: nomorUnit,
          luasTanah: luasTanah,
          luasBangunan: luasBangunan,
          nilaiTanahPerM2: nilaiTanah,
          nilaiBangunanPerM2: nilaiBangunan,
          status: _status,
        );
      } else {
        await UnitService.tambahUnit(
          blokId: widget.blokId,
          nomorUnit: nomorUnit,
          luasTanah: luasTanah,
          luasBangunan: luasBangunan,
          nilaiTanahPerM2: nilaiTanah,
          nilaiBangunanPerM2: nilaiBangunan,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? 'Unit rumah berhasil diperbarui.'
                : 'Unit rumah berhasil ditambahkan.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan unit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
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
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInformationCard(),
                    const SizedBox(height: 25),

                    _buildLabel('Nomor Rumah', true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nomorController,
                      hint: 'Masukkan nomor rumah',
                    ),

                    const SizedBox(height: 20),
                    _buildLabel('Luas Tanah (m²)', true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _luasTanahController,
                      hint: 'Masukkan luas tanah',
                      isNumber: true,
                    ),

                    const SizedBox(height: 20),
                    _buildLabel('Luas Bangunan (m²)', false),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _luasBangunanController,
                      hint: 'Masukkan luas bangunan',
                      isNumber: true,
                    ),

                    const SizedBox(height: 25),
                    const Text(
                      'Informasi Penilaian',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Nilai Tanah per m² (Rp)', false),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nilaiTanahController,
                      hint: 'Contoh: 1000000',
                      isNumber: true,
                    ),

                    const SizedBox(height: 20),
                    _buildLabel('Nilai Bangunan per m² (Rp)', false),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nilaiBangunanController,
                      hint: 'Contoh: 1500000',
                      isNumber: true,
                    ),

                    if (_isEdit) ...[
                      const SizedBox(height: 25),
                      const Text(
                        'Status Unit',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _status,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'aktif',
                            child: Text('Aktif'),
                          ),
                          DropdownMenuItem(
                            value: 'nonaktif',
                            child: Text('Nonaktif'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _status = value);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
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
          Text(
            _isEdit ? 'Edit Unit Rumah' : 'Tambah Unit Rumah',
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

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Perumahan',
            style: TextStyle(fontSize: 12, color: Color(0xFF718078)),
          ),
          const SizedBox(height: 5),
          Text(
            widget.namaPerumahan,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkGreen,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE8EFEB)),
          ),
          const Text(
            'Blok Perumahan',
            style: TextStyle(fontSize: 12, color: Color(0xFF718078)),
          ),
          const SizedBox(height: 5),
          Text(
            widget.namaBlok,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkGreen,
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
              style: TextStyle(color: Color(0xFFD64545)),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFF89958F),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFD7E4DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFD7E4DD)),
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
              onPressed: _isSaving ? null : _simpanUnit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
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
          const SizedBox(height: 5),
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
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
