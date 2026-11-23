import 'package:flutter/material.dart';

import 'unit_list_page.dart';
import 'blok_form_page.dart';
import '../../../core/services/blok_service.dart';
import '../../../models/blok_model.dart';

class BlokListPage extends StatefulWidget {
  final int perumahanId;
  final String namaDeveloper;
  final String namaPerumahan;

  const BlokListPage({
    super.key,
    required this.perumahanId,
    required this.namaDeveloper,
    required this.namaPerumahan,
  });

  @override
  State<BlokListPage> createState() => _BlokListPageState();
}

class _BlokListPageState extends State<BlokListPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);

  late Future<List<BlokModel>> _blokFuture;

  @override
  void initState() {
    super.initState();
    _loadBlok();
  }

  void _loadBlok() {
    _blokFuture = BlokService.getBlok(widget.perumahanId);
  }

  Future<void> _bukaFormTambahBlok() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlokFormPage(
          perumahanId: widget.perumahanId,
          namaPerumahan: widget.namaPerumahan,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _loadBlok();
      });
    }
  }

  // Menampilkan menu aksi blok
  void _tampilkanMenuBlok(BlokModel blok) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blok.namaBlok,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: primaryGreen),
                  title: const Text('Edit Blok'),
                  onTap: () {
                    Navigator.pop(context);
                    _editBlok(blok);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Hapus Blok',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _konfirmasiHapusBlok(blok);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _editBlok(BlokModel blok) async {
    final controller = TextEditingController(text: blok.namaBlok);

    final namaBlok = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Blok'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nama Blok',
              hintText: 'Contoh: Blok A',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, controller.text.trim());
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      controller.dispose();
      return;
    }

    if (namaBlok == null || namaBlok.isEmpty) {
      controller.dispose();
      return;
    }

    try {
      await BlokService.updateBlok(id: blok.id, namaBlok: namaBlok);

      controller.dispose();

      if (!mounted) return;

      setState(() {
        _loadBlok();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Blok berhasil diperbarui.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      controller.dispose();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _konfirmasiHapusBlok(BlokModel blok) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Blok?'),
        content: Text(
          'Yakin ingin menghapus ${blok.namaBlok}? '
          'Seluruh unit di dalam blok ini juga akan dihapus. '
          'Blok dengan riwayat monitoring tidak dapat dihapus.',
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

    if (konfirmasi != true || !mounted) return;

    try {
      await BlokService.hapusBlok(id: blok.id);

      if (!mounted) return;

      setState(() {
        _loadBlok();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Blok berhasil dihapus.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPropertyInformation(),

                    const SizedBox(height: 10),
                    const SizedBox(height: 27),

                    const Text(
                      'Blok Perumahan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),

                    const SizedBox(height: 12),

                    FutureBuilder<List<BlokModel>>(
                      future: _blokFuture,
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
                                    'Gagal mengambil data blok:\n${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _loadBlok();
                                      });
                                    },
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final daftarBlok = snapshot.data ?? [];

                        if (daftarBlok.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Text('Belum ada blok pada perumahan ini.'),
                            ),
                          );
                        }

                        return Column(
                          children: daftarBlok.map((blok) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildBlokCard(context, blok),
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

  Widget _buildPropertyInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Developer Perumahan',
            style: TextStyle(fontSize: 12, color: Color(0xFF718078)),
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

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Divider(height: 1, color: Color(0xFFE8EFEB)),
          ),

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
        ],
      ),
    );
  }

  Widget _buildBlokCard(BuildContext context, BlokModel blok) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitListPage(
              blokId: blok.id,
              namaPerumahan: widget.namaPerumahan,
              namaBlok: blok.namaBlok,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
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
            Text(
              blok.namaBlok,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkGreen,
              ),
            ),
            const Spacer(),

            IconButton(
              onPressed: () => _tampilkanMenuBlok(blok),
              icon: const Icon(Icons.more_vert, color: Color(0xFF718078)),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF718078), size: 23),
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
          onPressed: _bukaFormTambahBlok,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006B50),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: const Text(
            'Tambah Blok',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
