import 'package:flutter/material.dart';

import '../../../core/services/blok_service.dart';
import '../../../models/unit_model.dart';
import 'unit_form_page.dart';
import 'unit_detail_page.dart';
import '../../../core/services/unit_service.dart';

class UnitListPage extends StatefulWidget {
  final int blokId;
  final String namaPerumahan;
  final String namaBlok;

  const UnitListPage({
    super.key,
    required this.blokId,
    required this.namaPerumahan,
    required this.namaBlok,
  });

  @override
  State<UnitListPage> createState() => _UnitListPageState();
}

class _UnitListPageState extends State<UnitListPage> {
  late Future<List<UnitModel>> _unitFuture;

  @override
  void initState() {
    super.initState();
    _loadUnit();
  }

  void _loadUnit() {
    _unitFuture = BlokService.getUnit(widget.blokId);
  }

  Future<void> _editUnit(UnitModel unit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnitFormPage(
          blokId: widget.blokId,
          namaPerumahan: widget.namaPerumahan,
          namaBlok: widget.namaBlok,
          unit: unit,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _loadUnit();
      });
    }
  }

  Future<void> _hapusUnit(UnitModel unit) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Unit Rumah?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus unit ${unit.nomorUnit}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) return;

    try {
      await UnitService.hapusUnit(unit.id);

      if (!mounted) return;

      setState(() {
        _loadUnit();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unit rumah berhasil dihapus.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus unit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInformationCard(),

                    const SizedBox(height: 10),
                    const SizedBox(height: 27),

                    const Text(
                      'Daftar Unit Rumah',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),

                    const SizedBox(height: 12),

                    FutureBuilder<List<UnitModel>>(
                      future: _unitFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(25),
                              child: CircularProgressIndicator(
                                color: primaryGreen,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Gagal mengambil data unit:\n${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _loadUnit();
                                      });
                                    },
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final daftarUnit = snapshot.data ?? [];

                        if (daftarUnit.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                'Belum ada unit rumah.',
                                style: TextStyle(
                                  color: Color(0xFF718078),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: daftarUnit.map((unit) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildUnitCard(context, unit),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            _buildBottomButton(context),
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
            'Kelola Blok dan Unit Rumah',
            style: TextStyle(
              color: darkGreen,
              fontSize: 15,
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
            'Perumahan',
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

  Widget _buildUnitCard(BuildContext context, UnitModel unit) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitDetailPage(
              unit: unit,
              namaPerumahan: widget.namaPerumahan,
              namaBlok: widget.namaBlok,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
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
                    'Nomor rumah ${unit.nomorUnit}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Luas tanah ${unit.luasTanah} m²',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718078),
                    ),
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Color(0xFF718078)),
              onSelected: (value) {
                if (value == 'edit') {
                  _editUnit(unit);
                } else if (value == 'hapus') {
                  _hapusUnit(unit);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 19),
                      SizedBox(width: 10),
                      Text('Edit Unit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'hapus',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 19),
                      SizedBox(width: 10),
                      Text('Hapus Unit', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 49,
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UnitFormPage(
                  blokId: widget.blokId,
                  namaPerumahan: widget.namaPerumahan,
                  namaBlok: widget.namaBlok,
                ),
              ),
            );

            if (!mounted) return;

            if (result == true) {
              setState(() {
                _loadUnit();
              });
            }
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
            'Tambah Unit Rumah',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
