import 'package:flutter/material.dart';

import 'select_unit_page.dart';

class SelectPerumahanPage extends StatefulWidget {
  const SelectPerumahanPage({super.key});

  @override
  State<SelectPerumahanPage> createState() => _SelectPerumahanPageState();
}

class _SelectPerumahanPageState extends State<SelectPerumahanPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _perumahanList = [
    {
      'id': 1,
      'nama': 'Perumahan Contoh Asri',
      'alamat': 'Jalan Contoh No. 10, Makassar (alamat demo)',
    },
  ];

  int? _selectedPerumahanId;
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredPerumahan {
    return _perumahanList.where((perumahan) {
      final nama = perumahan['nama'].toString().toLowerCase();
      return nama.contains(_searchQuery.toLowerCase());
    }).toList();
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih perumahan yang akan dimonitor.',
                    style: TextStyle(fontSize: 14, color: secondaryText),
                  ),

                  const SizedBox(height: 10),

                  _buildDemoLabel(),

                  const SizedBox(height: 19),

                  _buildSearchField(),

                  const SizedBox(height: 21),

                  _buildPerumahanList(),
                ],
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
        'Pilih Perumahan',
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

  Widget _buildDemoLabel() {
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

  Widget _buildSearchField() {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8E5DE)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Cari nama perumahan...',
          hintStyle: TextStyle(color: Color(0xFF8A9A92), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: secondaryText, size: 21),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPerumahanList() {
    final filteredList = _filteredPerumahan;

    if (filteredList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 35),
        child: Center(
          child: Text(
            'Perumahan tidak ditemukan.',
            style: TextStyle(color: secondaryText, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: filteredList.map((perumahan) {
        final id = perumahan['id'] as int;
        final isSelected = _selectedPerumahanId == id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPerumahanId = id;
              });
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? primaryGreen : const Color(0xFFE1EBE5),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF7F2),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.home_work_outlined,
                      color: primaryGreen,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          perumahan['nama'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          perumahan['alamat'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? primaryGreen : const Color(0xFFB9C9C1),
                    size: 21,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomAction() {
    final isEnabled = _selectedPerumahanId != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: SizedBox(
        height: 49,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled ? _continueToNextPage : null,
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

  void _continueToNextPage() {
    final selectedPerumahan = _perumahanList.firstWhere(
      (item) => item['id'] == _selectedPerumahanId,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectUnitPage(
          namaPerumahan: selectedPerumahan['nama'].toString(),
          namaDeveloper: 'PT Contoh Developer Nusantara',
        ),
      ),
    );
  }
}
