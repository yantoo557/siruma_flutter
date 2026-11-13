import 'photo_page.dart';

import 'package:flutter/material.dart';

class BuildingDataPage extends StatefulWidget {
  final String namaPerumahan;
  final String namaBlok;
  final String nomorRumah;

  const BuildingDataPage({
    super.key,
    required this.namaPerumahan,
    required this.namaBlok,
    required this.nomorRumah,
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

                    _buildDemoBadge(),

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

  Widget _buildDemoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F3ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Data demo fiktif',
        style: TextStyle(
          color: primaryGreen,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
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
      value: _kondisiBangunan,
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

  void _continueToNextPage() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPage(
          namaPerumahan: widget.namaPerumahan,
          namaBlok: widget.namaBlok,
          nomorRumah: widget.nomorRumah,
        ),
      ),
    );
  }
}
