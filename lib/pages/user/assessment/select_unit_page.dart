import 'package:flutter/material.dart';

import 'land_data_page.dart';

import 'package:flutter/material.dart';

class SelectUnitPage extends StatefulWidget {
  final String namaPerumahan;
  final String namaDeveloper;

  const SelectUnitPage({
    super.key,
    required this.namaPerumahan,
    required this.namaDeveloper,
  });

  @override
  State<SelectUnitPage> createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final TextEditingController _searchController = TextEditingController();

  String? _selectedUnit;

  final List<Map<String, String>> _unitList = [
    {'nomor': 'A-01', 'blok': 'Blok A', 'luasTanah': '98'},
    {'nomor': 'A-02', 'blok': 'Blok A', 'luasTanah': '97'},
    {'nomor': 'B-01', 'blok': 'Blok B', 'luasTanah': '100'},
  ];

  List<Map<String, String>> get _filteredUnits {
    final query = _searchController.text.toLowerCase();

    return _unitList.where((unit) {
      return unit['nomor']!.toLowerCase().contains(query) ||
          unit['blok']!.toLowerCase().contains(query);
    }).toList();
  }

  List<String> get _blokList {
    return _filteredUnits.map((unit) => unit['blok']!).toSet().toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih unit rumah yang akan dinilai.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF52645D)),
                    ),

                    const SizedBox(height: 18),

                    _buildInformationCard(),

                    const SizedBox(height: 10),

                    _buildDemoBadge(),

                    const SizedBox(height: 14),

                    _buildSearchField(),

                    const SizedBox(height: 20),

                    ..._blokList.map((blok) {
                      final units = _filteredUnits
                          .where((unit) => unit['blok'] == blok)
                          .toList();

                      return _buildBlokSection(blok, units);
                    }),

                    if (_filteredUnits.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: Center(
                          child: Text(
                            'Unit rumah tidak ditemukan.',
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryText,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 58,
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
            'Pilih Rumah',
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
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
            style: TextStyle(fontSize: 12, color: secondaryText),
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
            padding: EdgeInsets.symmetric(vertical: 11),
            child: Divider(height: 1, color: Color(0xFFE8EFEB)),
          ),

          const Text(
            'Developer Perumahan',
            style: TextStyle(fontSize: 12, color: secondaryText),
          ),

          const SizedBox(height: 5),

          Text(
            widget.namaDeveloper,
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

  Widget _buildDemoBadge() {
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

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {
        if (_selectedUnit != null &&
            !_filteredUnits.any((unit) => unit['nomor'] == _selectedUnit)) {
          _selectedUnit = null;
        }
      }),
      decoration: InputDecoration(
        hintText: 'Cari nomor rumah atau blok',
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF89958F)),
        prefixIcon: const Icon(Icons.search, color: secondaryText, size: 22),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _selectedUnit = null;
                  });
                },
                icon: const Icon(Icons.close),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
          borderSide: const BorderSide(color: primaryGreen),
        ),
      ),
    );
  }

  Widget _buildBlokSection(String namaBlok, List<Map<String, String>> units) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaBlok,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 10),

          ...units.map(
            (unit) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildUnitCard(unit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(Map<String, String> unit) {
    final nomor = unit['nomor']!;
    final isSelected = _selectedUnit == nomor;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedUnit = nomor;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryGreen : const Color(0xFFE1EBE5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7F2),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.home_outlined,
                color: primaryGreen,
                size: 22,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor rumah $nomor',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    unit['blok']!,
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Luas tanah ${unit['luasTanah']} m²',
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? primaryGreen : const Color(0xFFB7C8C0),
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 13, 22, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 47,
        child: ElevatedButton(
          onPressed: _selectedUnit == null
              ? null
              : () {
                  final unit = _unitList.firstWhere(
                    (item) => item['nomor'] == _selectedUnit,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandDataPage(
                        namaPerumahan: widget.namaPerumahan,
                        namaBlok: unit['blok']!,
                        nomorRumah: unit['nomor']!,
                        luasTanah: unit['luasTanah']!,
                      ),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            disabledBackgroundColor: const Color(0xFFC9D6D1),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
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
    );
  }
}
