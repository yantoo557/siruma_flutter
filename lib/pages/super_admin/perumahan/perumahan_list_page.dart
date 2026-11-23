import 'package:flutter/material.dart';

import '../../../core/services/perumahan_service.dart';
import '../../../models/perumahan_model.dart';
import 'perumahan_form_page.dart';
import 'perumahan_detail_page.dart';
import '../blok/blok_list_page.dart';

class PerumahanListPage extends StatefulWidget {
  final bool modeKelolaRumah;

  const PerumahanListPage({super.key, this.modeKelolaRumah = false});

  @override
  State<PerumahanListPage> createState() => _PerumahanListPageState();
}

class _PerumahanListPageState extends State<PerumahanListPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  final TextEditingController _searchController = TextEditingController();

  List<PerumahanModel> _perumahanList = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPerumahan();
  }

  Future<void> _loadPerumahan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await PerumahanService.getPerumahan();

      if (!mounted) return;

      setState(() {
        _perumahanList = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String get _searchQuery => _searchController.text.toLowerCase();

  List<PerumahanModel> get _filteredPerumahan {
    return _perumahanList.where((perumahan) {
      return perumahan.namaPerumahan.toLowerCase().contains(_searchQuery) ||
          perumahan.developer.toLowerCase().contains(_searchQuery);
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
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                color: primaryGreen,
                onRefresh: _loadPerumahan,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kelola daftar perumahan yang terdaftar.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF52645D),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4F4ED),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Data terhubung ke server',
                          style: TextStyle(
                            color: primaryGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      _buildSearchField(),

                      const SizedBox(height: 14),

                      if (!widget.modeKelolaRumah) _buildAddButton(),

                      const SizedBox(height: 18),

                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryGreen,
                            ),
                          ),
                        )
                      else if (_errorMessage != null)
                        _buildErrorState()
                      else if (_filteredPerumahan.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 35),
                          child: Center(
                            child: Text(
                              'Perumahan tidak ditemukan.',
                              style: TextStyle(
                                color: Color(0xFF718078),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      else
                        ..._filteredPerumahan.map(
                          (perumahan) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildPerumahanCard(perumahan),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 42,
              color: Color(0xFF89958F),
            ),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat data perumahan.',
              style: TextStyle(fontWeight: FontWeight.w600, color: darkGreen),
            ),
            const SizedBox(height: 6),
            Text(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Color(0xFF718078)),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _loadPerumahan,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
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
            widget.modeKelolaRumah ? 'Pilih Perumahan' : 'Data Perumahan',
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

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Cari developer atau nama perumahan',
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF89958F)),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF718078),
          size: 22,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD7E4DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD7E4DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGreen),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 49,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PerumahanFormPage()),
          ).then((_) => _loadPerumahan());
        },
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: const Text(
          'Tambah Perumahan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _buildPerumahanCard(PerumahanModel perumahan) {
    return InkWell(
      onTap: () {
        if (widget.modeKelolaRumah) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlokListPage(
                perumahanId: perumahan.id,
                namaDeveloper: perumahan.developer,
                namaPerumahan: perumahan.namaPerumahan,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PerumahanDetailPage(
                perumahanId: perumahan.id,
                namaDeveloper: perumahan.developer,
                namaPerumahan: perumahan.namaPerumahan,
                alamatPerumahan: perumahan.lokasi,
              ),
            ),
          ).then((result) {
            if (result == true) {
              _loadPerumahan();
            }
          });
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE1EBE5)),
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
              child: const Icon(Icons.apartment, color: primaryGreen, size: 21),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perumahan.namaPerumahan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    perumahan.developer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718078),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    perumahan.lokasi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718078),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '${perumahan.blokCount} blok',
                    style: const TextStyle(
                      fontSize: 10,
                      color: primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            const Icon(Icons.chevron_right, color: Color(0xFF718078), size: 22),
          ],
        ),
      ),
    );
  }
}
