import 'building_data_page.dart';

import 'package:flutter/material.dart';

class LandDataPage extends StatefulWidget {
  final String namaPerumahan;
  final String namaBlok;
  final String nomorRumah;
  final String luasTanah;

  const LandDataPage({
    super.key,
    required this.namaPerumahan,
    required this.namaBlok,
    required this.nomorRumah,
    required this.luasTanah,
  });

  @override
  State<LandDataPage> createState() => _LandDataPageState();
}

class _LandDataPageState extends State<LandDataPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nilaiTanahController = TextEditingController();

  final TextEditingController _sumberDataController = TextEditingController();

  @override
  void dispose() {
    _nilaiTanahController.dispose();
    _sumberDataController.dispose();
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInformationCard(),

                      const SizedBox(height: 10),

                      _buildDemoLabel(),

                      const SizedBox(height: 27),

                      _buildFieldLabel('Luas Tanah (m²)', required: true),

                      const SizedBox(height: 8),

                      _buildTextField(
                        initialValue: widget.luasTanah,
                        readOnly: true,
                      ),

                      const SizedBox(height: 20),

                      _buildFieldLabel(
                        'Nilai Tanah per m² (Rp)',
                        required: true,
                      ),

                      const SizedBox(height: 8),

                      _buildTextField(
                        controller: _nilaiTanahController,
                        hint: 'Masukkan nilai tanah per m²',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nilai tanah wajib diisi.';
                          }

                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Masukkan nilai yang valid.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildFieldLabel('Sumber Data Tanah'),

                      const SizedBox(height: 8),

                      _buildTextField(
                        controller: _sumberDataController,
                        hint: '',
                        maxLines: 1,
                      ),
                    ],
                  ),
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
            'Data Tanah',
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

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE8EFEB)),
          ),

          _buildInformationItem('Blok Perumahan', widget.namaBlok),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE8EFEB)),
          ),

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

  Widget _buildDemoLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F4ED),
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

  Widget _buildFieldLabel(String label, {bool required = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: darkGreen,
          fontFamily: 'Roboto',
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
    TextEditingController? controller,
    String? initialValue,
    String hint = '',
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: darkGreen),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF8A9A92)),
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
          borderSide: const BorderSide(color: primaryGreen),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 15),
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

          const SizedBox(height: 8),

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
        builder: (context) => BuildingDataPage(
          namaPerumahan: widget.namaPerumahan,
          namaBlok: widget.namaBlok,
          nomorRumah: widget.nomorRumah,
        ),
      ),
    );
  }
}
