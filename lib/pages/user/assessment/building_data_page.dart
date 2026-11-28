import 'package:flutter/material.dart';

import 'photo_page.dart';

class BuildingDataPage extends StatefulWidget {
  final int unitId;
  final String namaPerumahan;
  final String namaBlok;
  final String nomorRumah;
  final double luasTanah;
  final double nilaiTanahPerM2;
  final String sumberDataTanah;
  final double nilaiBangunanPerM2;
  final double? nilaiBangunanAwal;
  final int? monitoringId;
  final int? penilaianId;
  final double? luasBangunanAwal;
  final int? jumlahLantaiAwal;
  final int? tahunBangunanAwal;
  final String? kondisiBangunanAwal;
  final String keteranganAwal;
  final List<Map<String, dynamic>> fotoTersimpan;
  final bool isRevision;

  const BuildingDataPage({
    super.key,
    required this.unitId,
    required this.namaPerumahan,
    required this.namaBlok,
    required this.nomorRumah,
    required this.luasTanah,
    required this.nilaiTanahPerM2,
    required this.sumberDataTanah,
    required this.nilaiBangunanPerM2,
    this.nilaiBangunanAwal,
    this.monitoringId,
    this.penilaianId,
    this.luasBangunanAwal,
    this.jumlahLantaiAwal,
    this.tahunBangunanAwal,
    this.kondisiBangunanAwal,
    this.keteranganAwal = '',
    this.fotoTersimpan = const [],
    this.isRevision = false,  
  });

  @override
  State<BuildingDataPage> createState() => _BuildingDataPageState();
}

class _BuildingDataPageState extends State<BuildingDataPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _luasBangunanController = TextEditingController();
  final TextEditingController _jumlahLantaiController = TextEditingController();
  final TextEditingController _tahunBangunanController =
      TextEditingController();

  String? _kondisiBangunan;

  @override
  void initState() {
    super.initState();

    _luasBangunanController.text =
        widget.luasBangunanAwal?.toString() ?? '';

    _jumlahLantaiController.text =
        widget.jumlahLantaiAwal?.toString() ?? '';

    _tahunBangunanController.text =
        widget.tahunBangunanAwal?.toString() ?? '';

    _kondisiBangunan = widget.kondisiBangunanAwal;
  }

  @override
  void dispose() {
    _luasBangunanController.dispose();
    _jumlahLantaiController.dispose();
    _tahunBangunanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInformationCard(),

                    const SizedBox(height: 10),
                    const SizedBox(height: 27),

                    _buildLabel('Luas Bangunan (m²)', required: true),
                    const SizedBox(height: 9),
                    _buildTextField(
                      controller: _luasBangunanController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 21),

                    _buildLabel('Jumlah Lantai', required: true),
                    const SizedBox(height: 9),
                    _buildTextField(
                      controller: _jumlahLantaiController,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 21),

                    _buildLabel('Kondisi Bangunan', required: true),
                    const SizedBox(height: 9),
                    _buildConditionDropdown(),

                    const SizedBox(height: 21),

                    _buildLabel('Tahun Bangunan'),
                    const SizedBox(height: 9),
                    _buildTextField(
                      controller: _tahunBangunanController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        'Data Bangunan',
        style: TextStyle(
          color: darkGreen,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: darkGreen),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFE5ECE8)),
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
          _buildInformationItem('Nama Perumahan', widget.namaPerumahan),
          const Divider(height: 18, color: Color(0xFFE8EFEB)),
          _buildInformationItem('Blok Perumahan', widget.namaBlok),
          const Divider(height: 18, color: Color(0xFFE8EFEB)),
          _buildInformationItem('Nomor Rumah', widget.nomorRumah),
        ],
      ),
    );
  }

  Widget _buildInformationItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: secondaryText)),
        const SizedBox(height: 4),
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

  Widget _buildLabel(String label, {bool required = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: darkGreen,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Field ini wajib diisi.';
        }

        if (double.tryParse(value.trim()) == null) {
          return 'Masukkan angka yang valid.';
        }

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildConditionDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _kondisiBangunan,
      hint: const Text(
        'Pilih kondisi bangunan',
        style: TextStyle(fontSize: 14, color: darkGreen),
      ),
      items: const [
        DropdownMenuItem(value: 'Baik', child: Text('Baik')),
        DropdownMenuItem(value: 'Sedang', child: Text('Sedang')),
        DropdownMenuItem(
          value: 'Perlu Perbaikan',
          child: Text('Perlu Perbaikan'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _kondisiBangunan = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Pilih kondisi bangunan.';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
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
    );
  }

  Widget _buildBottomAction() {
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
              onPressed: _continueToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Lanjutkan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Kembali',
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

 Future<void> _continueToNextPage() async {
    if (!_formKey.currentState!.validate()) return;

    final hasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPage(
          unitId: widget.unitId,
          namaPerumahan: widget.namaPerumahan,
          namaBlok: widget.namaBlok,
          nomorRumah: widget.nomorRumah,
          luasTanah: widget.luasTanah,
          nilaiTanahPerM2: widget.nilaiTanahPerM2,
          sumberDataTanah: widget.sumberDataTanah,
          nilaiBangunanPerM2: widget.nilaiBangunanPerM2,
          isRevision: widget.isRevision,
          luasBangunan: double.parse(
            _luasBangunanController.text.trim(),
          ),
          jumlahLantai: int.parse(
            _jumlahLantaiController.text.trim(),
          ),  
          tahunBangunan: _tahunBangunanController.text.trim().isEmpty
              ? null
              : int.parse(_tahunBangunanController.text.trim()),
          kondisiBangunan: _kondisiBangunan!,

          // Data untuk proses revisi
          monitoringId: widget.monitoringId,
          penilaianId: widget.penilaianId,
          keteranganAwal: widget.keteranganAwal,
          fotoTersimpan: widget.fotoTersimpan,
        ),
      ),
    );
    if (hasil == true && mounted) {
      Navigator.pop(context, true);
    }
  }
}
